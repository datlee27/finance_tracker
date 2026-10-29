import 'dart:math';
import 'package:flutter/material.dart';
import '../../transactions/models/transaction_model.dart';

/// Dữ liệu biểu đồ cho 1 tháng
class MonthlyChartBar {
  final String label; // VD: 'T6'
  final int year;
  final double income;
  final double expense;

  const MonthlyChartBar({
    required this.label,
    required this.year,
    required this.income,
    required this.expense,
  });
}

/// Dữ liệu tổng hợp biểu đồ 6 tháng gần nhất
class ChartDataSummary {
  final List<MonthlyChartBar> months;
  final double maxAmount;
  final String yearsLabel;

  const ChartDataSummary({
    required this.months,
    required this.maxAmount,
    required this.yearsLabel,
  });

  factory ChartDataSummary.empty() => const ChartDataSummary(
        months: [],
        maxAmount: 1.0,
        yearsLabel: '',
      );
}

/// Provider phục vụ màn hình Tổng quan / Dashboard
class DashboardProvider extends ChangeNotifier {
  double _totalIncome = 0.0;
  double _totalExpense = 0.0;
  bool _isBalanceVisible = true;
  ChartDataSummary _chartData = ChartDataSummary.empty();

  // Getters
  double get totalIncome => _totalIncome;
  double get totalExpense => _totalExpense;
  double get balance => _totalIncome - _totalExpense;
  bool get isBalanceVisible => _isBalanceVisible;
  ChartDataSummary get chartData => _chartData;

  /// Bật / tắt ẩn số dư hiện tại (bảo mật khi xem ở nơi đông người)
  void toggleBalanceVisibility() {
    _isBalanceVisible = !_isBalanceVisible;
    notifyListeners();
  }

  /// Cập nhật dữ liệu từ danh sách giao dịch của TransactionProvider
  void updateFromTransactions(List<TransactionModel> transactions) {
    double income = 0.0;
    double expense = 0.0;

    for (final t in transactions) {
      if (t.isIncome) {
        income += t.amount;
      } else if (t.isExpense) {
        expense += t.amount;
      }
    }

    _totalIncome = income;
    _totalExpense = expense;
    _chartData = _calculateChartData(transactions);

    notifyListeners();
  }

  /// Tính toán dữ liệu 6 tháng gần nhất cho biểu đồ cột
  ChartDataSummary _calculateChartData(List<TransactionModel> transactions) {
    if (transactions.isEmpty) {
      return ChartDataSummary.empty();
    }

    final latestDate = transactions
        .map((t) => t.date)
        .reduce((a, b) => a.isAfter(b) ? a : b);

    final months = List.generate(6, (i) {
      // 5 tháng trước đến tháng hiện tại
      final date = DateTime(latestDate.year, latestDate.month - 5 + i, 1);
      final monthTransactions = transactions.where((t) {
        return t.date.year == date.year && t.date.month == date.month;
      });

      final monthIncome = monthTransactions
          .where((t) => t.isIncome)
          .fold(0.0, (sum, t) => sum + t.amount);

      final monthExpense = monthTransactions
          .where((t) => t.isExpense)
          .fold(0.0, (sum, t) => sum + t.amount);

      return MonthlyChartBar(
        label: 'T${date.month}',
        year: date.year,
        income: monthIncome,
        expense: monthExpense,
      );
    });

    final maxVal = months.fold<double>(
      1.0,
      (maxSoFar, m) => max(maxSoFar, max(m.income, m.expense)),
    );

    final distinctYears = months.map((m) => m.year).toSet().toList()..sort();
    final yearsStr = distinctYears.join('–');

    return ChartDataSummary(
      months: months,
      maxAmount: maxVal,
      yearsLabel: yearsStr,
    );
  }
}
