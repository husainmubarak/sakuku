// lib/features/transaction/presentation/providers/transaction_provider.dart

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/transaction_model.dart';
import '../../data/repositories/transaction_repository.dart';

// Provider untuk instance TransactionRepository
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepository(Supabase.instance.client);
});

// AsyncNotifier untuk mengelola AsyncValue<List<TransactionModel>>
class TransactionNotifier extends AsyncNotifier<List<TransactionModel>> {
  @override
  FutureOr<List<TransactionModel>> build() async {
    // Ambil data transaksi dari Supabase saat pertama kali Provider di-watch
    return ref.read(transactionRepositoryProvider).fetchTransactions();
  }

  // Tambah transaksi
  Future<void> addTransaction({
    required String title,
    required double amount,
    required TransactionType type,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(transactionRepositoryProvider);
      await repo.addTransaction(title: title, amount: amount, type: type);
      return repo.fetchTransactions();
    });
  }

  // Hapus transaksi
  Future<void> deleteTransaction(String id) async {
    state = await AsyncValue.guard(() async {
      final repo = ref.read(transactionRepositoryProvider);
      await repo.deleteTransaction(id);
      return repo.fetchTransactions();
    });
  }
}

// Global AsyncNotifierProvider
final transactionProvider = AsyncNotifierProvider<TransactionNotifier, List<TransactionModel>>(() {
  return TransactionNotifier();
});