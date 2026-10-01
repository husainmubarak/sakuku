// lib/features/summary/presentation/providers/summary_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../transaction/data/models/transaction_model.dart';
import '../../../transaction/presentation/providers/transaction_provider.dart';

class FinancialSummary {
  final double totalIncome;
  final double totalExpense;
  final double balance;

  FinancialSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
  });
}

final summaryProvider = Provider<FinancialSummary>((ref) {
  final asyncTransactions = ref.watch(transactionProvider);
  
  // Ambil data jika sudah ter-load (jika loading/error default ke list kosong)
  final transactions = asyncTransactions.value ?? [];

  double income = 0;
  double expense = 0;

  for (final item in transactions) {
    if (item.type == TransactionType.income) {
      income += item.amount;
    } else {
      expense += item.amount;
    }
  }

  return FinancialSummary(
    totalIncome: income,
    totalExpense: expense,
    balance: income - expense,
  );
});