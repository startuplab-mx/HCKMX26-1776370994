import 'dart:convert';

// ---------------------------------------------------------------------------
// Input type
// ---------------------------------------------------------------------------

enum AnalysisInputType {
  image,
  text,
  link;

  String get dbValue => name; // 'image' | 'text' | 'link'
}

// ---------------------------------------------------------------------------
// Risk level
// ---------------------------------------------------------------------------

enum RiskLevel {
  low,
  medium,
  high;

  static RiskLevel fromString(String value) {
    switch (value.toLowerCase()) {
      case 'high':
      case 'alto':
        return RiskLevel.high;
      case 'medium':
      case 'medio':
        return RiskLevel.medium;
      default:
        return RiskLevel.low;
    }
  }

  String get dbValue => name; // 'low' | 'medium' | 'high'

  String get label {
    switch (this) {
      case RiskLevel.low:
        return 'Riesgo bajo';
      case RiskLevel.medium:
        return 'Riesgo medio';
      case RiskLevel.high:
        return 'Riesgo alto';
    }
  }
}

// ---------------------------------------------------------------------------
// AnalysisResult
// ---------------------------------------------------------------------------

class AnalysisResult {
  const AnalysisResult({
    required this.riskLevel,
    required this.score,
    required this.signals,
    required this.explanation,
    required this.recommendedActions,
    required this.summary,
  });

  /// Risk level: low / medium / high.
  final RiskLevel riskLevel;

  /// 0–100 numeric risk score.
  final int score;

  /// Short detected warning signals.
  final List<String> signals;

  /// Detailed explanation oriented to the child/teen.
  final String explanation;

  /// Concrete recommended steps the user should take.
  final List<String> recommendedActions;

  /// One-line summary suitable for a card/list view.
  final String summary;

  // ── JSON parsing ────────────────────────────────────────────────────────

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      riskLevel: RiskLevel.fromString(json['risk_level'] as String? ?? 'low'),
      score: (json['score'] as num?)?.toInt() ?? 0,
      signals: _parseStringList(json['signals']),
      explanation: json['explanation'] as String? ?? '',
      recommendedActions: _parseStringList(json['recommended_actions']),
      summary: json['summary'] as String? ?? '',
    );
  }

  /// Parse a raw OpenAI response string.
  ///
  /// OpenAI sometimes wraps JSON in ```json … ``` fences — we strip them.
  factory AnalysisResult.fromRawString(String raw) {
    final cleaned = raw
        .replaceAll(RegExp(r'```json\s*'), '')
        .replaceAll(RegExp(r'```\s*'), '')
        .trim();
    final map = jsonDecode(cleaned) as Map<String, dynamic>;
    return AnalysisResult.fromJson(map);
  }

  static List<String> _parseStringList(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }

  // ── Serialization (for Supabase) ────────────────────────────────────────

  Map<String, dynamic> toSupabaseMap({
    required String userId,
    required AnalysisInputType inputType,
    String? sourceText,
  }) {
    return {
      'user_id': userId,
      'input_type': inputType.dbValue,
      if (sourceText != null) 'source_text': sourceText,
      'risk_level': riskLevel.dbValue,
      'explanation': explanation,
      'signals': signals,
      'recommended_actions': recommendedActions,
    };
  }
}
