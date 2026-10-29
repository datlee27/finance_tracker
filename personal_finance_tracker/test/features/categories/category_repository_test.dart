import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:personal_finance_tracker/core/theme/app_colors.dart';
import 'package:personal_finance_tracker/features/categories/data/category_repository.dart';
import 'package:personal_finance_tracker/features/categories/models/transaction_category.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('CategoryRepository Unit Tests', () {
    test('Default categories contain income and expense categories', () {
      final repo = CategoryRepository();
      final all = repo.getAllCategories();
      expect(all.isNotEmpty, isTrue);

      final incomeCats = repo.getCategoriesByType('income');
      expect(incomeCats.any((c) => c.name == 'Lương'), isTrue);
      expect(incomeCats.any((c) => c.name == 'Làm thêm'), isTrue);

      final expenseCats = repo.getCategoriesByType('expense');
      expect(expenseCats.any((c) => c.name == 'Ăn uống'), isTrue);
      expect(expenseCats.any((c) => c.name == 'Nhà ở'), isTrue);
      expect(expenseCats.any((c) => c.name == 'Đi chợ'), isTrue);
    });

    test('Add custom expense category persists and shows in lists', () async {
      final repo = CategoryRepository();
      const customCat = TransactionCategory(
        id: 'custom_tra_sua',
        name: 'Trà sữa',
        type: CategoryType.expense,
        icon: Icons.local_cafe_rounded,
        color: AppColors.expense,
      );

      await repo.addCustomCategory(customCat);

      expect(repo.categoryExists('Trà sữa'), isTrue);
      expect(repo.categoryExists('trà sữa'), isTrue);

      final expenseCats = repo.getCategoriesByType('expense');
      expect(expenseCats.any((c) => c.name == 'Trà sữa'), isTrue);

      final found = repo.getCategoryByName('Trà sữa');
      expect(found.name, 'Trà sữa');
      expect(found.icon, Icons.local_cafe_rounded);
    });

    test('Add custom income category appears in income list', () async {
      final repo = CategoryRepository();
      const customIncomeCat = TransactionCategory(
        id: 'custom_thuong_kpi',
        name: 'Thưởng KPI',
        type: CategoryType.income,
        icon: Icons.monetization_on_outlined,
        color: AppColors.income,
      );

      await repo.addCustomCategory(customIncomeCat);

      final incomeCats = repo.getCategoriesByType('income');
      expect(incomeCats.any((c) => c.name == 'Thưởng KPI'), isTrue);

      final expenseCats = repo.getCategoriesByType('expense');
      expect(expenseCats.any((c) => c.name == 'Thưởng KPI'), isFalse);
    });

    test('Category icon helper serializes and restores icon correctly', () {
      const icon = Icons.fitness_center_rounded;
      final restored = CategoryIconHelper.fromCodePoint(icon.codePoint);
      expect(restored, icon);
    });
  });
}
