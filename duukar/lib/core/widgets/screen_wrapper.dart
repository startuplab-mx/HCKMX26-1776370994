import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

/// Wrapper base para pantallas que no requieren AppBar.
/// Provee SafeArea, fondo y padding lateral consistentes.
class ScreenWrapper extends StatelessWidget {
  const ScreenWrapper({
    super.key,
    required this.child,
    this.backgroundColor = AppColors.background,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
    this.resizeToAvoidBottomInset = true,
  });

  final Widget child;
  final Color backgroundColor;
  final EdgeInsets padding;
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: SafeArea(
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
