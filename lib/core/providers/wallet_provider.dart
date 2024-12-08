import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solrina/core/services/solana_wallet_service.dart';

// Wallet Service Provider
final walletServiceProvider = Provider<SolanaWalletService>((ref) {
  return SolanaWalletService();
});

// Wallet State Provider
final walletStateProvider = StateNotifierProvider<WalletStateNotifier, WalletState>((ref) {
  final walletService = ref.watch(walletServiceProvider);
  return WalletStateNotifier(walletService);
});

// Wallet State
class WalletState {
  final String publicKey;
  final double balance;
  final bool isConnected;

  WalletState({
    this.publicKey = '',
    this.balance = 0.0,
    this.isConnected = false,
  });

  WalletState copyWith({
    String? publicKey,
    double? balance,
    bool? isConnected,
  }) {
    return WalletState(
      publicKey: publicKey ?? this.publicKey,
      balance: balance ?? this.balance,
      isConnected: isConnected ?? this.isConnected,
    );
  }
}

// Wallet State Notifier
class WalletStateNotifier extends StateNotifier<WalletState> {
  final SolanaWalletService _walletService;

  WalletStateNotifier(this._walletService) : super(WalletState());

  Future<void> connectWallet() async {
    try {
      await _walletService.initializeWallet();
      final publicKey = await _walletService.getPublicKey();
      final balance = await _walletService.getBalance();

      state = state.copyWith(
        publicKey: publicKey,
        balance: balance,
        isConnected: true,
      );
    } catch (e) {
      state = state.copyWith(isConnected: false);
      rethrow;
    }
  }

  Future<void> refreshBalance() async {
    if (!state.isConnected) return;

    try {
      final balance = await _walletService.getBalance();
      state = state.copyWith(balance: balance);
    } catch (e) {
      // Handle balance refresh error
      print('Balance refresh error: $e');
    }
  }

  Future<void> sendSol(String recipientAddress, double amount) async {
    if (!state.isConnected) throw Exception('Wallet not connected');

    try {
      await _walletService.sendSol(recipientAddress, amount);
      await refreshBalance();
    } catch (e) {
      rethrow;
    }
  }
}
