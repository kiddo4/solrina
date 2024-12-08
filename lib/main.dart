import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solrina/core/routing/app_router.dart';
import 'package:solrina/core/theme/app_colors.dart';
import 'package:solrina/features/main_navigation/presentation/pages/main_navigation_page.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solrina',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.yellow,
        scaffoldBackgroundColor: AppColors.background,
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
        textTheme: TextTheme(
          displayLarge: TextStyle(
            color: AppColors.primaryText, 
            fontWeight: FontWeight.bold
          ),
          bodyLarge: TextStyle(
            color: AppColors.primaryText
          ),
        ),
        colorScheme: ColorScheme.dark(
          primary: AppColors.yellow,
          secondary: AppColors.yellow,
          background: AppColors.background,
          surface: AppColors.cardBackground,
        ),
      ),
      home: const MainNavigationPage(),
    );
  }
}
