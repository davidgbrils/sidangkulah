import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/features/auth/presentation/providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with TickerProviderStateMixin {
  static const Duration _minSplashDuration = Duration(milliseconds: 2000);
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _dotsController;
  bool _isNavigating = false;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _slideController.forward();
    });

    _startNavigationFlow();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  Future<void> _startNavigationFlow() async {
    try {
      // Tunggu durasi minimum splash
      await Future.delayed(_minSplashDuration);
      
      if (!mounted || _isNavigating) return;

      final String targetRoute = await _resolveInitialRoute();

      if (!mounted || _isNavigating) return;
      
      // Gunakan post frame callback untuk memastikan frame rendering selesai
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_isNavigating) {
          _isNavigating = true;
          context.go(targetRoute);
        }
      });
    } catch (e) {
      debugPrint('Error in splash navigation: $e');
      if (mounted && !_isNavigating) {
        _isNavigating = true;
        context.go('/login');
      }
    }
  }

  Future<String> _resolveInitialRoute() async {
    try {
      final user = await ref.read(authRepositoryProvider).getCurrentUser();
      if (user != null) {
        return _routeByRole(user.roleString);
      }
    } catch (e) {
      debugPrint('Error resolving route in splash: $e');
    }
    return '/login';
  }

  String _routeByRole(String role) {
    switch (role) {
      case 'mahasiswa':
        return '/mahasiswa';
      case 'dosen':
        return '/dosen';
      case 'operator':
        return '/operator';
      case 'kaprodi':
        return '/kaprodi';
      default:
        return '/login';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Gunakan AnnotatedRegion untuk memastikan status bar putih di bg biru
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark, // Untuk iOS
      ),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.primary,
          ),
          child: Stack(
            children: [
              Positioned(
                top: -100,
                right: -100,
                child: _buildCircleOrnament(),
              ),
              Positioned(
                bottom: -100,
                left: -100,
                child: _buildCircleOrnament(),
              ),
              SafeArea(
                child: Column(
                  children: [
                    const Spacer(flex: 3),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.school_rounded,
                          size: 64,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          children: [
                            const Text(
                              'SidangKu',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Sistem Manajemen Sidang Skripsi',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withValues(alpha: 0.7),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(flex: 4),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Column(
                        children: [
                          _LoadingDots(controller: _dotsController),
                          const SizedBox(height: 32),
                          Text(
                            'ITPLN DIGITAL ECOSYSTEM',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Colors.white.withValues(alpha: 0.4),
                              letterSpacing: 2.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircleOrnament() {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.03),
      ),
    );
  }
}

class _LoadingDots extends StatelessWidget {
  final AnimationController controller;

  const _LoadingDots({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            final double begin = index * 0.2;
            final double end = (begin + 0.6).clamp(0.0, 1.0);
            double value = 0.0;

            if (controller.value >= begin && controller.value <= end) {
              value = (controller.value - begin) / 0.6;
              value = value < 0.5 ? value * 2 : (1 - value) * 2;
            }

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2 + (value * 0.8)),
                shape: BoxShape.circle,
              ),
            );
          },
        );
      }),
    );
  }
}
