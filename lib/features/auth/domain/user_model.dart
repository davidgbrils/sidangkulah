import 'package:flutter/material.dart';

enum UserRole { mahasiswa, dosen, operator, kaprodi }

class UserModel {
  final String id;
  final String email;
  final String password;
  final String nama;
  final UserRole role;
  final String? nim;
  final String? nidn;
  final String? prodi;
  final String? fotoUrl;

  const UserModel({
    required this.id,
    required this.email,
    required this.password,
    required this.nama,
    required this.role,
    this.nim,
    this.nidn,
    this.prodi,
    this.fotoUrl,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? password,
    String? nama,
    UserRole? role,
    String? nim,
    String? nidn,
    String? prodi,
    String? fotoUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      nama: nama ?? this.nama,
      role: role ?? this.role,
      nim: nim ?? this.nim,
      nidn: nidn ?? this.nidn,
      prodi: prodi ?? this.prodi,
      fotoUrl: fotoUrl ?? this.fotoUrl,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'nama': nama,
      'role': role.name,
      'nim': nim,
      'nidn': nidn,
      'prodi': prodi,
      'fotoUrl': fotoUrl,
    };
  }

  factory UserModel.fromFirestore(Map<String, dynamic> json, String id) {
    return UserModel(
      id: id,
      email: json['email'] ?? '',
      password: '', // Password tidak disimpan di Firestore untuk alasan keamanan
      nama: json['nama'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => UserRole.mahasiswa,
      ),
      nim: json['nim'],
      nidn: json['nidn'],
      prodi: json['prodi'],
      fotoUrl: json['fotoUrl'],
    );
  }

  String get roleString {
    switch (role) {
      case UserRole.mahasiswa:
        return 'mahasiswa';
      case UserRole.dosen:
        return 'dosen';
      case UserRole.operator:
        return 'operator';
      case UserRole.kaprodi:
        return 'kaprodi';
    }
  }

  IconData get roleIcon {
    switch (role) {
      case UserRole.mahasiswa:
        return Icons.school_rounded;
      case UserRole.dosen:
        return Icons.badge_rounded;
      case UserRole.operator:
        return Icons.admin_panel_settings_rounded;
      case UserRole.kaprodi:
        return Icons.supervisor_account_rounded;
    }
  }
}

class SeedUsers {
  SeedUsers._();

  static const List<UserModel> all = [
    // ADMIN/OPERATOR
    UserModel(
      id: 'op001',
      email: 'admin@itpln.ac.id',
      password: 'admin123',
      nama: 'AhmadAdmin',
      role: UserRole.operator,
      prodi: 'Teknik Informatika',
    ),
    UserModel(
      id: 'op002',
      email: 'operator@itpln.ac.id',
      password: 'operator123',
      nama: 'Siti Operator',
      role: UserRole.operator,
      prodi: 'Teknik Informatika',
    ),

    // DOSEN
    UserModel(
      id: 'ds001',
      email: 'heru@itpln.ac.id',
      password: 'dosen123',
      nama: 'Dr. Ir. Heru Setiawan, M.T.',
      role: UserRole.dosen,
      nidn: '197001011995031001',
      prodi: 'Teknik Informatika',
    ),
    UserModel(
      id: 'ds002',
      email: 'siti@itpln.ac.id',
      password: 'dosen123',
      nama: 'Dr. Siti Aminah, M.Kom.',
      role: UserRole.dosen,
      nidn: '197002021996032002',
      prodi: 'Teknik Informatika',
    ),
    UserModel(
      id: 'ds003',
      email: 'ahmaddosen@itpln.ac.id',
      password: 'dosen123',
      nama: 'Dr. Ahmad Fauzi, M.T.',
      role: UserRole.dosen,
      nidn: '197003031997043003',
      prodi: 'Teknik Informatika',
    ),
    UserModel(
      id: 'ds004',
      email: 'irfan@itpln.ac.id',
      password: 'dosen123',
      nama: 'Irfan Hakim, M.Kom.',
      role: UserRole.dosen,
      nidn: '197004041998054004',
      prodi: 'Teknik Informatika',
    ),

    // KAPRODI
    UserModel(
      id: 'kp001',
      email: 'kaprodi@itpln.ac.id',
      password: 'kaprodi123',
      nama: 'Prof. Dr. Academic Leader',
      role: UserRole.kaprodi,
      nidn: '196001011980011001',
      prodi: 'Teknik Informatika',
    ),

    // MAHASISWA
    UserModel(
      id: 'mhs001',
      email: '202011001@student.itpln.ac.id',
      password: 'mahasiswa123',
      nama: 'Budi Santoso',
      role: UserRole.mahasiswa,
      nim: '202011001',
      prodi: 'Teknik Informatika',
    ),
    UserModel(
      id: 'mhs002',
      email: '202011002@student.itpln.ac.id',
      password: 'mahasiswa123',
      nama: 'Anisa Maharani',
      role: UserRole.mahasiswa,
      nim: '202011002',
      prodi: 'Teknik Informatika',
    ),
    UserModel(
      id: 'mhs003',
      email: '202011003@student.itpln.ac.id',
      password: 'mahasiswa123',
      nama: 'Dian Permana',
      role: UserRole.mahasiswa,
      nim: '202011003',
      prodi: 'Teknik Informatika',
    ),
    UserModel(
      id: 'mhs004',
      email: '202011004@student.itpln.ac.id',
      password: 'mahasiswa123',
      nama: 'Irfan Hakim',
      role: UserRole.mahasiswa,
      nim: '202011004',
      prodi: 'Teknik Informatika',
    ),
    UserModel(
      id: 'mhs005',
      email: '202011005@student.itpln.ac.id',
      password: 'mahasiswa123',
      nama: 'Lisa Permata',
      role: UserRole.mahasiswa,
      nim: '202011005',
      prodi: 'Teknik Informatika',
    ),
  ];

  static UserModel? authenticate(String email, String password) {
    try {
      return all.firstWhere(
        (user) =>
            user.email.toLowerCase() == email.toLowerCase() &&
            user.password == password,
      );
    } catch (_) {
      return null;
    }
  }

  static List<UserModel> getByRole(UserRole role) {
    return all.where((user) => user.role == role).toList();
  }

  static List<UserModel> getMahasiswa() => getByRole(UserRole.mahasiswa);
  static List<UserModel> getDosen() => getByRole(UserRole.dosen);
  static List<UserModel> getOperator() => getByRole(UserRole.operator);
  static List<UserModel> getKaprodi() => getByRole(UserRole.kaprodi);
}
