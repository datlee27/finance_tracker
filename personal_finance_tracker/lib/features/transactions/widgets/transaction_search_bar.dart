import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Ô tìm kiếm giao dịch hoặc danh mục
class TransactionSearchBar extends StatefulWidget {
  final String initialQuery;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const TransactionSearchBar({
    super.key,
    required this.initialQuery,
    required this.onChanged,
    required this.onClear,
  });

  @override
  State<TransactionSearchBar> createState() => _TransactionSearchBarState();
}

class _TransactionSearchBarState extends State<TransactionSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
  }

  @override
  void didUpdateWidget(covariant TransactionSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialQuery != widget.initialQuery &&
        _controller.text != widget.initialQuery) {
      _controller.text = widget.initialQuery;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            size: 20,
            color: colors.textSecondary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              style: TextStyle(
                fontSize: 12,
                color: colors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Tìm giao dịch hoặc danh mục',
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: colors.textHint,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (text) {
                setState(() {});
                widget.onChanged(text);
              },
            ),
          ),
          if (_controller.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _controller.clear();
                setState(() {});
                widget.onClear();
              },
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.close_rounded,
                  size: 17,
                  color: colors.textSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
