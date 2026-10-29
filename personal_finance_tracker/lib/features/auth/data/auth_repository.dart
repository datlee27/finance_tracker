import '../models/app_user.dart';
import 'firebase_auth_data_source.dart';

/// Repository trung gian giữa Provider và FirebaseAuthDataSource
class AuthRepository {
  final FirebaseAuthDataSource _dataSource;

  AuthRepository({FirebaseAuthDataSource? dataSource})
      : _dataSource = dataSource ?? FirebaseAuthDataSource();

  /// Stream lắng nghe phiên đăng nhập từ Firebase
  Stream<AppUser?> get authStateChanges => _dataSource.authStateChanges;

  /// Lấy user hiện tại
  AppUser? get currentUser => _dataSource.currentUser;

  /// Đăng nhập
  Future<AppUser> login({
    required String email,
    required String password,
  }) {
    return _dataSource.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Đăng ký
  Future<AppUser> register({
    required String email,
    required String password,
    String? displayName,
  }) {
    return _dataSource.createUserWithEmailAndPassword(
      email: email,
      password: password,
      displayName: displayName,
    );
  }

  /// Đăng nhập Khách (ẩn danh)
  Future<AppUser> signInAnonymously() {
    return _dataSource.signInAnonymously();
  }

  /// Đăng nhập bằng Google
  Future<AppUser?> signInWithGoogle() {
    return _dataSource.signInWithGoogle();
  }

  /// Kiểm tra kết quả trả về sau khi redirect từ Google
  Future<AppUser?> getRedirectResult() {
    return _dataSource.getRedirectResult();
  }

  /// Đăng xuất
  Future<void> logout() {
    return _dataSource.signOut();
  }
}
