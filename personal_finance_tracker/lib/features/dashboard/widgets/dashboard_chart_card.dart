import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/dashboard_provider.dart';

/// Thẻ Biểu đồ dòng tiền 6 tháng gần nhất theo thiết kế Penny
class DashboardChartCard extends StatelessWidget {
  const DashboardChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Consumer<DashboardProvider>(
      builder: (context, dashboard, _) {
        final chartData = dashboard.chartData;
        final hasData = chartData.months.isNotEmpty;

        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header dòng tiền + Chip năm
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dòng tiền',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '6 tháng gần nhất · từ dữ liệu giao dịch',
                        style: TextStyle(
                          fontSize: 9,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  if (chartData.yearsLabel.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: colors.surface2,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: colors.border),
                      ),
                      child: Text(
                        chartData.yearsLabel,
                        style: TextStyle(
                          fontSize: 9,
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Chú thích (Legend)
              Row(
                children: [
                  _buildLegendItem(
                    colors: colors,
                    label: 'Thu nhập',
                    color: colors.accent,
                  ),
                  const SizedBox(width: 14),
                  _buildLegendItem(
                    colors: colors,
                    label: 'Chi tiêu',
                    color: colors.surface3,
                    borderColor: colors.textSecondary,
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Cột biểu đồ
              if (!hasData)
                Container(
                  height: 110,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: colors.border,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Text(
                    'Chưa có dữ liệu để hiển thị biểu đồ.',
                    style: TextStyle(
                      fontSize: 11,
                      color: colors.textSecondary,
                    ),
                  ),
                )
              else
                SizedBox(
                  height: 125,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: colors.border),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: chartData.months.map((m) {
                              final incomeHeightFactor = (m.income / chartData.maxAmount)
                                  .clamp(m.income > 0 ? 0.08 : 0.0, 1.0);
                              final expenseHeightFactor = (m.expense / chartData.maxAmount)
                                  .clamp(m.expense > 0 ? 0.08 : 0.0, 1.0);

                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      // Cột Thu nhập
                                      FractionallySizedBox(
                                        heightFactor: incomeHeightFactor,
                                        child: Container(
                                          width: 7,
                                          decoration: BoxDecoration(
                                            color: colors.accent,
                                            borderRadius: const BorderRadius.vertical(
                                              top: Radius.circular(3),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 3),
                                      // Cột Chi tiêu
                                      FractionallySizedBox(
                                        heightFactor: expenseHeightFactor,
                                        child: Container(
                                          width: 7,
                                          decoration: BoxDecoration(
                                            color: colors.surface3,
                                            borderRadius: const BorderRadius.vertical(
                                              top: Radius.circular(3),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 7),
                      // Hàng tên các tháng
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: chartData.months.map((m) {
                          return Expanded(
                            child: Text(
                              m.label,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 9,
                                color: colors.textSecondary,
                              ),
                            ),
                          );
                        }).toList(),
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

  Widget _buildLegendItem({
    required PennyColors colors,
    required String label,
    required Color color,
    Color? borderColor,
  }) {
    return Row(
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: borderColor != null ? Border.all(color: borderColor) : null,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }
}
