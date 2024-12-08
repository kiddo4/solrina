import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:solrina/core/theme/app_colors.dart';
import 'package:solrina/core/theme/app_typography.dart';

class SwapPage extends StatefulWidget {
  const SwapPage({super.key});

  @override
  State<SwapPage> createState() => _SwapPageState();
}

class _SwapPageState extends State<SwapPage> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSwapCard(),
                  const SizedBox(height: 24),
                  _buildSwapDetails(),
                  const SizedBox(height: 32),
                  _buildSwapButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwapCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.yellow.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildTokenInput(
            controller: _fromController,
            label: 'From',
            token: 'SOL',
            balance: '2.5',
          ),
          const SizedBox(height: 16),
          _buildSwapIcon(),
          const SizedBox(height: 16),
          _buildTokenInput(
            controller: _toController,
            label: 'To',
            token: 'DEGEN',
            balance: '0.0',
            isOutput: true,
          ),
        ],
      ),
    ).animate().fade(
      duration: const Duration(milliseconds: 300),
    ).moveY(
      begin: 20,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutQuad,
    );
  }

  Widget _buildTokenInput({
    required TextEditingController controller,
    required String label,
    required String token,
    required String balance,
    bool isOutput = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
            Text(
              'Balance: $balance $token',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.white,
                  ),
                  keyboardType: TextInputType.number,
                  enabled: !isOutput,
                  decoration: InputDecoration(
                    hintText: '0.0',
                    hintStyle: AppTypography.headlineMedium.copyWith(
                      color: AppColors.secondaryText,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.yellow.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: AppColors.yellow,
                      child: Text(
                        token[0],
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      token,
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.yellow,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.yellow,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSwapIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.yellow.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(
          Icons.swap_vert,
          color: AppColors.yellow,
        ),
        onPressed: () {},
      ),
    );
  }

  Widget _buildSwapDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildSwapDetailRow(
            label: 'Rate',
            value: '1 SOL = 1,000 DEGEN',
          ),
          const SizedBox(height: 12),
          _buildSwapDetailRow(
            label: 'Fee',
            value: '0.001 SOL',
          ),
          const SizedBox(height: 12),
          _buildSwapDetailRow(
            label: 'Slippage',
            value: '0.5%',
          ),
        ],
      ),
    ).animate().fade(
      duration: const Duration(milliseconds: 300),
    ).moveY(
      begin: 20,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutQuad,
    );
  }

  Widget _buildSwapDetailRow({
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.secondaryText,
          ),
        ),
        Text(
          value,
          style: AppTypography.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildSwapButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: AppColors.accentGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.yellow.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Swap',
          style: AppTypography.buttonLarge,
        ),
      ),
    ).animate().fade(
      duration: const Duration(milliseconds: 300),
    ).moveY(
      begin: 20,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutQuad,
    );
  }
}
