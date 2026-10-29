import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/firestore_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/empty_state.dart';
import '../../categories/data/category_repository.dart';
import '../providers/transaction_provider.dart';
import '../widgets/transaction_filter_sheet.dart';
import '../widgets/transaction_search_bar.dart';
import '../widgets/transaction_tile.dart';
import 'transaction_detail_screen.dart';

/// Màn hình Danh sách Giao dịch: Tìm kiếm, Bộ lọc và Quản lý theo chuẩn Penny
class TransactionListScreen extends StatelessWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Consumer<TransactionProvider>(
      builder: (context, provider, _) {
        final filtered = provider.filteredTransactions;
        final filter = provider.filter;
        final categoryRepo = CategoryRepository();
        final currentCat = filter.category != 'all'
            ? categoryRepo.getCategoryByName(filter.category)
            : null;

        return Scaffold(
          backgroundColor: colors.bg,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 6),

                  // Header màn hình
                  Text(
                    'QUẢN LÝ CHI TIÊU',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: colors.accent,
                      letterSpacing: 1.6,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Giao dịch',
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tìm kiếm và theo dõi mọi khoản thu chi.',
                    style: TextStyle(
                      fontSize: 11,
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Thanh tìm kiếm
                  TransactionSearchBar(
                    initialQuery: filter.searchQuery,
                    onChanged: (val) => provider.setSearchQuery(val),
                    onClear: () => provider.setSearchQuery(''),
                  ),
                  const SizedBox(height: 14),

                  // Hàng nút lọc Loại (Tất cả / Thu nhập / Chi tiêu)
                  Row(
                    children: [
                      _buildTypeFilterChip(
                        context,
                        colors: colors,
                        label: 'Tất cả',
                        isSelected: filter.type == 'all',
                        onTap: () => provider.setFilterType('all'),
                      ),
                      const SizedBox(width: 8),
                      _buildTypeFilterChip(
                        context,
                        colors: colors,
                        label: 'Thu nhập',
                        isSelected: filter.type == FirestoreConstants.typeIncome,
                        onTap: () =>
                            provider.setFilterType(FirestoreConstants.typeIncome),
                      ),
                      const SizedBox(width: 8),
                      _buildTypeFilterChip(
                        context,
                        colors: colors,
                        label: 'Chi tiêu',
                        isSelected: filter.type == FirestoreConstants.typeExpense,
                        onTap: () =>
                            provider.setFilterType(FirestoreConstants.typeExpense),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Bộ chọn danh mục + số lượng giao dịch
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final picked = await CategoryPickerSheet.show(
                            context,
                            selectedCategory: filter.category,
                            isFilterMode: true,
                          );
                          if (picked != null) {
                            provider.setFilterCategory(picked);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: colors.surface2,
                            borderRadius: BorderRadius.circular(9),
                            border: Border.all(color: colors.border),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                currentCat?.icon ?? Icons.more_horiz_rounded,
                                size: 15,
                                color: currentCat?.color ?? colors.accent,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                filter.category == 'all'
                                    ? 'Tất cả danh mục'
                                    : filter.category,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: colors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 16,
                                color: colors.textSecondary,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        '${filtered.length} giao dịch',
                        style: TextStyle(
                          fontSize: 10,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Danh sách giao dịch hiển thị trong thẻ bo góc
                  if (filtered.isEmpty)
                    EmptyState(
                      title: filter.hasActiveFilter
                          ? 'Không có giao dịch phù hợp'
                          : 'Chưa có giao dịch',
                      subtitle: filter.hasActiveFilter
                          ? 'Hãy thử xóa bộ lọc hoặc tìm kiếm bằng từ khóa khác.'
                          : 'Các khoản thu chi mới của bạn sẽ hiển thị tại đây.',
                      icon: filter.hasActiveFilter
                          ? Icons.search_off_rounded
                          : Icons.receipt_long_outlined,
                      action: filter.hasActiveFilter
                          ? TextButton(
                              onPressed: () => provider.resetFilters(),
                              child: Text(
                                'Xóa bộ lọc',
                                style: TextStyle(
                                  color: colors.accent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : null,
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: colors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 14, bottom: 4),
                            child: Text(
                              'GẦN ĐÂY',
                              style: TextStyle(
                                fontSize: 9,
                                letterSpacing: 1.4,
                                fontWeight: FontWeight.w600,
                                color: colors.textSecondary,
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final item = filtered[index];
                              return TransactionTile(
                                transaction: item,
                                showDivider: index < filtered.length - 1,
                                onTap: () {
                                  TransactionDetailScreen.showSheet(
                                    context,
                                    transaction: item,
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 6),
                        ],
                      ),
                    ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTypeFilterChip(
    BuildContext context, {
    required PennyColors colors,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? colors.accent : colors.surface,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: isSelected ? colors.accent : colors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? colors.accentInk : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
