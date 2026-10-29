// Các hàm validation dùng chung
class Validators {
  Validators._();

  /// Kiểm tra email hợp lệ
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email không được để trống';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  /// Kiểm tra mật khẩu tối thiểu 6 ký tự
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mật khẩu không được để trống';
    }
    if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }
    return null;
  }

  /// Kiểm tra xác nhận mật khẩu khớp
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng xác nhận mật khẩu';
    }
    if (value != password) {
      return 'Mật khẩu không khớp';
    }
    return null;
  }

  /// Kiểm tra số tiền > 0
  static String? validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Số tiền không được để trống';
    }
    final cleaned = value.replaceAll(',', '.').trim();
    final amount = double.tryParse(cleaned);
    if (amount == null) {
      return 'Số tiền không hợp lệ';
    }
    if (amount <= 0) {
      return 'Số tiền phải lớn hơn 0';
    }
    return null;
  }

  /// Kiểm tra danh mục bắt buộc
  static String? validateCategory(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng chọn danh mục';
    }
    return null;
  }

  /// Kiểm tra ngày bắt buộc
  static String? validateDate(DateTime? value) {
    if (value == null) {
      return 'Vui lòng chọn ngày';
    }
    return null;
  }

  /// Kiểm tra trường không được rỗng (generic)
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName không được để trống';
    }
    return null;
  }
}
