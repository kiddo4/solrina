import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solrina/core/theme/app_colors.dart';
import 'package:solrina/core/theme/app_typography.dart';
import 'package:solrina/core/providers/wallet_provider.dart';
import 'package:solrina/features/home/data/model/meme_token_model.dart';
import 'package:solrina/features/trading/presentation/pages/trading_page.dart';
import 'package:solrina/features/betting/presentation/pages/betting_page.dart';
import 'package:solrina/features/wallet/presentation/pages/swap_page.dart';
import 'package:solrina/features/wallet/presentation/pages/transfer_page.dart';

class MainNavigationPage extends ConsumerStatefulWidget {
  const MainNavigationPage({super.key});

  @override
  ConsumerState<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends ConsumerState<MainNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const TradingPage(),
    const BettingPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

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
            icon: const Icon(Icons.trending_up_outlined),
            activeIcon: const Icon(Icons.trending_up),
            label: 'Trading',
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
  // Static data for now
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!ref.read(walletStateProvider).isConnected) {
        ref.read(walletStateProvider.notifier).connectWallet();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletStateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildWalletCard(walletState),
          _buildTokenSection(),
          _buildBettingSection(),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          icon:
              const Icon(Icons.notifications_outlined, color: AppColors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.person_outline, color: AppColors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  SliverToBoxAdapter _buildWalletCard(WalletState walletState) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.yellow.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Balance',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 8),
              if (walletState.isConnected) ...[
                Text(
                  '${walletState.balance.toStringAsFixed(4)} SOL',
                  style: AppTypography.headlineLarge.copyWith(
                    color: AppColors.black,
                    fontSize: 36,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  walletState.publicKey.substring(0, 8) +
                      '...' +
                      walletState.publicKey
                          .substring(walletState.publicKey.length - 8),
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.black.withOpacity(0.7),
                  ),
                ),
              ] else ...[
                Text(
                  '0.0000 SOL',
                  style: AppTypography.headlineLarge.copyWith(
                    color: AppColors.black,
                    fontSize: 36,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Wallet not connected',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.black.withOpacity(0.7),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildActionButton(
                    'Send',
                    Icons.send,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransferPage(isSending: true),
                      ),
                    ),
                  ),
                  _buildActionButton(
                    'Receive',
                    Icons.qr_code,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransferPage(isSending: false),
                      ),
                    ),
                  ),
                  _buildActionButton(
                    'Swap',
                    Icons.swap_horiz,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SwapPage(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2),
    );
  }

  SliverToBoxAdapter _buildTokenSection() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Meme Tokens',
              style: AppTypography.headlineMedium,
            ),
          ),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _tokens.length,
              itemBuilder: (context, index) {
                final token = _tokens[index];
                return _buildTokenCard(token);
              },
            ),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildBettingSection() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
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
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '50/50 Bet',
                style: AppTypography.headlineMedium.copyWith(
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Place a bet and double your money!',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BettingPage(),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  foregroundColor: AppColors.black,
                ),
                child: Text(
                  'Place Bet',
                  style: AppTypography.buttonLarge.copyWith(
                    color: AppColors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2),
    );
  }

  Widget _buildActionButton(String label, IconData icon,
      {VoidCallback? onTap}) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.white.withOpacity(0.2),
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildTokenCard(MemeToken token) {
    final isPositive = token.change >= 0;
    return Container(
      width: 160,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
                      style: AppTypography.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Text(
              '\$${token.price.toStringAsFixed(6)}',
              style: isPositive
                  ? AppTypography.cryptoPricePositive
                  : AppTypography.cryptoPriceNegative,
            ),
            const SizedBox(height: 8),
            Text(
              '${isPositive ? '+' : ''}${token.change.toStringAsFixed(2)}%',
              style: TextStyle(
                color: isPositive
                    ? AppColors.cryptoPositive
                    : AppColors.cryptoNegative,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
