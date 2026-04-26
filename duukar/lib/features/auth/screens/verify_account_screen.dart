import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';

/// Pantalla de verificación de cuenta por email.
/// Se muestra después del registro cuando Supabase requiere confirmación.
class VerifyAccountScreen extends StatelessWidget {
  const VerifyAccountScreen({super.key});

  // El email se puede pasar como query param en producción.
  // Por ahora se muestra genérico.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 32, 28, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mark_email_unread_outlined,
                  size: 52,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 32),

              Text(
                'Verifica tu correo',
                style: AppTextStyles.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Te enviamos un correo de confirmación.\nAbre el enlace para activar tu cuenta y luego regresa aquí.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              PrimaryButton(
                label: 'Ya verifiqué mi cuenta',
                onPressed: () => context.go(AppRoutes.login),
              ),
              const SizedBox(height: 14),
              PrimaryButton(
                label: 'Cambiar correo',
                onPressed: () => context.go(AppRoutes.register),
                variant: PrimaryButtonVariant.outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
