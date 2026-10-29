import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../navigation/route_names.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_header.dart';
import '../widgets/login_form.dart';

/// Màn hình Đăng nhập theo thiết kế Penny Figma (có nút Khách dùng thử)
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 40,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 12),

                      // Header
                      const AuthHeader(
                        title: 'Chào mừng trở lại.',
                        subtitle:
                            'Đăng nhập để tiếp tục theo dõi tài chính của bạn.',
                      ),
                      const SizedBox(height: 32),

                      // Form đăng nhập
                      const LoginForm(),
                      const SizedBox(height: 18),

                      // Phân cách "hoặc"
                      Row(
                        children: [
                          Expanded(child: Divider(color: colors.border)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Text(
                              'hoặc',
                              style: TextStyle(
                                color: colors.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: colors.border)),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Nút Đăng nhập bằng Google
                      Consumer<AuthProvider>(
                        builder: (context, auth, _) {
                          return AppButton(
                            label: 'Tiếp tục với Google',
                            variant: AppButtonVariant.secondary,
                            leading: Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'G',
                                style: TextStyle(
                                  color: Color(0xFF4285F4),
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            isLoading: auth.isLoading,
                            onPressed: () async {
                              final success = await auth.loginWithGoogle();
                              if (success && context.mounted) {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  RouteNames.main,
                                  (route) => false,
                                );
                              } else if (!success &&
                                  auth.errorMessage != null &&
                                  context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(auth.errorMessage!),
                                    backgroundColor: colors.danger,
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 12),

                      // Nút vào với tư cách Khách
                      Consumer<AuthProvider>(
                        builder: (context, auth, _) {
                          return AppButton(
                            label: 'Vào dùng ngay với tư cách Khách',
                            variant: AppButtonVariant.text,
                            icon: Icons.person_outline_rounded,
                            isLoading: auth.isLoading,
                            onPressed: () async {
                              final success = await auth.loginAsGuest();
                              if (success && context.mounted) {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  RouteNames.main,
                                  (route) => false,
                                );
                              }
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      // Chuyển sang màn hình Đăng ký
                      AppLinkButton(
                        text: 'Chưa có tài khoản?',
                        linkText: 'Đăng ký ngay',
                        onTap: () {
                          Navigator.pushNamed(context, RouteNames.register);
                        },
                      ),

                      const Spacer(),

                      // Footer nhỏ
                      Center(
                        child: Text(
                          'Personal Finance Tracker · PRM393',
                          style: TextStyle(
                            fontSize: 10,
                            color: colors.textHint,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
