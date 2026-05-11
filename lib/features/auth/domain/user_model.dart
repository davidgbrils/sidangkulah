import 'package:flutter/material.dart';

enum UserRole { mahasiswa, dosen, operator, kaprodi }

class UserModel {
  final String id;
  final String email;
  final String nama;
  final UserRole role;
  final String? nim;
  final String? nidn;
  final String? prodi;
  final String? fotoUrl;

  const UserModel({
    required this.id,
    required this.email,
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

  /// Nama role sebagai string (delegasi ke enum name)
  String get roleString => role.name;

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
