import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:solrina/core/theme/app_colors.dart';
import 'package:solrina/core/theme/app_typography.dart';

class TransferPage extends StatelessWidget {
  final bool isSending;
  const TransferPage({super.key, this.isSending = true});

  @override
  Widget build(BuildContext context) {
    return _TransferPageContent(initialIsSending: isSending);
  }
}

class _TransferPageContent extends StatefulWidget {
  final bool initialIsSending;
  const _TransferPageContent({required this.initialIsSending});

  @override
  State<_TransferPageContent> createState() => _TransferPageContentState();
}

class _TransferPageContentState extends State<_TransferPageContent> {
  late bool _isSending;
  final _addressController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isSending = widget.initialIsSending;
  }

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
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isSending ? 'Send SOL' : 'Receive SOL',
                    style: AppTypography.headlineLarge,
                  ),
                  const SizedBox(height: 24),
                  _buildSegmentControl(),
                  const SizedBox(height: 24),
                  _buildTransferForm(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentControl() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSegmentButton(
              title: 'Send',
              isSelected: _isSending,
              onTap: () => setState(() => _isSending = true),
            ),
          ),
          Expanded(
            child: _buildSegmentButton(
              title: 'Receive',
              isSelected: !_isSending,
              onTap: () => setState(() => _isSending = false),
            ),
          ),
        ],
      ),
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
        decoration: BoxDecoration(
          color: isSelected ? AppColors.yellow : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            title,
            style: AppTypography.buttonLarge.copyWith(
              color: isSelected ? AppColors.black : AppColors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransferForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_isSending) ...[
          _buildTextField(
            controller: _addressController,
            label: 'Recipient Address',
            hintText: 'Enter SOL address',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _amountController,
            label: 'Amount',
            hintText: 'Enter amount in SOL',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: Text(
                'Send SOL',
                style: AppTypography.buttonLarge.copyWith(
                  color: AppColors.black,
                ),
              ),
            ),
          ),
        ] else ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.yellow.withOpacity(0.3),
              ),
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
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        '5KoJ8qhUE2yHxNQQ3Nz8rvpH6PbhawXxKKwwRoqBnK1m',
                        style: AppTypography.bodyMedium,
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
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.bodyLarge,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTypography.bodyMedium.copyWith(
              color: AppColors.white.withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }
}
