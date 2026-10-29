import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/errors/app_exception.dart';
import '../data/auth_repository.dart';
import '../models/app_user.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

/// Provider quản lý trạng thái xác thực và phiên đăng nhập của người dùng
class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  StreamSubscription<AppUser?>? _authSubscription;

  AppUser? _currentUser;
  AuthStatus _status = AuthStatus.initial;
  String? _errorMessage;
  bool _isInitialized = false;

  AuthProvider({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository() {
    _initAuthStateListener();
  }

  // Getters
  AppUser? get currentUser => _currentUser;
  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _status == AuthStatus.loading;
  bool get isInitialized => _isInitialized;

  /// Kiểm tra có đang ở Chế độ Khách (lưu trữ theo máy, không đồng bộ cloud) hay không
  bool get isGuest =>
      _currentUser == null ||
      _currentUser!.uid.startsWith('guest_') ||
      _currentUser!.email == 'guest@penny.app';

  /// Lắng nghe stream authStateChanges từ Firebase Auth và kết quả redirect
  void _initAuthStateListener() {
    try {
      // 1. Kiểm tra kết quả redirect Google trên Web nếu vừa quay lại từ trang đăng nhập
      _checkRedirectResult();

      // 2. Lắng nghe stream authStateChanges
      _authSubscription = _authRepository.authStateChanges.listen(
        (user) {
          _currentUser = user;
          _status = user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
          _isInitialized = true;
          _errorMessage = null;
          notifyListeners();
        },
        onError: (error) {
          _errorMessage = error.toString();
          _status = AuthStatus.unauthenticated;
          _isInitialized = true;
          notifyListeners();
        },
      );
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _isInitialized = true;
      notifyListeners();
    }
  }

  /// Thu hồi kết quả redirect từ Google nếu trình duyệt vừa quay về
  Future<void> _checkRedirectResult() async {
    try {
      final user = await _authRepository.getRedirectResult();
      if (user != null) {
        _currentUser = user;
        _status = AuthStatus.authenticated;
        _isInitialized = true;
        _errorMessage = null;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Redirect result check error: $e');
    }
  }

  /// Đăng nhập bằng Email và Password
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final user = await _authRepository.login(
        email: email,
        password: password,
      );
      _currentUser = user;
      _status = AuthStatus.authenticated;
      _setLoading(false);
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _status = AuthStatus.error;
      _setLoading(false);
      return false;
    } catch (e) {
      _errorMessage = 'Đã xảy ra lỗi không xác định. Vui lòng thử lại.';
      _status = AuthStatus.error;
      _setLoading(false);
      return false;
    }
  }

  /// Đăng ký tài khoản mới bằng Email và Password
  Future<bool> register({
    required String email,
    required String password,
    String? displayName,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final user = await _authRepository.register(
        email: email,
        password: password,
        displayName: displayName,
      );
      _currentUser = user;
      _status = AuthStatus.authenticated;
      _setLoading(false);
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _status = AuthStatus.error;
      _setLoading(false);
      return false;
    } catch (e) {
      _errorMessage = 'Đã xảy ra lỗi không xác định. Vui lòng thử lại.';
      _status = AuthStatus.error;
      _setLoading(false);
      return false;
    }
  }

  /// Đăng nhập với tư cách Khách (dùng thử lưu trữ trên thiết bị, không cần tài khoản)
  Future<bool> loginAsGuest() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _currentUser = AppUser.guest();
      _status = AuthStatus.authenticated;
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _currentUser = AppUser.guest();
      _status = AuthStatus.authenticated;
      _setLoading(false);
      notifyListeners();
      return true;
    }
  }

  /// Đăng nhập bằng tài khoản Google
  Future<bool> loginWithGoogle() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final user = await _authRepository.signInWithGoogle();
      if (user == null) {
        // Người dùng hủy chọn tài khoản Google
        _setLoading(false);
        return false;
      }
      _currentUser = user;
      _status = AuthStatus.authenticated;
      _setLoading(false);
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _status = AuthStatus.error;
      _setLoading(false);
      return false;
    } catch (e) {
      _errorMessage = 'Đã xảy ra lỗi khi đăng nhập bằng Google: $e';
      _status = AuthStatus.error;
      _setLoading(false);
      return false;
    }
  }

  /// Đăng xuất khỏi hệ thống
  Future<void> logout() async {
    _setLoading(true);
    try {
      await _authRepository.logout();
      _currentUser = null;
      _status = AuthStatus.unauthenticated;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Lỗi khi đăng xuất: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// Xóa thông báo lỗi
  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  void _setLoading(bool loading) {
    if (loading) {
      _status = AuthStatus.loading;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
