import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';

/// Tutorial de espacios principales de la app.
/// Muestra tarjetas de cada sección con ícono, nombre y descripción.
class NavigationTutorialScreen extends StatefulWidget {
  const NavigationTutorialScreen({super.key});

  @override
  State<NavigationTutorialScreen> createState() =>
      _NavigationTutorialScreenState();
}

class _NavigationTutorialScreenState extends State<NavigationTutorialScreen> {
  int _step = 0;

  static const _sections = [
    _Section(
      icon: Icons.home_rounded,
      color: Color(0xFF6ECBF5),
      title: 'Inicio',
      description:
          'Tu panel principal. Aquí verás tu nivel, racha diaria y las misiones disponibles.',
    ),
    _Section(
      icon: Icons.search_rounded,
      color: Color(0xFF8B6EF5),
      title: 'Analizar',
      description:
          'Envíale a Duki una captura, enlace o texto para saber si hay algo sospechoso.',
    ),
    _Section(
      icon: Icons.flag_rounded,
      color: Color(0xFFE35D6A),
      title: 'Reportar',
      description:
          'Encontraste algo peligroso en línea. Repórtalo aquí para ayudar a otros.',
    ),
    _Section(
      icon: Icons.emoji_events_rounded,
      color: Color(0xFFF4B740),
      title: 'Logros',
      description:
          'Tus insignias, puntos y recompensas cosméticas. ¡Colecciónalos todos!',
    ),
    _Section(
      icon: Icons.person_rounded,
      color: Color(0xFF46B97A),
      title: 'Perfil',
      description:
          'Ajusta tu apariencia, configura tu cuenta y controla tu privacidad.',
    ),
  ];

  void _next() {
    if (_step < _sections.length - 1) {
      setState(() => _step++);
    } else {
      // TODO: navegar a lección obligatoria 1 cuando esté lista
      context.go(AppRoutes.mandatoryLesson1);
    }
  }

  void _skip() => context.go(AppRoutes.mandatoryLesson1);

  @override
  Widget build(BuildContext context) {
    final section = _sections[_step];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Text('Tutorial', style: AppTextStyles.titleLarge),
                  const Spacer(),
                  TextButton(
                    onPressed: _skip,
                    child: Text(
                      'Saltar',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Indicadores de paso
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: List.generate(_sections.length, (i) {
                  final active = i == _step;
                  final done = i < _step;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        height: 5,
                        decoration: BoxDecoration(
                          color: (active || done)
                              ? AppColors.primary
                              : AppColors.border,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${_step + 1} / ${_sections.length}',
                  style: AppTextStyles.bodySmall,
                ),
              ),
            ),

            const Spacer(),

            // Contenido de la sección actual
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.08, 0),
                    end: Offset.zero,
                  ).animate(anim),
                  child: child,
                ),
              ),
              child: _SectionCard(section: section, key: ValueKey(_step)),
            ),

            const Spacer(),

            // Fila inferior con Duki pequeño
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Image.asset(
                    'assets/img/duki_delado.png',
                    height: 72,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const SizedBox(width: 72),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        _dukiMessage(_step),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: PrimaryButton(
                label: _step < _sections.length - 1
                    ? 'Entendido, ¡siguiente!'
                    : '¡Listo, quiero empezar!',
                onPressed: _next,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  String _dukiMessage(int step) {
    const messages = [
      '¡Aquí verás todo lo que pasa! Tu base de operaciones.',
      'Mándame lo que sea sospechoso. Soy muy bueno detectando trampas.',
      'Reportar hace que todos estemos más seguros. ¡Eres un héroe!',
      'Cada misión te da puntos. ¡Colecciona todas las insignias!',
      'Tu perfil, tus reglas. Siempre en control.',
    ];
    return messages[step];
  }
}

class _Section {
  const _Section({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String description;
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({super.key, required this.section});
  final _Section section;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          // Ícono grande
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: section.color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(section.icon, size: 56, color: section.color),
          ),
          const SizedBox(height: 28),

          Text(
            section.title,
            style: AppTextStyles.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            section.description,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
