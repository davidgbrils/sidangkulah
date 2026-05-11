import 'package:sidangkufix/features/mahasiswa/domain/models/sidang_model.dart';

abstract class MahasiswaRepository {
  /// Mendapatkan data sidang berdasarkan ID mahasiswa
  Stream<List<SidangModel>> getSidangByMahasiswa(String mahasiswaId);
  
  /// Mengajukan pendaftaran sidang
  Future<void> daftarSidang(SidangModel sidang);
  
  /// Update data sidang (misal: ganti judul sebelum disetujui)
  Future<void> updateSidang(SidangModel sidang);
}
