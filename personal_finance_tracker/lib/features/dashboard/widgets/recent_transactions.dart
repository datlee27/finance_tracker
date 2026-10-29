import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../transactions/models/transaction_model.dart';
import '../../transactions/providers/transaction_provider.dart';
import '../../transactions/widgets/transaction_tile.dart';

/// Danh sách 5 giao dịch mới nhất trên Dashboard
class RecentTransactions extends StatelessWidget {
  final VoidCallback onViewAllTap;
  final ValueChanged<TransactionModel> onTransactionTap;

  const RecentTransactions({
    super.key,
    required this.onViewAllTap,
    required this.onTransactionTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Consumer<TransactionProvider>(
      builder: (context, provider, _) {
        final recent = provider.recentTransactions;

        return Container(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tiêu đề + nút "Xem tất cả >"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Giao dịch gần đây',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Hoạt động mới nhất của bạn',
                        style: TextStyle(
                          fontSize: 9,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: onViewAllTap,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      foregroundColor: colors.accent,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Xem tất cả',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.chevron_right_rounded, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // Danh sách giao dịch
              if (recent.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  alignment: Alignment.center,
                  child: Text(
                    'Chưa có giao dịch nào gần đây.',
                    style: TextStyle(
                      fontSize: 11,
                      color: colors.textSecondary,
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recent.length,
                  itemBuilder: (context, index) {
                    final item = recent[index];
                    return TransactionTile(
                      transaction: item,
                      showDivider: index < recent.length - 1,
                      onTap: () => onTransactionTap(item),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
