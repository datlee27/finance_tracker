import 'package:firebase_auth/firebase_auth.dart' as fb;

/// Model người dùng ứng dụng
class AppUser {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;

  const AppUser({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  /// Tạo AppUser từ Firebase User
  factory AppUser.fromFirebaseUser(fb.User user) {
    return AppUser(
      uid: user.uid,
      email: user.email ?? (user.isAnonymous ? 'guest@penny.app' : ''),
      displayName: user.displayName ?? (user.isAnonymous ? 'Khách trải nghiệm' : null),
      photoUrl: user.photoURL,
    );
  }

  /// Tài khoản khách dùng thử
  factory AppUser.guest() {
    return const AppUser(
      uid: 'guest_user_preview',
      email: 'guest@penny.app',
      displayName: 'Khách',
    );
  }

  /// Lấy 1-2 ký tự viết tắt làm avatar (VD: Minh Anh -> MA, test@gmail.com -> T)
  String get initials {
    if (displayName != null && displayName!.trim().isNotEmpty) {
      final parts = displayName!.trim().split(RegExp(r'\s+'));
      if (parts.length >= 2) {
        return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
      }
      return parts.first[0].toUpperCase();
    }
    if (email.isNotEmpty) {
      return email[0].toUpperCase();
    }
    return 'U';
  }

  /// Tên hiển thị ưu tiên displayName hoặc phần username trước @ của email
  String get nameDisplay {
    if (displayName != null && displayName!.trim().isNotEmpty) {
      return displayName!;
    }
    if (email.contains('@')) {
      return email.split('@').first;
    }
    return email.isNotEmpty ? email : 'Người dùng';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppUser && runtimeType == other.runtimeType && uid == other.uid;

  @override
  int get hashCode => uid.hashCode;
}
