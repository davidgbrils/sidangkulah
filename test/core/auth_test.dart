import 'package:flutter_test/flutter_test.dart';
import 'package:sidangkufix/features/auth/domain/user_model.dart';

void main() {
  group('SeedUsers Authentication Tests', () {
    test('should return a user when valid credentials are provided', () {
      // Test with student credentials
      final user = SeedUsers.authenticate('202011001@student.itpln.ac.id', 'mahasiswa123');
      expect(user, isNotNull);
      expect(user!.nama, 'Budi Santoso');
      expect(user.role, UserRole.mahasiswa);

      // Test with admin credentials
      final admin = SeedUsers.authenticate('admin@itpln.ac.id', 'admin123');
      expect(admin, isNotNull);
      expect(admin!.role, UserRole.operator);
    });

    test('should return null when invalid email is provided', () {
      final user = SeedUsers.authenticate('wrong@itpln.ac.id', 'admin123');
      expect(user, isNull);
    });

    test('should return null when invalid password is provided', () {
      final user = SeedUsers.authenticate('admin@itpln.ac.id', 'wrongpassword');
      expect(user, isNull);
    });

    test('should be case-insensitive for email', () {
      final user = SeedUsers.authenticate('ADMIN@ITPLN.AC.ID', 'admin123');
      expect(user, isNotNull);
      expect(user!.id, 'op001');
    });

    test('should return correct role string', () {
      const user = UserModel(
        id: '1',
        email: 'test@test.com',
        password: '123',
        nama: 'Test',
        role: UserRole.kaprodi,
      );
      expect(user.roleString, 'kaprodi');
    });
  });
}
