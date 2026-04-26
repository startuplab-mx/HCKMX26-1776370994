import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/nav_helper.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/section_card.dart';

// ---------------------------------------------------------------------------
// Constants
// ---------------------------------------------------------------------------

const _kTutorialSeenKey = 'ask_duki_tutorial_seen';

// ---------------------------------------------------------------------------
// Screen entry point
// ---------------------------------------------------------------------------

/// Pantalla "Pregúntale a Duki".
///
/// En el primer acceso muestra un tutorial con instrucciones.
/// Después de "¡Estoy listo!" u "Omitir" persiste el flag con shared_preferences
/// y muestra la pantalla de consulta normal en visitas posteriores.
class AskDukiScreen extends StatefulWidget {
  const AskDukiScreen({super.key});

  @override
  State<AskDukiScreen> createState() => _AskDukiScreenState();
}

class _AskDukiScreenState extends State<AskDukiScreen> {
  // null = loading, false = tutorial, true = normal
  bool? _tutorialSeen;

  @override
  void initState() {
    super.initState();
    _loadTutorialFlag();
  }

  Future<void> _loadTutorialFlag() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool(_kTutorialSeenKey) ?? false;
    if (mounted) setState(() => _tutorialSeen = seen);
  }

  Future<void> _markTutorialSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kTutorialSeenKey, true);
    if (mounted) setState(() => _tutorialSeen = true);
  }

  @override
  Widget build(BuildContext context) {
    // Loading state — blank background while we read prefs
    if (_tutorialSeen == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: SizedBox.shrink(),
      );
    }

    if (_tutorialSeen == false) {
      return _TutorialView(onReady: _markTutorialSeen);
    }

    return _ConsultView();
  }
}

// ---------------------------------------------------------------------------
// _TutorialView
// ---------------------------------------------------------------------------

class _TutorialView extends StatefulWidget {
  const _TutorialView({required this.onReady});

  final VoidCallback onReady;

  @override
  State<_TutorialView> createState() => _TutorialViewState();
}

class _TutorialViewState extends State<_TutorialView> {
  // 0 = Captura, 1 = Texto
  int _selectedMode = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ────────────────────────────────────────────────
            _TutorialTopBar(onSkip: widget.onReady),

            // ── Scrollable content ─────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Label chip
                    _LabelChip(label: 'TUTORIAL · CONSULTAR'),

                    const SizedBox(height: 16),

                    // Title + subtitle
                    Text(
                      '¿Cómo usar\nPregúntale a Duki?',
                      style: AppTextStyles.headlineLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Duki analiza contenido digital para ayudarte a identificar posibles riesgos. Elige cómo quieres compartirlo:',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Mode selector — Captura / Texto (sin Enlace)
                    _ModePicker(
                      selected: _selectedMode,
                      onSelect: (i) => setState(() => _selectedMode = i),
                    ),

                    const SizedBox(height: 20),

                    // Upload / info area preview
                    _UploadPreview(mode: _selectedMode),

                    const SizedBox(height: 24),

                    // Step cards
                    Text('Así funciona', style: AppTextStyles.titleMedium),
                    const SizedBox(height: 12),
                    const _StepCard(
                      step: '1',
                      icon: Icons.upload_rounded,
                      iconColor: Color(0xFF6ECBF5),
                      iconBg: Color(0xFFE3F5FF),
                      title: 'Envía el contenido',
                      body:
                          'Sube una captura de pantalla o pega el texto que quieres que Duki revise.',
                    ),
                    const SizedBox(height: 12),
                    const _StepCard(
                      step: '2',
                      icon: Icons.search_rounded,
                      iconColor: Color(0xFFF4B740),
                      iconBg: Color(0xFFFFF8E1),
                      title: 'Duki lo analiza',
                      body:
                          'Duki revisa el contenido buscando señales de peligro: engaños, presión, datos personales, etc.',
                    ),
                    const SizedBox(height: 12),
                    const _StepCard(
                      step: '3',
                      icon: Icons.shield_rounded,
                      iconColor: Color(0xFF46B97A),
                      iconBg: Color(0xFFE8F5E9),
                      title: 'Recibe el resultado',
                      body:
                          'Obtienes un reporte claro con el nivel de riesgo y qué hacer a continuación.',
                    ),

                    const SizedBox(height: 28),

                    // Primary CTA
                    PrimaryButton(
                      label: '¡Estoy listo!',
                      onPressed: widget.onReady,
                    ),

                    const SizedBox(height: 16),

                    // Privacy message
                    _PrivacyMessage(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _TutorialTopBar
// ---------------------------------------------------------------------------

class _TutorialTopBar extends StatelessWidget {
  const _TutorialTopBar({required this.onSkip});

  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          // Back button — uses Navigator.pop if possible, else go home
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            color: AppColors.textPrimary,
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                context.go('/home-kids');
              }
            },
          ),
          const Spacer(),
          TextButton(
            onPressed: onSkip,
            child: Text(
              'Omitir',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _LabelChip
// ---------------------------------------------------------------------------

class _LabelChip extends StatelessWidget {
  const _LabelChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.primaryPressed,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _ModePicker — Captura & Texto toggle (sin Enlace)
// ---------------------------------------------------------------------------

class _ModePicker extends StatelessWidget {
  const _ModePicker({required this.selected, required this.onSelect});

  final int selected;
  final ValueChanged<int> onSelect;

  static const _modes = [
    _ModeOption(
      icon: Icons.camera_alt_rounded,
      label: 'Captura',
      description: 'Imagen o pantallazos',
    ),
    _ModeOption(
      icon: Icons.text_fields_rounded,
      label: 'Texto',
      description: 'Pega el contenido',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_modes.length, (i) {
        final mode = _modes[i];
        final active = i == selected;
        return Expanded(
          child: GestureDetector(
            onTap: () => onSelect(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(right: i == 0 ? 8 : 0),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              decoration: BoxDecoration(
                color: active ? AppColors.primaryLight : AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: active ? AppColors.primary : AppColors.border,
                  width: active ? 1.5 : 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    mode.icon,
                    size: 28,
                    color: active
                        ? AppColors.primaryPressed
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    mode.label,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: active
                          ? AppColors.primaryPressed
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    mode.description,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _ModeOption {
  const _ModeOption({
    required this.icon,
    required this.label,
    required this.description,
  });

  final IconData icon;
  final String label;
  final String description;
}

// ---------------------------------------------------------------------------
// _UploadPreview — visual hint for the selected mode
// ---------------------------------------------------------------------------

class _UploadPreview extends StatelessWidget {
  const _UploadPreview({required this.mode});

  final int mode; // 0 = Captura, 1 = Texto

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.muted,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.border,
                style: BorderStyle.solid,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    mode == 0
                        ? Icons.add_photo_alternate_rounded
                        : Icons.content_paste_rounded,
                    size: 32,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    mode == 0
                        ? 'Toca para elegir imagen'
                        : 'Toca para pegar texto',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  mode == 0
                      ? 'Acepta JPG, PNG, HEIC. Máx. 10 MB.'
                      : 'Pega hasta 2 000 caracteres de texto.',
                  style: AppTextStyles.bodySmall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _StepCard
// ---------------------------------------------------------------------------

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.step,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.body,
  });

  final String step;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step number badge
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              step,
              style: AppTextStyles.labelMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.labelLarge),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: AppTextStyles.bodySmall.copyWith(height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _PrivacyMessage
// ---------------------------------------------------------------------------

class _PrivacyMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.lock_rounded,
          size: 13,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 5),
        Text(
          'Tu información es privada y no se almacena.',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// _ConsultView — Normal mode (after tutorial)
// ---------------------------------------------------------------------------

class _ConsultView extends StatefulWidget {
  @override
  State<_ConsultView> createState() => _ConsultViewState();
}

class _ConsultViewState extends State<_ConsultView> {
  // 0 = Captura, 1 = Texto
  int _mode = 0;
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  int get _currentNavIndex {
    final location = GoRouterState.of(context).uri.toString();
    final idx = NavHelper.indexForLocation(location);
    return idx < 0 ? 1 : idx; // default tab 1 = Duki
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentNavIndex,
        onTap: (i) => NavHelper.goToTab(context, i),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ─────────────────────────────────────────────────
            _ConsultHeader(),

            // ── Body ───────────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Title
                    Text(
                      'Consultar a Duki',
                      style: AppTextStyles.headlineMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Elige cómo quieres enviarle información a Duki:',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Mode picker
                    _ModePicker(
                      selected: _mode,
                      onSelect: (i) => setState(() {
                        _mode = i;
                        _textController.clear();
                      }),
                    ),

                    const SizedBox(height: 20),

                    // Input area
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: _mode == 0
                          ? _CaptureInput(key: const ValueKey('capture'))
                          : _TextInput(
                              key: const ValueKey('text'),
                              controller: _textController,
                            ),
                    ),

                    const SizedBox(height: 24),

                    // Send button
                    PrimaryButton(
                      label: 'Analizar con Duki',
                      icon: const Icon(
                        Icons.search_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        // TODO: integrate with analysis controller / repository
                        _showAnalyzingSnackbar(context);
                      },
                    ),

                    const SizedBox(height: 16),

                    _PrivacyMessage(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAnalyzingSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Duki está analizando...',
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryPressed,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _ConsultHeader
// ---------------------------------------------------------------------------

class _ConsultHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        children: [
          // Duki avatar badge
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 1.5),
            ),
            child: const Icon(
              Icons.smart_toy_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pregúntale a Duki', style: AppTextStyles.titleMedium),
              Text(
                'Tu asistente de seguridad digital',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _CaptureInput
// ---------------------------------------------------------------------------

class _CaptureInput extends StatefulWidget {
  const _CaptureInput({super.key});

  @override
  State<_CaptureInput> createState() => _CaptureInputState();
}

class _CaptureInputState extends State<_CaptureInput> {
  // Simple mock state — no actual image_picker wiring for hackathon speed
  bool _hasImage = false;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _hasImage = !_hasImage),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 140,
              decoration: BoxDecoration(
                color: _hasImage ? AppColors.primaryLight : AppColors.muted,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _hasImage ? AppColors.primary : AppColors.border,
                  width: _hasImage ? 1.5 : 1,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _hasImage
                          ? Icons.check_circle_rounded
                          : Icons.add_photo_alternate_rounded,
                      size: 40,
                      color: _hasImage
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _hasImage
                          ? 'Imagen lista ✓ (toca para cambiar)'
                          : 'Toca para subir una captura',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: _hasImage
                            ? AppColors.primaryPressed
                            : AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 13,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  'Acepta JPG, PNG, HEIC. Máx. 10 MB.',
                  style: AppTextStyles.bodySmall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _TextInput
// ---------------------------------------------------------------------------

class _TextInput extends StatelessWidget {
  const _TextInput({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            maxLines: 6,
            maxLength: 2000,
            style: AppTextStyles.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Pega aquí el texto que quieres que Duki revise…',
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
              filled: true,
              fillColor: AppColors.muted,
              contentPadding: const EdgeInsets.all(14),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 13,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  'Pega hasta 2 000 caracteres de texto.',
                  style: AppTextStyles.bodySmall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
