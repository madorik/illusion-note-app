import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // 베이스 컬러 (깔끔한 그레이/화이트)
  static const Color primaryWhite = Color(0xFFFFFFFF);
  static const Color backgroundGray = Color(0xFFF8F9FA);
  static const Color lightGray = Color(0xFFF1F3F4);
  static const Color cardWhite = Color(0xFFFFFFFF);
  
  // 포인트 컬러 (모던 블루)
  static const Color primaryBlue = Color(0xFF007AFF);
  static const Color lightBlue = Color(0xFFE3F2FD);
  static const Color darkBlue = Color(0xFF0056CC);
  
  // 텍스트 컬러
  static const Color textPrimary = Color(0xFF1D1D1F);
  static const Color textSecondary = Color(0xFF6D6D80);
  static const Color textTertiary = Color(0xFF98989D);
  
  // 세컨더리 컬러
  static const Color successGreen = Color(0xFF34C759);
  static const Color warningOrange = Color(0xFFFF9500);
  static const Color errorRed = Color(0xFFFF3B30);
  
  // 감정별 컬러 (차분한 톤)
  static const Color joyBlue = Color(0xFF64B5F6);
  static const Color calmGreen = Color(0xFF81C784);
  static const Color neutralGray = Color(0xFF90A4AE);
  static const Color sadPurple = Color(0xFF9575CD);
  static const Color angryRed = Color(0xFFE57373);
  
  // 시간대별 배경 그라데이션 색상
  // 아침 (6-11시): 밝은 노란색, 하늘색 계열
  static const Color morningStart = Color(0xFFFFF8E1);
  static const Color morningEnd = Color(0xFFE1F5FE);
  
  // 오후 (12-17시): 따뜻한 주황, 노란색 계열
  static const Color afternoonStart = Color(0xFFFFF3E0);
  static const Color afternoonEnd = Color(0xFFFFECB3);
  
  // 저녁 (18-21시): 분홍, 보라 계열
  static const Color eveningStart = Color(0xFFF3E5F5);
  static const Color eveningEnd = Color(0xFFE1BEE7);
  
  // 밤 (22-5시): 어두운 남색, 보라 계열
  static const Color nightStart = Color(0xFFE8EAF6);
  static const Color nightEnd = Color(0xFFD1C4E9);
  
  // 현재 시간에 따른 배경 그라데이션 색상 반환
  static List<Color> getBackgroundColorsForCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour;
    
    if (hour >= 6 && hour < 12) {
      // 아침
      return [morningStart, morningEnd];
    } else if (hour >= 12 && hour < 18) {
      // 오후
      return [afternoonStart, afternoonEnd];
    } else if (hour >= 18 && hour < 22) {
      // 저녁
      return [eveningStart, eveningEnd];
    } else {
      // 밤
      return [nightStart, nightEnd];
    }
  }
}

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.primaryBlue,
          onPrimary: Colors.white,
          secondary: AppColors.successGreen,
          onSecondary: Colors.white,
          error: AppColors.errorRed,
          onError: Colors.white,
          background: AppColors.backgroundGray,
          onBackground: AppColors.textPrimary,
          surface: AppColors.cardWhite,
          onSurface: AppColors.textPrimary,
        ),
        scaffoldBackgroundColor: AppColors.backgroundGray,
        textTheme: GoogleFonts.interTextTheme().copyWith(
          bodyLarge: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimary,
          ),
          bodyMedium: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
          titleLarge: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          titleMedium: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          labelLarge: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primaryWhite,
          elevation: 0,
          shadowColor: Colors.black.withOpacity(0.05),
          surfaceTintColor: Colors.transparent,
          iconTheme: IconThemeData(color: AppColors.textPrimary),
          titleTextStyle: GoogleFonts.inter(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        cardTheme: CardTheme(
          color: AppColors.cardWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.08),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.lightGray,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primaryBlue, width: 2),
          ),
          hintStyle: GoogleFonts.inter(
            color: AppColors.textTertiary,
            fontSize: 14,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            elevation: 2,
            shadowColor: AppColors.primaryBlue.withOpacity(0.3),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryBlue,
            side: BorderSide(color: AppColors.primaryBlue),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        iconTheme: IconThemeData(
          color: AppColors.textSecondary,
          size: 24,
        ),
        dividerTheme: DividerThemeData(
          color: AppColors.lightGray,
          thickness: 1,
        ),
      );

  // Shadow Styles
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.12),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  // Border Radius
  static const double smallRadius = 8.0;
  static const double mediumRadius = 12.0;
  static const double largeRadius = 16.0;
  static const double xlRadius = 24.0;

  // Spacing
  static const double smallSpacing = 8.0;
  static const double mediumSpacing = 16.0;
  static const double largeSpacing = 24.0;
  static const double xlSpacing = 32.0;
} 