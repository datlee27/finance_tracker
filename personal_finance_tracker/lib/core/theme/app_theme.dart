import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Cấu hình ThemeData Penny: Hỗ trợ cả Dark theme và Light theme chuẩn Figma
class AppTheme {
  AppTheme._();

  /// Theme Chế độ Tối (Dark Obsidian)
  static ThemeData get darkTheme {
    const colors = PennyColors.dark;

    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: colors.bg,
      colorScheme: ColorScheme.dark(
        primary: colors.accent,
        onPrimary: colors.accentInk,
        surface: colors.surface,
        onSurface: colors.textPrimary,
        error: colors.danger,
        onError: Colors.white,
      ),
      extensions: const [colors],
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFFF5F3EE),
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        titleTextStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: Color(0xFFF5F3EE),
          letterSpacing: -0.4,
        ),
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colors.border),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surface,
        modalBackgroundColor: colors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
      ),
      scrollbarTheme: const ScrollbarThemeData(
        thumbVisibility: WidgetStatePropertyAll(false),
        trackVisibility: WidgetStatePropertyAll(false),
        interactive: false,
      ),
      dividerColor: colors.border,
    );

    return baseTheme.copyWith(
      textTheme: baseTheme.textTheme.apply(
        fontFamily: GoogleFonts.beVietnamPro().fontFamily,
      ),
    );
  }

  /// Theme Chế độ Sáng (Warm Sand / White)
  static ThemeData get lightTheme {
    const colors = PennyColors.light;

    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: colors.bg,
      colorScheme: ColorScheme.light(
        primary: colors.accent,
        onPrimary: colors.accentInk,
        surface: colors.surface,
        onSurface: colors.textPrimary,
        error: colors.danger,
        onError: Colors.white,
      ),
      extensions: const [colors],
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFF24231F),
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        titleTextStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: Color(0xFF24231F),
          letterSpacing: -0.4,
        ),
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colors.border),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surface,
        modalBackgroundColor: colors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
      ),
      scrollbarTheme: const ScrollbarThemeData(
        thumbVisibility: WidgetStatePropertyAll(false),
        trackVisibility: WidgetStatePropertyAll(false),
        interactive: false,
      ),
      dividerColor: colors.border,
    );

    return baseTheme.copyWith(
      textTheme: baseTheme.textTheme.apply(
        fontFamily: GoogleFonts.beVietnamPro().fontFamily,
      ),
    );
  }
}
