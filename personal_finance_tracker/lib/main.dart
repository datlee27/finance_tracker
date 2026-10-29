import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'core/theme/theme_provider.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/categories/data/category_repository.dart';
import 'features/transactions/providers/transaction_provider.dart';
import 'features/dashboard/providers/dashboard_provider.dart';

/// Entry point: khởi tạo Firebase, chuẩn hóa Locale formatting và đăng ký các Provider
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo bảng Locale symbols cho intl, tránh lỗi LocaleDataException trên Flutter Web
  try {
    await initializeDateFormatting('vi_VN', null);
    await initializeDateFormatting('en', null);
  } catch (e) {
    debugPrint('DateFormatting init log: $e');
  }

  // Khởi tạo Firebase với options hỗ trợ đa nền tảng
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase init log: $e');
  }

  // Khởi tạo danh mục tùy chỉnh
  try {
    await CategoryRepository.init();
  } catch (e) {
    debugPrint('CategoryRepository init log: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        // Quản lý theme Sáng / Tối / Theo hệ thống
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),

        // AuthProvider lắng nghe trạng thái đăng nhập Firebase
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),

        // TransactionProvider phụ thuộc AuthProvider:
        // Khi uid thay đổi (đổi tài khoản/logout), provider tự reset
        ChangeNotifierProxyProvider<AuthProvider, TransactionProvider>(
          create: (_) => TransactionProvider(),
          update: (_, authProvider, transactionProvider) {
            return (transactionProvider ?? TransactionProvider())
              ..updateUser(
                authProvider.currentUser?.uid,
                isGuest: authProvider.isGuest,
              );
          },
        ),

        // DashboardProvider phụ thuộc TransactionProvider:
        // Chỉ tính toán từ dữ liệu có sẵn, không gọi repository
        ChangeNotifierProxyProvider<TransactionProvider, DashboardProvider>(
          create: (_) => DashboardProvider(),
          update: (_, transactionProvider, dashboardProvider) {
            return (dashboardProvider ?? DashboardProvider())
              ..updateFromTransactions(transactionProvider.transactions);
          },
        ),
      ],
      child: const App(),
    ),
  );
}
