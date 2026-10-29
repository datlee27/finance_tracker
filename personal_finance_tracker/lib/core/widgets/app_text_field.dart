import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

/// TextField dùng chung trong toàn ứng dụng (Đồng bộ Penny Design)
class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final VoidCallback? onTap;
  final bool readOnly;
  final int maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final bool showTopLabel;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.onTap,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.showTopLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final field = TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onTap: onTap,
      readOnly: readOnly,
      maxLines: maxLines,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      focusNode: focusNode,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      style: TextStyle(
        color: colors.textPrimary,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: colors.textHint,
          fontSize: 13,
        ),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        counterText: '',
        filled: true,
        fillColor: colors.surface2,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.accent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.danger, width: 1.5),
        ),
      ),
    );

    if (!showTopLabel) return field;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: 7),
        field,
      ],
    );
  }
}
