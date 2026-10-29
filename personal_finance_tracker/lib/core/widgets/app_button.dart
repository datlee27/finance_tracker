import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum AppButtonVariant { primary, secondary, outlined, text, danger, dangerGhost }

/// Nút bấm dùng chung trong toàn ứng dụng (Đồng bộ Penny Design)
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final IconData? icon;
  final Widget? leading;
  final double? width;
  final double height;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.leading,
    this.width,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spinnerColor = variant == AppButtonVariant.primary
        ? colors.accentInk
        : variant == AppButtonVariant.danger
            ? Colors.white
            : colors.accent;

    final child = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              color: spinnerColor,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: 8),
              ] else if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 8),
              ],
              Text(label),
            ],
          );

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: _buildButton(context, colors, child),
    );
  }

  Widget _buildButton(BuildContext context, PennyColors colors, Widget child) {
    switch (variant) {
      case AppButtonVariant.primary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.accent,
            foregroundColor: colors.accentInk,
            disabledBackgroundColor: colors.accent.withValues(alpha: 0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
            textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          child: child,
        );

      case AppButtonVariant.secondary:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: colors.surface2,
            foregroundColor: colors.textPrimary,
            side: BorderSide(color: colors.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
            textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          child: child,
        );

      case AppButtonVariant.outlined:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: colors.accent,
            side: BorderSide(color: colors.accent),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          child: child,
        );

      case AppButtonVariant.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: colors.accent,
            textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          child: child,
        );

      case AppButtonVariant.danger:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.danger,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
            textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          child: child,
        );

      case AppButtonVariant.dangerGhost:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: colors.danger,
            textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          child: child,
        );
    }
  }
}

/// Link chuyển đổi đăng nhập / đăng ký
class AppLinkButton extends StatelessWidget {
  final String text;
  final String linkText;
  final VoidCallback onTap;

  const AppLinkButton({
    super.key,
    required this.text,
    required this.linkText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: AppTextStyles.bodySmall.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: onTap,
          child: Text(
            linkText,
            style: AppTextStyles.bodySmall.copyWith(
              color: colors.accent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
