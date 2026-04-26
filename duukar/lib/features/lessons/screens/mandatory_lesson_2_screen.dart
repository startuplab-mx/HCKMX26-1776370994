import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';

/// Lección obligatoria 2: "Aprende a leer las banderas rojas."
class MandatoryLesson2Screen extends StatelessWidget {
  const MandatoryLesson2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ─────────────────────────────────────────────────────
            const _LessonHeader(
              title: 'LECCIÓN OBLIGATORIA · 02',
              subtitle: 'Paso 2 de 3',
              points: 20,
              progress: 0.66,
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Hero Card Señales de Alerta ────────────────────────
                    const _HeroCard(
                      label: 'SEÑALES DE ALERTA',
                      title: 'Aprende a leer las\n"banderas rojas" 🚩',
                      description: 'Toca cada señal para descubrir cómo funciona.',
                    ),

                    const SizedBox(height: 24),

                    // ── Señales ───────────────────────────────────────────
                    const _SignalCard(
                      title: '¡Tienes que responder YA!',
                      tag: 'PRESIÓN',
                      tagColor: Color(0xFFE35D6A),
                      tagBg: Color(0xFFFDECED),
                    ),
                    const SizedBox(height: 12),
                    const _SignalCard(
                      title: '"No le digas a nadie de mí"',
                      tag: 'SECRETO',
                      tagColor: Color(0xFF8B6EF5),
                      tagBg: Color(0xFFF1EEFF),
                    ),
                    const SizedBox(height: 12),
                    const _SignalCard(
                      title: '"Ganaste un premio increíble"',
                      tag: 'ENGAÑO',
                      tagColor: Color(0xFFF4B740),
                      tagBg: Color(0xFFFFF8E6),
                    ),
                    const SizedBox(height: 12),
                    const _SignalCard(
                      title: '"¿Me mandas una foto tuya?"',
                      tag: 'INVASIÓN',
                      tagColor: Color(0xFFE35D6A),
                      tagBg: Color(0xFFFDECED),
                    ),

                    const SizedBox(height: 24),

                    // ── Tip de Duki ───────────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F5FF),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.shield_outlined,
                                color: AppColors.primary, size: 20),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textPrimary,
                                  height: 1.4,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Tip de Duki: ',
                                    style: AppTextStyles.labelLarge.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const TextSpan(
                                    text:
                                        'Si algo te hace sentir raro, eso ya es una señal. Confía en ti.',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // ── Footer ─────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(24),
              child: PrimaryButton(
                label: 'Continuar',
                onPressed: () => context.go(AppRoutes.mandatoryLesson3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Widgets Privados ────────────────────────────────────────────────────────

class _LessonHeader extends StatelessWidget {
  const _LessonHeader({
    required this.title,
    required this.subtitle,
    required this.points,
    required this.progress,
  });

  final String title;
  final String subtitle;
  final int points;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => context.go(AppRoutes.mandatoryLesson1),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(Icons.chevron_left_rounded, size: 24),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F5FF),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 16, color: Color(0xFF4FA8D1)),
                    const SizedBox(width: 4),
                    Text(
                      '+$points pts',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: const Color(0xFF4FA8D1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: const Color(0xFFE9F2FA),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.label,
    required this.title,
    required this.description,
  });

  final String label;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFE6D6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 10,
            top: 10,
            child: Icon(
              Icons.warning_amber_rounded,
              size: 100,
              color: const Color(0xFFE35D6A).withOpacity(0.15),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: const Color(0xFFE35D6A),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: AppTextStyles.headlineMedium.copyWith(
                    height: 1.1,
                    fontSize: 26,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: const Color(0xFF8B5E52).withOpacity(0.8),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SignalCard extends StatelessWidget {
  const _SignalCard({
    required this.title,
    required this.tag,
    required this.tagColor,
    required this.tagBg,
  });

  final String title;
  final String tag;
  final Color tagColor;
  final Color tagBg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFDECED),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.flag_rounded, color: Color(0xFFE35D6A), size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                  ),
                ),
                Text(
                  'Toca para ver por qué',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: tagBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              tag,
              style: AppTextStyles.labelSmall.copyWith(
                color: tagColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
