import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solrina/core/theme/app_colors.dart';
import 'package:solrina/core/theme/app_typography.dart';
import 'package:solrina/features/main_navigation/presentation/pages/main_navigation_page.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MainNavigationPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: AppColors.accentGradient,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.yellow.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.currency_bitcoin,
                size: 60,
                color: AppColors.black,
              ),
            ).animate().scale(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutBack,
            ),
            const SizedBox(height: 24),
            // App Name
            Text(
              'Solrina',
              style: AppTypography.headlineLarge.copyWith(
                color: AppColors.white,
                fontSize: 36,
              ),
            ).animate().fade(
              delay: const Duration(milliseconds: 400),
              duration: const Duration(milliseconds: 600),
            ),
            const SizedBox(height: 8),
            // Tagline
            Text(
              'Trade & Bet on Solana',
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.white.withOpacity(0.7),
              ),
            ).animate().fade(
              delay: const Duration(milliseconds: 600),
              duration: const Duration(milliseconds: 600),
            ),
          ],
        ),
      ),
    );
  }
}
