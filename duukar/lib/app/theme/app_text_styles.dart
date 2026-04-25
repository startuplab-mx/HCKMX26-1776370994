import 'package:flutter/material.dart';
import 'app_colors.dart';
class AppTextStyles {
  const AppTextStyles._();
  static TextStyle displayLarge = const TextStyle(
    fontFamily: 'Fredoka',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
  static TextStyle headlineLarge = const TextStyle(
    fontFamily: 'Fredoka',
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
  static TextStyle headlineMedium = const TextStyle(
    fontFamily: 'Fredoka',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
  static TextStyle titleLarge = const TextStyle(
    fontFamily: 'Fredoka',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static TextStyle titleMedium = const TextStyle(
    fontFamily: 'Fredoka',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static TextStyle bodyLarge = const TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  static TextStyle bodyMedium = const TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  static TextStyle bodySmall = const TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.3,
  );
  static TextStyle labelLarge = const TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static TextStyle labelMedium = const TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );
  static TextTheme textTheme = TextTheme(
    displayLarge: displayLarge,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
  );
}