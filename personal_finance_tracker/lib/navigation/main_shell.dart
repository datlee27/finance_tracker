import 'package:flutter/material.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/transactions/screens/transaction_form_screen.dart';
import '../../features/transactions/screens/transaction_list_screen.dart';
import '../../shared/widgets/app_bottom_navigation.dart';

/// Shell điều hướng chính của ứng dụng
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  void _switchTab(int index) {
    if (_currentIndex != index) {
      setState(() => _currentIndex = index);
    }
  }

  void _openAddTransaction() {
    TransactionFormScreen.show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // Tab 0: Trang chủ Dashboard
          DashboardScreen(
            onViewAllTransactions: () => _switchTab(1),
          ),

          // Tab 1: Danh sách giao dịch
          const TransactionListScreen(),
        ],
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _currentIndex,
        onIndexChanged: _switchTab,
        onAddTap: _openAddTransaction,
      ),
    );
  }
}
