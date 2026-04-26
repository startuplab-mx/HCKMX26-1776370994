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
                    const SizedBox(height: 20),

                    // Risk level hero card
                    _RiskHeroCard(result: result),

                    const SizedBox(height: 20),

                    // Explanation
                    SectionCard(
                      title: '¿Qué encontró Duki?',
                      child: Text(
                        result.explanation,
                        style: AppTextStyles.bodyMedium.copyWith(height: 1.55),
                      ),
                    ),

                    // Pre-detected risk terms (only when found)
                    if (result.hasDetectedTerms) ...[
                      const SizedBox(height: 16),
                      _DetectedTermsCard(
                        terms: result.detectedTerms,
                        categories: result.categories,
                      ),
                    ],

                    if (result.signals.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _SignalsList(signals: result.signals),
                    ],

                    if (result.recommendedActions.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _ActionsList(actions: result.recommendedActions),
                    ],

                    // Child safety advice (only for medium/high or when terms detected)
                    if (result.hasMinorAdvice) ...[
                      const SizedBox(height: 16),
                      _MinorAdviceCard(advice: result.minorAdvice),
                    ],

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
          Text('Resultado del análisis', style: AppTextStyles.titleMedium),
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
