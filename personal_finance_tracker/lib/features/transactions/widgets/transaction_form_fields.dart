import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';

/// Ô nhập tiền tệ lớn trong form theo chuẩn Penny
class AmountInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const AmountInputField({
    super.key,
    required this.controller,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.surface2,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: errorText != null ? AppColors.danger : AppColors.border,
              width: errorText != null ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [ThousandsSeparatorInputFormatter()],
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  decoration: const InputDecoration(
                    hintText: '0',
                    hintStyle: TextStyle(
                      fontSize: 22,
                      color: AppColors.textHint,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  onChanged: onChanged,
                ),
              ),
              const Text(
                '₫',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 5),
          Text(
            errorText!,
            style: const TextStyle(fontSize: 10, color: AppColors.danger),
          ),
        ],
      ],
    );
  }
}
