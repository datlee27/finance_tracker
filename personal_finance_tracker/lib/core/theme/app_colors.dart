import 'package:flutter/material.dart';

/// Extension chứa bộ màu hoàn chỉnh cho cả Dark và Light mode theo chuẩn Penny
@immutable
class PennyColors extends ThemeExtension<PennyColors> {
  final Color bg;
  final Color surface;
  final Color surface2;
  final Color surface3;
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;
  final Color border;
  final Color accent;
  final Color accentStrong;
  final Color accentInk;
  final Color income;
  final Color expense;
  final Color danger;
  final Color stageBg;

  const PennyColors({
    required this.bg,
    required this.surface,
    required this.surface2,
    required this.surface3,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.border,
    required this.accent,
    required this.accentStrong,
    required this.accentInk,
    required this.income,
    required this.expense,
    required this.danger,
    required this.stageBg,
  });

  /// Bảng màu Chế độ Tối (Dark Obsidian)
  static const dark = PennyColors(
    bg: Color(0xFF12110F),
    surface: Color(0xFF1C1B19),
    surface2: Color(0xFF252421),
    surface3: Color(0xFF2D2B27),
    textPrimary: Color(0xFFF5F3EE),
    textSecondary: Color(0xFFA7A49D),
    textHint: Color(0xFF686660),
    border: Color(0xFF34322E),
    accent: Color(0xFFF2B544),
    accentStrong: Color(0xFFFFC75F),
    accentInk: Color(0xFF2B1D04),
    income: Color(0xFF54C69A),
    expense: Color(0xFFE98573),
    danger: Color(0xFFE67565),
    stageBg: Color(0xFF090908),
  );

  /// Bảng màu Chế độ Sáng (Warm Sand / White)
  static const light = PennyColors(
    bg: Color(0xFFF6F5F1),
    surface: Color(0xFFFFFFFF),
    surface2: Color(0xFFEEEEE8),
    surface3: Color(0xFFE6E4DC),
    textPrimary: Color(0xFF24231F),
    textSecondary: Color(0xFF77766F),
    textHint: Color(0xFFA3A199),
    border: Color(0xFFE3E1D9),
    accent: Color(0xFFB77A12),
    accentStrong: Color(0xFFA56B08),
    accentInk: Color(0xFFFFFFFF),
    income: Color(0xFF21845D),
    expense: Color(0xFFC65F4D),
    danger: Color(0xFFBD5142),
    stageBg: Color(0xFFDEDDD8),
  );

  @override
  PennyColors copyWith({
    Color? bg,
    Color? surface,
    Color? surface2,
    Color? surface3,
    Color? textPrimary,
    Color? textSecondary,
    Color? textHint,
    Color? border,
    Color? accent,
    Color? accentStrong,
    Color? accentInk,
    Color? income,
    Color? expense,
    Color? danger,
    Color? stageBg,
  }) {
    return PennyColors(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      surface2: surface2 ?? this.surface2,
      surface3: surface3 ?? this.surface3,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textHint: textHint ?? this.textHint,
      border: border ?? this.border,
      accent: accent ?? this.accent,
      accentStrong: accentStrong ?? this.accentStrong,
      accentInk: accentInk ?? this.accentInk,
      income: income ?? this.income,
      expense: expense ?? this.expense,
      danger: danger ?? this.danger,
      stageBg: stageBg ?? this.stageBg,
    );
  }

  @override
  PennyColors lerp(ThemeExtension<PennyColors>? other, double t) {
    if (other is! PennyColors) return this;
    return PennyColors(
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surface2: Color.lerp(surface2, other.surface2, t)!,
      surface3: Color.lerp(surface3, other.surface3, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textHint: Color.lerp(textHint, other.textHint, t)!,
      border: Color.lerp(border, other.border, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentStrong: Color.lerp(accentStrong, other.accentStrong, t)!,
      accentInk: Color.lerp(accentInk, other.accentInk, t)!,
      income: Color.lerp(income, other.income, t)!,
      expense: Color.lerp(expense, other.expense, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      stageBg: Color.lerp(stageBg, other.stageBg, t)!,
    );
  }
  Color get background => bg;
  Color get primary => accent;
  Color get error => danger;
  Color get divider => border;
  Color get surfaceVariant => surface2;
  Color get muted => textSecondary;
}

/// Extension tiện lợi trên BuildContext để lấy nhanh colors: context.colors
extension BuildContextColorsX on BuildContext {
  PennyColors get colors => AppColors.of(this);
}

/// Hằng số màu fallback và hàm truy cập AppColors.of(context)
class AppColors {
  AppColors._();

  /// Lấy bộ màu tương thích theo theme (Sáng / Tối) hiện tại
  static PennyColors of(BuildContext context) {
    return Theme.of(context).extension<PennyColors>() ?? PennyColors.dark;
  }

  // Tương thích ngược với các static access cũ
  static const Color background = Color(0xFF12110F);
  static const Color surface = Color(0xFF1C1B19);
  static const Color surface2 = Color(0xFF252421);
  static const Color surface3 = Color(0xFF2D2B27);
  static const Color surfaceVariant = surface2;

  static const Color accent = Color(0xFFF2B544);
  static const Color accentStrong = Color(0xFFFFC75F);
  static const Color accentInk = Color(0xFF2B1D04);
  static const Color primary = accent;
  static const Color secondary = surface3;

  static const Color income = Color(0xFF54C69A);
  static const Color expense = Color(0xFFE98573);
  static const Color danger = Color(0xFFE67565);
  static const Color error = Color(0xFFE67565);

  static const Color textPrimary = Color(0xFFF5F3EE);
  static const Color textSecondary = Color(0xFFA7A49D);
  static const Color textHint = Color(0xFF686660);

  static const Color border = Color(0xFF34322E);
  static const Color divider = Color(0xFF34322E);

  static const Color catBlue = Color(0xFF72A8DA);
  static const Color catPurple = Color(0xFFB48EED);
  static const Color shadow = Color(0x66000000);
}
