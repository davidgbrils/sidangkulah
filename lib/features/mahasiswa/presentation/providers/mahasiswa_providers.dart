import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sidangkufix/core/providers/firebase_providers.dart';
import 'package:sidangkufix/features/mahasiswa/data/repositories/firebase_mahasiswa_repository.dart';
import 'package:sidangkufix/features/mahasiswa/domain/repositories/mahasiswa_repository.dart';
import 'package:sidangkufix/features/mahasiswa/domain/models/sidang_model.dart';
import 'package:sidangkufix/features/auth/presentation/providers/auth_provider.dart';

/// Provider untuk MahasiswaRepository
final mahasiswaRepositoryProvider = Provider<MahasiswaRepository>((ref) {
  return FirebaseMahasiswaRepository(ref.watch(firestoreProvider));
});

/// Provider untuk Stream data sidang mahasiswa yang sedang login
final currentMahasiswaSidangProvider = StreamProvider<List<SidangModel>>((ref) {
  final authState = ref.watch(authProvider);
  final user = authState.user;
  
  if (user == null) {
    return Stream.value([]);
  }
  
  return ref.watch(mahasiswaRepositoryProvider).getSidangByMahasiswa(user.id);
});
