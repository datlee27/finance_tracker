/// Model lưu trữ điều kiện lọc và tìm kiếm giao dịch
class TransactionFilter {
  final String type; // 'all', 'income', 'expense'
  final String category; // 'all' hoặc tên danh mục cụ thể (VD: 'Ăn uống')
  final String searchQuery;

  const TransactionFilter({
    this.type = 'all',
    this.category = 'all',
    this.searchQuery = '',
  });

  /// Kiểm tra có đang áp dụng bộ lọc nào không
  bool get hasActiveFilter =>
      type != 'all' || category != 'all' || searchQuery.trim().isNotEmpty;

  /// Tạo bản sao có cập nhật
  TransactionFilter copyWith({
    String? type,
    String? category,
    String? searchQuery,
  }) {
    return TransactionFilter(
      type: type ?? this.type,
      category: category ?? this.category,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  /// Trạng thái mặc định (không lọc)
  factory TransactionFilter.initial() => const TransactionFilter();
}
