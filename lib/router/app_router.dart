import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sidangkufix/features/auth/presentation/screens/splash_screen.dart';
import 'package:sidangkufix/features/auth/presentation/screens/login_screen.dart';
import 'package:sidangkufix/features/mahasiswa/presentation/screens/mahasiswa_home_screen.dart';
import 'package:sidangkufix/features/mahasiswa/presentation/screens/daftar_sidang_screen.dart';
import 'package:sidangkufix/features/mahasiswa/presentation/screens/nilai_screen.dart';
import 'package:sidangkufix/features/shared/presentation/screens/notifikasi_screen.dart';
import 'package:sidangkufix/features/dosen/presentation/screens/dosen_home_screen.dart';
import 'package:sidangkufix/features/dosen/presentation/screens/dosen_mahasiswa_screen.dart';
import 'package:sidangkufix/features/dosen/presentation/screens/dosen_mahasiswa_detail_screen.dart';
import 'package:sidangkufix/features/dosen/presentation/screens/input_nilai_screen.dart';
import 'package:sidangkufix/features/dosen/presentation/screens/ttd_dokumen_screen.dart';
import 'package:sidangkufix/features/dosen/presentation/screens/formulir_absen_screen.dart';
import 'package:sidangkufix/features/dosen/presentation/screens/formulir_revisi_screen.dart';
import 'package:sidangkufix/features/dosen/presentation/screens/ganti_penguji_screen.dart';
import 'package:sidangkufix/features/operator/presentation/screens/operator_home_screen.dart';
import 'package:sidangkufix/features/operator/presentation/screens/kelola_mahasiswa_screen.dart';
import 'package:sidangkufix/features/operator/presentation/screens/approval_penguji_screen.dart';
import 'package:sidangkufix/features/operator/presentation/screens/dokumen_honor_screen.dart';
import 'package:sidangkufix/features/kaprodi/presentation/screens/kaprodi_home_screen.dart';
import 'package:sidangkufix/features/kaprodi/presentation/screens/kaprodi_jadwal_screen.dart';
import 'package:sidangkufix/features/kaprodi/presentation/screens/kaprodi_rekap_nilai_screen.dart';

/// Placeholder page untuk rute yang belum diimplementasikan
class _PlaceholderPage extends StatelessWidget {
  final String title;
  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction_rounded, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Halaman ini sedang dalam pengembangan',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Konfigurasi semua rute aplikasi SidangKu menggunakan GoRouter
class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  // ── Route Names ───────────────────────────────────────────────────────
  static const String splash = 'splash';
  static const String login = 'login';

  // Mahasiswa
  static const String mahasiswaBeranda = 'mahasiswa-beranda';
  static const String mahasiswaJadwal = 'mahasiswa-jadwal';
  static const String mahasiswaDokumen = 'mahasiswa-dokumen';
  static const String mahasiswaProfil = 'mahasiswa-profil';
  static const String pendaftaranSidangDataDiri = 'pendaftaran-sidang-data-diri';
  static const String pendaftaranSidangUpload = 'pendaftaran-sidang-upload';
  static const String pendaftaranSidangKonfirmasi = 'pendaftaran-sidang-konfirmasi';
  static const String statusBerkas = 'status-berkas';
  static const String detailJadwalSidang = 'detail-jadwal-sidang';
  static const String hasilSidang = 'hasil-sidang';
  static const String notifikasi = 'notifikasi';

  // Dosen
  static const String dosenBeranda = 'dosen-beranda';
  static const String daftarMahasiswaSaya = 'daftar-mahasiswa-saya';
  static const String detailMahasiswaDosen = 'detail-mahasiswa-dosen';
  static const String inputNilai = 'input-nilai';
  static const String formulirRevisi = 'formulir-revisi';
  static const String formulirKehadiran = 'formulir-kehadiran';
  static const String tandaTanganDokumen = 'tanda-tangan-dokumen';
  static const String pengajuanGantiPenguji = 'pengajuan-ganti-penguji';
  static const String dosenJadwal = 'dosen-jadwal';
  static const String dosenFormulir = 'dosen-formulir';
  static const String dosenProfil = 'dosen-profil';

  // Operator
  static const String operatorDashboard = 'operator-dashboard';
  static const String kelolaDataMahasiswa = 'kelola-data-mahasiswa';
  static const String dataDosen = 'data-dosen';
  static const String inputJadwalSidang = 'input-jadwal-sidang';
  static const String importExcel = 'import-excel';
  static const String approvalGantiPenguji = 'approval-ganti-penguji';
  static const String dokumenRekapHonor = 'dokumen-rekap-honor';
  static const String operatorGenerateSk = 'operator-generate-sk';
  static const String operatorProfil = 'operator-profil';

  // Kaprodi
  static const String kaprodiDashboard = 'kaprodi-dashboard';
  static const String approvalPenguji = 'approval-penguji';
  static const String jadwalSidangFinal = 'jadwal-sidang-final';
  static const String rekapNilaiSidang = 'rekap-nilai-sidang';
  static const String rekapHonorDosen = 'rekap-honor-dosen';
  static const String kaprodiLaporanSidang = 'kaprodi-laporan-sidang';
  static const String kaprodiProfil = 'kaprodi-profil';

  // ── Route Paths ───────────────────────────────────────────────────────
  static const String _splashPath = '/';
  static const String _loginPath = '/login';

  // Mahasiswa paths
  static const String _mahasiswaBerandaPath = '/mahasiswa';
  static const String _mahasiswaJadwalPath = '/mahasiswa/jadwal';
  static const String _mahasiswaDokumenPath = '/mahasiswa/dokumen';
  static const String _mahasiswaProfilPath = '/mahasiswa/profil';
  static const String _pendaftaranDataDiriPath = '/mahasiswa/pendaftaran/data-diri';
  static const String _pendaftaranUploadPath = '/mahasiswa/pendaftaran/upload';
  static const String _pendaftaranKonfirmasiPath = '/mahasiswa/pendaftaran/konfirmasi';
  static const String _statusBerkasPath = '/mahasiswa/status-berkas';
  static const String _detailJadwalPath = '/mahasiswa/jadwal/:id';
  static const String _hasilSidangPath = '/mahasiswa/hasil-sidang';
  static const String _notifikasiPath = '/notifikasi';

  // Dosen paths
  static const String _dosenBerandaPath = '/dosen';
  static const String _daftarMahasiswaPath = '/dosen/mahasiswa';
  static const String _detailMahasiswaDosenPath = '/dosen/mahasiswa/:id';
  static const String _inputNilaiPath = '/dosen/input-nilai/:id';
  static const String _formulirRevisiPath = '/dosen/formulir-revisi/:id';
  static const String _formulirKehadiranPath = '/dosen/formulir-kehadiran';
  static const String _tandaTanganPath = '/dosen/tanda-tangan';
  static const String _pengajuanGantiPengujiPath = '/dosen/ganti-penguji';
  static const String _dosenJadwalPath = '/dosen/jadwal';
  static const String _dosenFormulirPath = '/dosen/formulir';
  static const String _dosenProfilPath = '/dosen/profil';

  // Operator paths
  static const String _operatorDashboardPath = '/operator';
  static const String _kelolaDataMahasiswaPath = '/operator/mahasiswa';
  static const String _dataDosenPath = '/operator/dosen';
  static const String _inputJadwalSidangPath = '/operator/jadwal';
  static const String _importExcelPath = '/operator/import-excel';
  static const String _approvalGantiPengujiPath = '/operator/approval-ganti-penguji';
  static const String _dokumenRekapHonorPath = '/operator/rekap-honor';
  static const String _operatorGenerateSkPath = '/operator/generate-sk';
  static const String _operatorProfilPath = '/operator/profil';

  // Kaprodi paths
  static const String _kaprodiDashboardPath = '/kaprodi';
  static const String _approvalPengujiPath = '/kaprodi/approval-penguji';
  static const String _jadwalSidangFinalPath = '/kaprodi/jadwal-final';
  static const String _rekapNilaiPath = '/kaprodi/rekap-nilai';
  static const String _rekapHonorDosenPath = '/kaprodi/rekap-honor';
  static const String _kaprodiLaporanSidangPath = '/kaprodi/laporan-sidang';
  static const String _kaprodiProfilPath = '/kaprodi/profil';

  // ── Router Configuration ─────────────────────────────────────────────
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: _splashPath,
    debugLogDiagnostics: true,
    routes: [
      // ── Splash & Auth ───────────────────────────────────────────────
      GoRoute(
        path: _splashPath,
        name: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: _loginPath,
        name: login,
        builder: (context, state) => const LoginScreen(),
      ),

      // ── Mahasiswa Routes ────────────────────────────────────────────
      GoRoute(
        path: _mahasiswaBerandaPath,
        name: mahasiswaBeranda,
        builder: (context, state) => const MahasiswaHomeScreen(),
      ),
      GoRoute(
        path: _mahasiswaJadwalPath,
        name: mahasiswaJadwal,
        builder: (context, state) => const _PlaceholderPage(title: 'Jadwal Sidang'),
      ),
      GoRoute(
        path: _mahasiswaDokumenPath,
        name: mahasiswaDokumen,
        builder: (context, state) =>
            const _PlaceholderPage(title: 'Berkas'),
      ),
      GoRoute(
        path: _mahasiswaProfilPath,
        name: mahasiswaProfil,
        builder: (context, state) =>
            const _PlaceholderPage(title: 'Profil Mahasiswa'),
      ),
      GoRoute(
        path: _pendaftaranDataDiriPath,
        name: pendaftaranSidangDataDiri,
        builder: (context, state) => const DaftarSidangScreen(),
      ),
      GoRoute(
        path: _pendaftaranUploadPath,
        name: pendaftaranSidangUpload,
        builder: (context, state) => const DaftarSidangScreen(),
      ),
      GoRoute(
        path: _pendaftaranKonfirmasiPath,
        name: pendaftaranSidangKonfirmasi,
        builder: (context, state) => const DaftarSidangScreen(),
      ),
      GoRoute(
        path: _statusBerkasPath,
        name: statusBerkas,
        builder: (context, state) => const _PlaceholderPage(title: 'Status Berkas'),
      ),
      GoRoute(
        path: _detailJadwalPath,
        name: detailJadwalSidang,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return _PlaceholderPage(title: 'Detail Jadwal Sidang #$id');
        },
      ),
      GoRoute(
        path: _hasilSidangPath,
        name: hasilSidang,
        builder: (context, state) => const NilaiScreen(),
      ),
      GoRoute(
        path: _notifikasiPath,
        name: notifikasi,
        builder: (context, state) => const NotifikasiScreen(),
      ),

      // ── Dosen Routes ────────────────────────────────────────────────
      GoRoute(
        path: _dosenBerandaPath,
        name: dosenBeranda,
        builder: (context, state) => const DosenHomeScreen(),
      ),
      GoRoute(
        path: _daftarMahasiswaPath,
        name: daftarMahasiswaSaya,
        builder: (context, state) => const DosenMahasiswaScreen(),
      ),
      GoRoute(
        path: _detailMahasiswaDosenPath,
        name: detailMahasiswaDosen,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return DosenMahasiswaDetailScreen(mahasiswaId: id);
        },
      ),
      GoRoute(
        path: _inputNilaiPath,
        name: inputNilai,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return InputNilaiScreen(mahasiswaId: id);
        },
      ),
      GoRoute(
        path: _formulirRevisiPath,
        name: formulirRevisi,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return FormulirRevisiScreen(mahasiswaId: id);
        },
      ),
      GoRoute(
        path: _formulirKehadiranPath,
        name: formulirKehadiran,
        builder: (context, state) => const FormulirAbsenScreen(),
      ),
      GoRoute(
        path: _tandaTanganPath,
        name: tandaTanganDokumen,
        builder: (context, state) => const TTDDokumenScreen(),
      ),
      GoRoute(
        path: _pengajuanGantiPengujiPath,
        name: pengajuanGantiPenguji,
        builder: (context, state) => const GantiPengujiScreen(),
      ),
      GoRoute(
        path: _dosenJadwalPath,
        name: dosenJadwal,
        builder: (context, state) =>
            const _PlaceholderPage(title: 'Jadwal Sidang Dosen'),
      ),
      GoRoute(
        path: _dosenFormulirPath,
        name: dosenFormulir,
        builder: (context, state) =>
            const _PlaceholderPage(title: 'Formulir & Dokumen Dosen'),
      ),
      GoRoute(
        path: _dosenProfilPath,
        name: dosenProfil,
        builder: (context, state) =>
            const _PlaceholderPage(title: 'Profil Dosen'),
      ),

      // ── Operator Routes ─────────────────────────────────────────────
      GoRoute(
        path: _operatorDashboardPath,
        name: operatorDashboard,
        builder: (context, state) => const OperatorHomeScreen(),
      ),
      GoRoute(
        path: _kelolaDataMahasiswaPath,
        name: kelolaDataMahasiswa,
        builder: (context, state) => const KelolaMahasiswaScreen(),
      ),
      GoRoute(
        path: _dataDosenPath,
        name: dataDosen,
        builder: (context, state) =>
            const _PlaceholderPage(title: 'Data Dosen'),
      ),
      GoRoute(
        path: _inputJadwalSidangPath,
        name: inputJadwalSidang,
        builder: (context, state) =>
            const _PlaceholderPage(title: 'Input Jadwal Sidang'),
      ),
      GoRoute(
        path: _importExcelPath,
        name: importExcel,
        builder: (context, state) =>
            const _PlaceholderPage(title: 'Import Excel'),
      ),
      GoRoute(
        path: _approvalGantiPengujiPath,
        name: approvalGantiPenguji,
        builder: (context, state) => const ApprovalPengujiScreen(),
      ),
      GoRoute(
        path: _dokumenRekapHonorPath,
        name: dokumenRekapHonor,
        builder: (context, state) => const DokumenHonorScreen(),
      ),
      GoRoute(
        path: _operatorGenerateSkPath,
        name: operatorGenerateSk,
        builder: (context, state) =>
            const _PlaceholderPage(title: 'Generate SK Sidang'),
      ),
      GoRoute(
        path: _operatorProfilPath,
        name: operatorProfil,
        builder: (context, state) =>
            const _PlaceholderPage(title: 'Profil Operator'),
      ),

      // ── Kaprodi Routes ──────────────────────────────────────────────
      GoRoute(
        path: _kaprodiDashboardPath,
        name: kaprodiDashboard,
        builder: (context, state) => const KaprodiHomeScreen(),
      ),
      GoRoute(
        path: _approvalPengujiPath,
        name: approvalPenguji,
        builder: (context, state) =>
            const _PlaceholderPage(title: 'Approval Penguji'),
      ),
      GoRoute(
        path: _jadwalSidangFinalPath,
        name: jadwalSidangFinal,
        builder: (context, state) =>
            const KaprodiJadwalScreen(),
      ),
      GoRoute(
        path: _rekapNilaiPath,
        name: rekapNilaiSidang,
        builder: (context, state) =>
            const KaprodiRekapNilaiScreen(),
      ),
      GoRoute(
        path: _rekapHonorDosenPath,
        name: rekapHonorDosen,
        builder: (context, state) =>
            const _PlaceholderPage(title: 'Rekap Honor Dosen'),
      ),
      GoRoute(
        path: _kaprodiLaporanSidangPath,
        name: kaprodiLaporanSidang,
        builder: (context, state) =>
            const _PlaceholderPage(title: 'Laporan Sidang'),
      ),
      GoRoute(
        path: _kaprodiProfilPath,
        name: kaprodiProfil,
        builder: (context, state) =>
            const _PlaceholderPage(title: 'Profil Kaprodi'),
      ),
    ],

    // ── Error Page ──────────────────────────────────────────────────────
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Halaman tidak ditemukan',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(_splashPath),
              child: const Text('Kembali ke Beranda'),
            ),
          ],
        ),
      ),
    ),
  );
}
