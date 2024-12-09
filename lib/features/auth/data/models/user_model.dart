import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String username;
  final String walletAddress;
  final String publicKey;
  final String privateKey;

  const UserModel({
    required this.username,
    required this.walletAddress,
    required this.publicKey,
    required this.privateKey,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'walletAddress': walletAddress,
    'publicKey': publicKey,
    'privateKey': privateKey,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    username: json['username'],
    walletAddress: json['walletAddress'],
    publicKey: json['publicKey'],
    privateKey: json['privateKey'],
  );

  @override
  List<Object?> get props => [username, walletAddress, publicKey];
}
