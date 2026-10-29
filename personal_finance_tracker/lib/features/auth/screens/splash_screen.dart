import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../navigation/route_names.dart';
import '../providers/auth_provider.dart';

/// Màn hình Splash kiểm tra phiên đăng nhập tự động
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthAndNavigate();
    });
  }

  void _checkAuthAndNavigate() {
    final auth = context.read<AuthProvider>();
    if (auth.isInitialized) {
      _navigate(auth.isAuthenticated);
    } else {
      // Đợi đến khi AuthProvider nhận event đầu tiên từ authStateChanges()
      void listener() {
        if (auth.isInitialized) {
          auth.removeListener(listener);
          _navigate(auth.isAuthenticated);
        }
      }
      auth.addListener(listener);
    }
  }

  void _navigate(bool isAuthenticated) {
    if (!mounted) return;
    final targetRoute = isAuthenticated ? RouteNames.main : RouteNames.login;
    Navigator.pushNamedAndRemoveUntil(context, targetRoute, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Mark 'P' + 'Penny'
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colors.accent,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'P',
                    style: TextStyle(
                      color: colors.accentInk,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                    ),
                  ),
                ),
                const SizedBox(width: 13),
                Text(
                  'Penny',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                    letterSpacing: -0.6,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 36),

            // Loading spinner màu vàng hổ phách
            SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                color: colors.accent,
              ),
            ),
            const SizedBox(height: 14),

            // Dòng chữ trạng thái
            Text(
              'Đang kiểm tra phiên đăng nhập...',
              style: TextStyle(
                fontSize: 12,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
