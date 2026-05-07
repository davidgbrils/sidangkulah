import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:sidangkufix/features/auth/domain/user_model.dart';

class FirebaseSeeder {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> seedInitialData() async {
    debugPrint('🚀 Memulai Seeding Data Firebase...');

    try {
      // 1. Seed Users (Auth & Firestore)
      for (final user in SeedUsers.all) {
        await _seedUser(user);
      }

      // 2. Seed Sidang Data (Contoh)
      await _seedSidang();

      debugPrint('✅ Seeding Selesai!');
    } catch (e) {
      debugPrint('❌ Seeding Gagal: $e');
    }
  }

  Future<void> _seedUser(UserModel user) async {
    try {
      debugPrint('Mencoba membuat user: ${user.email}');
      
      // Buat User di Firebase Auth
      UserCredential credential;
      try {
        credential = await _auth.createUserWithEmailAndPassword(
          email: user.email,
          password: user.password,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          debugPrint('User ${user.email} sudah ada di Auth.');
          // Jika sudah ada, kita coba login untuk dapat UID nya
          credential = await _auth.signInWithEmailAndPassword(
            email: user.email,
            password: user.password,
          );
        } else {
          rethrow;
        }
      }

      final uid = credential.user!.uid;

      // Buat Document di Firestore
      await _firestore.collection('users').doc(uid).set(user.toFirestore());
      debugPrint('Berhasil seeding user: ${user.nama} (ID: $uid)');
    } catch (e) {
      debugPrint('Error seeding user ${user.email}: $e');
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
