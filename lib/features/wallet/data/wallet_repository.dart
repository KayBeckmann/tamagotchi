import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletRepository {
  // In-memory storage for development
  final Map<String, int> _balances = {};
  final List<Transaction> _transactions = [];

  Future<int> getBalance(String userId) async {
    // TODO: Replace with actual API call
    await Future.delayed(const Duration(milliseconds: 100));
    return _balances[userId] ?? 12500; // Starting balance for testing
  }

  Future<void> addSatoshi(String userId, int amount, String reason) async {
    // TODO: Replace with actual API call
    await Future.delayed(const Duration(milliseconds: 100));
    _balances[userId] = (await getBalance(userId)) + amount;
    
    _transactions.add(Transaction(
      userId: userId,
      title: reason,
      amount: amount,
      isPositive: true,
      timestamp: DateTime.now(),
    ));
  }

  Future<void> removeSatoshi(String userId, int amount, String reason) async {
    // TODO: Replace with actual API call
    await Future.delayed(const Duration(milliseconds: 100));
    final balance = await getBalance(userId);
    if (balance < amount) {
      throw Exception('Unzureichendes Guthaben');
    }
    
    _balances[userId] = balance - amount;
    
    _transactions.add(Transaction(
      userId: userId,
      title: reason,
      amount: amount,
      isPositive: false,
      timestamp: DateTime.now(),
    ));
  }

  Future<List<Transaction>> getTransactions(String userId) async {
    // TODO: Replace with actual API call
    await Future.delayed(const Duration(milliseconds: 100));
    return _transactions.where((t) => t.userId == userId).toList().reversed.toList();
  }
}

class Transaction {
  final String userId;
  final String title;
  final int amount;
  final bool isPositive;
  final DateTime timestamp;

  Transaction({
    required this.userId,
    required this.title,
    required this.amount,
    required this.isPositive,
    required this.timestamp,
  });
}

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  return WalletRepository();
});
