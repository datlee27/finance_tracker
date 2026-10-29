import 'package:flutter/material.dart';
import '../../../core/constants/firestore_constants.dart';
import '../../../core/theme/app_colors.dart';

/// Bộ chọn chuyển đổi giữa "Chi tiêu" và "Thu nhập" trong Form thêm/sửa
class TransactionTypeSelector extends StatelessWidget {
  final String selectedType; // 'income' hoặc 'expense'
  final ValueChanged<String> onChanged;

  const TransactionTypeSelector({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isExpense = selectedType == FirestoreConstants.typeExpense;
    final isIncome = selectedType == FirestoreConstants.typeIncome;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.surface2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          // Nút Chi tiêu
          Expanded(
            child: _buildChoiceButton(
              colors: colors,
              label: 'Chi tiêu',
              isSelected: isExpense,
              activeColor: colors.expense,
              icon: Icons.arrow_downward_rounded,
              onTap: () => onChanged(FirestoreConstants.typeExpense),
            ),
          ),
          const SizedBox(width: 4),

          // Nút Thu nhập
          Expanded(
            child: _buildChoiceButton(
              colors: colors,
              label: 'Thu nhập',
              isSelected: isIncome,
              activeColor: colors.income,
              icon: Icons.arrow_upward_rounded,
              onTap: () => onChanged(FirestoreConstants.typeIncome),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceButton({
    required PennyColors colors,
    required String label,
    required bool isSelected,
    required Color activeColor,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? colors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? activeColor : colors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? activeColor : colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
