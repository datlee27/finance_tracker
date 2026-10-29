import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/settings_sheet.dart';
import '../../transactions/screens/transaction_detail_screen.dart';
import '../widgets/balance_card.dart';
import '../widgets/dashboard_chart_card.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/income_expense_cards.dart';
import '../widgets/recent_transactions.dart';

/// Màn hình Tổng quan / Dashboard chính của Penny
class DashboardScreen extends StatelessWidget {
  final VoidCallback onViewAllTransactions;

  const DashboardScreen({
    super.key,
    required this.onViewAllTransactions,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header cố định trên cùng
            DashboardHeader(
              onAvatarTap: () => SettingsSheet.show(context),
            ),

            // Phần nội dung cuộn mượt mà
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Thẻ số dư chính
                    const BalanceCard(),
                    const SizedBox(height: 12),

                    // 2. Thẻ mini stats: Thu nhập & Chi tiêu
                    const IncomeExpenseCards(),
                    const SizedBox(height: 14),

                    // 3. Biểu đồ dòng tiền 6 tháng
                    const DashboardChartCard(),
                    const SizedBox(height: 14),

                    // 4. Khối giao dịch gần đây
                    RecentTransactions(
                      onViewAllTap: onViewAllTransactions,
                      onTransactionTap: (item) {
                        TransactionDetailScreen.showSheet(
                          context,
                          transaction: item,
                        );
                      },
                    ),
                    const SizedBox(height: 18),

                    // Ghi chú chân trang
                    Center(
                      child: Text(
                        'Personal Finance Tracker · Penny Design System',
                        style: TextStyle(
                          fontSize: 9,
                          color: colors.textHint,
                        ),
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
