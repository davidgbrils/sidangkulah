/// Kelas utilitas untuk validasi form input
class Validators {
  Validators._();

  /// Validasi field wajib diisi
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null
          ? '$fieldName wajib diisi'
          : 'Field ini wajib diisi';
    }
    return null;
  }

  /// Validasi format email
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email wajib diisi';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Format email tidak valid';
    }
    return null;
  }

  /// Validasi minimal karakter password
  static String? password(String? value, {int minLength = 8}) {
    if (value == null || value.trim().isEmpty) {
      return 'Kata sandi wajib diisi';
    }
    if (value.length < minLength) {
      return 'Kata sandi minimal $minLength karakter';
    }
    return null;
  }

  /// Validasi konfirmasi password cocok
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.trim().isEmpty) {
      return 'Konfirmasi kata sandi wajib diisi';
    }
    if (value != password) {
      return 'Kata sandi tidak cocok';
    }
    return null;
  }

  /// Validasi nomor telepon Indonesia
  static String? phoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor telepon wajib diisi';
    }
    final phoneRegex = RegExp(r'^(\+62|62|0)8[1-9][0-9]{6,10}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Format nomor telepon tidak valid';
    }
    return null;
  }

  /// Validasi NIM (Nomor Induk Mahasiswa)
  static String? nim(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'NIM wajib diisi';
    }
    if (value.trim().length < 8) {
      return 'NIM minimal 8 karakter';
    }
    return null;
  }

  /// Validasi NIP (Nomor Induk Pegawai)
  static String? nip(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'NIP wajib diisi';
    }
    if (value.trim().length < 8) {
      return 'NIP minimal 8 karakter';
    }
    return null;
  }

  /// Validasi panjang minimum
  static String? minLength(String? value, int length, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Field'} wajib diisi';
    }
    if (value.trim().length < length) {
      return '${fieldName ?? 'Field'} minimal $length karakter';
    }
    return null;
  }

  /// Validasi panjang maksimum
  static String? maxLength(String? value, int length, [String? fieldName]) {
    if (value != null && value.trim().length > length) {
      return '${fieldName ?? 'Field'} maksimal $length karakter';
    }
    return null;
  }

  /// Validasi angka saja
  static String? numericOnly(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Field'} wajib diisi';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return '${fieldName ?? 'Field'} hanya boleh berisi angka';
    }
    return null;
  }

  /// Validasi file extension
  static String? fileExtension(String? fileName, List<String> allowedExtensions) {
    if (fileName == null || fileName.isEmpty) {
      return 'File wajib dipilih';
    }
    final ext = fileName.split('.').last.toLowerCase();
    if (!allowedExtensions.contains(ext)) {
      return 'Format file harus ${allowedExtensions.join(', ')}';
    }
    return null;
  }

  /// Validasi ukuran file (dalam bytes)
  static String? fileSize(int? sizeInBytes, int maxSizeInMB) {
    if (sizeInBytes == null) return null;
    final maxBytes = maxSizeInMB * 1024 * 1024;
    if (sizeInBytes > maxBytes) {
      return 'Ukuran file maksimal $maxSizeInMB MB';
    }
    return null;
  }
}
