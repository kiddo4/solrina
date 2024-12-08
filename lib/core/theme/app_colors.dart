import 'package:flutter/material.dart';

class AppColors {
  // Dark Theme Color Palette
  static const Color background = Color(0xFF121212);
  static const Color cardBackground = Color(0xFF1E1E1E);
  static const Color primaryText = Color(0xFFE0E0E0);
  static const Color secondaryText = Color(0xFF9E9E9E);

  // Accent Colors
  static const Color yellow = Color(0xFFFFC107);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Crypto Colors
  static const Color cryptoPositive = Color(0xFF4CAF50);
  static const Color cryptoNegative = Color(0xFFF44336);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color(0xFF1E1E1E),
      Color(0xFF2C2C2C),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [
      Color(0xFFFFC107),
      Color(0xFFFF9800),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Bottom Navigation Colors
  static const Color navBarBackground = Color(0xFF1E1E1E);
  static const Color navBarSelectedItem = Color(0xFFFFC107);
  static const Color navBarUnselectedItem = Color(0xFF9E9E9E);
}

// Custom Shadow Styles
class AppShadows {
  static BoxShadow softShadow = BoxShadow(
    color: Colors.black.withOpacity(0.2),
    blurRadius: 10,
    offset: const Offset(0, 4),
  );

  static BoxShadow heavyShadow = BoxShadow(
    color: Colors.black.withOpacity(0.4),
    blurRadius: 20,
    offset: const Offset(0, 6),
  );
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.yellow,
      scaffoldBackgroundColor: AppColors.background,
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        color: AppColors.cardBackground,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.white),
        titleTextStyle: TextStyle(
          color: AppColors.white, 
          fontSize: 20, 
          fontWeight: FontWeight.bold
        ),
      ),
      
      // Text Theme
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: AppColors.primaryText, 
          fontWeight: FontWeight.bold
        ),
        bodyLarge: TextStyle(
          color: AppColors.primaryText
        ),
      ),
      
      // Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.yellow,
          foregroundColor: AppColors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
      ),
      
      // Card Theme
      cardTheme: CardTheme(
        color: AppColors.cardBackground,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.yellow,
        primary: AppColors.yellow,
        secondary: AppColors.yellow,
        background: AppColors.background,
      ),
    );
  }
}
