import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/local_prefs.dart';
import '../../../core/widgets/primary_button.dart';

/// Lección obligatoria 3: "Cuando algo se sienta mal…"
class MandatoryLesson3Screen extends StatefulWidget {
  const MandatoryLesson3Screen({super.key});

  @override
  State<MandatoryLesson3Screen> createState() => _MandatoryLesson3ScreenState();
}

class _MandatoryLesson3ScreenState extends State<MandatoryLesson3Screen> {
  Future<void> _onFinish() async {
    await LocalPrefs.setMandatoryLessonsCompleted();
    if (!mounted) return;
    context.go(AppRoutes.reward);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ─────────────────────────────────────────────────────
            const _LessonHeader(
              title: 'LECCIÓN OBLIGATORIA · 03',
              subtitle: 'Paso 3 de 3',
              points: 20,
              progress: 1.0,
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Duki Zen ──────────────────────────────────────────
                    Center(
                      child: Image.asset(
                        'assets/img/duki_zen.png',
                        height: 240,
                        fit: BoxFit.contain,
                      ),
                    ),

                    // ── Hero Card Plan de 4 Pasos ──────────────────────────
                    const _HeroCard(
                      label: 'PLAN DE 4 PASOS',
                      title: 'Cuando algo se sienta\nmal...',
                      description:
                          'No estás solo. Sigue estos 4 pasos en cualquier orden — el que más te ayude.',
                    ),

                    const SizedBox(height: 24),

                    // ── Pasos con línea vertical ───────────────────────────
                    Stack(
                      children: [
                        // Línea vertical decorativa
                        Positioned(
                          left: 23,
                          top: 40,
                          bottom: 40,
                          child: Container(
                            width: 2,
                            color: const Color(0xFFF1F1F1),
                          ),
                        ),
                        Column(
                          children: const [
                            _StepCard(
                              number: '01',
                              title: 'Pausa y respira',
                              subtitle:
                                  'No respondas de inmediato. Tu calma es tu mejor herramienta.',
                              circleBg: Color(0xFFE3F5FF),
                              numberColor: Color(0xFF4FA8D1),
                            ),
                            SizedBox(height: 12),
                            _StepCard(
                              number: '02',
                              title: 'Cuéntale a un adulto',
                              subtitle:
                                  'Mamá, papá, un profe — alguien que te quiera bien.',
                              circleBg: Color(0xFFF1EEFF),
                              numberColor: Color(0xFF8B6EF5),
                            ),
                            SizedBox(height: 12),
                            _StepCard(
                              number: '03',
                              title: 'Pregúntale a Duki',
                              subtitle:
                                  'Comparte la captura o el enlace. Te ayudo a entender.',
                              circleBg: Color(0xFFEEFAF3),
                              numberColor: Color(0xFF46B97A),
                            ),
                            SizedBox(height: 12),
                            _StepCard(
                              number: '04',
                              title: 'Reporta y bloquea',
                              subtitle:
                                  'Si insisten, repórtalo. Tu seguridad es lo primero.',
                              circleBg: Color(0xFFFDECED),
                              numberColor: Color(0xFFE35D6A),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ── Ayuda Urgente ─────────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDECED),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFE35D6A).withOpacity(0.1),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE35D6A),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'SOS',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '¿Necesitas ayuda urgente?',
                                  style: AppTextStyles.labelLarge.copyWith(
                                    color: const Color(0xFFE35D6A),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'El botón rojo de Duukar siempre está a un toque.',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: const Color(
                                      0xFF8B5E5E,
                                    ).withOpacity(0.7),
                                  ),
                                ),
                              ],
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
              child: PrimaryButton(label: 'Lo tengo', onPressed: _onFinish),
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
                onTap: () => context.go(AppRoutes.mandatoryLesson2),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F5FF),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 16,
                      color: Color(0xFF4FA8D1),
                    ),
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
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
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
        color: const Color(0xFFD9F2E6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
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
                    color: const Color(0xFF46B97A),
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
                    color: AppColors.textSecondary,
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

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.circleBg,
    required this.numberColor,
  });

  final String number;
  final String title;
  final String subtitle;
  final Color circleBg;
  final Color numberColor;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: circleBg, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(
              number,
              style: TextStyle(
                color: numberColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
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
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
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
