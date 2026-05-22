import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/wallet_repository.dart';

final balanceProvider = FutureProvider.family<int, String>((ref, userId) async {
  final repo = ref.watch(walletRepositoryProvider);
  return repo.getBalance(userId);
});

final transactionsProvider = FutureProvider.family<List<Transaction>, String>((ref, userId) async {
  final repo = ref.watch(walletRepositoryProvider);
  return repo.getTransactions(userId);
});
