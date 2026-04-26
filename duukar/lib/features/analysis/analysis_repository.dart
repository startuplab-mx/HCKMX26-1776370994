import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/app_supabase.dart';
import 'analysis_model.dart';

// ---------------------------------------------------------------------------
// System prompt
// ---------------------------------------------------------------------------

const _kSystemPrompt = '''
Eres Duki, un asistente de seguridad digital especializado en proteger a niños y adolescentes en línea.
Tu misión es analizar contenido digital (texto, capturas de pantalla, mensajes) y detectar posibles riesgos como:
- Manipulación emocional o grooming (adultos que intentan ganarse la confianza de menores)
- Trampas de dinero o estafas (pedidos de dinero, premios falsos, cripto)
- Secretismo sospechoso (presión para no contarle a padres o amigos)
- Normalización peligrosa (contenido que hace ver como normal algo dañino)
- Ofertas sospechosas (regalos, viajes, oportunidades "demasiado buenas")
- Presión social o amenazas

Debes responder ÚNICAMENTE con un objeto JSON válido, sin texto adicional, sin explicación, sin markdown.
El JSON debe seguir EXACTAMENTE este esquema:
{
  "risk_level": "low" | "medium" | "high",
  "score": <número entero 0-100>,
  "signals": ["señal 1", "señal 2"],
  "explanation": "<explicación clara en español, apropiada para niños y adolescentes>",
  "recommended_actions": ["acción 1", "acción 2"],
  "summary": "<resumen en una sola oración>"
}

Reglas:
- Responde siempre en español.
- El lenguaje debe ser comprensible para niños y adolescentes (8-17 años).
- Si el contenido parece seguro, asigna risk_level "low" y score bajo (0-30).
- Si hay señales moderadas, usa "medium" y score 31-65.
- Si hay señales claras de peligro, usa "high" y score 66-100.
- No incluyas texto fuera del JSON.
- No uses bloques de código ni comillas triples.
''';

// ---------------------------------------------------------------------------
// AnalysisRepository
// ---------------------------------------------------------------------------

class AnalysisRepository {
  AnalysisRepository({http.Client? httpClient})
    : _http = httpClient ?? http.Client();

  final http.Client _http;

  static const _kOpenAiUrl = 'https://api.openai.com/v1/chat/completions';

  // ── Public API ──────────────────────────────────────────────────────────

  /// Analyze a plain text string.
  Future<AnalysisResult> analyzeText(String text) async {
    if (text.trim().isEmpty) {
      throw const FormatException('El texto no puede estar vacío.');
    }

    final messages = [
      {'role': 'system', 'content': _kSystemPrompt},
      {
        'role': 'user',
        'content':
            'Analiza el siguiente texto y responde con el JSON requerido:\n\n$text',
      },
    ];

    return _callOpenAi(messages);
  }

  /// Analyze an image file (JPEG/PNG).
  ///
  /// Converts the image to base64 and sends it to the vision-capable endpoint.
  Future<AnalysisResult> analyzeImage(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);

    // Detect MIME type from extension
    final ext = imageFile.path.split('.').last.toLowerCase();
    final mimeType = ext == 'png' ? 'image/png' : 'image/jpeg';

    final messages = [
      {'role': 'system', 'content': _kSystemPrompt},
      {
        'role': 'user',
        'content': [
          {
            'type': 'text',
            'text':
                'Analiza la siguiente captura de pantalla y responde con el JSON requerido:',
          },
          {
            'type': 'image_url',
            'image_url': {
              'url': 'data:$mimeType;base64,$base64Image',
              'detail': 'high',
            },
          },
        ],
      },
    ];

    // Use gpt-4o for vision (gpt-4o-mini also supports vision)
    return _callOpenAi(messages, forceModel: 'gpt-4o-mini');
  }

  /// Store a completed analysis in Supabase `analysis_history`.
  ///
  /// Silently ignores errors (fire-and-forget) to avoid blocking the UI.
  Future<void> saveAnalysis({
    required AnalysisResult result,
    required AnalysisInputType inputType,
    String? sourceText,
  }) async {
    final userId = AppSupabase.currentUser?.id;
    if (userId == null) return; // not logged in — skip silently

    try {
      await AppSupabase.client
          .from('analysis_history')
          .insert(
            result.toSupabaseMap(
              userId: userId,
              inputType: inputType,
              sourceText: sourceText,
            ),
          );
    } catch (_) {
      // non-critical — don't surface to user
    }
  }

  // ── Internal ────────────────────────────────────────────────────────────

  Future<AnalysisResult> _callOpenAi(
    List<Map<String, dynamic>> messages, {
    String? forceModel,
  }) async {
    final apiKey = AppConstants.openAiApiKey;
    final model = forceModel ?? AppConstants.openAiModel;

    final body = jsonEncode({
      'model': model,
      'messages': messages,
      'temperature': 0.2,
      'max_tokens': 800,
      'response_format': {'type': 'json_object'},
    });

    final response = await _http
        .post(
          Uri.parse(_kOpenAiUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey',
          },
          body: body,
        )
        .timeout(const Duration(seconds: 60));

    if (response.statusCode != 200) {
      final err = jsonDecode(response.body);
      final msg = err['error']?['message'] ?? 'Error desconocido de OpenAI';
      throw Exception('OpenAI error ${response.statusCode}: $msg');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final content =
        decoded['choices']?[0]?['message']?['content'] as String? ?? '{}';

    return AnalysisResult.fromRawString(content);
  }
}
