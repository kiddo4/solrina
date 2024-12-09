import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:solrina/core/theme/app_colors.dart';
import 'package:solrina/core/theme/app_typography.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TradingPage extends StatefulWidget {
  const TradingPage({super.key});

  @override
  State<TradingPage> createState() => _TradingPageState();
}

class _TradingPageState extends State<TradingPage> {
  late WebViewController _controller;
  bool _isBuying = true;
  final _amountController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString('''
        <!DOCTYPE html>
        <html>
          <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <style>
              body { margin: 0; }
              .tradingview-widget-container { height: 100vh; }
            </style>
          </head>
          <body>
            <div class="tradingview-widget-container">
              <div id="tradingview_widget"></div>
            </div>
            <script type="text/javascript" src="https://s3.tradingview.com/tv.js"></script>
            <script type="text/javascript">
              new TradingView.widget({
                "width": "100%",
                "height": "100%",
                "symbol": "BINANCE:SOLUSDT",
                "interval": "D",
                "timezone": "Etc/UTC",
                "theme": "dark",
                "style": "1",
                "locale": "en",
                "toolbar_bg": "#f1f3f6",
                "enable_publishing": false,
                "hide_side_toolbar": false,
                "allow_symbol_change": true,
                "container_id": "tradingview_widget"
              });
            </script>
          </body>
        </html>
      ''');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: WebViewWidget(controller: _controller),
          ),
          Expanded(
            flex: 2,
            child: _buildTradingPanel(),
          ),
        ],
      ),
    );
  }

  Widget _buildTradingPanel() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTabSelector(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPriceInfo(),
                  const SizedBox(height: 24),
                  _buildTradeForm(),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fade(
      duration: const Duration(milliseconds: 300),
    ).moveY(
      begin: 100,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutQuad,
    );
  }

  Widget _buildTabSelector() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTab(
              title: 'Buy',
              isSelected: _isBuying,
              onTap: () => setState(() => _isBuying = true),
            ),
          ),
          Expanded(
            child: _buildTab(
              title: 'Sell',
              isSelected: !_isBuying,
              onTap: () => setState(() => _isBuying = false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
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

  Widget _buildPriceInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.yellow.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current Price',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
              Text(
                '\$60.25',
                style: AppTypography.headlineMedium,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '24h Change',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
              Text(
                '+2.5%',
                style: AppTypography.bodyLarge.copyWith(
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTradeForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amount',
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.secondaryText,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.yellow.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: TextField(
            controller: _amountController,
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.white,
            ),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: '0.0',
              hintStyle: AppTypography.headlineMedium.copyWith(
                color: AppColors.secondaryText,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              suffixText: 'SOL',
              suffixStyle: AppTypography.bodyLarge.copyWith(
                color: AppColors.yellow,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Container(
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
              _isBuying ? 'Buy SOL' : 'Sell SOL',
              style: AppTypography.buttonLarge,
            ),
          ),
        ),
      ],
    );
  }
}
