// ---------------------------------------------------------------------------
// analysis_signals.dart
//
// Contextual risk signals for Duukar's analysis engine.
//
// PURPOSE:
//   These terms are used as contextual evidence, NOT as a blacklist.
//   The AI model makes the final risk decision based on overall context.
//   A single match alone does not imply danger; multiple signals combined
//   with offers, pressure, secrecy, or recruitment language raise the risk.
//
// SOURCE: User-provided material for hackathon — HCKMX26.
// ---------------------------------------------------------------------------

/// A matched signal found in the user's input.
class DetectedSignal {
  const DetectedSignal({required this.term, required this.category});

  /// The exact term/emoji/phrase found in the input.
  final String term;

  /// Category it belongs to (e.g. 'narcocultura', 'reclutamiento').
  final String category;

  @override
  String toString() => '$term ($category)';
}

// ---------------------------------------------------------------------------
// Signal registry
// ---------------------------------------------------------------------------

/// Categorized risk signals.
///
/// Each entry is: (term, category).
/// Categories help the model understand the domain of each signal.
const List<({String term, String category})> kRiskSignals = [
  // ── Narco hashtags / org identifiers ──────────────────────────────────
  (term: '#gentedelmz', category: 'narcocultura'),
  (term: '#mayozambada', category: 'narcocultura'),
  (term: '#operativamz', category: 'narcocultura'),
  (term: '#nuevageneración', category: 'narcocultura'),
  (term: '#nuevageneracion', category: 'narcocultura'),
  (term: '#4l', category: 'narcocultura'),
  (term: '#ng', category: 'narcocultura'),
  (term: '#mencho', category: 'narcocultura'),
  (term: '#maña', category: 'narcocultura'),
  (term: '#mana', category: 'narcocultura'),
  (term: '#trabajoparalamaña', category: 'narcocultura'),
  (term: '#trabajoparalamaña', category: 'narcocultura'),

  // ── Slang / coded words ────────────────────────────────────────────────
  (term: 'belicones', category: 'narcocultura'),
  (term: 'ondeado', category: 'narcocultura'),
  (term: 'ondear', category: 'narcocultura'),
  (term: '4l', category: 'narcocultura'),
  (term: '4 letras', category: 'narcocultura'),
  (term: 'adiestramiento', category: 'reclutamiento'),
  (term: 'entrenamiento especial', category: 'reclutamiento'),
  (term: 'plaza', category: 'narcocultura'),
  (term: 'halcón', category: 'narcocultura'),
  (term: 'halcon', category: 'narcocultura'),
  (term: 'sicario', category: 'narcocultura'),
  (term: 'jale', category: 'narcocultura'),

  // ── Recruitment / manipulation phrases ───────────────────────────────
  (term: 'salir adelante', category: 'reclutamiento'),
  (term: 'perder el miedo', category: 'reclutamiento'),
  (term: 'pierdes el miedo', category: 'reclutamiento'),
  (term: 'reclutar', category: 'reclutamiento'),
  (term: 'reclutamiento', category: 'reclutamiento'),
  (term: 'te damos trabajo', category: 'reclutamiento'),
  (term: 'somos familia', category: 'manipulacion'),
  (term: 'te protegemos', category: 'manipulacion'),
  (term: 'nadie te va a hacer daño', category: 'manipulacion'),
  (term: 'no le cuentes a nadie', category: 'secretismo'),
  (term: 'es un secreto', category: 'secretismo'),
  (term: 'no le digas a tus papás', category: 'secretismo'),
  (term: 'ganas buen dinero', category: 'trampa_dinero'),
  (term: 'dinero fácil', category: 'trampa_dinero'),
  (term: 'ganarás mucho', category: 'trampa_dinero'),
  (term: 'te pagamos bien', category: 'trampa_dinero'),
  (term: 'sin horario', category: 'trampa_dinero'),
  (term: 'solo tienes que', category: 'manipulacion'),
  (term: 'solo tenés que', category: 'manipulacion'),
  (term: 'no pasa nada', category: 'normalizacion'),
  (term: 'todos lo hacen', category: 'normalizacion'),
  (term: 'es normal', category: 'normalizacion'),

  // ── Emojis associated with narco/gang/recruit content ────────────────
  // NOTE: emojis alone are NOT evidence — context determines risk.
  (term: '🥷', category: 'simbolo_riesgo'),
  (term: '🆖', category: 'simbolo_riesgo'),
  (term: '👹', category: 'simbolo_riesgo'),
  (term: '☠️', category: 'simbolo_riesgo'),
  (term: '🧿', category: 'simbolo_riesgo'),
  (term: '🪖', category: 'simbolo_riesgo'),
  // 🍕 and 🐓 are used as coded references in some recruitment contexts
  (term: '🍕', category: 'codigo'),
  (term: '🐓', category: 'codigo'),
];

// ---------------------------------------------------------------------------
// Child safety advice
// ---------------------------------------------------------------------------

/// Age-appropriate safety tips for minors, always in Spanish.
///
/// These are surfaced in the result screen when the analysis detects
/// medium or high risk, or when recruitment/manipulation signals are found.
const List<String> kChildSafetyAdvice = [
  'No todo el mundo en internet es quien dice ser.',
  'Tu información personal es privada — no la compartas con desconocidos.',
  'No aceptes solicitudes de personas que no conocés en la vida real.',
  'Cuidado con los secretos: alguien que te pide que no le cuentes a tus papás probablemente no tiene buenas intenciones.',
  'Desconfiá de regalos, dinero o promesas que parecen demasiado buenos.',
  'No compartas fotos íntimas o personales con nadie en línea.',
  'Escuchá tu intuición — si algo te hace sentir incómodo, alejate.',
  'Hablá con un adulto de confianza si alguien te presiona o te hace sentir raro.',
  'El trabajo o dinero "fácil" sin esfuerzo casi siempre esconde una trampa.',
  'Pertenecer a un grupo no vale la pena si te piden hacer algo peligroso o ilegal.',
];

/// Advice specifically relevant when recruitment signals are detected.
const List<String> kRecruitmentAdvice = [
  'Si alguien te ofrece trabajo sin explicarte bien qué tenés que hacer, desconfiá.',
  'Las organizaciones peligrosas usan frases como "somos familia" o "te protegemos" para manipularte.',
  'Nadie debería pedirte que guardes secretos de tus padres o adultos de confianza.',
  'Si sentís presión para unirte a un grupo, hablá con un adulto de confianza inmediatamente.',
];

// ---------------------------------------------------------------------------
// Signal detector
// ---------------------------------------------------------------------------

/// Scans [input] text and returns all matching [DetectedSignal]s.
///
/// Matching is case-insensitive and handles accented variations.
/// Returns an empty list if no signals are found.
List<DetectedSignal> detectSignals(String input) {
  if (input.trim().isEmpty) return [];

  final normalized = input.toLowerCase();
  final found = <DetectedSignal>[];

  for (final signal in kRiskSignals) {
    final termLower = signal.term.toLowerCase();
    if (normalized.contains(termLower)) {
      found.add(DetectedSignal(term: signal.term, category: signal.category));
    }
  }

  return found;
}

/// Returns true if any detected signal belongs to the given [category].
bool hasCategory(List<DetectedSignal> signals, String category) {
  return signals.any((s) => s.category == category);
}

/// Returns a deduplicated list of category names from [signals].
List<String> extractCategories(List<DetectedSignal> signals) {
  return signals.map((s) => s.category).toSet().toList();
}
