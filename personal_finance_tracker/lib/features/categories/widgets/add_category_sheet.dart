import 'package:flutter/material.dart';
import '../../../core/constants/firestore_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../data/category_repository.dart';
import '../models/transaction_category.dart';

/// Modal popup thêm danh mục mới theo chuẩn Penny Design System
class AddCategorySheet extends StatefulWidget {
  final String? defaultType; // 'income' hoặc 'expense'

  const AddCategorySheet({super.key, this.defaultType});

  /// Hàm tiện ích mở Bottom Sheet Thêm danh mục
  static Future<TransactionCategory?> show(
    BuildContext context, {
    String? defaultType,
  }) {
    final colors = context.colors;
    return showModalBottomSheet<TransactionCategory>(
      context: context,
      backgroundColor: colors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddCategorySheet(defaultType: defaultType),
        );
      },
    );
  }

  @override
  State<AddCategorySheet> createState() => _AddCategorySheetState();
}

class _AddCategorySheetState extends State<AddCategorySheet> {
  final _nameController = TextEditingController();
  final _categoryRepo = CategoryRepository();

  late String _selectedType;
  late IconData _selectedIcon;
  late Color _selectedColor;
  String? _errorMessage;
  bool _isSaving = false;

  // Danh sách các biểu tượng phong phú cho tài chính & đời sống
  static const List<IconData> _availableIcons = CategoryIconHelper.allIcons;

  // Bảng màu hài hòa chuẩn Penny theme
  static const List<Color> _availableColors = [
    AppColors.expense,
    AppColors.income,
    AppColors.accent,
    AppColors.catBlue,
    AppColors.catPurple,
    Color(0xFFF472B6), // Hồng
    Color(0xFF2DD4BF), // Teal
    Color(0xFFE89858), // Nâu cam
  ];

  @override
  void initState() {
    super.initState();
    final isIncome = widget.defaultType == FirestoreConstants.typeIncome ||
        widget.defaultType == 'Thu nhập';
    _selectedType = isIncome
        ? FirestoreConstants.typeIncome
        : FirestoreConstants.typeExpense;

    _selectedIcon = isIncome
        ? Icons.monetization_on_outlined
        : Icons.restaurant_rounded;

    _selectedColor = isIncome ? AppColors.income : AppColors.expense;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _errorMessage = 'Vui lòng nhập tên danh mục.');
      return;
    }

    if (_categoryRepo.categoryExists(name)) {
      setState(() => _errorMessage = 'Tên danh mục này đã tồn tại.');
      return;
    }

    setState(() {
      _errorMessage = null;
      _isSaving = true;
    });

    final newCat = TransactionCategory(
      id: 'custom_${DateTime.now().microsecondsSinceEpoch}',
      name: name,
      type: _selectedType == FirestoreConstants.typeIncome
          ? CategoryType.income
          : CategoryType.expense,
      icon: _selectedIcon,
      color: _selectedColor,
    );

    await _categoryRepo.addCustomCategory(newCat);

    if (mounted) {
      Navigator.pop(context, newCat);
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
        child: SingleChildScrollView(
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
                        'Thêm danh mục mới',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tạo danh mục thu chi riêng của bạn',
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
              const SizedBox(height: 18),

              // 1. Loại giao dịch (Chi tiêu / Thu nhập)
              Text(
                'Loại danh mục *',
                style: TextStyle(fontSize: 11, color: colors.textSecondary),
              ),
              const SizedBox(height: 8),
              Container(
                height: 44,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: colors.surface2,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildTypeButton(
                        label: 'Chi tiêu',
                        icon: Icons.arrow_downward_rounded,
                        isSelected:
                            _selectedType == FirestoreConstants.typeExpense,
                        activeColor: colors.expense,
                        colors: colors,
                        onTap: () {
                          setState(() {
                            _selectedType = FirestoreConstants.typeExpense;
                            _selectedColor = AppColors.expense;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: _buildTypeButton(
                        label: 'Thu nhập',
                        icon: Icons.arrow_upward_rounded,
                        isSelected:
                            _selectedType == FirestoreConstants.typeIncome,
                        activeColor: colors.income,
                        colors: colors,
                        onTap: () {
                          setState(() {
                            _selectedType = FirestoreConstants.typeIncome;
                            _selectedColor = AppColors.income;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 2. Tên danh mục
              Text(
                'Tên danh mục *',
                style: TextStyle(fontSize: 11, color: colors.textSecondary),
              ),
              const SizedBox(height: 8),
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: colors.surface2,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        _errorMessage != null ? colors.danger : colors.border,
                    width: _errorMessage != null ? 1.5 : 1,
                  ),
                ),
                child: TextField(
                  controller: _nameController,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: colors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Ví dụ: Trà sữa, Tiền thưởng, Xăng xe...',
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: colors.textHint,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  onChanged: (_) {
                    if (_errorMessage != null) {
                      setState(() => _errorMessage = null);
                    }
                  },
                ),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 5),
                Text(
                  _errorMessage!,
                  style: TextStyle(
                    fontSize: 10,
                    color: colors.danger,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              const SizedBox(height: 16),

              // 3. Chọn Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Chọn biểu tượng *',
                    style: TextStyle(fontSize: 11, color: colors.textSecondary),
                  ),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: _selectedColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _selectedColor),
                    ),
                    alignment: Alignment.center,
                    child: Icon(_selectedIcon, size: 16, color: _selectedColor),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                height: 130,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colors.surface2,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.border),
                ),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                  ),
                  itemCount: _availableIcons.length,
                  itemBuilder: (context, index) {
                    final icon = _availableIcons[index];
                    final isSelected = icon == _selectedIcon;

                    return GestureDetector(
                      onTap: () => setState(() => _selectedIcon = icon),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _selectedColor.withValues(alpha: 0.2)
                              : colors.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? _selectedColor : colors.border,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          icon,
                          size: 16,
                          color: isSelected ? _selectedColor : colors.textSecondary,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // 4. Chọn màu sắc
              Text(
                'Màu sắc hiển thị',
                style: TextStyle(fontSize: 11, color: colors.textSecondary),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _availableColors.map((color) {
                  final isSelected = color.toARGB32() == _selectedColor.toARGB32();
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = color),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? colors.textPrimary : Colors.transparent,
                          width: 2.5,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.4),
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: isSelected
                          ? const Icon(
                              Icons.check_rounded,
                              size: 16,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 22),

              // 5. Nút bấm Tạo danh mục
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Hủy',
                      variant: AppButtonVariant.outlined,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppButton(
                      label: _isSaving ? 'Đang tạo...' : 'Tạo danh mục',
                      onPressed: _isSaving ? null : _handleSave,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required Color activeColor,
    required PennyColors colors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
          border: isSelected
              ? Border.all(color: activeColor.withValues(alpha: 0.5))
              : null,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 14,
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
