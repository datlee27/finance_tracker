import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';
import '../../../core/errors/app_exception.dart';
import '../models/app_user.dart';

/// Data Source tương tác trực tiếp với Firebase Authentication SDK
class FirebaseAuthDataSource {
  final fb.FirebaseAuth _firebaseAuth;
  final GoogleSignIn? _googleSignIn;

  FirebaseAuthDataSource({
    fb.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? fb.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? (kIsWeb ? null : GoogleSignIn());

  /// Stream theo dõi thay đổi trạng thái đăng nhập
  Stream<AppUser?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map(
          (user) => user != null ? AppUser.fromFirebaseUser(user) : null,
        );
  }

  /// Người dùng đang đăng nhập (nếu có)
  AppUser? get currentUser {
    final user = _firebaseAuth.currentUser;
    return user != null ? AppUser.fromFirebaseUser(user) : null;
  }

  /// Đăng nhập bằng Email và Password
  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const AppException('Đăng nhập thất bại. Vui lòng thử lại.');
      }
      return AppUser.fromFirebaseUser(user);
    } on fb.FirebaseAuthException catch (e) {
      throw AppException.fromFirebaseAuthCode(e.code);
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException('Đã xảy ra lỗi khi đăng nhập: $e');
    }
  }

  /// Đăng ký tài khoản mới bằng Email và Password
  Future<AppUser> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const AppException('Đăng ký thất bại. Vui lòng thử lại.');
      }

      if (displayName != null && displayName.trim().isNotEmpty) {
        await user.updateDisplayName(displayName.trim());
        await user.reload();
      }

      final updatedUser = _firebaseAuth.currentUser ?? user;
      return AppUser.fromFirebaseUser(updatedUser);
    } on fb.FirebaseAuthException catch (e) {
      throw AppException.fromFirebaseAuthCode(e.code);
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException('Đã xảy ra lỗi khi đăng ký: $e');
    }
  }

  /// Đăng nhập ẩn danh (Khách)
  Future<AppUser> signInAnonymously() async {
    try {
      final credential = await _firebaseAuth.signInAnonymously();
      final user = credential.user;
      if (user == null) {
        throw const AppException('Đăng nhập khách thất bại.');
      }
      return AppUser.fromFirebaseUser(user);
    } on fb.FirebaseAuthException catch (e) {
      throw AppException.fromFirebaseAuthCode(e.code);
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException('Đã xảy ra lỗi khi đăng nhập khách: $e');
    }
  }

  /// Đăng nhập bằng tài khoản Google
  Future<AppUser?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        final googleProvider = fb.GoogleAuthProvider();
        try {
          // 1. Thử đăng nhập qua Popup (chuẩn khuyến nghị chính thức từ Firebase cho môi trường localhost)
          final credential =
              await _firebaseAuth.signInWithPopup(googleProvider);
          final user = credential.user;
          if (user != null) {
            return AppUser.fromFirebaseUser(user);
          }
        } on fb.FirebaseAuthException catch (e) {
          // 2. Nếu trình duyệt chặn popup, tự động chuyển hướng (Redirect) mượt mà
          if (e.code == 'popup-blocked' || e.code == 'cancelled-popup-request') {
            await _firebaseAuth.signInWithRedirect(googleProvider);
            return null;
          }
          rethrow;
        }
        return null;
      }

      final GoogleSignInAccount? googleUser = await _googleSignIn?.signIn();
      if (googleUser == null) {
        // Người dùng chủ động hủy hộp thoại đăng nhập Google
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final fb.OAuthCredential credential = fb.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) {
        throw const AppException('Đăng nhập Google thất bại. Vui lòng thử lại.');
      }
      return AppUser.fromFirebaseUser(user);
    } on fb.FirebaseAuthException catch (e) {
      throw AppException.fromFirebaseAuthCode(e.code);
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException('Đã xảy ra lỗi khi đăng nhập bằng Google: $e');
    }
  }

  /// Kiểm tra kết quả trả về sau khi redirect từ Google về lại trang
  Future<AppUser?> getRedirectResult() async {
    try {
      if (kIsWeb) {
        final credential = await _firebaseAuth.getRedirectResult();
        final user = credential.user;
        if (user != null) {
          return AppUser.fromFirebaseUser(user);
        }
      }
      return null;
    } on fb.FirebaseAuthException catch (e) {
      throw AppException.fromFirebaseAuthCode(e.code);
    } catch (e) {
      return null;
    }
  }

  /// Đăng xuất khỏi Firebase Auth và Google Sign-In
  Future<void> signOut() async {
    try {
      if (!kIsWeb) {
        try {
          await _googleSignIn?.signOut();
        } catch (_) {}
      }
      await _firebaseAuth.signOut();
    } catch (e) {
      throw AppException('Đã xảy ra lỗi khi đăng xuất: $e');
    }
  }
}
