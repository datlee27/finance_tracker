import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Widget trạng thái rỗng (không có dữ liệu) theo phong cách Penny
class EmptyState extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Widget? action;

  const EmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.receipt_long_outlined,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: colors.surface2,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.border),
              ),
              child: Icon(
                icon,
                size: 26,
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
                letterSpacing: -0.3,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 7),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 12,
                  color: colors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: 20),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
