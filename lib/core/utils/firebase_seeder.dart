import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Data seed untuk development/demo.
/// PENTING: Class ini HANYA boleh digunakan dalam mode debug.
/// Jangan pernah memanggil class ini di production build.
class FirebaseSeeder {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  FirebaseSeeder({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  /// Data seed user untuk development.
  /// Email dan password hanya digunakan untuk Firebase Auth saat seeding.
  static const List<Map<String, dynamic>> _seedAccounts = [
    // OPERATOR
    {
      'email': 'admin@itpln.ac.id',
      'password': 'admin123',
      'nama': 'AhmadAdmin',
      'role': 'operator',
      'prodi': 'Teknik Informatika',
    },
    {
      'email': 'operator@itpln.ac.id',
      'password': 'operator123',
      'nama': 'Siti Operator',
      'role': 'operator',
      'prodi': 'Teknik Informatika',
    },
    // DOSEN
    {
      'email': 'heru@itpln.ac.id',
      'password': 'dosen123',
      'nama': 'Dr. Ir. Heru Setiawan, M.T.',
      'role': 'dosen',
      'nidn': '197001011995031001',
      'prodi': 'Teknik Informatika',
    },
    {
      'email': 'siti@itpln.ac.id',
      'password': 'dosen123',
      'nama': 'Dr. Siti Aminah, M.Kom.',
      'role': 'dosen',
      'nidn': '197002021996032002',
      'prodi': 'Teknik Informatika',
    },
    {
      'email': 'ahmaddosen@itpln.ac.id',
      'password': 'dosen123',
      'nama': 'Dr. Ahmad Fauzi, M.T.',
      'role': 'dosen',
      'nidn': '197003031997043003',
      'prodi': 'Teknik Informatika',
    },
    {
      'email': 'irfan@itpln.ac.id',
      'password': 'dosen123',
      'nama': 'Irfan Hakim, M.Kom.',
      'role': 'dosen',
      'nidn': '197004041998054004',
      'prodi': 'Teknik Informatika',
    },
    // KAPRODI
    {
      'email': 'kaprodi@itpln.ac.id',
      'password': 'kaprodi123',
      'nama': 'Prof. Dr. Academic Leader',
      'role': 'kaprodi',
      'nidn': '196001011980011001',
      'prodi': 'Teknik Informatika',
    },
    // MAHASISWA
    {
      'email': '202011001@student.itpln.ac.id',
      'password': 'mahasiswa123',
      'nama': 'Budi Santoso',
      'role': 'mahasiswa',
      'nim': '202011001',
      'prodi': 'Teknik Informatika',
    },
    {
      'email': '202011002@student.itpln.ac.id',
      'password': 'mahasiswa123',
      'nama': 'Anisa Maharani',
      'role': 'mahasiswa',
      'nim': '202011002',
      'prodi': 'Teknik Informatika',
    },
    {
      'email': '202011003@student.itpln.ac.id',
      'password': 'mahasiswa123',
      'nama': 'Dian Permana',
      'role': 'mahasiswa',
      'nim': '202011003',
      'prodi': 'Teknik Informatika',
    },
    {
      'email': '202011004@student.itpln.ac.id',
      'password': 'mahasiswa123',
      'nama': 'Irfan Hakim',
      'role': 'mahasiswa',
      'nim': '202011004',
      'prodi': 'Teknik Informatika',
    },
    {
      'email': '202011005@student.itpln.ac.id',
      'password': 'mahasiswa123',
      'nama': 'Lisa Permata',
      'role': 'mahasiswa',
      'nim': '202011005',
      'prodi': 'Teknik Informatika',
    },
  ];

  /// Jalankan seeding data. Hanya berjalan di mode debug.
  Future<void> seedInitialData() async {
    if (!kDebugMode) {
      debugPrint('⛔ [SEEDER] Seeder hanya dapat dijalankan di mode debug.');
      return;
    }

    debugPrint('🚀 [SEEDER] Memulai Seeding Data Firebase...');
    int successCount = 0;
    int failCount = 0;

    try {
      for (final account in _seedAccounts) {
        final success = await _seedUser(account);
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

  Future<bool> _seedUser(Map<String, dynamic> account) async {
    final email = account['email'] as String;
    final password = account['password'] as String;

    try {
      debugPrint('🟡 [SEEDER] Memproses: $email...');
      
      String? uid;

      try {
        // Coba buat user baru
        final credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        uid = credential.user?.uid;
        debugPrint('🟢 [SEEDER] Akun BARU dibuat: $email');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          debugPrint('🔵 [SEEDER] Akun SUDAH ADA: $email. Mencoba sinkronisasi data...');
          // Jika sudah ada, kita butuh UID-nya. 
          // Karena kita tidak bisa ambil UID tanpa login, kita coba login sementara.
          final loginCred = await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          uid = loginCred.user?.uid;
        } else {
          debugPrint('🔴 [SEEDER] Gagal membuat $email: ${e.message}');
          return false;
        }
      }

      if (uid != null) {
        // Buat data Firestore TANPA password
        final firestoreData = Map<String, dynamic>.from(account)
          ..remove('password');

        // Update/Set data di Firestore
        await _firestore.collection('users').doc(uid).set(firestoreData);
        debugPrint('✨ [SEEDER] Firestore Sync Berhasil: ${account['nama']}');
        
        // Logout setelah sinkronisasi agar tidak mengganggu state aplikasi
        await _auth.signOut();
        return true;
      }
      
      return false;
    } catch (e) {
      debugPrint('🔴 [SEEDER] Error pada $email: $e');
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
