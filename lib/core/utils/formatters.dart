import 'package:intl/intl.dart';

/// Kelas utilitas untuk format data tampilan
class Formatters {
  Formatters._();

  // ── Date Formatters ───────────────────────────────────────────────────

  /// Format tanggal: 24 April 2026
  static String formatDateLong(DateTime date) {
    return DateFormat('d MMMM yyyy', 'id_ID').format(date);
  }

  /// Format tanggal: 24 Apr 2026
  static String formatDateMedium(DateTime date) {
    return DateFormat('d MMM yyyy', 'id_ID').format(date);
  }

  /// Format tanggal: 24/04/2026
  static String formatDateShort(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Format tanggal relatif: Hari ini, Kemarin, 2 hari lalu, dll.
  static String formatDateRelative(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        if (diff.inMinutes == 0) return 'Baru saja';
        return '${diff.inMinutes} menit lalu';
      }
      return '${diff.inHours} jam lalu';
    } else if (diff.inDays == 1) {
      return 'Kemarin';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} hari lalu';
    } else if (diff.inDays < 30) {
      return '${(diff.inDays / 7).floor()} minggu lalu';
    } else {
      return formatDateMedium(date);
    }
  }

  // ── Time Formatters ───────────────────────────────────────────────────

  /// Format waktu: 09:30
  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  /// Format waktu: 09:30 WIB
  static String formatTimeWIB(DateTime date) {
    return '${DateFormat('HH:mm').format(date)} WIB';
  }

  /// Format tanggal + waktu: 24 Apr 2026, 09:30
  static String formatDateTime(DateTime date) {
    return '${formatDateMedium(date)}, ${formatTime(date)}';
  }

  /// Format tanggal + waktu lengkap: 24 April 2026, 09:30 WIB
  static String formatDateTimeFull(DateTime date) {
    return '${formatDateLong(date)}, ${formatTimeWIB(date)}';
  }

  // ── Name Formatters ───────────────────────────────────────────────────

  /// Ambil inisial dari nama (maks 2 huruf)
  static String getInitials(String name) {
    if (name.isEmpty) return '';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }

  /// Format nama: huruf kapital tiap kata
  static String capitalizeName(String name) {
    if (name.isEmpty) return '';
    return name.split(' ').map((word) {
      if (word.isEmpty) return '';
      return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
    }).join(' ');
  }

  // ── Number Formatters ─────────────────────────────────────────────────

  /// Format angka dengan titik pemisah ribuan: 1.000.000
  static String formatNumber(num number) {
    return NumberFormat('#,###', 'id_ID').format(number);
  }

  /// Format mata uang Rupiah: Rp 1.000.000
  static String formatCurrency(num amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }

  /// Format nilai/skor: 85.50
  static String formatScore(double score) {
    if (score == score.roundToDouble()) {
      return score.toInt().toString();
    }
    return score.toStringAsFixed(2);
  }

  // ── File Formatters ───────────────────────────────────────────────────

  /// Format ukuran file: 2.5 MB, 350 KB
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Ambil ekstensi file dari nama file
  static String getFileExtension(String fileName) {
    return fileName.split('.').last.toUpperCase();
  }

  // ── Phone Formatters ──────────────────────────────────────────────────

  /// Format nomor telepon: 0812-3456-7890
  static String formatPhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (cleaned.length >= 12) {
      return '${cleaned.substring(0, 4)}-${cleaned.substring(4, 8)}-${cleaned.substring(8)}';
    }
    return phone;
  }

  // ── Semester Formatters ───────────────────────────────────────────────

  /// Format semester: Ganjil 2025/2026
  static String formatSemester(int year, bool isOdd) {
    final type = isOdd ? 'Ganjil' : 'Genap';
    return '$type $year/${year + 1}';
  }
}
