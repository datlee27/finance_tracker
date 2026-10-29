import 'package:flutter/material.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/auth/screens/splash_screen.dart';
import '../features/transactions/models/transaction_model.dart';
import '../features/transactions/screens/transaction_detail_screen.dart';
import '../features/transactions/screens/transaction_form_screen.dart';
import 'main_shell.dart';
import 'route_names.dart';

/// Cấu hình routing của ứng dụng dùng named routes
class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );

      case RouteNames.login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );

      case RouteNames.register:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
          settings: settings,
        );

      case RouteNames.main:
        return MaterialPageRoute(
          builder: (_) => const MainShell(),
          settings: settings,
        );

      case RouteNames.transactionDetail:
        final item = settings.arguments as TransactionModel?;
        return MaterialPageRoute(
          builder: (_) => TransactionDetailScreen(transaction: item),
          settings: settings,
        );

      case RouteNames.transactionAdd:
        return MaterialPageRoute(
          builder: (_) => const TransactionFormScreen(),
          settings: settings,
        );

      case RouteNames.transactionEdit:
        final item = settings.arguments as TransactionModel?;
        return MaterialPageRoute(
          builder: (_) => TransactionFormScreen(initial: item),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route không tồn tại: ${settings.name}'),
            ),
          ),
        );
    }
  }
}
