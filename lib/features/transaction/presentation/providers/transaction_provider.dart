// lib/features/transaction/presentation/providers/transaction_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/transaction_model.dart';

class TransactionNotifier extends Notifier<List<TransactionModel>> {
  @override
  List<TransactionModel> build() {
    // Memberikan 2 data dummy awal agar tampilan tidak kosong saat dites
    return [
      TransactionModel(
        id: '1',
        title: 'Gaji Bulanan',
        amount: 5000000,
        type: TransactionType.income,
        date: DateTime.now(),
      ),
      TransactionModel(
        id: '2',
        title: 'Beli Kopi & Makan',
        amount: 45000,
        type: TransactionType.expense,
        date: DateTime.now(),
      ),
    ];
  }

  // Fungsi Tambah Transaksi Baru
  void addTransaction({
    required String title,
    required double amount,
    required TransactionType type,
  }) {
    final newTransaction = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      amount: amount,
      type: type,
      date: DateTime.now(),
    );

    // Memperbarui state dengan list baru (Immutability)
    state = [newTransaction, ...state];
  }

  // Fungsi Hapus Transaksi
  void deleteTransaction(String id) {
    state = state.where((item) => item.id != id).toList();
  }
}

// Global Provider
final transactionProvider = NotifierProvider<TransactionNotifier, List<TransactionModel>>(() {
  return TransactionNotifier();
});