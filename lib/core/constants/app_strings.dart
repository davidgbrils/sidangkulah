/// Konstanta string UI dalam Bahasa Indonesia
class AppStrings {
  AppStrings._();

  // ── App ───────────────────────────────────────────────────────────────
  static const String appName = 'SidangKu';
  static const String appTagline = 'Sistem Manajemen Sidang Skripsi';
  static const String university = 'Institut Teknologi PLN';
  static const String universityShort = 'ITPLN';

  // ── Auth ──────────────────────────────────────────────────────────────
  static const String login = 'Masuk';
  static const String logout = 'Keluar';
  static const String email = 'Email';
  static const String password = 'Kata Sandi';
  static const String forgotPassword = 'Lupa Kata Sandi?';
  static const String loginSubtitle = 'Masuk ke akun SidangKu Anda';
  static const String emailHint = 'Masukkan email Anda';
  static const String passwordHint = 'Masukkan kata sandi Anda';
  static const String rememberMe = 'Ingat saya';

  // ── Navigation ────────────────────────────────────────────────────────
  static const String beranda = 'Beranda';
  static const String jadwal = 'Jadwal';
  static const String dokumen = 'Dokumen';
  static const String profil = 'Profil';
  static const String notifikasi = 'Notifikasi';
  static const String pengaturan = 'Pengaturan';

  // ── Mahasiswa ─────────────────────────────────────────────────────────
  static const String pendaftaranSidang = 'Pendaftaran Sidang';
  static const String statusBerkas = 'Status Berkas';
  static const String jadwalSidang = 'Jadwal Sidang';
  static const String hasilSidang = 'Hasil Sidang';
  static const String uploadBerkas = 'Upload Berkas';
  static const String dataDiri = 'Data Diri';
  static const String konfirmasi = 'Konfirmasi';
  static const String detailJadwal = 'Detail Jadwal Sidang';
  static const String riwayatSidang = 'Riwayat Sidang';

  // ── Dosen ─────────────────────────────────────────────────────────────
  static const String daftarMahasiswa = 'Daftar Mahasiswa';
  static const String detailMahasiswa = 'Detail Mahasiswa';
  static const String inputNilai = 'Input Nilai';
  static const String formulirRevisi = 'Formulir Revisi';
  static const String formulirKehadiran = 'Formulir Kehadiran';
  static const String tandaTanganDokumen = 'Tanda Tangan Dokumen';
  static const String pengajuanGantiPenguji = 'Pengajuan Ganti Penguji';

  // ── Operator ──────────────────────────────────────────────────────────
  static const String kelolaDataMahasiswa = 'Kelola Data Mahasiswa';
  static const String dataDosen = 'Data Dosen';
  static const String inputJadwalSidang = 'Input Jadwal Sidang';
  static const String importExcel = 'Import Excel';
  static const String approvalGantiPenguji = 'Approval Ganti Penguji';
  static const String dokumenRekapHonor = 'Dokumen Rekap Honor';

  // ── Kaprodi ───────────────────────────────────────────────────────────
  static const String dashboard = 'Dashboard';
  static const String approvalPenguji = 'Approval Penguji';
  static const String jadwalSidangFinal = 'Jadwal Sidang Final';
  static const String rekapNilaiSidang = 'Rekap Nilai Sidang';
  static const String rekapHonorDosen = 'Rekap Honor Dosen';

  // ── Status ────────────────────────────────────────────────────────────
  static const String scheduled = 'Terjadwal';
  static const String done = 'Selesai';
  static const String revision = 'Revisi';
  static const String pending = 'Menunggu';
  static const String approved = 'Disetujui';
  static const String rejected = 'Ditolak';

  // ── Actions ───────────────────────────────────────────────────────────
  static const String simpan = 'Simpan';
  static const String batal = 'Batal';
  static const String kirim = 'Kirim';
  static const String hapus = 'Hapus';
  static const String edit = 'Edit';
  static const String lihatSemua = 'Lihat Semua';
  static const String unduh = 'Unduh';
  static const String bagikan = 'Bagikan';
  static const String upload = 'Upload';
  static const String cari = 'Cari';
  static const String filter = 'Filter';
  static const String ulangi = 'Ulangi';

  // ── Empty States ──────────────────────────────────────────────────────
  static const String belumAdaData = 'Belum Ada Data';
  static const String belumAdaNotifikasi = 'Belum Ada Notifikasi';
  static const String belumAdaJadwal = 'Belum Ada Jadwal';
  static const String belumAdaDokumen = 'Belum Ada Dokumen';
  static const String dataTidakDitemukan = 'Data Tidak Ditemukan';

  // ── Messages ──────────────────────────────────────────────────────────
  static const String berhasilDisimpan = 'Data berhasil disimpan';
  static const String berhasilDikirim = 'Data berhasil dikirim';
  static const String berhasilDihapus = 'Data berhasil dihapus';
  static const String gagalMemuatData = 'Gagal memuat data';
  static const String tidakAdaKoneksi = 'Tidak ada koneksi internet';
  static const String sessionExpired = 'Sesi Anda telah berakhir, silakan masuk kembali';
  static const String konfirmasiLogout = 'Apakah Anda yakin ingin keluar?';

  // ── Validation ────────────────────────────────────────────────────────
  static const String fieldWajibDiisi = 'Field ini wajib diisi';
  static const String emailTidakValid = 'Format email tidak valid';
  static const String passwordMinimal = 'Kata sandi minimal 8 karakter';
  static const String formatTidakValid = 'Format tidak valid';
}
