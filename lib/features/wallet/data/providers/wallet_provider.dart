import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletState {
  final bool isConnected;
  final double balance;
  final String publicKey;

  WalletState({
    this.isConnected = false,
    this.balance = 0.0,
    this.publicKey = '',
  });

  WalletState copyWith({
    bool? isConnected,
    double? balance,
    String? publicKey,
  }) {
    return WalletState(
      isConnected: isConnected ?? this.isConnected,
      balance: balance ?? this.balance,
      publicKey: publicKey ?? this.publicKey,
    );
  }
}

class WalletNotifier extends StateNotifier<WalletState> {
  WalletNotifier() : super(WalletState());

  Future<void> connectWallet() async {
    // TODO: Implement actual wallet connection
    state = state.copyWith(
      isConnected: true,
      balance: 1.5,
      publicKey: '5KoJ8qhUE2yHxNQQ3Nz8rvpH6PbhawXxKKwwRoqBnK1m',
    );
  }

  Future<void> disconnectWallet() async {
    state = WalletState();
  }

  Future<void> refreshBalance() async {
    if (!state.isConnected) return;
    // TODO: Implement actual balance refresh
    state = state.copyWith(
      balance: state.balance + 0.1,
    );
  }
}

final walletStateProvider = StateNotifierProvider<WalletNotifier, WalletState>((ref) {
  return WalletNotifier();
});
