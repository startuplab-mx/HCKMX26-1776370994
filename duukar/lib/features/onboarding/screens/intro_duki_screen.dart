import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/local_prefs.dart';
import '../../../core/widgets/primary_button.dart';

/// Pantalla "Conoce a Duki" — presentación del asistente virtual.
/// Multi-step con 3 diapositivas que se avanza con el botón "Siguiente".
class IntroDukiScreen extends StatefulWidget {
  const IntroDukiScreen({super.key});

  @override
  State<IntroDukiScreen> createState() => _IntroDukiScreenState();
}

class _IntroDukiScreenState extends State<IntroDukiScreen> {
  Future<void> _onDone() async {
    await LocalPrefs.setDukiIntroSeen();
    if (!mounted) return;
    context.go(AppRoutes.navigationTutorial);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text('Duukar', style: AppTextStyles.titleAppBar),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              // Mascot & Speech Bubble
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topRight,
                  children: [
                    Image.asset(
                      'assets/img/duuki_frente.png',
                      height: 180,
                      fit: BoxFit.contain,
                    ),
                    Positioned(
                      top: -10,
                      right: -40,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border, width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '¡Hola! Soy Duki 👋',
                              style: AppTextStyles.labelLarge.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                'Conoce a Duki',
                style: AppTextStyles.headlineLarge.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Tu guía digital. Está aquí para ayudarte a entender qué pasa en línea — sin presionarte ni juzgarte.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 30),

              // Feature Cards
              _FeatureCard(
                icon: Icons.verified_user_outlined,
                iconColor: const Color(0xFF4CAF50),
                bgColor: const Color(0xFFE8F5E9),
                title: 'Nunca invasivo',
                subtitle: 'Solo aparece cuando lo necesitas o lo llamas tú.',
              ),
              const SizedBox(height: 16),

              _FeatureCard(
                icon: Icons.chat_bubble_outline_rounded,
                iconColor: const Color(0xFF2196F3),
                bgColor: const Color(0xFFE3F2FD),
                title: 'Habla tu idioma',
                subtitle: 'Te explica ideas complejas con palabras claras.',
              ),
              const SizedBox(height: 16),

              _FeatureCard(
                icon: Icons.lock_outline_rounded,
                iconColor: const Color(0xFF9C27B0),
                bgColor: const Color(0xFFF3E5F5),
                title: 'Tus secretos están seguros',
                subtitle: 'Lo que conversas con Duki es privado.',
              ),

              const SizedBox(height: 30),

              PrimaryButton(label: 'Conocer las secciones', onPressed: _onDone),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
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
