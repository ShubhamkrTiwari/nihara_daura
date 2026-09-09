import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Deeper Antique Dark Golden Brand Palette
  static const Color primary = Color(0xFFB8860B); // Deep Amber Gold
  static const Color secondary = Color(0xFF8B6508); // Antique Dark Gold
  static const Color accent = Color(0xFFD4AF37); // Rich Metallic Sparkle Gold
  static const Color background = Color(0xFFFAF2DF); // Warm Golden Sand Cream
  static const Color cardBg = Color(0xFFFFFFFF); // Pure Crisp White Surface
  static const Color textPrimary = Color(0xFF1A140E); // Deep Ebony Charcoal Text
  static const Color textSecondary = Color(0xFF5C5046); // Warm Rich Bronze Taupe
  static const Color border = Color(0xFFC8AD88); // Deep Metallic Gold Border

  // Supplementary Colors & Deep Golden Tints
  static const Color white = Color(0xFFFFFFFF);
  static const Color goldLight = Color(0xFFF7E8CE); // Soft Golden Surface Tint
  static const Color roseLight = Color(0xFFF7E8CE); // Alias for compatibility
  static const Color goldMedium = Color(0xFFD8B984); // Medium Antique Gold Accent
  static const Color goldDark = Color(0xFF503500); // Deep Antique Dark Gold Text
  static const Color starYellow = Color(0xFFFFB800);
  static const Color success = Color(0xFF2E7D32);
  static const Color shadow = Color(0x228B6508);

  // Deeper Rich Golden Ambient Background Gradient
  static const LinearGradient bgGradient = LinearGradient(
    colors: [
      Color(0xFFFAF2DF), // Warm Golden Sand
      Color(0xFFEEDCAE), // Rich Amber Gold Tint
      Color(0xFFE0C896), // Deep Golden Surface
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Multi-tier Deeper Dark Golden Gradients
  static const LinearGradient goldGradient = LinearGradient(
    colors: [
      Color(0xFFD4AF37),
      Color(0xFFB8860B),
      Color(0xFF8B6508),
      Color(0xFF503500),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGoldGradient = LinearGradient(
    colors: [
      Color(0xFF8B6508),
      Color(0xFF503500),
      Color(0xFF302000),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient softGoldGradient = LinearGradient(
    colors: [
      Color(0xFFF7E8CE),
      Color(0xFFE6D0A2),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGoldGradient = LinearGradient(
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFFAF2DF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  static ThemeData get lightTheme {
    final TextTheme baseTextTheme = GoogleFonts.poppinsTextTheme();
    final TextTheme serifTextTheme = GoogleFonts.playfairDisplayTextTheme();

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.light(
        primary: AppColors.secondary,
        secondary: AppColors.primary,
        tertiary: AppColors.accent,
        surface: AppColors.cardBg,
        onPrimary: AppColors.white,
        onSecondary: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
        outline: AppColors.border,
      ),
      fontFamily: GoogleFonts.poppins().fontFamily,
      textTheme: baseTextTheme.copyWith(
        displayLarge: serifTextTheme.displayLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        displayMedium: serifTextTheme.displayMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: serifTextTheme.headlineLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: serifTextTheme.headlineMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: serifTextTheme.headlineSmall?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: serifTextTheme.titleLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: baseTextTheme.titleMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: baseTextTheme.titleSmall?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          color: AppColors.textPrimary,
          height: 1.5,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          color: AppColors.textSecondary,
          height: 1.4,
        ),
        bodySmall: baseTextTheme.bodySmall?.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: serifTextTheme.titleLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border, width: 1.0),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          foregroundColor: AppColors.white,
          elevation: 3,
          shadowColor: AppColors.secondary.withValues(alpha: 0.35),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            letterSpacing: 0.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.secondary,
          side: const BorderSide(color: AppColors.secondary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.white,
        selectedColor: AppColors.secondary,
        disabledColor: Colors.grey.shade200,
        secondarySelectedColor: AppColors.secondary,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: GoogleFonts.poppins(
          color: AppColors.textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        secondaryLabelStyle: GoogleFonts.poppins(
          color: AppColors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.border, width: 1.0),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.secondary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        hintStyle: GoogleFonts.poppins(
          color: AppColors.textSecondary.withValues(alpha: 0.7),
          fontSize: 14,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.secondary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
        selectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
