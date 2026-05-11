import 'package:cloud_firestore/cloud_firestore.dart';

enum SidangStatus { 
  menunggu, 
  terjadwal, 
  selesai, 
  revisi, 
  ditolak 
}

class SidangModel {
  final String id;
  final String mahasiswaId;
  final String namaMahasiswa;
  final String judul;
  final SidangStatus status;
  final DateTime? tanggal;
  final String? waktu;
  final String? ruangan;
  final String? pembimbing1;
  final String? pembimbing2;
  final String? penguji1;
  final String? penguji2;
  final String? penguji3;
  final double? nilai;

  SidangModel({
    required this.id,
    required this.mahasiswaId,
    required this.namaMahasiswa,
    required this.judul,
    required this.status,
    this.tanggal,
    this.waktu,
    this.ruangan,
    this.pembimbing1,
    this.pembimbing2,
    this.penguji1,
    this.penguji2,
    this.penguji3,
    this.nilai,
  });

  factory SidangModel.fromFirestore(Map<String, dynamic> json, String id) {
    return SidangModel(
      id: id,
      mahasiswaId: json['mahasiswaId'] ?? '',
      namaMahasiswa: json['namaMahasiswa'] ?? '',
      judul: json['judul'] ?? '',
      status: SidangStatus.values.firstWhere(
        (e) => e.name.toUpperCase() == (json['status'] as String? ?? 'MENUNGGU').toUpperCase(),
        orElse: () => SidangStatus.menunggu,
      ),
      tanggal: (json['tanggal'] as Timestamp?)?.toDate(),
      waktu: json['waktu'],
      ruangan: json['ruangan'],
      pembimbing1: json['pembimbing1'],
      pembimbing2: json['pembimbing2'],
      penguji1: json['penguji1'],
      penguji2: json['penguji2'],
      penguji3: json['penguji3'],
      nilai: (json['nilai'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'mahasiswaId': mahasiswaId,
      'namaMahasiswa': namaMahasiswa,
      'judul': judul,
      'status': status.name.toUpperCase(),
      'tanggal': tanggal != null ? Timestamp.fromDate(tanggal!) : null,
      'waktu': waktu,
      'ruangan': ruangan,
      'pembimbing1': pembimbing1,
      'pembimbing2': pembimbing2,
      'penguji1': penguji1,
      'penguji2': penguji2,
      'penguji3': penguji3,
      'nilai': nilai,
    };
  }
}
