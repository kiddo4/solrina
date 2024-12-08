import 'package:flutter/foundation.dart';
import 'package:solana/solana.dart';
import 'package:bip39/bip39.dart' as bip39;

class SolanaWalletService {
  late Ed25519HDKeyPair _keyPair;
  late SolanaClient _client;

  Future<void> initializeWallet() async {
    try {
      // Generate a new mnemonic and create key pair
      final mnemonic = bip39.generateMnemonic();
      _keyPair = await Ed25519HDKeyPair.fromMnemonic(mnemonic);
      
      // Initialize Solana client (use devnet for testing)
      _client = SolanaClient(
        rpcUrl: Uri.parse('https://api.devnet.solana.com'),
        websocketUrl: Uri.parse('wss://api.devnet.solana.com'),
      );
    } catch (e) {
      debugPrint('Wallet initialization error: $e');
      rethrow;
    }
  }

  Future<String> getPublicKey() async {
    if (_keyPair == null) {
      await initializeWallet();
    }
    return _keyPair.address;
  }

  Future<double> getBalance() async {
    try {
      final balance = await _client.rpcClient.getBalance(
        _keyPair.address,
      );
      
      // Convert lamports to SOL
      return balance.value / lamportsPerSol;
    } catch (e) {
      debugPrint('Balance fetch error: $e');
      return 0.0;
    }
  }

  Future<String> sendSol(String recipientAddress, double amount) async {
    try {
      // Prepare transaction
      final lamports = (amount * lamportsPerSol).toInt();

      // Create transaction
      final message = Message(
        instructions: [
          SystemInstruction.transfer(
            fundingAccount: _keyPair.publicKey,
            recipientAccount: Ed25519HDPublicKey.fromBase58(recipientAddress),
            lamports: lamports,
          ),
        ],
      );

      // Send and confirm transaction
      final signature = await _client.sendAndConfirmTransaction(
        message: message,
        signers: [_keyPair],
        commitment: Commitment.confirmed,
      );

      return signature;
    } catch (e) {
      debugPrint('SOL transfer error: $e');
      rethrow;
    }
  }
}
