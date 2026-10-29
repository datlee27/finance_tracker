import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../categories/data/category_repository.dart';
import '../models/transaction_model.dart';

/// Item hiển thị 1 dòng giao dịch theo chuẩn Penny design
class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback onTap;
  final bool showDivider;

  const TransactionTile({
    super.key,
    required this.transaction,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final categoryRepo = CategoryRepository();
    final cat = categoryRepo.getCategoryByName(transaction.category);
    final isIncome = transaction.isIncome;

    final signedAmount =
        '${isIncome ? '+' : '−'}${CurrencyFormatter.format(transaction.amount)}';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                // Icon danh mục
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: colors.surface2,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    cat.icon,
                    size: 19,
                    color: cat.color,
                  ),
                ),
                const SizedBox(width: 12),

                // Tiêu đề & phụ đề
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        transaction.noteDisplay,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: colors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${transaction.category} · ${DateFormatter.formatDate(transaction.date)}',
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
                const SizedBox(width: 8),

                // Số tiền & Loại
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      signedAmount,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isIncome ? colors.income : colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      transaction.kind,
                      style: TextStyle(
                        fontSize: 10,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (showDivider)
            Divider(
              height: 1,
              thickness: 1,
              color: colors.border,
            ),
        ],
      ),
    );
  }
}
