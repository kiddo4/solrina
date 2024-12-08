import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solrina/core/theme/app_colors.dart';
import 'package:solrina/features/splash/presentation/pages/splash_page.dart';

void main() {
  runApp(const ProviderScope(child: SolrinaApp()));
}

class SolrinaApp extends StatelessWidget {
  const SolrinaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solrina',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.yellow,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: const SplashPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
