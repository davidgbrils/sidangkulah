import 'package:sidangkufix/features/auth/domain/user_model.dart';

abstract class AuthRepository {
  Future<UserModel?> login(String email, String password);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> get onAuthStateChanged;
}
