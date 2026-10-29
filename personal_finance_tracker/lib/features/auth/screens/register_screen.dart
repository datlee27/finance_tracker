import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../navigation/route_names.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_header.dart';

/// Màn hình Đăng ký tài khoản theo thiết kế Penny Figma
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final auth = context.read<AuthProvider>();
    auth.clearError();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final success = await auth.register(
      email: _emailController.text,
      password: _passwordController.text,
      displayName: _nameController.text.trim().isNotEmpty
          ? _nameController.text.trim()
          : null,
    );

    if (success && mounted) {
      // Đăng ký thành công, tự động đăng nhập và vào Main
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

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Consumer<AuthProvider>(
              builder: (context, auth, _) {
                return SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 40,
                    ),
                    child: IntrinsicHeight(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 12),

                            // Header
                            const AuthHeader(
                              title: 'Bắt đầu hành trình mới.',
                              subtitle:
                                   'Tạo tài khoản để quản lý thu chi rõ ràng hơn.',
                            ),
                            const SizedBox(height: 28),

                            // Tên hiển thị
                            AppTextField(
                              label: 'Họ và tên',
                              hint: 'Ví dụ: Minh Anh',
                              controller: _nameController,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 16),

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
                              textInputAction: TextInputAction.next,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 19,
                                  color: colors.textSecondary,
                                ),
                                onPressed: () {
                                  setState(() =>
                                      _obscurePassword = !_obscurePassword);
                                },
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Xác nhận mật khẩu
                            AppTextField(
                              label: 'Xác nhận mật khẩu',
                              hint: 'Nhập lại mật khẩu',
                              controller: _confirmController,
                              obscureText: _obscureConfirm,
                              validator: (val) =>
                                  Validators.validateConfirmPassword(
                                val,
                                _passwordController.text,
                              ),
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _handleRegister(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirm
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 19,
                                  color: colors.textSecondary,
                                ),
                                onPressed: () {
                                  setState(() =>
                                      _obscureConfirm = !_obscureConfirm);
                                },
                              ),
                            ),

                            // Banner lỗi
                            if (auth.errorMessage != null) ...[
                              const SizedBox(height: 14),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 11),
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

                            // Nút Tạo tài khoản
                            AppButton(
                              label: 'Tạo tài khoản',
                              isLoading: auth.isLoading,
                              onPressed: _handleRegister,
                            ),
                            const SizedBox(height: 20),

                            // Chuyển sang Đăng nhập
                            AppLinkButton(
                              text: 'Đã có tài khoản?',
                              linkText: 'Đăng nhập',
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),

                            const Spacer(),

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
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
