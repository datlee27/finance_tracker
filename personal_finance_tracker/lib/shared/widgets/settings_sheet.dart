import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../navigation/route_names.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/transactions/providers/transaction_provider.dart';
import 'confirm_delete_dialog.dart';

/// Sheet Cài đặt & Thông tin tài khoản theo thiết kế Penny
class SettingsSheet extends StatelessWidget {
  const SettingsSheet({super.key});

  /// Hàm tiện ích mở Settings Sheet
  static Future<void> show(BuildContext context) {
    final colors = context.colors;
    return showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) => const SettingsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final auth = context.watch<AuthProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final currentTheme = themeProvider.themeSetting;

    final user = auth.currentUser;
    final displayName = user?.nameDisplay ?? 'Người dùng';
    final email = user?.email ?? 'Chưa liên kết email';
    final initials = user?.initials ?? 'P';

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Thanh Handle bar
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Header Cài đặt
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cài đặt',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tài khoản và tùy chọn của bạn.',
                        style: TextStyle(
                          fontSize: 10,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: colors.surface2,
                        borderRadius: BorderRadius.circular(9),
                        border: Border.all(color: colors.border),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.close_rounded,
                        size: 17,
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Thẻ tài khoản người dùng
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colors.surface2,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: colors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: colors.accent,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        initials,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: colors.accentInk,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            email,
                            style: TextStyle(
                              fontSize: 10,
                              color: colors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // Nhãn GIAO DIỆN
              Text(
                'GIAO DIỆN',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: colors.textSecondary,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 9),

              // Nhóm tùy chọn giao diện
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: colors.border),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    _buildThemeOption(
                      context: context,
                      value: 'light',
                      label: 'Sáng',
                      icon: Icons.light_mode_outlined,
                      isSelected: currentTheme == 'light',
                      colors: colors,
                    ),
                    Divider(height: 1, thickness: 1, color: colors.border),
                    _buildThemeOption(
                      context: context,
                      value: 'dark',
                      label: 'Tối',
                      icon: Icons.dark_mode_outlined,
                      isSelected: currentTheme == 'dark',
                      colors: colors,
                    ),
                    Divider(height: 1, thickness: 1, color: colors.border),
                    _buildThemeOption(
                      context: context,
                      value: 'system',
                      label: 'Theo thiết bị',
                      icon: Icons.settings_brightness_outlined,
                      isSelected: currentTheme == 'system',
                      colors: colors,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Nút Đặt lại / Xóa sạch dữ liệu trên máy (dành cho Chế độ Khách)
              if (auth.isGuest) ...[
                GestureDetector(
                  onTap: () async {
                    final confirm = await ConfirmDeleteDialog.show(
                      context,
                      title: 'Xóa sạch dữ liệu trên máy?',
                      message:
                          'Toàn bộ giao dịch đã lưu trên thiết bị này sẽ bị xóa sạch hoàn toàn để bắt đầu từ đầu.',
                      confirmLabel: 'Xóa sạch',
                      cancelLabel: 'Hủy',
                      icon: Icons.delete_sweep_rounded,
                      iconColor: colors.danger,
                    );

                    if (confirm == true && context.mounted) {
                      await context.read<TransactionProvider>().clearAllData();
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Đã xóa sạch toàn bộ dữ liệu trên thiết bị.'),
                            backgroundColor: colors.accent,
                          ),
                        );
                      }
                    }
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.border),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.delete_sweep_rounded,
                            color: colors.textSecondary, size: 18),
                        const SizedBox(width: 10),
                        Text(
                          'Xóa sạch dữ liệu trên máy',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: colors.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 18,
                          color: colors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Nút Đăng xuất
              GestureDetector(
                onTap: () async {
                  final confirm = await ConfirmDeleteDialog.show(
                    context,
                    title: 'Đăng xuất khỏi Penny?',
                    message:
                        'Bạn sẽ cần đăng nhập lại để tiếp tục sử dụng ứng dụng.',
                    confirmLabel: 'Đăng xuất',
                    cancelLabel: 'Hủy',
                    icon: Icons.logout_rounded,
                    iconColor: colors.danger,
                  );

                  if (confirm == true && context.mounted) {
                    final txProvider = context.read<TransactionProvider>();
                    final authProvider = context.read<AuthProvider>();
                    Navigator.pop(context); // Đóng Settings Sheet
                    await txProvider.clearAllData();
                    await authProvider.logout();
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        RouteNames.login,
                        (route) => false,
                      );
                    }
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.border),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.logout_rounded,
                          color: colors.danger, size: 18),
                      const SizedBox(width: 10),
                      Text(
                        'Đăng xuất',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: colors.danger,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: colors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Version text
              Center(
                child: Text(
                  'Penny · Bản thiết kế 1.0 · PRM393',
                  style: TextStyle(fontSize: 10, color: colors.textHint),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeOption({
    required BuildContext context,
    required String value,
    required String label,
    required IconData icon,
    required bool isSelected,
    required PennyColors colors,
  }) {
    return InkWell(
      onTap: () {
        context.read<ThemeProvider>().setTheme(value);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        color: colors.surface2,
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? colors.accent : colors.textSecondary,
            ),
            const SizedBox(width: 11),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? colors.accent : colors.textPrimary,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: colors.accent,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.check_rounded,
                  size: 13,
                  color: colors.accentInk,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
