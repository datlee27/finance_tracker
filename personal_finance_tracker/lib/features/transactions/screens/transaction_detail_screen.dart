import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/app_button.dart';
import '../../../shared/widgets/confirm_delete_dialog.dart';
import '../../categories/data/category_repository.dart';
import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';
import 'transaction_form_screen.dart';

/// Màn hình hoặc Sheet hiển thị chi tiết giao dịch theo chuẩn Penny
class TransactionDetailScreen extends StatelessWidget {
  final TransactionModel? transaction;

  const TransactionDetailScreen({super.key, this.transaction});

  /// Hàm tiện ích hiển thị chi tiết dạng Bottom Sheet
  static Future<void> showSheet(
    BuildContext context, {
    required TransactionModel transaction,
  }) {
    final colors = context.colors;
    return showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return TransactionDetailSheetContent(transaction: transaction);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    // Nhận model từ arguments nếu mở bằng Navigator.pushNamed
    final item = transaction ??
        ModalRoute.of(context)?.settings.arguments as TransactionModel?;

    if (item == null) {
      return Scaffold(
        backgroundColor: colors.bg,
        appBar: AppBar(
          backgroundColor: colors.bg,
          title: const Text('Chi tiết giao dịch'),
        ),
        body: Center(
          child: Text(
            'Không tìm thấy giao dịch.',
            style: TextStyle(color: colors.textSecondary),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.bg,
        elevation: 0,
        title: const Text(
          'Chi tiết giao dịch',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: TransactionDetailSheetContent(transaction: item),
        ),
      ),
    );
  }
}

/// Nội dung thẻ chi tiết giao dịch
class TransactionDetailSheetContent extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionDetailSheetContent({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final categoryRepo = CategoryRepository();
    final cat = categoryRepo.getCategoryByName(transaction.category);
    final isIncome = transaction.isIncome;
    final signedAmount =
        '${isIncome ? '+' : '−'}${CurrencyFormatter.format(transaction.amount)}';

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle bar
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
              const SizedBox(height: 18),

              // Icon to + Loại giao dịch + Số tiền to đậm
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: colors.surface2,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Icon(cat.icon, color: cat.color, size: 26),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      transaction.kind,
                      style: TextStyle(
                        fontSize: 11,
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      signedAmount,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: isIncome ? colors.income : colors.expense,
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Danh sách các dòng thông tin (detail-rows)
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: colors.border),
                    bottom: BorderSide(color: colors.border),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    _buildDetailRow(colors, 'Danh mục', transaction.category),
                    _buildDetailRow(
                      colors,
                      'Ngày giao dịch',
                      DateFormatter.formatDate(transaction.date),
                    ),
                    _buildDetailRow(
                      colors,
                      'Ghi chú',
                      transaction.note?.isNotEmpty == true
                          ? transaction.note!
                          : 'Không có ghi chú',
                    ),
                    _buildDetailRow(colors, 'Mã giao dịch', transaction.id),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Nút Chỉnh sửa giao dịch
              AppButton(
                label: 'Chỉnh sửa giao dịch',
                icon: Icons.edit_outlined,
                variant: AppButtonVariant.primary,
                onPressed: () {
                  Navigator.pop(context);
                  TransactionFormScreen.show(context, initial: transaction);
                },
              ),
              const SizedBox(height: 10),

              // Nút Xóa giao dịch
              AppButton(
                label: 'Xóa giao dịch',
                icon: Icons.delete_outline_rounded,
                variant: AppButtonVariant.dangerGhost,
                onPressed: () async {
                  final confirm = await ConfirmDeleteDialog.show(
                    context,
                    title: 'Xóa giao dịch?',
                    message:
                        'Bạn có chắc chắn muốn xóa giao dịch này? Thao tác này không thể hoàn tác.',
                    confirmLabel: 'Xóa giao dịch',
                    cancelLabel: 'Giữ lại',
                  );

                  if (confirm == true && context.mounted) {
                    final provider = context.read<TransactionProvider>();
                    await provider.deleteTransaction(transaction.id);
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Đã xóa giao dịch thành công'),
                          backgroundColor: colors.surface2,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(PennyColors colors, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
