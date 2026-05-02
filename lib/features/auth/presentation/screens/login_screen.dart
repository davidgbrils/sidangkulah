import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/constants/app_strings.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';
import 'package:sidangkufix/core/widgets/sidangku_button.dart';
import 'package:sidangkufix/core/widgets/sidangku_text_field.dart';
import 'package:sidangkufix/features/auth/domain/user_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  final bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldWajibDiisi;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldWajibDiisi;
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      final user = SeedUsers.authenticate(email, password);

      if (user == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Email atau password salah',
              style: AppTheme.bodyMedium.copyWith(color: Colors.white),
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: AppTheme.borderRadiusSmall),
            margin: const EdgeInsets.all(16),
          ),
        );
        setState(() => _isLoading = false);
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', 'seed_token_${user.id}');
      await prefs.setString('user_role', user.roleString);
      await prefs.setString('user_id', user.id);
      await prefs.setString('user_nama', user.nama);

      if (!mounted) return;

      switch (user.roleString) {
        case 'mahasiswa':
          context.go('/mahasiswa');
          break;
        case 'dosen':
          context.go('/dosen');
          break;
        case 'operator':
          context.go('/operator');
          break;
        case 'kaprodi':
          context.go('/kaprodi');
          break;
        default:
          context.go('/login');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Login gagal. Periksa email dan password Anda.',
            style: AppTheme.bodyMedium.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: AppTheme.borderRadiusSmall),
          margin: const EdgeInsets.all(16),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: screenHeight),
            child: Column(
              children: [
                _buildHeader(screenHeight),
                _buildFormCard(),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double screenHeight) {
    return Container(
      width: double.infinity,
      height: screenHeight * 0.30,
      decoration: const BoxDecoration(
        gradient: AppColors.headerGradient,
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.school_rounded,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              AppStrings.appName,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return Transform.translate(
      offset: const Offset(0, -24),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Selamat Datang',
                  style: AppTheme.headingLarge.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  'Masuk ke akun Anda',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 28),

              SidangkuTextField(
                label: 'Email atau NIM',
                hint: 'Contoh: 202011001',
                controller: _emailController,
                prefixIcon: Icons.person_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: _validateEmail,
              ),
              const SizedBox(height: 16),

              SidangkuTextField(
                label: 'Password',
                hint: '••••••••',
                controller: _passwordController,
                prefixIcon: Icons.lock_outline_rounded,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                validator: _validatePassword,
              ),
              const SizedBox(height: 8),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    _showInfo('Fitur reset password akan segera tersedia.');
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Lupa password?',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppColors.onPrimaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              SidangkuButton(
                label: 'Masuk',
                type: SidangkuButtonType.primary,
                isLoading: _isLoading,
                onTap: _isLoading ? null : _handleLogin,
                height: 52,
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.border, thickness: 1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Atau',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: AppColors.border, thickness: 1)),
                ],
              ),
              const SizedBox(height: 24),

              SidangkuButton(
                label: 'Login dengan QR Code',
                type: SidangkuButtonType.outlined,
                icon: Icons.qr_code_scanner_rounded,
                onTap: () {
                  _showInfo('Fitur login QR Code akan segera tersedia.');
                },
                height: 52,
              ),
              const SizedBox(height: 24),
              _buildSeedAccountsInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24, left: 20, right: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Belum memiliki akun? ',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              GestureDetector(
                onTap: () {
                  _showInfo('Silakan hubungi admin prodi melalui kanal resmi kampus.');
                },
                child: Text(
                  'Hubungi Admin Prodi',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppColors.primaryLight,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.hub_rounded,
                size: 18,
                color: AppColors.primary.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 6),
              Text(
                'Part of ITPLN Digital Ecosystem',
                style: AppTheme.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '© 2024 Institut Teknologi PLN. All rights reserved.',
            style: AppTheme.caption.copyWith(
              fontSize: 11,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeedAccountsInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.infoLight.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: AppColors.info),
              const SizedBox(width: 8),
              Text(
                'Akun Demo (Seed Data)',
                style: AppTheme.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.info,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildSeedAccountTile(
            'Operator/Admin',
            'admin@itpln.ac.id',
            'admin123',
            Icons.admin_panel_settings_rounded,
          ),
          _buildSeedAccountTile(
            'Kaprodi',
            'kaprodi@itpln.ac.id',
            'kaprodi123',
            Icons.supervisor_account_rounded,
          ),
          _buildSeedAccountTile(
            'Dosen',
            'heru@itpln.ac.id',
            'dosen123',
            Icons.badge_rounded,
          ),
          _buildSeedAccountTile(
            'Mahasiswa',
            '202011001@student.itpln.ac.id',
            'mahasiswa123',
            Icons.school_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildSeedAccountTile(String role, String email, String password, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: InkWell(
        onTap: () {
          _emailController.text = email;
          _passwordController.text = password;
        },
        child: Row(
          children: [
            Icon(icon, size: 14, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                role,
                style: AppTheme.caption.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              email,
              style: AppTheme.caption.copyWith(
                color: AppColors.textSecondary,
                fontSize: 10,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '/ $password',
              style: AppTheme.caption.copyWith(
                color: AppColors.info,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInfo(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
