import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../navigation/route_names.dart';
import '../providers/auth_provider.dart';

/// Form Đăng nhập theo thiết kế Penny Figma
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final authProvider = context.read<AuthProvider>();
    authProvider.clearError();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final success = await authProvider.login(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (success && mounted) {
      // Điều hướng vào màn hình chính và xóa toàn bộ stack
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.main,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Email
              AppTextField(
                label: 'Email',
                hint: 'tenban@example.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.validateEmail,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              // Mật khẩu
              AppTextField(
                label: 'Mật khẩu',
                hint: 'Tối thiểu 6 ký tự',
                controller: _passwordController,
                obscureText: _obscurePassword,
                validator: Validators.validatePassword,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _handleLogin(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 19,
                    color: colors.textSecondary,
                  ),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
              ),

              // Banner lỗi
              if (auth.errorMessage != null) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                  decoration: BoxDecoration(
                    color: colors.danger.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: colors.danger.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        color: colors.danger,
                        size: 18,
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          auth.errorMessage!,
                          style: TextStyle(
                            color: colors.danger,
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Nút Đăng nhập
              AppButton(
                label: 'Đăng nhập',
                isLoading: auth.isLoading,
                onPressed: _handleLogin,
              ),
            ],
          ),
        );
      },
    );
  }
}
