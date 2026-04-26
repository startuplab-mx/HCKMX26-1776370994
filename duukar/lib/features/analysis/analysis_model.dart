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

  /// Short, friendly label for the kid-facing hero card.
  String get kidLabel {
    switch (this) {
      case RiskLevel.low:
        return '¡Todo bien! 😊';
      case RiskLevel.medium:
        return 'Ojo con esto 🤔';
      case RiskLevel.high:
        return '¡Cuidado! 🚨';
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
    this.detectedTerms = const [],
    this.categories = const [],
    this.minorAdvice = const [],
    this.kidMessage = '',
    this.kidExplanation = '',
    this.kidActions = const [],
  });

  /// Risk level: low / medium / high.
  final RiskLevel riskLevel;

  /// 0–100 numeric risk score.
  final int score;

  /// Short detected warning signals (AI-generated, internal/technical).
  final List<String> signals;

  /// Detailed explanation — internal/technical, oriented to context analysis.
  final String explanation;

  /// Concrete recommended steps (internal version, may use adult language).
  final List<String> recommendedActions;

  /// One-line summary suitable for a card/list view.
  final String summary;

  /// Terms/hashtags/emojis pre-detected in the input before calling the AI.
  ///
  /// These are the raw matched terms from [kRiskSignals]. They are included
  /// here for display and context — they do NOT automatically elevate risk.
  final List<String> detectedTerms;

  /// Deduplicated signal categories detected in the input
  /// (e.g. 'narcocultura', 'reclutamiento', 'manipulacion').
  final List<String> categories;

  /// Child-appropriate safety advice in Spanish, selected based on context.
  ///
  /// Populated from [kChildSafetyAdvice] / [kRecruitmentAdvice] when
  /// relevant categories are detected. Empty for low-risk / no-signal results.
  final List<String> minorAdvice;

  // ── Kid-facing fields (visible output for children 6–11) ──────────────

  /// Very short headline message from Duki directed to the child.
  ///
  /// E.g. "Esto se ve raro." / "Parece una trampa." / "¡Todo bien!"
  /// One or two short sentences, warm and direct. No technical language.
  final String kidMessage;

  /// Brief child-friendly explanation of what Duki noticed.
  ///
  /// Plain Spanish for ages 6–11. No alarmist tone. Reassuring.
  /// E.g. "Esta persona pregunta muchas cosas raras y pide que
  /// no le cuentes a nadie. Eso no es normal."
  final String kidExplanation;

  /// 2–4 concrete, simple actions the child can take right now.
  ///
  /// E.g. ["No respondas todavía.", "Mostráselo a un adulto de confianza."]
  final List<String> kidActions;

  // ── Computed helpers ──────────────────────────────────────────────────

  /// True if the pre-analysis found any matching risk terms.
  bool get hasDetectedTerms => detectedTerms.isNotEmpty;

  /// True if child safety advice is available.
  bool get hasMinorAdvice => minorAdvice.isNotEmpty;

  /// True if kid-facing fields are populated.
  bool get hasKidContent => kidMessage.isNotEmpty || kidExplanation.isNotEmpty;

  // ── JSON parsing ──────────────────────────────────────────────────────

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      riskLevel: RiskLevel.fromString(json['risk_level'] as String? ?? 'low'),
      score: (json['score'] as num?)?.toInt() ?? 0,
      signals: _parseStringList(json['signals']),
      explanation: json['explanation'] as String? ?? '',
      recommendedActions: _parseStringList(json['recommended_actions']),
      summary: json['summary'] as String? ?? '',
      // kid-facing fields — returned by OpenAI in the same JSON response
      kidMessage: json['kid_message'] as String? ?? '',
      kidExplanation: json['kid_explanation'] as String? ?? '',
      kidActions: _parseStringList(json['kid_actions']),
      // detectedTerms, categories, minorAdvice are injected by the repository
      // after pre-analysis; they are not expected in the AI JSON response.
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

  /// Return a copy with the pre-analysis context fields populated.
  AnalysisResult withContext({
    required List<String> detectedTerms,
    required List<String> categories,
    required List<String> minorAdvice,
  }) {
    return AnalysisResult(
      riskLevel: riskLevel,
      score: score,
      signals: signals,
      explanation: explanation,
      recommendedActions: recommendedActions,
      summary: summary,
      detectedTerms: detectedTerms,
      categories: categories,
      minorAdvice: minorAdvice,
      // Preserve kid-facing fields unchanged
      kidMessage: kidMessage,
      kidExplanation: kidExplanation,
      kidActions: kidActions,
    );
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
      if (detectedTerms.isNotEmpty) 'detected_terms': detectedTerms,
      if (categories.isNotEmpty) 'categories': categories,
      if (kidMessage.isNotEmpty) 'kid_message': kidMessage,
      if (kidExplanation.isNotEmpty) 'kid_explanation': kidExplanation,
      if (kidActions.isNotEmpty) 'kid_actions': kidActions,
    };
  }
}
