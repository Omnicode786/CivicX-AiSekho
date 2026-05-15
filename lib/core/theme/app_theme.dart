import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CivixColors {
  static const bg = Color(0xFF050B18);
  static const panel = Color(0xFF0B1224);
  static const glass = Color(0x1AFFFFFF);
  static const cyan = Color(0xFF00D4FF);
  static const red = Color(0xFFFF3B3B);
  static const orange = Color(0xFFFFB020);
  static const green = Color(0xFF22C55E);
  static const purple = Color(0xFF8B5CF6);
  static const text = Color(0xFFE8F3FF);
  static const muted = Color(0xFF91A4B7);
}

class AppTheme {
  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: CivixColors.bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: CivixColors.cyan,
        brightness: Brightness.dark,
        surface: CivixColors.panel,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).apply(
        bodyColor: CivixColors.text,
        displayColor: CivixColors.text,
      ),
      cardTheme: CardTheme(
        color: CivixColors.glass,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(.07),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: CivixColors.cyan)),
      ),
    );
  }
}
