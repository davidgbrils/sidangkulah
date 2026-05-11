import 'package:flutter_test/flutter_test.dart';
import 'package:sidangkufix/features/auth/domain/user_model.dart';

void main() {
  group('Authentication Domain Tests', () {
    test('should return correct role string', () {
      const user = UserModel(
        id: '1',
        email: 'test@test.com',
        nama: 'Test',
        role: UserRole.kaprodi,
      );
      expect(user.roleString, 'kaprodi');
    });

    test('UserModel conversion toFirestore', () {
      const user = UserModel(
        id: '1',
        email: 'test@test.com',
        nama: 'Test',
        role: UserRole.mahasiswa,
        nim: '12345',
      );
      final map = user.toFirestore();
      expect(map['email'], 'test@test.com');
      expect(map['role'], 'mahasiswa');
      expect(map['nim'], '12345');
    });
  });
}
