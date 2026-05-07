import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Login gagal: Email atau password salah',
      );
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
