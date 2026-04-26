import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';

/// Lección obligatoria 1: "Internet es como una ciudad enorme."
class MandatoryLesson1Screen extends StatefulWidget {
  const MandatoryLesson1Screen({super.key});

  @override
  State<MandatoryLesson1Screen> createState() => _MandatoryLesson1ScreenState();
}

class _MandatoryLesson1ScreenState extends State<MandatoryLesson1Screen> {
  // null = sin responder, true = correcta, false = incorrecta
  bool? _selectedAnswer;

  void _onNext() {
    context.go(AppRoutes.mandatoryLesson2);
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
              title: 'LECCIÓN OBLIGATORIA · 01',
              subtitle: 'Paso 1 de 3',
              points: 20,
              progress: 0.33,
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Idea Principal ─────────────────────────────────────
                    const _HeroCard(
                      label: 'IDEA PRINCIPAL',
                      title: 'Internet es como una\nciudad enorme.',
                      description:
                          'Hay lugares geniales... y otros donde es mejor caminar con cuidado. Aprender a reconocerlos es tu superpoder.',
                    ),

                    const SizedBox(height: 24),

                    Text(
                      'Dos tipos de espacios:',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ── Espacios Seguros ───────────────────────────────────
                    _SpaceCard(
                      label: 'ESPACIOS SEGUROS',
                      title: 'Tu chat familiar, juegos con permiso',
                      description: 'Conoces a las personas. Hay límites claros.',
                      icon: Icons.shield_outlined,
                      color: AppColors.success,
                      bgColor: const Color(0xFFEEFAF3),
                    ),

                    const SizedBox(height: 12),

                    // ── Espacios con Dudas ─────────────────────────────────
                    const _SpaceCard(
                      label: 'ESPACIOS CON DUDAS',
                      title: 'Mensajes de desconocidos, regalos sospechosos',
                      description: 'Algo no encaja. Es momento de pausar.',
                      icon: Icons.warning_amber_rounded,
                      color: AppColors.warning,
                      bgColor: Color(0xFFFFF8E6),
                    ),

                    const SizedBox(height: 24),

                    // ── Pregunta ───────────────────────────────────────────
                    _QuestionBox(
                      question: '¿Qué espacio te suena más seguro?',
                      selectedAnswer: _selectedAnswer,
                      onSelect: (correct) => setState(() => _selectedAnswer = correct),
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
                onPressed: _selectedAnswer == true ? _onNext : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Widgets de la Pantalla ──────────────────────────────────────────────────

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
              // Badge de puntos
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
          // Barra de progreso
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
        color: const Color(0xFFD6EEF9),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          // Ornamento de círculo
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 140,
              height: 140,
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
                    color: const Color(0xFF4FA8D1),
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

class _SpaceCard extends StatelessWidget {
  const _SpaceCard({
    required this.label,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  final String label;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Color bgColor;

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
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                  ),
                ),
                Text(
                  description,
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

class _QuestionBox extends StatelessWidget {
  const _QuestionBox({
    required this.question,
    required this.selectedAnswer,
    required this.onSelect,
  });

  final String question;
  final bool? selectedAnswer;
  final ValueChanged<bool> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F5FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.question_mark_rounded,
                    size: 14, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  question,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _OptionBtn(
            label: 'Un grupo nuevo que pide tu dirección',
            isSelected: selectedAnswer == false,
            isCorrect: false,
            onTap: () => onSelect(false),
          ),
          const SizedBox(height: 10),
          _OptionBtn(
            label: 'Un juego con tus amigos del cole',
            isSelected: selectedAnswer == true,
            isCorrect: true,
            onTap: () => onSelect(true),
          ),
        ],
      ),
    );
  }
}

class _OptionBtn extends StatelessWidget {
  const _OptionBtn({
    required this.label,
    required this.isSelected,
    required this.isCorrect,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool isCorrect;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Color borderColor = AppColors.border;
    if (isSelected) {
      borderColor = isCorrect ? AppColors.success : AppColors.danger;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
