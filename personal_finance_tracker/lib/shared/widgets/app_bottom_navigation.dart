import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Thanh điều hướng dưới đáy màn hình theo đúng thiết kế Penny
class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;
  final VoidCallback onAddTap;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          top: BorderSide(color: colors.border, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // 2 Tab bên trái và phải
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Tab Trang chủ
                    _buildNavItem(
                      index: 0,
                      label: 'Trang chủ',
                      icon: Icons.home_rounded,
                      isSelected: currentIndex == 0,
                      colors: colors,
                    ),

                    // Khoảng trống ở giữa cho nút +
                    const SizedBox(width: 56),

                    // Tab Giao dịch
                    _buildNavItem(
                      index: 1,
                      label: 'Giao dịch',
                      icon: Icons.receipt_long_rounded,
                      isSelected: currentIndex == 1,
                      colors: colors,
                    ),
                  ],
                ),
              ),

              // Nút Thêm giao dịch (+) nổi ở giữa
              Positioned(
                top: -18,
                child: GestureDetector(
                  onTap: onAddTap,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: colors.accent,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: colors.accent.withValues(alpha: 0.35),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.add_rounded,
                      size: 28,
                      color: colors.accentInk,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required IconData icon,
    required bool isSelected,
    required PennyColors colors,
  }) {
    final color = isSelected ? colors.accent : colors.textSecondary;

    return InkWell(
      onTap: () => onIndexChanged(index),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 70,
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
