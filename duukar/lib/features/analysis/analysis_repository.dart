import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/app_supabase.dart';
import 'analysis_model.dart';
import 'analysis_signals.dart';

// ---------------------------------------------------------------------------
// System prompt (base)
// ---------------------------------------------------------------------------

const _kSystemPrompt = '''
Eres Duki, un asistente de seguridad digital especializado en proteger a niños y adolescentes en línea.
Tu misión es analizar contenido digital (texto, capturas de pantalla, mensajes) y detectar posibles riesgos como:
- Manipulación emocional o grooming (adultos que intentan ganarse la confianza de menores)
- Trampas de dinero o estafas (pedidos de dinero, premios falsos, cripto)
- Secretismo sospechoso (presión para no contarle a padres o amigos)
- Normalización de conductas peligrosas (violencia, drogas, crimen organizado)
- Ofertas sospechosas (regalos, viajes, oportunidades "demasiado buenas")
- Presión social, amenazas o coerción
- Lenguaje de reclutamiento para grupos criminales o pandillas
- Narcocultura o referencias a crimen organizado combinadas con reclutamiento

REGLAS DE EVALUACIÓN IMPORTANTES:
- Un término, hashtag o emoji aislado NO es evidencia suficiente de peligro.
- Evaluá el CONTEXTO COMPLETO: si hay una combinación de oferta + presión + secretismo + referencias a grupos, el riesgo sube.
- Distinguí claramente entre: (a) uso casual o de meme, (b) slang/jerga popular, (c) normalización de narcocultura, (d) reclutamiento explícito.
- Si en el contexto se proveen "términos detectados previamente", usá esa información como SEÑAL ADICIONAL, no como veredicto.
- Si ves frases como "salir adelante", "perder el miedo", "somos familia", "te pagamos bien" COMBINADAS con otros indicadores, considerálas señales de reclutamiento.
- No afirmes certeza criminal. Decí que puede ser asociado a contextos de riesgo si se combina con otros factores.

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

Reglas de formato:
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
  ///
  /// Runs pre-analysis signal detection before calling the AI, so the model
  /// receives contextual hints about any matched risk terms.
  Future<AnalysisResult> analyzeText(String text) async {
    if (text.trim().isEmpty) {
      throw const FormatException('El texto no puede estar vacío.');
    }

    final detected = detectSignals(text);
    final contextHint = _buildContextHint(detected);

    final userMessage =
        'Analiza el siguiente texto y responde con el JSON requerido.'
        '$contextHint'
        '\n\nTexto a analizar:\n$text';

    final messages = [
      {'role': 'system', 'content': _kSystemPrompt},
      {'role': 'user', 'content': userMessage},
    ];

    final rawResult = await _callOpenAi(messages);
    return _enrichResult(rawResult, detected);
  }

  /// Analyze an image file (JPEG/PNG).
  ///
  /// For images there is no pre-text to scan, so signal detection is skipped.
  /// The model analyzes the visual content directly.
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
                'Analiza la siguiente captura de pantalla y responde con el JSON requerido. '
                'Prestá especial atención a: hashtags, emojis, frases de reclutamiento, '
                'ofertas de dinero, secretismo, presión, normalización de violencia o crimen. '
                'Si ves términos como #gentedelmz, #4l, #ng, 🥷, ☠️, 🆖 u otros símbolos de grupos, '
                'considerálos como señales adicionales de contexto, no como prueba definitiva.',
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

    // Use gpt-4o-mini for vision (supports images)
    final rawResult = await _callOpenAi(messages, forceModel: 'gpt-4o-mini');

    // No pre-detected terms for images — return as-is with empty context
    return rawResult;
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

  // ── Signal helpers ───────────────────────────────────────────────────────

  /// Build the context hint block that is injected into the user prompt.
  ///
  /// Only included when at least one signal was detected.
  String _buildContextHint(List<DetectedSignal> detected) {
    if (detected.isEmpty) return '';

    final termLines = detected
        .map((d) => '  - "${d.term}" (categoría: ${d.category})')
        .join('\n');

    return '''

CONTEXTO PREVIO — Términos de riesgo detectados en el texto antes del análisis:
$termLines

Estos términos pueden estar asociados a narcocultura, reclutamiento para crimen organizado o manipulación.
IMPORTANTE: Evaluálos en contexto. Su presencia es una señal adicional, no una condena.
Si aparecen combinados con ofertas, presión, secretismo, dinero fácil o pertenencia a un grupo, el riesgo es mayor.
''';
  }

  /// Attach pre-analysis context to the AI result and select appropriate advice.
  AnalysisResult _enrichResult(
    AnalysisResult raw,
    List<DetectedSignal> detected,
  ) {
    if (detected.isEmpty && raw.riskLevel == RiskLevel.low) {
      // Nothing to enrich — return as-is
      return raw;
    }

    final terms = detected.map((d) => d.term).toList();
    final categories = extractCategories(detected);

    // Select advice based on detected categories and risk level
    final advice = _selectAdvice(categories, raw.riskLevel);

    return raw.withContext(
      detectedTerms: terms,
      categories: categories,
      minorAdvice: advice,
    );
  }

  /// Pick relevant advice items from the advice lists.
  ///
  /// Always surfaces general safety tips for medium/high risk.
  /// Adds recruitment-specific tips when recruitment/manipulation categories found.
  List<String> _selectAdvice(List<String> categories, RiskLevel riskLevel) {
    if (riskLevel == RiskLevel.low && categories.isEmpty) return [];

    final advice = <String>[];

    final hasRecruitment =
        categories.contains('reclutamiento') ||
        categories.contains('manipulacion') ||
        categories.contains('narcocultura');

    // Always add 3 general safety tips for any non-low result
    if (riskLevel != RiskLevel.low || categories.isNotEmpty) {
      advice.addAll(kChildSafetyAdvice.take(4));
    }

    // Add recruitment-specific advice if relevant
    if (hasRecruitment) {
      advice.addAll(kRecruitmentAdvice.take(3));
    }

    return advice;
  }

  // ── Internal ─────────────────────────────────────────────────────────────

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
      'max_tokens': 900,
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
