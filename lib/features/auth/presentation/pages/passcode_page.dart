import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solrina/core/theme/app_colors.dart';
import 'package:solrina/core/theme/app_typography.dart';
import 'package:solrina/features/auth/data/providers/auth_provider.dart';
import 'package:solrina/features/main_navigation/presentation/pages/main_navigation_page.dart';

class PasscodePage extends ConsumerStatefulWidget {
  const PasscodePage({super.key});

  @override
  ConsumerState<PasscodePage> createState() => _PasscodePageState();
}

class _PasscodePageState extends ConsumerState<PasscodePage> {
  final _passcodeController = TextEditingController();
  bool _isLoading = false;
  bool _isError = false;

  @override
  void dispose() {
    _passcodeController.dispose();
    super.dispose();
  }

  Future<void> _verifyPasscode() async {
    if (_passcodeController.text.isEmpty) {
      setState(() => _isError = true);
      return;
    }

    setState(() {
      _isLoading = true;
      _isError = false;
    });

    try {
      final isValid = await ref
          .read(authProvider.notifier)
          .verifyPasscode(_passcodeController.text);

      if (mounted) {
        if (isValid) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainNavigationPage()),
          );
        } else {
          setState(() => _isError = true);
          _passcodeController.clear();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              Text(
                'Welcome back,\n${user?.username ?? ''}',
                style: AppTypography.headlineLarge.copyWith(
                  color: AppColors.yellow,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Enter your passcode to continue',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
              const SizedBox(height: 48),
              TextField(
                controller: _passcodeController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 6,
                style: AppTypography.headlineMedium,
                textAlign: TextAlign.center,
                onSubmitted: (_) => _verifyPasscode(),
                decoration: InputDecoration(
                  hintText: '******',
                  hintStyle: AppTypography.headlineMedium.copyWith(
                    color: AppColors.secondaryText,
                  ),
                  errorText: _isError ? 'Invalid passcode' : null,
                  filled: true,
                  fillColor: AppColors.cardBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.yellow.withOpacity(0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.yellow.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.yellow,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyPasscode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellow,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.black,
                          ),
                        )
                      : Text(
                          'Continue',
                          style: AppTypography.buttonLarge.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                ),
              ),
            ],
          ).animate().fade(
                duration: const Duration(milliseconds: 300),
              ),
        ),
      ),
    );
  }
}
