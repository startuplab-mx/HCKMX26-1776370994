import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../auth_controller.dart';

/// Pantalla de recuperación de contraseña.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    // TODO: Implementar lógica real de envío de enlace de recuperación (Supabase/Auth)
    final ok = await ref
        .read(authControllerProvider.notifier)
        .resetPassword(_emailCtrl.text.trim());
    if (!mounted) return;
    if (ok) setState(() => _sent = true);
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
        leadingWidth: 80,
        leading: Padding(
          padding: const EdgeInsets.only(left: 24, top: 8, bottom: 8),
          child: GestureDetector(
            onTap: () => context.go(AppRoutes.login),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: const Icon(
                Icons.chevron_left_rounded,
                color: AppColors.textPrimary,
                size: 24,
              ),
            ),
          ),
        ),
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
                child: _sent ? _buildSuccessState() : _buildFormState(isLoading, authState),
              ),

              const SizedBox(height: 24),

              // Banner de ayuda
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                      ),
                      child: const Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: '¿No tienes acceso al correo? ',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          children: [
                            TextSpan(
                              text: 'Pide ayuda a un adulto de confianza o ',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            TextSpan(
                              text: 'contáctanos.',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Footer
              Center(
                child: GestureDetector(
                  onTap: () => context.go(AppRoutes.login),
                  child: RichText(
                    text: TextSpan(
                      text: '¿Recordaste tu contraseña? ',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      children: [
                        TextSpan(
                          text: 'Volver',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormState(bool isLoading, AuthStateModel authState) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              '¿Olvidaste tu\ncontraseña?',
              textAlign: TextAlign.center,
              style: AppTextStyles.headlineLarge.copyWith(
                fontSize: 26,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'No te preocupes — pasa hasta a los más expertos. Te enviaremos lo necesario para recuperar tu acceso.',
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
          const SizedBox(height: 32),

          if (authState.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _ErrorBanner(message: authState.errorMessage!),
            ),

          PrimaryButton(
            label: 'Enviar enlace',
            onPressed: isLoading ? null : _submit,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState() {
    return Column(
      children: [
        const Icon(Icons.check_circle_outline_rounded,
            color: AppColors.primary, size: 64),
        const SizedBox(height: 20),
        Text('¡Correo enviado!', style: AppTextStyles.headlineMedium),
        const SizedBox(height: 12),
        Text(
          'Revisa tu bandeja de entrada para restablecer tu contraseña.',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 32),
        PrimaryButton(
          label: 'Volver al inicio',
          onPressed: () => context.go(AppRoutes.login),
        ),
      ],
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
