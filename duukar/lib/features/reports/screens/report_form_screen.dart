import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/nav_helper.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../core/widgets/primary_button.dart';

// ---------------------------------------------------------------------------
// Data — swap for real enums / backend models
// ---------------------------------------------------------------------------

enum _Category { grooming, reclutamiento, estafa, otro }

extension _CategoryLabel on _Category {
  String get label {
    switch (this) {
      case _Category.grooming:
        return 'Grooming';
      case _Category.reclutamiento:
        return 'Reclutamiento';
      case _Category.estafa:
        return 'Estafa';
      case _Category.otro:
        return 'Otro';
    }
  }

  IconData get icon {
    switch (this) {
      case _Category.grooming:
        return Icons.psychology_rounded;
      case _Category.reclutamiento:
        return Icons.people_rounded;
      case _Category.estafa:
        return Icons.warning_amber_rounded;
      case _Category.otro:
        return Icons.help_outline_rounded;
    }
  }
}

const _platforms = [
  'Instagram',
  'TikTok',
  'Facebook',
  'WhatsApp',
  'Telegram',
  'Twitter / X',
  'Snapchat',
  'Discord',
  'Roblox',
  'Otro',
];

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

/// Formulario para crear un reporte de incidente digital.
/// Solo frontend — lógica de envío pendiente (TODO).
class ReportFormScreen extends StatefulWidget {
  const ReportFormScreen({super.key});

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  _Category? _selectedCategory;
  String? _selectedPlatform;
  final _linkController = TextEditingController();
  final _notesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool get _canSubmit =>
      _selectedCategory != null &&
      _selectedPlatform != null &&
      _linkController.text.trim().isNotEmpty;

  int get _currentNavIndex {
    final location = GoRouterState.of(context).uri.toString();
    final idx = NavHelper.indexForLocation(location);
    return idx < 0 ? 2 : idx;
  }

  @override
  void dispose() {
    _linkController.dispose();
    _notesController.dispose();
    super.dispose();
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
            // ── Header ──────────────────────────────────────────────────
            _ReportHeader(),

            // ── Body ─────────────────────────────────────────────────────
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Título ─────────────────────────────────────────
                      Text('Crear Reporte', style: AppTextStyles.headlineLarge),
                      const SizedBox(height: 6),
                      Text(
                        'Tu reporte ayuda a mantener la comunidad segura. Por favor, proporciona los detalles necesarios a continuación.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── Categoría ─────────────────────────────────────
                      _SectionLabel(label: 'CATEGORÍA DEL INCIDENTE'),
                      const SizedBox(height: 10),
                      _CategoryGrid(
                        selected: _selectedCategory,
                        onSelect: (c) =>
                            setState(() => _selectedCategory = c),
                      ),

                      const SizedBox(height: 24),

                      // ── Plataforma ─────────────────────────────────────
                      _SectionLabel(label: 'PLATAFORMA'),
                      const SizedBox(height: 10),
                      _PlatformDropdown(
                        value: _selectedPlatform,
                        onChanged: (v) =>
                            setState(() => _selectedPlatform = v),
                      ),

                      const SizedBox(height: 24),

                      // ── Link / usuario ─────────────────────────────────
                      _SectionLabel(label: 'LINK O NOMBRE DE USUARIO'),
                      const SizedBox(height: 10),
                      _StyledTextField(
                        controller: _linkController,
                        hint: 'ej. @usuario o perfil.com/link',
                        prefixIcon: Icons.link_rounded,
                        keyboardType: TextInputType.url,
                        onChanged: (_) => setState(() {}),
                      ),

                      const SizedBox(height: 24),

                      // ── Notas ──────────────────────────────────────────
                      _SectionLabel(label: 'NOTAS OPCIONALES'),
                      const SizedBox(height: 10),
                      _StyledTextField(
                        controller: _notesController,
                        hint: 'Describe brevemente lo ocurrido...',
                        maxLines: 4,
                        keyboardType: TextInputType.multiline,
                      ),

                      const SizedBox(height: 32),

                      // ── Botón enviar ──────────────────────────────────
                      ListenableBuilder(
                        listenable: _linkController,
                        builder: (_, __) => PrimaryButton(
                          label: 'Enviar Reporte',
                          icon: const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          // TODO: conectar con ReportRepository.submit()
                          onPressed: _canSubmit ? _onSubmit : null,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Privacy note
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.lock_rounded,
                              size: 13,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'Tu reporte es anónimo y confidencial.',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
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
    );
  }

  void _onSubmit() {
    // TODO: validar y enviar a ReportRepository.submit(category, platform, link, notes)
    // TODO: navegar a pantalla de confirmación / historial tras éxito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(
              '¡Reporte enviado! Gracias por ayudar.',
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF46B97A),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _ReportHeader
// ---------------------------------------------------------------------------

class _ReportHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.border.withOpacity(0.5), width: 1),
        ),
      ),
      child: Row(
        children: [
          Text('Duukar', style: AppTextStyles.titleAppBar),
          const Spacer(),
          // Coin circle
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF4B740),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF4B740).withOpacity(0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🪙', style: TextStyle(fontSize: 12)),
                  Text(
                    '120',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white,
                      fontFamily: 'Fredoka',
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryLight,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _SectionLabel
// ---------------------------------------------------------------------------

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.labelSmall.copyWith(
        color: AppColors.textSecondary,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.8,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _CategoryGrid
// ---------------------------------------------------------------------------

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({required this.selected, required this.onSelect});

  final _Category? selected;
  final ValueChanged<_Category> onSelect;

  @override
  Widget build(BuildContext context) {
    final cats = _Category.values;
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: cats.map((c) {
        final active = c == selected;
        return GestureDetector(
          onTap: () => onSelect(c),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: active ? AppColors.primaryLight : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: active ? AppColors.primary : AppColors.border,
                width: active ? 1.5 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  c.icon,
                  size: 16,
                  color: active
                      ? AppColors.primaryPressed
                      : AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  c.label,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: active
                        ? AppColors.primaryPressed
                        : AppColors.textPrimary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// _PlatformDropdown
// ---------------------------------------------------------------------------

class _PlatformDropdown extends StatelessWidget {
  const _PlatformDropdown({required this.value, required this.onChanged});

  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(
            'Selecciona una red social',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.textSecondary),
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
          ),
          borderRadius: BorderRadius.circular(16),
          items: _platforms
              .map((p) => DropdownMenuItem(value: p, child: Text(p)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _StyledTextField
// ---------------------------------------------------------------------------

class _StyledTextField extends StatelessWidget {
  const _StyledTextField({
    required this.controller,
    required this.hint,
    this.prefixIcon,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final IconData? prefixIcon;
  final int maxLines;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary.withOpacity(0.6),
        ),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.textSecondary, size: 20)
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
