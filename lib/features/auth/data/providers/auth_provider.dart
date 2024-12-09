import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solana/solana.dart';
import 'package:solrina/features/auth/data/models/user_model.dart';

final authProvider = StateNotifierProvider<AuthNotifier, UserModel?>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<UserModel?> {
  AuthNotifier() : super(null) {
    _loadUser();
  }

  static const _userKey = 'user_data';
  static const _passcodeKey = 'user_passcode';

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userKey);
    if (userData != null) {
      state = UserModel.fromJson(jsonDecode(userData));
    }
  }

  Future<void> createAccount(String username, String passcode) async {
    final prefs = await SharedPreferences.getInstance();
    final wallet = await Ed25519HDKeyPair.random();
    final address = wallet.address;
    final publicKey = wallet.publicKey.toString();
    final keyPair = await wallet.extract();
    final privateKeyBytes = keyPair.bytes.sublist(0, 32);
    final privateKey = base58encode(privateKeyBytes);
    
    final user = UserModel(
      username: username,
      walletAddress: address,
      publicKey: publicKey,
      privateKey: privateKey,
    );

    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    await prefs.setString(_passcodeKey, passcode);
    
    state = user;
  }

  Future<bool> verifyPasscode(String passcode) async {
    final prefs = await SharedPreferences.getInstance();
    final savedPasscode = prefs.getString(_passcodeKey);
    return savedPasscode == passcode;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    state = null;
  }

  bool get isAuthenticated => state != null;
}

String base58encode(List<int> bytes) {
  const alphabet = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';
  var num = BigInt.zero;
  var leadingZeros = 0;
  
  while (leadingZeros < bytes.length && bytes[leadingZeros] == 0) {
    leadingZeros++;
  }

  for (var byte in bytes) {
    num = num * BigInt.from(256) + BigInt.from(byte);
  }

  var result = '';
  while (num > BigInt.zero) {
    var remainder = (num % BigInt.from(58)).toInt();
    num = num ~/ BigInt.from(58);
    result = alphabet[remainder] + result;
  }

  return '1' * leadingZeros + result;
}
