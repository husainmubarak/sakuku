// lib/features/transaction/data/repositories/transaction_repository.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/transaction_model.dart';

class TransactionRepository {
  final SupabaseClient _client;

  TransactionRepository(this._client);

  // READ: Ambil daftar transaksi milik user yang sedang login
  Future<List<TransactionModel>> fetchTransactions() async {
    final response = await _client
        .from('transactions')
        .select()
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => TransactionModel.fromJson(json))
        .toList();
  }

  // CREATE: Tambah transaksi baru
  Future<void> addTransaction({
    required String title,
    required double amount,
    required TransactionType type,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User tidak terautentikasi!');

    final newTransaction = TransactionModel(
      id: '', // Generated oleh Supabase
      title: title,
      amount: amount,
      type: type,
      date: DateTime.now(),
    );

    await _client.from('transactions').insert(newTransaction.toJson(userId));
  }

  // DELETE: Hapus transaksi berdasarkan ID
  Future<void> deleteTransaction(String id) async {
    await _client.from('transactions').delete().eq('id', id);
  }
}