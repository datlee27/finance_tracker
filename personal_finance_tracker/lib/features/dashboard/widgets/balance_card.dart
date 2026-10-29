import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../providers/dashboard_provider.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Consumer<DashboardProvider>(
      builder: (context, dashboard, _) {
        final isVisible = dashboard.isBalanceVisible;
        final balanceText = isVisible
            ? CurrencyFormatter.format(dashboard.balance)
            : '•••••••• ₫';

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: colors.border),
          ),
          child: Stack(
            clipBehavior: Clip.antiAlias,
            children: [
              // Vòng tròn họa tiết mờ góc trên phải
              Positioned(
                right: -60,
                top: -60,
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colors.accent.withValues(alpha: 0.08),
                      width: 32,
                    ),
                  ),
                ),
              ),

              // Nội dung thẻ
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nhãn "Số dư hiện tại" + nút Ẩn/Hiện
                    Row(
                      children: [
                        Text(
                          'Số dư hiện tại',
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.textSecondary,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => dashboard.toggleBalanceVisibility(),
                          child: Icon(
                            isVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 17,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Số dư lớn nổi bật
                    Text(
                      balanceText,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                        letterSpacing: -1.2,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Thanh meta phân cách dưới: Cập nhật hôm nay · VND
                    Container(
                      padding: const EdgeInsets.only(top: 12),
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: colors.border)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Cập nhật hôm nay',
                            style: TextStyle(
                              fontSize: 10,
                              color: colors.textSecondary,
                            ),
                          ),
                          Text(
                            'VND',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: colors.accent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
