// lib/features/summary/presentation/providers/summary_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../transaction/data/models/transaction_model.dart';
import '../../../transaction/presentation/providers/transaction_provider.dart';

// Model untuk data grafik bulanan
class MonthlyData {
  final String monthLabel; // contoh: "Jan", "Feb"
  final double income;
  final double expense;

  MonthlyData({
    required this.monthLabel,
    required this.income,
    required this.expense,
  });
}

// Model ringkasan keuangan lengkap
class FinancialSummary {
  final double totalIncome;
  final double totalExpense;
  final double balance;
  final List<MonthlyData> monthlyStats;

  FinancialSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
    required this.monthlyStats,
  });
}

final summaryProvider = Provider<FinancialSummary>((ref) {
  final asyncTransactions = ref.watch(transactionProvider);
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

  // --- LOGIKA PENGELOMPOKAN DATA 6 BULAN TERAKHIR ---
  final Map<String, Map<String, double>> monthlyMap = {};
  final now = DateTime.now();

  // Inisialisasi 6 bulan terakhir dengan nilai 0
  for (int i = 5; i >= 0; i--) {
    final date = DateTime(now.year, now.month - i, 1);
    final key = DateFormat('MMM').format(date); // Format singkatan bulan (e.g. Jan, Feb)
    monthlyMap[key] = {'income': 0.0, 'expense': 0.0};
  }

  // Kelompokkan data transaksi ke dalam bulan masing-masing
  for (final item in transactions) {
    final key = DateFormat('MMM').format(item.date);
    if (monthlyMap.containsKey(key)) {
      if (item.type == TransactionType.income) {
        monthlyMap[key]!['income'] = (monthlyMap[key]!['income'] ?? 0) + item.amount;
      } else {
        monthlyMap[key]!['expense'] = (monthlyMap[key]!['expense'] ?? 0) + item.amount;
      }
    }
  }

  final List<MonthlyData> monthlyStats = monthlyMap.entries.map((entry) {
    return MonthlyData(
      monthLabel: entry.key,
      income: entry.value['income']!,
      expense: entry.value['expense']!,
    );
  }).toList();

  return FinancialSummary(
    totalIncome: income,
    totalExpense: expense,
    balance: income - expense,
    monthlyStats: monthlyStats,
  );
});