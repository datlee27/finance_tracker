// Lớp ngoại lệ tùy chỉnh của ứng dụng
// Map lỗi Firebase sang thông báo tiếng Việt thân thiện
class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, {this.code});

  /// Tạo AppException từ FirebaseAuthException code
  factory AppException.fromFirebaseAuthCode(String code) {
    switch (code) {
      case 'user-not-found':
        return const AppException(
          'Không tìm thấy tài khoản với email này.',
          code: 'user-not-found',
        );
      case 'wrong-password':
      case 'invalid-credential':
        return const AppException(
          'Email hoặc mật khẩu không đúng.',
          code: 'wrong-password',
        );
      case 'email-already-in-use':
        return const AppException(
          'Email này đã được sử dụng. Vui lòng chọn email khác.',
          code: 'email-already-in-use',
        );
      case 'weak-password':
        return const AppException(
          'Mật khẩu quá yếu. Vui lòng đặt mật khẩu mạnh hơn.',
          code: 'weak-password',
        );
      case 'invalid-email':
        return const AppException(
          'Email không hợp lệ.',
          code: 'invalid-email',
        );
      case 'network-request-failed':
        return const AppException(
          'Không có kết nối mạng. Vui lòng kiểm tra lại.',
          code: 'network-request-failed',
        );
      case 'too-many-requests':
        return const AppException(
          'Quá nhiều yêu cầu. Vui lòng thử lại sau ít phút.',
          code: 'too-many-requests',
        );
      case 'user-disabled':
        return const AppException(
          'Tài khoản này đã bị vô hiệu hóa.',
          code: 'user-disabled',
        );
      case 'operation-not-allowed':
        return const AppException(
          'Phương thức đăng nhập này không được phép.',
          code: 'operation-not-allowed',
        );
      default:
        return AppException(
          'Lỗi xác thực: $code. Vui lòng thử lại.',
          code: code,
        );
    }
  }

  @override
  String toString() => 'AppException($code): $message';
}
