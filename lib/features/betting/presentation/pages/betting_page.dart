import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:solrina/core/theme/app_colors.dart';
import 'package:solrina/core/theme/app_typography.dart';

class BettingPage extends StatefulWidget {
  const BettingPage({super.key});

  @override
  State<BettingPage> createState() => _BettingPageState();
}

class _BettingPageState extends State<BettingPage> {
  final _betController = TextEditingController();
  bool _isUp = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBettingCard(),
                  const SizedBox(height: 24),
                  _buildRecentBets(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBettingCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.accentGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.yellow.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Prediction',
            style: AppTypography.headlineLarge.copyWith(
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Bet on SOL price movement in next 24h',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.black.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 32),
          _buildDirectionSelector(),
          const SizedBox(height: 24),
          _buildBetAmountField(),
          const SizedBox(height: 24),
          _buildBetButton(),
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

  Widget _buildDirectionSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildDirectionOption(
              title: 'Up',
              icon: Icons.arrow_upward_rounded,
              isSelected: _isUp,
              onTap: () => setState(() => _isUp = true),
            ),
          ),
          Expanded(
            child: _buildDirectionOption(
              title: 'Down',
              icon: Icons.arrow_downward_rounded,
              isSelected: !_isUp,
              onTap: () => setState(() => _isUp = false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDirectionOption({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.white : AppColors.black,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: AppTypography.buttonLarge.copyWith(
                color: isSelected ? AppColors.white : AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBetAmountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bet Amount',
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.black.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.black.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _betController,
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.black,
            ),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: '0.0',
              hintStyle: AppTypography.headlineMedium.copyWith(
                color: AppColors.black.withOpacity(0.3),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              suffixText: 'SOL',
              suffixStyle: AppTypography.bodyLarge.copyWith(
                color: AppColors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBetButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Place Bet',
          style: AppTypography.buttonLarge.copyWith(
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildRecentBets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Bets',
          style: AppTypography.headlineMedium,
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return _buildBetHistoryCard(
              amount: 0.5,
              direction: index % 2 == 0,
              won: index == 0,
            );
          },
        ),
      ],
    ).animate().fade(
      duration: const Duration(milliseconds: 300),
    ).moveY(
      begin: 20,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutQuad,
    );
  }

  Widget _buildBetHistoryCard({
    required double amount,
    required bool direction,
    required bool won,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.yellow.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: direction ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              direction ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
              color: direction ? Colors.green : Colors.red,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$amount SOL',
                style: AppTypography.bodyLarge,
              ),
              Text(
                '24h ${direction ? 'Up' : 'Down'} Prediction',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: won ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              won ? 'Won' : 'Lost',
              style: AppTypography.bodySmall.copyWith(
                color: won ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
