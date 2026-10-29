import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Header của màn hình Xác thực theo đúng thiết kế Penny Figma
class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo & Brand
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
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
            ),
            const SizedBox(width: 11),
            Text(
              'Penny',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 48),

        // Overline Tag
        Text(
          'QUẢN LÝ TÀI CHÍNH CÁ NHÂN',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: colors.accent,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 10),

        // Main Title
        Text(
          title,
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: -1,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),

        // Subtitle
        Text(
          subtitle,
          style: TextStyle(
            color: colors.textSecondary,
            fontSize: 12,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
