import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../models/transaction_category.dart';

/// Repository quản lý danh mục thu / chi cố định và tùy chỉnh theo thiết kế Penny
class CategoryRepository {
  static const String _prefsKey = 'penny_custom_categories';

  static const List<TransactionCategory> _defaultCategories = [
    // Thu nhập
    TransactionCategory(
      id: 'salary',
      name: 'Lương',
      type: CategoryType.income,
      icon: Icons.work_outline_rounded,
      color: AppColors.income,
    ),
    TransactionCategory(
      id: 'freelance',
      name: 'Làm thêm',
      type: CategoryType.income,
      icon: Icons.auto_awesome_outlined,
      color: AppColors.income,
    ),

    // Chi tiêu
    TransactionCategory(
      id: 'food',
      name: 'Ăn uống',
      type: CategoryType.expense,
      icon: Icons.restaurant_rounded,
      color: AppColors.expense,
    ),
    TransactionCategory(
      id: 'housing',
      name: 'Nhà ở',
      type: CategoryType.expense,
      icon: Icons.home_outlined,
      color: Color(0xFFE89858),
    ),
    TransactionCategory(
      id: 'market',
      name: 'Đi chợ',
      type: CategoryType.expense,
      icon: Icons.shopping_bag_outlined,
      color: AppColors.expense,
    ),
    TransactionCategory(
      id: 'transport',
      name: 'Di chuyển',
      type: CategoryType.expense,
      icon: Icons.directions_car_outlined,
      color: AppColors.catBlue,
    ),
    TransactionCategory(
      id: 'bills',
      name: 'Hóa đơn',
      type: CategoryType.expense,
      icon: Icons.receipt_long_outlined,
      color: AppColors.catPurple,
    ),
    TransactionCategory(
      id: 'shopping',
      name: 'Mua sắm',
      type: CategoryType.expense,
      icon: Icons.shopping_cart_outlined,
      color: AppColors.expense,
    ),
  ];

  static const TransactionCategory _otherCategory = TransactionCategory(
    id: 'other',
    name: 'Khác',
    type: CategoryType.both,
    icon: Icons.more_horiz_rounded,
    color: AppColors.accent,
  );

  static final List<TransactionCategory> _customCategories = [];
  static bool _isLoaded = false;

  /// Khởi tạo và nạp danh mục tùy chỉnh từ SharedPreferences
  static Future<void> init() async {
    if (_isLoaded) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey);
      if (raw != null && raw.isNotEmpty) {
        final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
        _customCategories.clear();
        for (final item in list) {
          if (item is Map<String, dynamic>) {
            _customCategories.add(TransactionCategory.fromJson(item));
          }
        }
      }
      _isLoaded = true;
    } catch (_) {
      _isLoaded = true;
    }
  }

  /// Lấy toàn bộ danh mục (mặc định + tùy chỉnh, 'Khác' luôn ở cuối)
  List<TransactionCategory> getAllCategories() {
    return [
      ..._defaultCategories,
      ..._customCategories,
      _otherCategory,
    ];
  }

  /// Lấy danh mục theo loại giao dịch ('income' hoặc 'expense')
  List<TransactionCategory> getCategoriesByType(String type) {
    final isInc = type.toLowerCase() == 'income' || type == 'Thu nhập';
    final filtered = [
      ..._defaultCategories,
      ..._customCategories,
    ].where((c) => isInc ? c.isIncome : c.isExpense).toList();

    return [
      ...filtered,
      _otherCategory,
    ];
  }

  /// Thêm danh mục tùy chỉnh mới
  Future<void> addCustomCategory(TransactionCategory category) async {
    _customCategories.removeWhere(
      (c) => c.name.toLowerCase() == category.name.toLowerCase(),
    );
    _customCategories.add(category);
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = _customCategories.map((c) => c.toJson()).toList();
      await prefs.setString(_prefsKey, jsonEncode(list));
    } catch (_) {}
  }

  /// Xóa danh mục tùy chỉnh
  Future<void> deleteCustomCategory(String id) async {
    _customCategories.removeWhere((c) => c.id == id);
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = _customCategories.map((c) => c.toJson()).toList();
      await prefs.setString(_prefsKey, jsonEncode(list));
    } catch (_) {}
  }

  /// Tìm danh mục theo tên, fallback về 'Khác' nếu không thấy
  TransactionCategory getCategoryByName(String name) {
    final all = getAllCategories();
    return all.firstWhere(
      (c) => c.name.toLowerCase() == name.trim().toLowerCase(),
      orElse: () => _otherCategory,
    );
  }

  /// Kiểm tra tên danh mục đã tồn tại hay chưa
  bool categoryExists(String name) {
    return getAllCategories().any(
      (c) => c.name.trim().toLowerCase() == name.trim().toLowerCase(),
    );
  }
}

