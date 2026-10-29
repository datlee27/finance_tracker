import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';

/// Hộp thoại xác nhận xóa giao dịch hoặc đăng xuất theo thiết kế Penny
class ConfirmDeleteDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback onConfirm;

  const ConfirmDeleteDialog({
    super.key,
    this.title = 'Xóa giao dịch?',
    this.message =
        'Bạn có chắc chắn muốn xóa giao dịch này? Thao tác này không thể hoàn tác.',
    this.confirmLabel = 'Xóa giao dịch',
    this.cancelLabel = 'Giữ lại',
    this.icon = Icons.delete_outline_rounded,
    this.iconColor,
    required this.onConfirm,
  });

  /// Hàm tiện ích mở dialog
  static Future<bool?> show(
    BuildContext context, {
    String title = 'Xóa giao dịch?',
    String message =
        'Bạn có chắc chắn muốn xóa giao dịch này? Thao tác này không thể hoàn tác.',
    String confirmLabel = 'Xóa giao dịch',
    String cancelLabel = 'Giữ lại',
    IconData icon = Icons.delete_outline_rounded,
    Color? iconColor,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return ConfirmDeleteDialog(
          title: title,
          message: message,
          confirmLabel: confirmLabel,
          cancelLabel: cancelLabel,
          icon: icon,
          iconColor: iconColor,
          onConfirm: () => Navigator.pop(context, true),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final effectiveIconColor = iconColor ?? colors.danger;

    return Dialog(
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: colors.border),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon đỏ viền tròn
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: effectiveIconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(15),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: effectiveIconColor, size: 24),
            ),
            const SizedBox(height: 16),

            // Tiêu đề
            Text(
              title,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
                letterSpacing: -0.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // Nội dung mô tả
            Text(
              message,
              style: TextStyle(
                fontSize: 11,
                color: colors.textSecondary,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 22),

            // 2 Nút bấm Hủy & Xác nhận
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: cancelLabel,
                    variant: AppButtonVariant.secondary,
                    height: 42,
                    onPressed: () => Navigator.pop(context, false),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppButton(
                    label: confirmLabel,
                    variant: AppButtonVariant.danger,
                    height: 42,
                    onPressed: () {
                      Navigator.pop(context, true);
                      onConfirm();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
