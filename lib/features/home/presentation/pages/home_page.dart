import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:solrina/core/theme/app_colors.dart';
import 'package:solrina/core/theme/app_typography.dart';
import 'package:solrina/core/providers/wallet_provider.dart';
import 'package:solrina/features/home/data/model/meme_token_model.dart';
import 'package:solrina/features/wallet/presentation/pages/transfer_page.dart';
import 'package:solrina/features/betting/presentation/pages/betting_page.dart';

class MainNavigationPage extends ConsumerStatefulWidget {
  const MainNavigationPage({super.key});

  @override
  ConsumerState<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends ConsumerState<MainNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const BettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.yellow,
        unselectedItemColor: AppColors.black.withOpacity(0.5),
        type: BottomNavigationBarType.shifting,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: 'Home',
            backgroundColor: AppColors.white,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.casino_outlined),
            activeIcon: const Icon(Icons.casino),
            label: 'Betting',
            backgroundColor: AppColors.white,
          ),
        ],
      ),
    );
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final List<MemeToken> _tokens = [
    MemeToken(
      name: 'DEGEN',
      symbol: 'DGEN',
      price: 0.0069,
      change: 12.45,
      imageUrl: 'assets/images/degen.jpg',
    ),
    MemeToken(
      name: 'BONK',
      symbol: 'BONK',
      price: 0.00001,
      change: -3.21,
      imageUrl: 'assets/images/bonk_token.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletStateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            floating: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.person_outline),
                onPressed: () {},
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: _buildWalletCard(walletState),
          ),
          SliverToBoxAdapter(
            child: _buildActionButtons(),
          ),
          SliverToBoxAdapter(
            child: _buildTokenList(),
          ),
          SliverToBoxAdapter(
            child: _buildBettingSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletCard(WalletState walletState) {
    return Container(
      margin: const EdgeInsets.all(16),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Wallet Balance',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.black.withOpacity(0.7),
                ),
              ),
              if (!walletState.isConnected)
                ElevatedButton(
                  onPressed: () {
                    ref.read(walletStateProvider.notifier).connectWallet();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Connect Wallet',
                    style: AppTypography.buttonMedium.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (walletState.isConnected) ...[
            Text(
              '${walletState.balance.toStringAsFixed(4)} SOL',
              style: AppTypography.headlineLarge.copyWith(
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              walletState.publicKey.substring(0, 8) + '...' + walletState.publicKey.substring(walletState.publicKey.length - 8),
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.black.withOpacity(0.7),
              ),
            ),
          ] else ...[
            Text(
              '0.0000 SOL',
              style: AppTypography.headlineLarge.copyWith(
                color: AppColors.black,
              ),
            ),
          ],
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

  Widget _buildActionButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              icon: Icons.arrow_upward_rounded,
              label: 'Send',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TransferPage(isSending: true),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              icon: Icons.arrow_downward_rounded,
              label: 'Receive',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TransferPage(isSending: false),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
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
            Icon(
              icon,
              color: AppColors.yellow,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTypography.bodyLarge,
            ),
          ],
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

  Widget _buildTokenList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text(
            'Meme Tokens',
            style: AppTypography.headlineMedium,
          ),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _tokens.length,
            itemBuilder: (context, index) {
              final token = _tokens[index];
              return _buildTokenCard(token);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTokenCard(MemeToken token) {
    final isPositive = token.change >= 0;
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.yellow.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  token.imageUrl,
                  width: 40,
                  height: 40,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      token.symbol,
                      style: AppTypography.bodyLarge,
                    ),
                    Text(
                      token.name,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Text(
              '\$${token.price.toStringAsFixed(6)}',
              style: AppTypography.bodyLarge.copyWith(
                color: isPositive ? AppColors.cryptoPositive : AppColors.cryptoNegative,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${isPositive ? '+' : ''}${token.change.toStringAsFixed(2)}%',
              style: TextStyle(
                color: isPositive ? AppColors.cryptoPositive : AppColors.cryptoNegative,
              ),
            ),
          ],
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

  Widget _buildBettingSection() {
    return Container(
      margin: const EdgeInsets.all(16),
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
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Bet on SOL price movement',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.black.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BettingPage(),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Place a Bet',
                style: AppTypography.buttonLarge.copyWith(
                  color: AppColors.white,
                ),
              ),
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
}
