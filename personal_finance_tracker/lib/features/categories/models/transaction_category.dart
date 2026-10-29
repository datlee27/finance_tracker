import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Loại danh mục giao dịch
enum CategoryType {
  income,
  expense,
  both,
}

/// Model Danh mục giao dịch (Thu nhập / Chi tiêu)
class TransactionCategory {
  final String id;
  final String name;
  final CategoryType type;
  final IconData icon;
  final Color color;

  const TransactionCategory({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
    this.color = AppColors.accent,
  });

  bool get isIncome => type == CategoryType.income || type == CategoryType.both;
  bool get isExpense => type == CategoryType.expense || type == CategoryType.both;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type.name,
    'iconCode': icon.codePoint,
    'colorValue': color.toARGB32(),
  };

  factory TransactionCategory.fromJson(Map<String, dynamic> json) {
    return TransactionCategory(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Khác',
      type: CategoryType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => CategoryType.both,
      ),
      icon: CategoryIconHelper.fromCodePoint(
        json['iconCode'] as int? ?? Icons.more_horiz_rounded.codePoint,
      ),
      color: Color(json['colorValue'] as int? ?? 0xFFF59E0B),
    );
  }
}

/// Helper định nghĩa danh mục biểu tượng chuẩn Penny
class CategoryIconHelper {
  CategoryIconHelper._();

  static const List<IconData> allIcons = [
    Icons.restaurant_rounded,
    Icons.local_cafe_rounded,
    Icons.fastfood_rounded,
    Icons.shopping_bag_outlined,
    Icons.shopping_cart_outlined,
    Icons.home_outlined,
    Icons.directions_car_outlined,
    Icons.two_wheeler_rounded,
    Icons.local_gas_station_outlined,
    Icons.receipt_long_outlined,
    Icons.lightbulb_outline_rounded,
    Icons.wifi_rounded,
    Icons.phone_iphone_rounded,
    Icons.medical_services_outlined,
    Icons.school_outlined,
    Icons.sports_esports_outlined,
    Icons.fitness_center_rounded,
    Icons.flight_takeoff_rounded,
    Icons.card_giftcard_rounded,
    Icons.pets_outlined,
    Icons.content_cut_rounded,
    Icons.work_outline_rounded,
    Icons.auto_awesome_outlined,
    Icons.monetization_on_outlined,
    Icons.savings_outlined,
    Icons.trending_up_rounded,
    Icons.account_balance_rounded,
    Icons.more_horiz_rounded,
  ];

  static IconData fromCodePoint(int codePoint) {
    return allIcons.firstWhere(
      (icon) => icon.codePoint == codePoint,
      orElse: () => Icons.more_horiz_rounded,
    );
  }
}


