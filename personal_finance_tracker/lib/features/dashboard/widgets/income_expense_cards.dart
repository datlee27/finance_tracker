import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/firestore_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../transactions/screens/transaction_form_screen.dart';
import '../providers/dashboard_provider.dart';

/// Thẻ đôi hiển thị mini stats Tổng thu nhập & Tổng chi tiêu
class IncomeExpenseCards extends StatelessWidget {
  const IncomeExpenseCards({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Consumer<DashboardProvider>(
      builder: (context, dashboard, _) {
        final isVisible = dashboard.isBalanceVisible;
        final incomeText = isVisible
            ? CurrencyFormatter.format(dashboard.totalIncome)
            : '•••••• ₫';
        final expenseText = isVisible
            ? CurrencyFormatter.format(dashboard.totalExpense)
            : '•••••• ₫';

        return Row(
          children: [
            // Thẻ Tổng thu nhập (bấm vào mở popup nhanh đã chọn Thu nhập)
            Expanded(
              child: _buildStatCard(
                colors: colors,
                title: 'Tổng thu nhập',
                amount: incomeText,
                icon: Icons.arrow_upward_rounded,
                iconColor: colors.income,
                iconBgColor: colors.income.withValues(alpha: 0.12),
                onTap: () {
                  TransactionFormScreen.show(
                    context,
                    initialType: FirestoreConstants.typeIncome,
                  );
                },
              ),
            ),
            const SizedBox(width: 10),

            // Thẻ Tổng chi tiêu (bấm vào mở popup nhanh đã chọn Chi tiêu)
            Expanded(
              child: _buildStatCard(
                colors: colors,
                title: 'Tổng chi tiêu',
                amount: expenseText,
                icon: Icons.arrow_downward_rounded,
                iconColor: colors.expense,
                iconBgColor: colors.expense.withValues(alpha: 0.12),
                onTap: () {
                  TransactionFormScreen.show(
                    context,
                    initialType: FirestoreConstants.typeExpense,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required PennyColors colors,
    required String title,
    required String amount,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        splashColor: iconColor.withValues(alpha: 0.15),
        highlightColor: iconColor.withValues(alpha: 0.08),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.border),
          ),
          child: Row(
            children: [
              // Icon tròn có nền màu nhẹ
              Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: iconColor, size: 17),
          ),
          const SizedBox(width: 10),

          // Nội dung text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 9,
                    color: colors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  amount,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
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
  ),
);
  }
}

