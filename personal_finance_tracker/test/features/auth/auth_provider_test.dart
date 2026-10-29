import 'package:flutter_test/flutter_test.dart';
import 'package:personal_finance_tracker/features/auth/models/app_user.dart';

void main() {
  group('AppUser Unit Tests', () {
    test('AppUser.guest tạo tài khoản khách đúng định dạng', () {
      final guest = AppUser.guest();
      expect(guest.uid, 'guest_user_preview');
      expect(guest.email, 'guest@penny.app');
      expect(guest.displayName, 'Khách');
      expect(guest.nameDisplay, 'Khách');
      expect(guest.initials, 'K');
    });

    test('Lấy initials từ họ và tên đầy đủ', () {
      const user = AppUser(
        uid: '123',
        email: 'minhanh@example.com',
        displayName: 'Minh Anh',
      );
      expect(user.initials, 'MA');
      expect(user.nameDisplay, 'Minh Anh');
    });

    test('Lấy initials và nameDisplay từ email khi không có displayName', () {
      const user = AppUser(
        uid: '124',
        email: 'hoangnam@gmail.com',
      );
      expect(user.initials, 'H');
      expect(user.nameDisplay, 'hoangnam');
    });
  });
}
