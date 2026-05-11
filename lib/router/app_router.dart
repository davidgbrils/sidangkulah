import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/shared/presentation/widgets/shared_bottom_nav.dart';

import '../features/mahasiswa/presentation/screens/mahasiswa_home_screen.dart';
import '../features/mahasiswa/presentation/screens/berkas_sidang_screen.dart';
import '../features/mahasiswa/presentation/screens/nilai_screen.dart';
import '../features/mahasiswa/presentation/screens/revisi_sidang_screen.dart';
import '../features/dosen/presentation/screens/dosen_home_screen.dart';
import '../features/dosen/presentation/screens/dosen_pembimbing_home_screen.dart';
import '../features/dosen/presentation/screens/daftar_mahasiswa_bimbingan_screen.dart';
import '../features/dosen/presentation/screens/formulir_revisi_screen.dart';
import '../features/operator/presentation/screens/operator_home_screen.dart';
import '../features/operator/presentation/screens/import_excel_screen.dart';
import '../features/operator/presentation/screens/approval_berkas_screen.dart';
import '../features/shared/presentation/screens/chat_admin_mahasiswa_screen.dart';
import '../features/shared/presentation/screens/jadwal_sidang_screen.dart';
import '../features/kaprodi/presentation/screens/kaprodi_home_screen.dart';
import '../features/kaprodi/presentation/screens/pengaturan_prodi_screen.dart';
import '../features/operator/presentation/screens/input_jadwal_screen.dart';
import '../features/operator/presentation/screens/penilaian_mahasiswa_screen.dart';
import '../features/operator/presentation/screens/sidang_berlangsung_screen.dart';
import '../features/dosen/presentation/screens/ganti_penguji_screen.dart';

/// Placeholder page
class _PlaceholderPage extends StatelessWidget {
  final String title;
  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('Under Construction: $title')),
    );
  }
}

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
  
  // Paths
  static const String splashPath = '/';
  static const String loginPath = '/auth/login';
  static const String registerPath = '/auth/register';

  static const String mahasiswaHomePath = '/mahasiswa/home';
  static const String dosenPengujiHomePath = '/dosen-penguji/home';
  static const String dosenPembimbingHomePath = '/dosen-pembimbing/home';
  static const String operatorHomePath = '/operator/home';
  static const String kaprodiHomePath = '/kaprodi/home';

  static const Map<String, String> roleHomePaths = {
    'mahasiswa': mahasiswaHomePath,
    'dosen_penguji': dosenPengujiHomePath,
    'dosen_pembimbing': dosenPembimbingHomePath,
    'operator': operatorHomePath,
    'kaprodi': kaprodiHomePath,
  };

  static Future<String?> _guardRedirect(BuildContext context, GoRouterState state) async {
    final path = state.uri.path;
    final isAuthRoute = path.startsWith('/auth') || path == '/';

    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      return isAuthRoute ? null : loginPath;
    }

    // User is logged in
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).get();
      if (!userDoc.exists) {
        await FirebaseAuth.instance.signOut();
        return loginPath;
      }

      final role = userDoc.data()?['role'] as String? ?? '';
      
      // Convert 'dosen_penguji' to '/dosen-penguji' prefix
      final expectedPrefix = '/${role.replaceAll('_', '-')}';

      // If user is on an auth route, redirect to their home
      if (isAuthRoute) {
        return roleHomePaths[role] ?? loginPath;
      }

      // If user is trying to access a route for another role
      if (!path.startsWith(expectedPrefix)) {
        return roleHomePaths[role];
      }

      return null;
    } catch (e) {
      debugPrint('Router Guard Error: $e');
      return null;
    }
  }

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: splashPath,
    redirect: _guardRedirect,
    routes: [
      GoRoute(
        path: splashPath,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: loginPath,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: registerPath,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/mahasiswa/revisi',
        builder: (context, state) => const RevisiSidangScreen(),
      ),
      GoRoute(
        path: '/operator/import-excel',
        builder: (context, state) => const ImportExcelScreen(),
      ),
      GoRoute(
        path: '/operator/approval-berkas',
        builder: (context, state) => const ApprovalBerkasScreen(),
      ),
      GoRoute(
        path: '/chat/:name',
        builder: (context, state) => ChatAdminMahasiswaScreen(
          participantName: state.pathParameters['name'] ?? 'Chat',
        ),
      ),

      GoRoute(
        path: '/operator/input-jadwal',
        builder: (context, state) => const InputJadwalScreen(),
      ),
      GoRoute(
        path: '/operator/penilaian',
        builder: (context, state) => const PenilaianMahasiswaScreen(),
      ),
      GoRoute(
        path: '/operator/sidang-berlangsung',
        builder: (context, state) => const SidangBerlangsungScreen(),
      ),
      GoRoute(
        path: '/dosen-penguji/ganti-penguji',
        builder: (context, state) => const GantiPengujiScreen(),
      ),
      GoRoute(
        path: '/dosen-pembimbing/ganti-penguji',
        builder: (context, state) => const GantiPengujiScreen(),
      ),

      // ── Mahasiswa Shell ──────────────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return SharedBottomNav(
            navigationShell: navigationShell,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), activeIcon: Icon(Icons.calendar_today), label: 'Jadwal'),
              BottomNavigationBarItem(icon: Icon(Icons.folder_outlined), activeIcon: Icon(Icons.folder), label: 'Berkas'),
              BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), activeIcon: Icon(Icons.analytics), label: 'Nilai'),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profil'),
            ],
          );
        },
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: mahasiswaHomePath, builder: (context, state) => const MahasiswaHomeScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/mahasiswa/jadwal', builder: (context, state) => const JadwalSidangScreen(role: 'mahasiswa'))]),
          StatefulShellBranch(routes: [GoRoute(path: '/mahasiswa/berkas', builder: (context, state) => const BerkasSidangScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/mahasiswa/nilai', builder: (context, state) => const NilaiScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/mahasiswa/profil', builder: (context, state) => const _PlaceholderPage(title: 'Profil'))]),
        ],
      ),

      // ── Dosen Penguji Shell ──────────────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return SharedBottomNav(
            navigationShell: navigationShell,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.people_outline), activeIcon: Icon(Icons.people), label: 'Mahasiswa'),
              BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), activeIcon: Icon(Icons.calendar_today), label: 'Jadwal'),
              BottomNavigationBarItem(icon: Icon(Icons.description_outlined), activeIcon: Icon(Icons.description), label: 'Formulir'),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profil'),
            ],
          );
        },
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: dosenPengujiHomePath, builder: (context, state) => const DosenHomeScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/dosen-penguji/mahasiswa', builder: (context, state) => const _PlaceholderPage(title: 'Mahasiswa'))]),
          StatefulShellBranch(routes: [GoRoute(path: '/dosen-penguji/jadwal', builder: (context, state) => const JadwalSidangScreen(role: 'dosen'))]),
          StatefulShellBranch(routes: [GoRoute(path: '/dosen-penguji/formulir', builder: (context, state) => const FormulirRevisiScreen(mahasiswaId: '1'))]),
          StatefulShellBranch(routes: [GoRoute(path: '/dosen-penguji/profil', builder: (context, state) => const _PlaceholderPage(title: 'Profil'))]),
        ],
      ),

      // ── Dosen Pembimbing Shell ──────────────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return SharedBottomNav(
            navigationShell: navigationShell,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.people_outline), activeIcon: Icon(Icons.people), label: 'Mahasiswa'),
              BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), activeIcon: Icon(Icons.calendar_today), label: 'Jadwal'),
              BottomNavigationBarItem(icon: Icon(Icons.description_outlined), activeIcon: Icon(Icons.description), label: 'Formulir'),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profil'),
            ],
          );
        },
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: dosenPembimbingHomePath, builder: (context, state) => const DosenPembimbingHomeScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/dosen-pembimbing/mahasiswa', builder: (context, state) => const DaftarMahasiswaBimbinganScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/dosen-pembimbing/jadwal', builder: (context, state) => const JadwalSidangScreen(role: 'dosen'))]),
          StatefulShellBranch(routes: [GoRoute(path: '/dosen-pembimbing/formulir', builder: (context, state) => const _PlaceholderPage(title: 'Formulir'))]),
          StatefulShellBranch(routes: [GoRoute(path: '/dosen-pembimbing/profil', builder: (context, state) => const _PlaceholderPage(title: 'Profil'))]),
        ],
      ),

      // ── Operator Shell ──────────────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return SharedBottomNav(
            navigationShell: navigationShell,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard), label: 'Dashboard'),
              BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), activeIcon: Icon(Icons.calendar_today), label: 'Jadwal'),
              BottomNavigationBarItem(icon: Icon(Icons.storage_outlined), activeIcon: Icon(Icons.storage), label: 'Data'),
              BottomNavigationBarItem(icon: Icon(Icons.fact_check_outlined), activeIcon: Icon(Icons.fact_check), label: 'Approval'),
              BottomNavigationBarItem(icon: Icon(Icons.folder_outlined), activeIcon: Icon(Icons.folder), label: 'Dokumen'),
            ],
          );
        },
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: operatorHomePath, builder: (context, state) => const OperatorHomeScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/operator/jadwal', builder: (context, state) => const JadwalSidangScreen(role: 'operator'))]),
          StatefulShellBranch(routes: [GoRoute(path: '/operator/data', builder: (context, state) => const PenilaianMahasiswaScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/operator/approval', builder: (context, state) => const ApprovalBerkasScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/operator/dokumen', builder: (context, state) => const ImportExcelScreen())]),
        ],
      ),

      // ── Kaprodi Shell ──────────────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return SharedBottomNav(
            navigationShell: navigationShell,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard), label: 'Dashboard'),
              BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), activeIcon: Icon(Icons.calendar_today), label: 'Jadwal'),
              BottomNavigationBarItem(icon: Icon(Icons.fact_check_outlined), activeIcon: Icon(Icons.fact_check), label: 'Approval'),
              BottomNavigationBarItem(icon: Icon(Icons.assessment_outlined), activeIcon: Icon(Icons.assessment), label: 'Rekap'),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profil'),
            ],
          );
        },
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: kaprodiHomePath, builder: (context, state) => const KaprodiHomeScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/kaprodi/jadwal', builder: (context, state) => const _PlaceholderPage(title: 'Jadwal'))]),
          StatefulShellBranch(routes: [GoRoute(path: '/kaprodi/approval', builder: (context, state) => const _PlaceholderPage(title: 'Approval'))]),
          StatefulShellBranch(routes: [GoRoute(path: '/kaprodi/rekap', builder: (context, state) => const _PlaceholderPage(title: 'Rekap'))]),
          StatefulShellBranch(routes: [GoRoute(path: '/kaprodi/profil', builder: (context, state) => const PengaturanProdiScreen())]),
        ],
      ),

    ],
  );
}
