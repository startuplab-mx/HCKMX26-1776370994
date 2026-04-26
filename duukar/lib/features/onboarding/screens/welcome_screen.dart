import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Logo grande central
              Center(
                child: Image.asset(
                  'assets/img/duukar_logo.png',
                  width: 220,
                  height: 220,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 48),

              // Texto de Bienvenida
              Text(
                'Tu espacio para\nnavegar con confianza',
                textAlign: TextAlign.center,
                style: AppTextStyles.headlineLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Aprende a reconocer la manipulación, los\nengaños y el contenido peligroso en línea\n— con Duki a tu lado.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),

              const Spacer(flex: 3),


              PrimaryButton(
                label: 'Continuar',
                onPressed: () => context.go(AppRoutes.login),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
