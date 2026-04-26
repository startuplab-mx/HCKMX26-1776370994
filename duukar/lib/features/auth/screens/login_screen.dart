import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../auth_controller.dart';

/// Pantalla de inicio de sesión.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final ok = await ref
        .read(authControllerProvider.notifier)
        .signIn(email: _emailCtrl.text.trim(), password: _passwordCtrl.text);
    if (!mounted) return;
    if (ok) {
      // TODO: navegar a home según ageRange del usuario
      context.go(AppRoutes.introDuki);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Duukar',
          style: AppTextStyles.titleAppBar,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 24),

              // Card principal
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          '¡Bienvenido!',
                          style: AppTextStyles.headlineLarge.copyWith(
                            fontSize: 26,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Accede a tu refugio digital de seguridad.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 32),

                      _buildLabel('CORREO ELECTRÓNICO'),
                      AppTextField(
                        controller: _emailCtrl,
                        label: 'Email',
                        hint: 'example@duukar.com',
                        prefixIcon: Icons.mail_outline,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) => !v!.contains('@') ? 'Inválido' : null,
                      ),
                      const SizedBox(height: 20),

                      _buildLabel('CONTRASEÑA'),
                      AppTextField(
                        controller: _passwordCtrl,
                        label: 'Contraseña',
                        hint: '••••••••',
                        prefixIcon: Icons.lock_outline,
                        isPassword: true,
                        onFieldSubmitted: (_) => _submit(),
                        validator: (v) => v!.length < 6 ? 'Muy corta' : null,
                      ),
                      const SizedBox(height: 32),

                      if (authState.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _ErrorBanner(message: authState.errorMessage!),
                        ),

                      PrimaryButton(
                        label: 'Iniciar sesión',
                        onPressed: isLoading ? null : _submit,
                        isLoading: isLoading,
                      ),

                      const SizedBox(height: 24),

                      Center(
                        child: GestureDetector(
                          onTap: () => context.go(AppRoutes.forgotPassword),
                          child: Text(
                            'Recuperar contraseña',
                            style: AppTextStyles.labelMedium.copyWith(
                              decoration: TextDecoration.underline,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Footer
              Center(
                child: GestureDetector(
                  onTap: () => context.go(AppRoutes.register),
                  child: RichText(
                    text: TextSpan(
                      text: '¿No tienes una cuenta? ',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      children: [
                        TextSpan(
                          text: 'Regístrate ahora',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('POLÍTICA DE PRIVACIDAD',
                      style: AppTextStyles.labelSmall.copyWith(
                          fontSize: 10, color: AppColors.textSecondary)),
                  const SizedBox(width: 20),
                  Text('TÉRMINOS DE SERVICIO',
                      style: AppTextStyles.labelSmall.copyWith(
                          fontSize: 10, color: AppColors.textSecondary)),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: AppTextStyles.labelMedium.copyWith(
          letterSpacing: 0.5,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.danger.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.danger.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.danger,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
  }
}
