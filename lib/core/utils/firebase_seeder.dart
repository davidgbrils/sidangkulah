import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:sidangkufix/features/auth/domain/user_model.dart';

class FirebaseSeeder {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> seedInitialData() async {
    debugPrint('🚀 [SEEDER] Memulai Seeding Data Firebase...');
    int successCount = 0;
    int failCount = 0;

    try {
      for (final user in SeedUsers.all) {
        final success = await _seedUser(user);
        if (success) {
          successCount++;
        } else {
          failCount++;
        }
        // Beri jeda sedikit agar tidak terkena rate limit
        await Future.delayed(const Duration(milliseconds: 500));
      }

      await _seedSidang();

      debugPrint('✅ [SEEDER] Seeding Selesai!');
      debugPrint('📊 [SEEDER] Berhasil: $successCount, Gagal: $failCount');
    } catch (e) {
      debugPrint('❌ [SEEDER] Error Global: $e');
    }
  }

  Future<bool> _seedUser(UserModel user) async {
    try {
      debugPrint('🟡 [SEEDER] Memproses: ${user.email}...');
      
      String? uid;

      try {
        // Coba buat user baru
        final credential = await _auth.createUserWithEmailAndPassword(
          email: user.email,
          password: user.password,
        );
        uid = credential.user?.uid;
        debugPrint('🟢 [SEEDER] Akun BARU dibuat: ${user.email}');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          debugPrint('🔵 [SEEDER] Akun SUDAH ADA: ${user.email}. Mencoba sinkronisasi data...');
          // Jika sudah ada, kita butuh UID-nya. 
          // Karena kita tidak bisa ambil UID tanpa login, kita coba login sementara.
          final loginCred = await _auth.signInWithEmailAndPassword(
            email: user.email,
            password: user.password,
          );
          uid = loginCred.user?.uid;
        } else {
          debugPrint('🔴 [SEEDER] Gagal membuat ${user.email}: ${e.message}');
          return false;
        }
      }

      if (uid != null) {
        // Update/Set data di Firestore
        await _firestore.collection('users').doc(uid).set(user.toFirestore());
        debugPrint('✨ [SEEDER] Firestore Sync Berhasil: ${user.nama}');
        
        // Logout setelah sinkronisasi agar tidak mengganggu state aplikasi
        await _auth.signOut();
        return true;
      }
      
      return false;
    } catch (e) {
      debugPrint('🔴 [SEEDER] Error pada ${user.email}: $e');
      return false;
    }
  }

  Future<void> _seedSidang() async {
    final sidangCollection = _firestore.collection('sidang');
    
    final sampleSidang = [
      {
        'mahasiswaId': 'mhs001',
        'namaMahasiswa': 'Budi Santoso',
        'judul': 'Analisis Jaringan IoT',
        'status': 'TERJADWAL',
        'tanggal': DateTime(2025, 1, 15),
        'waktu': '09:00',
        'ruangan': 'Ruang 1',
        'pembimbing1': 'Dr. Ir. Heru Setiawan, M.T.',
        'pembimbing2': 'Dr. Siti Rahayu, M.Kom.',
      },
      {
        'mahasiswaId': 'mhs002',
        'namaMahasiswa': 'Anisa Maharani',
        'judul': 'Sistem Pakar Diagnosa Penyakit',
        'status': 'MENUNGGU',
        'pembimbing1': 'Dr. Ahmad Fauzi, M.T.',
        'pembimbing2': 'Irfan Hakim, M.Kom.',
      }
    ];

    for (var data in sampleSidang) {
      await sidangCollection.add(data);
    }
    debugPrint('Berhasil seeding data sidang.');
  }
}
