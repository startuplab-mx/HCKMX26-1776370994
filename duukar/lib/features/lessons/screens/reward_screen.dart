import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/constants/app_supabase.dart';
import '../../../core/widgets/primary_button.dart';

/// Pantalla de recompensas: Aparece al completar misiones o lecciones importantes.
class RewardScreen extends StatelessWidget {
  const RewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeRoute = AppSupabase.homeRouteForCurrentUser();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ────────────────────────────────────────────────────
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: TextButton(
                  onPressed: () => context.go(homeRoute),
                  child: Text(
                    'Saltar',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    // ── Ilustración Central ────────────────────────────────
                    const _RewardTrophy(),

                    const SizedBox(height: 32),

                    // ── Badge y Textos ─────────────────────────────────────
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4B740),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        'PRIMERA MISIÓN COMPLETADA',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '¡Increíble trabajo!',
                      style: AppTextStyles.headlineMedium.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Acabas de dar tu primer paso para navegar\ncon más confianza.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── Lista de Recompensas ───────────────────────────────
                    const _RewardItem(
                      icon: Icons.monetization_on_rounded,
                      iconColor: Color(0xFFF4B740),
                      iconBg: Color(0xFFFFF8E6),
                      title: '+60 Duki-monedas',
                      subtitle: 'Tu primera recompensa',
                      actionLabel: '+60',
                      actionColor: Color(0xFFF4B740),
                    ),
                    const SizedBox(height: 12),
                    const _RewardItem(
                      icon: Icons.shield_outlined,
                      iconColor: Color(0xFF46B97A),
                      iconBg: Color(0xFFEEFAF3),
                      title: 'Insignia: Explorador Seguro',
                      subtitle: 'Primera insignia desbloqueada',
                      actionLabel: 'NUEVA',
                      actionColor: Color(0xFF46B97A),
                    ),
                    const SizedBox(height: 12),
                    const _RewardItem(
                      icon: Icons.face_unlock_rounded,
                      iconColor: Color(0xFF8B6EF5),
                      iconBg: Color(0xFFF1EEFF),
                      title: 'Skin: Duki Detective',
                      subtitle: 'Personaliza a tu guía',
                      actionLabel: 'NUEVO',
                      actionColor: Color(0xFF8B6EF5),
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
                label: 'Reclamar y continuar',
                onPressed: () => context.go(homeRoute),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Widgets Privados ────────────────────────────────────────────────────────

class _RewardTrophy extends StatelessWidget {
  const _RewardTrophy();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Anillos exteriores
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE9F2FA), width: 1),
            ),
          ),
          Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE9F2FA), width: 2),
            ),
          ),
          // Círculo central con degradado
          Container(
            width: 140,
            height: 140,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Color(0xFFF4B740), Color(0xFFFFD580)],
              ),
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              color: Colors.white,
              size: 64,
            ),
          ),
          // Chispitas / Ornatos
          Positioned(
            top: 20,
            right: 30,
            child: Icon(
              Icons.star_rounded,
              size: 16,
              color: const Color(0xFFF4B740).withOpacity(0.6),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            child: Icon(
              Icons.star_rounded,
              size: 12,
              color: const Color(0xFFF4B740).withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _RewardItem extends StatelessWidget {
  const _RewardItem({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.actionColor,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final String actionLabel;
  final Color actionColor;

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
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 24),
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
                Text(subtitle, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          Text(
            actionLabel,
            style: AppTextStyles.labelMedium.copyWith(
              color: actionColor,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
