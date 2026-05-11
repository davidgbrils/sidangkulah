import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';
import 'package:sidangkufix/core/widgets/sidangku_button.dart';
import 'package:sidangkufix/core/widgets/sidangku_text_field.dart';
import 'package:sidangkufix/core/utils/validators.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _nimController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _agreedToTerms = false;
  bool _isLoading = false;

  double _passwordStrength = 0;
  String _passwordStrengthText = 'Lemah';
  Color _passwordStrengthColor = AppColors.error;

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _checkPasswordStrength(String value) {
    int score = 0;
    if (value.length >= 8) score++;
    if (value.contains(RegExp(r'[A-Z]'))) score++;
    if (value.contains(RegExp(r'[0-9]'))) score++;
    if (value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    setState(() {
      if (value.isEmpty) {
        _passwordStrength = 0;
        _passwordStrengthText = '';
        return;
      }
      switch (score) {
        case 0:
        case 1:
          _passwordStrength = 0.25;
          _passwordStrengthText = 'Lemah';
          _passwordStrengthColor = AppColors.error;
          break;
        case 2:
          _passwordStrength = 0.5;
          _passwordStrengthText = 'Sedang';
          _passwordStrengthColor = AppColors.warning;
          break;
        case 3:
          _passwordStrength = 0.75;
          _passwordStrengthText = 'Kuat';
          _passwordStrengthColor = AppColors.primaryLight;
          break;
        case 4:
          _passwordStrength = 1.0;
          _passwordStrengthText = 'Sangat Kuat';
          _passwordStrengthColor = AppColors.success;
          break;
      }
    });
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda harus menyetujui Syarat & Ketentuan.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Mock API Call
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pendaftaran berhasil! Silakan masuk.'),
        backgroundColor: AppColors.success,
      ),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Daftar Mahasiswa'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Buat Akun Baru',
                style: AppTheme.headingLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Lengkapi data di bawah ini untuk mendaftar sebagai mahasiswa.',
                style: AppTheme.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),

              SidangkuTextField(
                label: 'Nama Lengkap',
                hint: 'Contoh: John Doe',
                controller: _namaController,
                prefixIcon: Icons.person_outline,
                validator: (val) => val == null || val.isEmpty ? 'Nama harus diisi' : null,
              ),
              const SizedBox(height: 16),

              SidangkuTextField(
                label: 'NIM',
                hint: 'Contoh: 202011001',
                controller: _nimController,
                prefixIcon: Icons.badge_outlined,
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'NIM harus diisi';
                  if (int.tryParse(val) == null) return 'NIM harus berupa angka';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              SidangkuTextField(
                label: 'Email',
                hint: 'Contoh: john@student.itpln.ac.id',
                controller: _emailController,
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email,
              ),
              const SizedBox(height: 16),

              SidangkuTextField(
                label: 'Nomor Telepon',
                hint: 'Contoh: 081234567890',
                controller: _phoneController,
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              SidangkuTextField(
                label: 'Password',
                hint: '••••••••',
                controller: _passwordController,
                prefixIcon: Icons.lock_outline,
                obscureText: true,
                onChanged: _checkPasswordStrength,
                validator: (val) => val == null || val.length < 8 ? 'Password minimal 8 karakter' : null,
              ),
              if (_passwordStrength > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: _passwordStrength,
                            backgroundColor: AppColors.border,
                            valueColor: AlwaysStoppedAnimation<Color>(_passwordStrengthColor),
                            minHeight: 4,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _passwordStrengthText,
                        style: AppTheme.caption.copyWith(
                          color: _passwordStrengthColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),

              SidangkuTextField(
                label: 'Konfirmasi Password',
                hint: '••••••••',
                controller: _confirmPasswordController,
                prefixIcon: Icons.lock_outline,
                obscureText: true,
                validator: (val) {
                  if (val != _passwordController.text) return 'Password tidak cocok';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                value: _agreedToTerms,
                onChanged: (val) => setState(() => _agreedToTerms = val ?? false),
                title: Text(
                  'Saya menyetujui Syarat dan Ketentuan yang berlaku',
                  style: AppTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 32),

              SidangkuButton(
                label: 'Daftar Sekarang',
                type: SidangkuButtonType.primary,
                isLoading: _isLoading,
                onTap: _handleRegister,
              ),
              const SizedBox(height: 16),
              
              Center(
                child: Text(
                  'Akun Dosen dibuat oleh Admin',
                  style: AppTheme.caption.copyWith(
                    fontStyle: FontStyle.italic,
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
