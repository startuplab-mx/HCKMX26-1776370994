import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/section_card.dart';
import '../analysis_model.dart';

// ---------------------------------------------------------------------------
// AnalysisResultScreen
// ---------------------------------------------------------------------------

/// Displays the result of a Duki analysis.
///
/// Receives the [AnalysisResult] via constructor.
class AnalysisResultScreen extends StatelessWidget {
  const AnalysisResultScreen({super.key, required this.result});

  final AnalysisResult result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ─────────────────────────────────────────────────
            _TopBar(riskLevel: result.riskLevel),

            // ── Scrollable content ───────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    // ── DUKI MASCOT ──────────────────────────────────────
                    Center(
                      child: Image.asset(
                        'assets/img/duki_redflag.png',
                        height: 180,
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── PRIMERA IMPRESIÓN: Duki le habla al niño/a ──────
                    _DukiHeroCard(result: result),

                    const SizedBox(height: 16),

                    // Kid actions (primary, most actionable)
                    if (result.kidActions.isNotEmpty) ...[
                      _KidActionsCard(actions: result.kidActions),
                      const SizedBox(height: 16),
                    ],

                    // ── SECCIÓN SECUNDARIA: Detalles técnicos ───────────
                    _TechnicalDetailsSection(result: result),

                    const SizedBox(height: 24),

                    // Primary CTA
                    PrimaryButton(
                      label: 'Analizar otro contenido',
                      icon: const Icon(
                        Icons.search_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () => context.go(AppRoutes.askDuki),
                    ),

                    const SizedBox(height: 12),

                    // Secondary CTA
                    PrimaryButton(
                      label: 'Volver al inicio',
                      variant: PrimaryButtonVariant.outline,
                      onPressed: () => context.go(AppRoutes.homeKids),
                    ),

                    const SizedBox(height: 24),

                    // Footer note
                    _FooterNote(riskLevel: result.riskLevel),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _TopBar
// ---------------------------------------------------------------------------

class _TopBar extends StatelessWidget {
  const _TopBar({required this.riskLevel});

  final RiskLevel riskLevel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            color: AppColors.textPrimary,
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                context.go(AppRoutes.askDuki);
              }
            },
          ),
          const Spacer(),
          Text('Duki analizó esto 🔍', style: AppTextStyles.titleMedium),
          const Spacer(),
          // Risk level pill
          _RiskPill(riskLevel: riskLevel),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _RiskPill
// ---------------------------------------------------------------------------

class _RiskPill extends StatelessWidget {
  const _RiskPill({required this.riskLevel});

  final RiskLevel riskLevel;

  Color get _bg {
    switch (riskLevel) {
      case RiskLevel.high:
        return AppColors.danger.withOpacity(0.12);
      case RiskLevel.medium:
        return AppColors.warning.withOpacity(0.15);
      case RiskLevel.low:
        return AppColors.success.withOpacity(0.12);
    }
  }

  Color get _fg {
    switch (riskLevel) {
      case RiskLevel.high:
        return AppColors.danger;
      case RiskLevel.medium:
        return const Color(0xFFBF8A00);
      case RiskLevel.low:
        return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _fg.withOpacity(0.35)),
      ),
      child: Text(
        riskLevel.label.toUpperCase(),
        style: AppTextStyles.labelSmall.copyWith(
          color: _fg,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _DukiHeroCard — first impression, kid-facing
// ---------------------------------------------------------------------------

/// Big, warm hero card that Duki uses to speak directly to the child.
///
/// Prioritizes [AnalysisResult.kidMessage] and [AnalysisResult.kidExplanation].
/// Falls back gracefully to [AnalysisResult.summary] if kid fields are empty.
class _DukiHeroCard extends StatelessWidget {
  const _DukiHeroCard({required this.result});

  final AnalysisResult result;

  Color get _cardColor {
    switch (result.riskLevel) {
      case RiskLevel.high:
        return const Color(0xFFFFF0F0);
      case RiskLevel.medium:
        return const Color(0xFFFFF8E8);
      case RiskLevel.low:
        return const Color(0xFFF0FAF0);
    }
  }

  Color get _accentColor {
    switch (result.riskLevel) {
      case RiskLevel.high:
        return AppColors.danger;
      case RiskLevel.medium:
        return const Color(0xFFBF8A00);
      case RiskLevel.low:
        return AppColors.success;
    }
  }

  Color get _borderColor {
    switch (result.riskLevel) {
      case RiskLevel.high:
        return AppColors.danger.withOpacity(0.3);
      case RiskLevel.medium:
        return const Color(0xFFFFCA28).withOpacity(0.5);
      case RiskLevel.low:
        return AppColors.success.withOpacity(0.3);
    }
  }

  String get _dukiEmoji {
    switch (result.riskLevel) {
      case RiskLevel.high:
        return '🚨';
      case RiskLevel.medium:
        return '🤔';
      case RiskLevel.low:
        return '✅';
    }
  }

  @override
  Widget build(BuildContext context) {
    final message = result.kidMessage.isNotEmpty
        ? result.kidMessage
        : result.summary;
    final explanation = result.kidExplanation.isNotEmpty
        ? result.kidExplanation
        : result.explanation;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _borderColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Duki avatar row
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _accentColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(_dukiEmoji, style: const TextStyle(fontSize: 24)),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Duki dice:',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: _accentColor,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    result.riskLevel.kidLabel,
                    style: AppTextStyles.titleLarge.copyWith(
                      color: _accentColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Kid message (headline)
          if (message.isNotEmpty)
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                height: 1.4,
                color: const Color(0xFF1A1A1A),
              ),
            ),

          // Kid explanation
          if (explanation.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              explanation,
              style: AppTextStyles.bodyMedium.copyWith(
                height: 1.6,
                color: const Color(0xFF2C2C2C),
              ),
            ),
          ],

          // Reassurance stamp for low-risk
          if (result.riskLevel == RiskLevel.low) ...[
            const SizedBox(height: 14),
            Text(
              '¡Hiciste bien en preguntar! 👏',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _KidActionsCard — simple, numbered actions for the child
// ---------------------------------------------------------------------------

class _KidActionsCard extends StatelessWidget {
  const _KidActionsCard({required this.actions});

  final List<String> actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EEFF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFCEB8FF).withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('💡', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                '¿Qué podés hacer ahora?',
                style: AppTextStyles.labelMedium.copyWith(
                  color: const Color(0xFF6B3FCC),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...List.generate(actions.length, (i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: const BoxDecoration(
                      color: Color(0xFF6B3FCC),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${i + 1}',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      actions[i],
                      style: AppTextStyles.bodyMedium.copyWith(
                        height: 1.45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _TechnicalDetailsSection — collapsible secondary section
// ---------------------------------------------------------------------------

/// Groups all the technical / internal result details in a collapsible card
/// so the first impression stays kid-friendly but the data is still visible.
class _TechnicalDetailsSection extends StatefulWidget {
  const _TechnicalDetailsSection({required this.result});

  final AnalysisResult result;

  @override
  State<_TechnicalDetailsSection> createState() =>
      _TechnicalDetailsSectionState();
}

class _TechnicalDetailsSectionState extends State<_TechnicalDetailsSection> {
  bool _expanded = false;

  AnalysisResult get result => widget.result;

  Color get _barColor {
    if (result.score >= 66) return AppColors.danger;
    if (result.score >= 31) return AppColors.warning;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Header / toggle
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  const Icon(
                    Icons.manage_search_rounded,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Detalles del análisis',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          if (_expanded) ...[
            Divider(height: 1, color: AppColors.border),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Score bar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Nivel de riesgo',
                            style: AppTextStyles.labelMedium,
                          ),
                          Text(
                            '${result.score}/100',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: _barColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: result.score / 100,
                          minHeight: 8,
                          backgroundColor: AppColors.muted,
                          valueColor: AlwaysStoppedAnimation<Color>(_barColor),
                        ),
                      ),
                    ],
                  ),

                  // Internal explanation
                  if (result.explanation.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text('Análisis interno', style: AppTextStyles.labelMedium),
                    const SizedBox(height: 6),
                    Text(
                      result.explanation,
                      style: AppTextStyles.bodySmall.copyWith(height: 1.55),
                    ),
                  ],

                  // Detected terms chips
                  if (result.hasDetectedTerms) ...[
                    const SizedBox(height: 16),
                    _DetectedTermsCard(
                      terms: result.detectedTerms,
                      categories: result.categories,
                    ),
                  ],

                  // Signals list
                  if (result.signals.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _SignalsList(signals: result.signals),
                  ],

                  // Technical recommended actions
                  if (result.recommendedActions.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _ActionsList(actions: result.recommendedActions),
                  ],

                  // Minor advice
                  if (result.hasMinorAdvice) ...[
                    const SizedBox(height: 16),
                    _MinorAdviceCard(advice: result.minorAdvice),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _RiskHeroCard
// ---------------------------------------------------------------------------

class _RiskHeroCard extends StatelessWidget {
  const _RiskHeroCard({required this.result});

  final AnalysisResult result;

  Color get _barColor {
    if (result.score >= 66) return AppColors.danger;
    if (result.score >= 31) return AppColors.warning;
    return AppColors.success;
  }

  IconData get _icon {
    switch (result.riskLevel) {
      case RiskLevel.high:
        return Icons.warning_rounded;
      case RiskLevel.medium:
        return Icons.info_rounded;
      case RiskLevel.low:
        return Icons.shield_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _barColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(_icon, color: _barColor, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.riskLevel.label,
                      style: AppTextStyles.titleLarge.copyWith(
                        color: _barColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      result.summary,
                      style: AppTextStyles.bodySmall.copyWith(height: 1.45),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Score bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Nivel de riesgo', style: AppTextStyles.labelMedium),
                  Text(
                    '${result.score}/100',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: _barColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: result.score / 100,
                  minHeight: 10,
                  backgroundColor: AppColors.muted,
                  valueColor: AlwaysStoppedAnimation<Color>(_barColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _DetectedTermsCard
// ---------------------------------------------------------------------------

/// Shown only when pre-analysis found matching risk terms in the text input.
///
/// Displays them as chips with a soft amber tint, alongside a disclaimer
/// that presence alone doesn't mean danger.
class _DetectedTermsCard extends StatelessWidget {
  const _DetectedTermsCard({required this.terms, required this.categories});

  final List<String> terms;
  final List<String> categories;

  String get _categoryLabel {
    if (categories.isEmpty) return '';
    final labels = {
      'narcocultura': 'narcocultura',
      'reclutamiento': 'reclutamiento',
      'manipulacion': 'manipulación',
      'secretismo': 'secretismo',
      'trampa_dinero': 'trampa de dinero',
      'normalizacion': 'normalización',
      'simbolo_riesgo': 'símbolo de riesgo',
      'codigo': 'código',
    };
    return categories.map((c) => labels[c] ?? c).toSet().join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1), // warm amber tint
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFE082)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.travel_explore_rounded,
                size: 18,
                color: Color(0xFFBF8A00),
              ),
              const SizedBox(width: 8),
              Text(
                'Términos detectados',
                style: AppTextStyles.labelMedium.copyWith(
                  color: const Color(0xFFBF8A00),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Chips
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: terms
                .map(
                  (t) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFECB3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFFFCA28).withOpacity(0.7),
                      ),
                    ),
                    child: Text(
                      t,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: const Color(0xFF7A5700),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          if (_categoryLabel.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              'Contexto: $_categoryLabel',
              style: AppTextStyles.bodySmall.copyWith(
                color: const Color(0xFF7A5700),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 10),
          Text(
            '⚠️ Estos términos son señales de contexto, no una condena. '
            'Duki consideró el conjunto del mensaje para su análisis.',
            style: AppTextStyles.bodySmall.copyWith(
              color: const Color(0xFF7A5700),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _SignalsList
// ---------------------------------------------------------------------------

class _SignalsList extends StatelessWidget {
  const _SignalsList({required this.signals});

  final List<String> signals;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Señales detectadas',
      child: Column(
        children: signals
            .map(
              (s) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 3),
                      child: Icon(Icons.lens, size: 8, color: AppColors.danger),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        s,
                        style: AppTextStyles.bodyMedium.copyWith(height: 1.45),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _ActionsList
// ---------------------------------------------------------------------------

class _ActionsList extends StatelessWidget {
  const _ActionsList({required this.actions});

  final List<String> actions;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '¿Qué podés hacer?',
      child: Column(
        children: List.generate(actions.length, (i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Step number badge
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${i + 1}',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    actions[i],
                    style: AppTextStyles.bodyMedium.copyWith(height: 1.45),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _MinorAdviceCard
// ---------------------------------------------------------------------------

/// Surfaces age-appropriate safety advice when medium/high risk or
/// recruitment/manipulation signals are detected.
class _MinorAdviceCard extends StatelessWidget {
  const _MinorAdviceCard({required this.advice});

  final List<String> advice;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9), // soft green
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFA5D6A7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🛡️', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Text(
                'Consejos para cuidarte',
                style: AppTextStyles.labelMedium.copyWith(
                  color: const Color(0xFF2E7D32),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...advice.map(
            (tip) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Icon(
                      Icons.check_circle_rounded,
                      size: 14,
                      color: Color(0xFF43A047),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      tip,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: const Color(0xFF1B5E20),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _FooterNote
// ---------------------------------------------------------------------------

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.riskLevel});

  final RiskLevel riskLevel;

  String get _note {
    switch (riskLevel) {
      case RiskLevel.high:
        return '⚠️ Si sentís que estás en peligro, hablá con un adulto de confianza o llamá a una línea de ayuda.';
      case RiskLevel.medium:
        return '💡 Si tenés dudas sobre este contenido, podés mostrárselo a un adulto de confianza.';
      case RiskLevel.low:
        return '✅ El contenido parece seguro, pero siempre es bueno estar atento.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.muted,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        _note,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary,
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
