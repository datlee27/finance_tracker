import 'package:flutter/material.dart';
import '../../../core/constants/firestore_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../categories/data/category_repository.dart';
import '../../categories/models/transaction_category.dart';
import '../../categories/widgets/add_category_sheet.dart';

/// Sheet chọn danh mục theo thiết kế Penny (dùng cho cả Lọc và Form)
class CategoryPickerSheet extends StatefulWidget {
  final String selectedCategory; // 'all' hoặc tên danh mục
  final String? filterKind; // null hoặc 'income' hoặc 'expense'
  final bool isFilterMode;
  final ValueChanged<String> onSelected;

  const CategoryPickerSheet({
    super.key,
    required this.selectedCategory,
    this.filterKind,
    this.isFilterMode = false,
    required this.onSelected,
  });

  /// Hàm tiện ích hiển thị Bottom Sheet
  static Future<String?> show(
    BuildContext context, {
    required String selectedCategory,
    String? filterKind,
    bool isFilterMode = false,
  }) {
    final colors = context.colors;
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: colors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return CategoryPickerSheet(
          selectedCategory: selectedCategory,
          filterKind: filterKind,
          isFilterMode: isFilterMode,
          onSelected: (cat) => Navigator.pop(context, cat),
        );
      },
    );
  }

  @override
  State<CategoryPickerSheet> createState() => _CategoryPickerSheetState();
}

class _CategoryPickerSheetState extends State<CategoryPickerSheet> {
  final _categoryRepo = CategoryRepository();
  late List<TransactionCategory> _allCats;
  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selectedCategory;
    _refreshCategories();
  }

  void _refreshCategories() {
    _allCats = widget.filterKind != null
        ? _categoryRepo.getCategoriesByType(widget.filterKind!)
        : _categoryRepo.getAllCategories();
  }

  Future<void> _openAddCategory() async {
    final newCat = await AddCategorySheet.show(
      context,
      defaultType: widget.filterKind,
    );
    if (newCat != null && mounted) {
      setState(() {
        _refreshCategories();
        _selected = newCat.name;
      });
      // Nếu được gọi từ popup Thêm giao dịch hoặc lọc, tự động chọn danh mục này ngay lập tức
      widget.onSelected(newCat.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thanh gạt drag handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chọn danh mục',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.isFilterMode
                            ? 'Lọc danh sách giao dịch'
                            : 'Danh mục ${widget.filterKind == FirestoreConstants.typeIncome ? "thu nhập" : "chi tiêu"}',
                        style: TextStyle(
                          fontSize: 10,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: colors.surface2,
                        borderRadius: BorderRadius.circular(9),
                        border: Border.all(color: colors.border),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.close_rounded,
                        size: 17,
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Nút Thêm danh mục mới nổi bật
              GestureDetector(
                onTap: _openAddCategory,
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: colors.accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colors.accent.withValues(alpha: 0.4),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_circle_outline_rounded,
                        size: 16,
                        color: colors.accent,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Thêm danh mục mới',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: colors.accent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Lưới danh mục 2 cột
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (widget.isFilterMode) ...[
                        _buildCategoryItem(
                          colors: colors,
                          name: 'Tất cả danh mục',
                          icon: Icons.more_horiz_rounded,
                          color: colors.accent,
                          isSelected: _selected == 'all' ||
                              _selected == 'Tất cả danh mục',
                          onTap: () => widget.onSelected('all'),
                        ),
                        const SizedBox(height: 9),
                      ],
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 9,
                          mainAxisSpacing: 9,
                          childAspectRatio: 2.2,
                        ),
                        itemCount: _allCats.length + 1,
                        itemBuilder: (context, index) {
                          if (index == _allCats.length) {
                            return _buildAddCategoryGridItem(
                              colors: colors,
                              onTap: _openAddCategory,
                            );
                          }
                          final cat = _allCats[index];
                          final isSelected = _selected.toLowerCase() ==
                              cat.name.toLowerCase();

                          return _buildCategoryGridItem(
                            colors: colors,
                            name: cat.name,
                            icon: cat.icon,
                            color: cat.color,
                            isSelected: isSelected,
                            onTap: () => widget.onSelected(cat.name),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddCategoryGridItem({
    required PennyColors colors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: colors.surface2.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colors.accent.withValues(alpha: 0.35),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: colors.accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Icon(Icons.add_rounded, color: colors.accent, size: 16),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Thêm mới',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: colors.accent,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem({
    required PennyColors colors,
    required String name,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.accent.withValues(alpha: 0.1)
              : colors.surface2,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? colors.accent : colors.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(9),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: color, size: 17),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: colors.textPrimary,
                ),
              ),
            ),
            if (isSelected)
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: colors.accent,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.check_rounded,
                  size: 13,
                  color: colors.accentInk,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGridItem({
    required PennyColors colors,
    required String name,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.accent.withValues(alpha: 0.1)
              : colors.surface2,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? colors.accent : colors.border,
          ),
        ),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: colors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (isSelected)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: colors.accent,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.check_rounded,
                    size: 12,
                    color: colors.accentInk,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
