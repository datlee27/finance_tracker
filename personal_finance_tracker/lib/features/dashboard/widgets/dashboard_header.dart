import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/providers/auth_provider.dart';

/// Header thanh điều hướng trên cùng của Penny Dashboard
class DashboardHeader extends StatelessWidget {
  final VoidCallback onAvatarTap;

  const DashboardHeader({
    super.key,
    required this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final user = context.watch<AuthProvider>().currentUser;
    final displayName = user?.nameDisplay ?? 'Người dùng';
    final initials = user?.initials ?? 'P';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: colors.bg,
        border: Border(
          bottom: BorderSide(color: colors.border.withValues(alpha: 0.5)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo & Tên ứng dụng + Lời chào
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: colors.accent,
                  borderRadius: BorderRadius.circular(11),
                ),
                alignment: Alignment.center,
                child: Text(
                  'P',
                  style: TextStyle(
                    color: colors.accentInk,
                    fontWeight: FontWeight.w700,
                    fontSize: 19,
                    letterSpacing: -1,
                  ),
                ),
              ),
              const SizedBox(width: 11),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Penny',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Xin chào, $displayName',
                    style: TextStyle(
                      fontSize: 11,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Avatar nút mở Cài đặt / Đăng xuất
          GestureDetector(
            onTap: onAvatarTap,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.surface2,
                border: Border.all(color: colors.border),
              ),
              alignment: Alignment.center,
              child: Text(
                initials,
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
