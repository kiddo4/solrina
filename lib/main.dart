import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solrina/core/theme/app_theme.dart';
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
      theme: AppTheme.darkTheme,
      home: const SplashPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
