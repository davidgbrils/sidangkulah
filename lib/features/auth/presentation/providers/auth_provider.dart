import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidangkufix/core/providers/firebase_providers.dart';
import 'package:sidangkufix/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:sidangkufix/features/auth/domain/repositories/auth_repository.dart';
import 'package:sidangkufix/features/auth/domain/user_model.dart';

/// Provider untuk AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository(
    ref.watch(firebaseAuthProvider),
    ref.watch(firestoreProvider),
  );
});

/// State untuk AuthNotifier
class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? errorMessage;

  AuthState({this.user, this.isLoading = false, this.errorMessage});

  AuthState copyWith({UserModel? user, bool? isLoading, String? errorMessage}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

/// Notifier untuk mengelola status autentikasi
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthState()) {
    _init();
  }

  void _init() {
    _repository.onAuthStateChanged.listen((user) {
      state = state.copyWith(user: user, isLoading: false);
    });
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _repository.login(email, password);
      if (user == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Akun tidak ditemukan di sistem. Hubungi admin.',
        );
        return;
      }
      
      // Save to SharedPreferences for offline/fast access
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_nama', user.nama);
      await prefs.setString('user_id', user.nim ?? user.id);
      await prefs.setString('user_role', user.role.name);
      
      state = state.copyWith(user: user, isLoading: false);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _mapFirebaseAuthError(e.code),
      );
    } on FirebaseException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Terjadi kesalahan server: ${e.message}',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Login gagal. Periksa koneksi internet Anda.',
      );
    }
  }

  /// Mapping Firebase Auth error codes ke pesan user-friendly
  String _mapFirebaseAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Akun dengan email tersebut tidak ditemukan.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Password yang Anda masukkan salah.';
      case 'user-disabled':
        return 'Akun Anda telah dinonaktifkan. Hubungi admin.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan login. Coba lagi nanti.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'network-request-failed':
        return 'Tidak dapat terhubung. Periksa koneksi internet Anda.';
      case 'operation-not-allowed':
        return 'Metode login ini tidak diaktifkan. Hubungi admin.';
      default:
        return 'Login gagal. Silakan coba lagi.';
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = AuthState();
  }
}

/// Provider untuk AuthNotifier
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

