import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:solrina/core/theme/app_colors.dart';
import 'package:solrina/core/theme/app_typography.dart';

class TransferPage extends StatefulWidget {
  final bool isSending;
  const TransferPage({super.key, this.isSending = true});

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  final _addressController = TextEditingController();
  final _amountController = TextEditingController();

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
                  _buildSegmentedControl(),
                  const SizedBox(height: 32),
                  _buildTransferForm(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSegmentButton(
              title: 'Send',
              isSelected: widget.isSending,
              onTap: () => setState(() => widget.isSending = true),
            ),
          ),
          Expanded(
            child: _buildSegmentButton(
              title: 'Receive',
              isSelected: !widget.isSending,
              onTap: () => setState(() => widget.isSending = false),
            ),
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

  Widget _buildSegmentButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.yellow : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          style: AppTypography.buttonLarge.copyWith(
            color: isSelected ? AppColors.black : AppColors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildTransferForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isSending) ...[
          _buildTextField(
            controller: _addressController,
            label: 'Recipient Address',
            hint: 'Enter Solana address',
          ),
          const SizedBox(height: 24),
          _buildTextField(
            controller: _amountController,
            label: 'Amount',
            hint: 'Enter amount',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 32),
          _buildSendButton(),
        ] else ...[
          _buildReceiveQR(),
        ],
      ],
    ).animate().fade(
      duration: const Duration(milliseconds: 300),
    ).moveY(
      begin: 20,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutQuad,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.secondaryText,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.yellow.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.white,
            ),
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTypography.bodyLarge.copyWith(
                color: AppColors.secondaryText,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSendButton() {
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
          'Send',
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

  Widget _buildReceiveQR() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Container(
                width: 200,
                height: 200,
                color: AppColors.white,
                child: const Center(
                  child: Text('QR Code'),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Your Wallet Address',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      '0x1234...5678',
                      style: AppTypography.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.copy,
                      color: AppColors.yellow,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
