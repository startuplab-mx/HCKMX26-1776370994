import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

/// Botón principal de Duukar.
/// Usa [label] como texto, [onPressed] como callback.
/// Si [isLoading] es true, muestra un spinner y deshabilita el tap.
/// [variant] permite usar el botón en modo outline (secundario).
enum PrimaryButtonVariant { filled, outline }

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.variant = PrimaryButtonVariant.filled,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final PrimaryButtonVariant variant;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    if (variant == PrimaryButtonVariant.outline) {
      return _OutlineBtn(
        label: label,
        onPressed: isLoading ? null : onPressed,
        icon: icon,
      );
    }
    return _FilledBtn(
      label: label,
      onPressed: isLoading ? null : onPressed,
      isLoading: isLoading,
      icon: icon,
    );
  }
}

class _FilledBtn extends StatefulWidget {
  const _FilledBtn({
    required this.label,
    required this.onPressed,
    required this.isLoading,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;

  @override
  State<_FilledBtn> createState() => _FilledBtnState();
}

class _FilledBtnState extends State<_FilledBtn> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = widget.onPressed != null && !widget.isLoading;
    // El "grosor" del efecto 3D
    const double depth = 5.0;

    return GestureDetector(
      onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: isEnabled ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
      onTap: widget.onPressed,
      child: SizedBox(
        width: double.infinity,
        height: 56 + depth,
        child: Stack(
          children: [
            // Capa de fondo (la "sombra" o profundidad 3D)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: isEnabled ? AppColors.primaryPressed : AppColors.muted,
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
            ),
            // Capa superior (el botón que se mueve)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 80),
              curve: Curves.easeOut,
              // Cuando está presionado o deshabilitado, baja para cubrir la profundidad
              top: _isPressed || !isEnabled ? depth : 0,
              left: 0,
              right: 0,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: isEnabled
                      ? (_isPressed ? AppColors.primaryPressed : AppColors.primary)
                      : AppColors.muted,
                  borderRadius: BorderRadius.circular(22),
                  // Opcional: un borde sutil para que se note más la separación
                  border: isEnabled
                      ? Border.all(color: Colors.white.withOpacity(0.1), width: 0.5)
                      : null,
                ),
                alignment: Alignment.center,
                child: widget.isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.icon != null) ...[widget.icon!, const SizedBox(width: 8)],
                          Text(
                            widget.label,
                            style: AppTextStyles.titleMedium.copyWith(
                              color: isEnabled ? Colors.white : AppColors.textSecondary,
                            ),
                          ),
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

class _OutlineBtn extends StatefulWidget {
  const _OutlineBtn({required this.label, required this.onPressed, this.icon});

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;

  @override
  State<_OutlineBtn> createState() => _OutlineBtnState();
}

class _OutlineBtnState extends State<_OutlineBtn> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = widget.onPressed != null;
    const double depth = 5.0;

    return GestureDetector(
      onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: isEnabled ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
      onTap: widget.onPressed,
      child: SizedBox(
        width: double.infinity,
        height: 56 + depth,
        child: Stack(
          children: [
            // Depth (Shadow)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: isEnabled ? AppColors.primaryPressed.withOpacity(0.2) : AppColors.muted,
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
            ),
            // Surface
            AnimatedPositioned(
              duration: const Duration(milliseconds: 80),
              curve: Curves.easeOut,
              top: _isPressed || !isEnabled ? depth : 0,
              left: 0,
              right: 0,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: isEnabled
                      ? (_isPressed ? AppColors.muted : AppColors.primaryLight)
                      : AppColors.muted,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.15),
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.icon != null) ...[widget.icon!, const SizedBox(width: 8)],
                    Text(
                      widget.label,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
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
