import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'navigation/app_router.dart';
import 'navigation/route_names.dart';

/// Behavior ẩn hoàn toàn thanh cuộn dọc (scrollbar) trên toàn bộ ứng dụng và web
class NoScrollbarBehavior extends MaterialScrollBehavior {
  const NoScrollbarBehavior();

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}

/// MaterialApp chính: Hỗ trợ chuyển đổi Theme (Sáng / Tối) & Prototype Stage chuẩn thiết kế Penny
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'Penny - Quản lý tài chính cá nhân',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          scrollBehavior: const NoScrollbarBehavior(),
          initialRoute: RouteNames.splash,
          onGenerateRoute: AppRouter.onGenerateRoute,
          builder: (context, child) {
            final colors = AppColors.of(context);

            return ScrollConfiguration(
              behavior: const NoScrollbarBehavior(),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Trên Web hoặc màn hình Desktop/Tablet lớn (> 540px):
                  // Hiển thị khung Phone Frame sắc nét căn giữa, nền Stage mockup chuẩn thiết kế Penny
                  if (constraints.maxWidth > 540) {
                    final phoneHeight = constraints.maxHeight > 940
                        ? 890.0
                        : (constraints.maxHeight - 32.0).clamp(600.0, 890.0);

                    return Scaffold(
                      backgroundColor: colors.stageBg,
                      body: Center(
                        child: Container(
                          width: 430,
                          height: phoneHeight,
                          decoration: BoxDecoration(
                            color: colors.bg,
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: colors.border,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.32),
                                blurRadius: 40,
                                spreadRadius: -4,
                                offset: const Offset(0, 18),
                              ),
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: child ?? const SizedBox.shrink(),
                        ),
                      ),
                    );
                  }

                  // Trên điện thoại thực tế: Hiển thị tràn viền toàn màn hình
                  return child ?? const SizedBox.shrink();
                },
              ),
            );
          },
        );
      },
    );
  }
}
