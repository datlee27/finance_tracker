import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/firestore_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/app_button.dart';
import '../../categories/data/category_repository.dart';
import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';
import '../widgets/transaction_filter_sheet.dart';
import '../widgets/transaction_type_selector.dart';

/// Form thêm hoặc chỉnh sửa giao dịch theo chuẩn Penny Figma
class TransactionFormScreen extends StatefulWidget {
  final TransactionModel? initial;
  final String? initialType;

  const TransactionFormScreen({super.key, this.initial, this.initialType});

  /// Hàm tiện ích mở Form dạng Bottom Sheet
  static Future<bool?> show(
    BuildContext context, {
    TransactionModel? initial,
    String? initialType,
  }) {
    final colors = context.colors;
    return showModalBottomSheet<bool>(
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
          child: TransactionFormContent(
            initial: initial,
            initialType: initialType,
          ),
        );
      },
    );
  }

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final initial = widget.initial ??
        ModalRoute.of(context)?.settings.arguments as TransactionModel?;

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.bg,
        elevation: 0,
        title: Text(
          initial != null ? 'Chỉnh sửa giao dịch' : 'Thêm giao dịch',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: TransactionFormContent(
            initial: initial,
            isStandaloneScreen: true,
          ),
        ),
      ),
    );
  }
}

/// Nội dung Form nhập liệu
class TransactionFormContent extends StatefulWidget {
  final TransactionModel? initial;
  final String? initialType;
  final bool isStandaloneScreen;

  const TransactionFormContent({
    super.key,
    this.initial,
    this.initialType,
    this.isStandaloneScreen = false,
  });

  @override
  State<TransactionFormContent> createState() => _TransactionFormContentState();
}

class _TransactionFormContentState extends State<TransactionFormContent> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  late String _type;
  String? _category;
  late DateTime _date;

  String? _amountError;
  String? _categoryError;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final init = widget.initial;
    if (init != null) {
      _type = init.type;
      _category = init.category;
      _date = init.date;
      _amountController.text = CurrencyFormatter.formatWithDots(init.amount);
      _noteController.text = init.note ?? '';
    } else {
      _type = widget.initialType ?? FirestoreConstants.typeExpense;
      _category = null;
      _date = DateTime.now();
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final colors = context.colors;
    setState(() {
      _amountError = null;
      _categoryError = null;
    });

    final amountVal = CurrencyFormatter.parse(_amountController.text);

    bool hasError = false;
    if (amountVal == null || amountVal <= 0) {
      _amountError = 'Số tiền phải lớn hơn 0.';
      hasError = true;
    }

    if (_category == null || _category!.trim().isEmpty) {
      _categoryError = 'Vui lòng chọn danh mục.';
      hasError = true;
    }

    if (hasError) {
      setState(() {});
      return;
    }

    setState(() => _isSaving = true);

    final provider = context.read<TransactionProvider>();
    final noteText = _noteController.text.trim().isEmpty
        ? null
        : _noteController.text.trim();

    bool success;
    if (widget.initial != null) {
      final updated = widget.initial!.copyWith(
        type: _type,
        amount: amountVal!,
        category: _category!,
        date: _date,
        note: noteText,
      );
      success = await provider.updateTransaction(updated);
    } else {
      success = await provider.addTransaction(
        type: _type,
        amount: amountVal!,
        category: _category!,
        date: _date,
        note: noteText,
      );
    }

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.initial != null
                  ? 'Đã cập nhật giao dịch thành công'
                  : 'Đã thêm giao dịch mới thành công',
            ),
            backgroundColor: colors.income,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _pickCategory() async {
    final picked = await CategoryPickerSheet.show(
      context,
      selectedCategory: _category ?? '',
      filterKind: _type,
      isFilterMode: false,
    );
    if (picked != null) {
      setState(() {
        _category = picked;
        _categoryError = null;
      });
    }
  }

  Future<void> _pickDate() async {
    final colors = context.colors;
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme(
              brightness: Theme.of(context).brightness,
              primary: colors.accent,
              onPrimary: colors.accentInk,
              secondary: colors.accent,
              onSecondary: colors.accentInk,
              error: colors.danger,
              onError: Colors.white,
              surface: colors.surface,
              onSurface: colors.textPrimary,
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: colors.surface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final categoryRepo = CategoryRepository();
    final cat = _category != null ? categoryRepo.getCategoryByName(_category!) : null;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        22,
        widget.isStandaloneScreen ? 0 : 10,
        22,
        widget.isStandaloneScreen ? 24 : 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!widget.isStandaloneScreen) ...[
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.initial != null
                          ? 'Chỉnh sửa giao dịch'
                          : 'Thêm giao dịch',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.initial != null
                          ? 'Cập nhật lại thông tin bên dưới.'
                          : 'Ghi lại một khoản thu hoặc chi mới.',
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
          ],

          // 1. Loại giao dịch (Chi tiêu / Thu nhập)
          Text(
            'Loại giao dịch',
            style: TextStyle(fontSize: 11, color: colors.textSecondary),
          ),
          const SizedBox(height: 8),
          TransactionTypeSelector(
            selectedType: _type,
            onChanged: (newType) {
              setState(() {
                _type = newType;
                _category = null;
              });
            },
          ),
          const SizedBox(height: 16),

          // 2. Số tiền (Ô nhập lớn kèm ký hiệu ₫)
          Row(
            children: [
              Text(
                'Số tiền',
                style: TextStyle(fontSize: 11, color: colors.textSecondary),
              ),
              const SizedBox(width: 4),
              Text('*', style: TextStyle(color: colors.accent, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: colors.surface2,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _amountError != null ? colors.danger : colors.border,
                width: _amountError != null ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [ThousandsSeparatorInputFormatter()],
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: '0',
                      hintStyle: TextStyle(
                        fontSize: 22,
                        color: colors.textHint,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    onChanged: (_) {
                      if (_amountError != null) {
                        setState(() => _amountError = null);
                      }
                    },
                  ),
                ),
                Text(
                  '₫',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: colors.accent,
                  ),
                ),
              ],
            ),
          ),
          if (_amountError != null) ...[
            const SizedBox(height: 5),
            Text(
              _amountError!,
              style: TextStyle(fontSize: 10, color: colors.danger),
            ),
          ],
          const SizedBox(height: 16),

          // 3. Danh mục
          Row(
            children: [
              Text(
                'Danh mục',
                style: TextStyle(fontSize: 11, color: colors.textSecondary),
              ),
              const SizedBox(width: 4),
              Text('*', style: TextStyle(color: colors.accent, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _pickCategory,
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: colors.surface2,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _categoryError != null
                      ? colors.danger
                      : colors.border,
                  width: _categoryError != null ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  if (cat != null) ...[
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      alignment: Alignment.center,
                      child: Icon(cat.icon, color: cat.color, size: 15),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        cat.name,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                  ] else ...[
                    Icon(
                      Icons.more_horiz_rounded,
                      size: 18,
                      color: colors.textSecondary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Chọn danh mục',
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.textHint,
                        ),
                      ),
                    ),
                  ],
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: colors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          if (_categoryError != null) ...[
            const SizedBox(height: 5),
            Text(
              _categoryError!,
              style: TextStyle(fontSize: 10, color: colors.danger),
            ),
          ],
          const SizedBox(height: 16),

          // 4. Ngày giao dịch
          Row(
            children: [
              Text(
                'Ngày giao dịch',
                style: TextStyle(fontSize: 11, color: colors.textSecondary),
              ),
              const SizedBox(width: 4),
              Text('*', style: TextStyle(color: colors.accent, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: colors.surface2,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.border),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 17,
                    color: colors.textSecondary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      DateFormatter.formatDate(_date),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: colors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 5. Ghi chú (không bắt buộc)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ghi chú',
                style: TextStyle(fontSize: 11, color: colors.textSecondary),
              ),
              Text(
                'Không bắt buộc',
                style: TextStyle(fontSize: 10, color: colors.textHint),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 72,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: colors.surface2,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.border),
            ),
            child: TextField(
              controller: _noteController,
              maxLines: 3,
              style: TextStyle(
                fontSize: 12,
                color: colors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Giao dịch này dùng cho việc gì?',
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: colors.textHint,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(height: 22),

          // Nút hành động: Hủy & Lưu
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Hủy',
                  variant: AppButtonVariant.secondary,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppButton(
                  label: widget.initial != null ? 'Lưu thay đổi' : 'Lưu giao dịch',
                  variant: AppButtonVariant.primary,
                  isLoading: _isSaving,
                  onPressed: _handleSave,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
