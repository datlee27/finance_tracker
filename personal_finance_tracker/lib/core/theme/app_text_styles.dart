import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Kiểu chữ Penny đồng bộ theo thiết kế Figma
class AppTextStyles {
  AppTextStyles._();

  // Display & Headings
  static const TextStyle displayLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -1.0,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.6,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.4,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
  );

  // Subtitle & Overline
  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppColors.accent,
    letterSpacing: 1.5,
  );

  // Body
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // Labels
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.accentInk,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  // Amounts
  static const TextStyle amountLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -1.2,
  );

  static const TextStyle amountIncome = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.income,
  );

  static const TextStyle amountExpense = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.expense,
  );
}
