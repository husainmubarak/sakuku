// lib/features/transaction/data/models/transaction_model.dart

enum TransactionType { income, expense }

class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final TransactionType type;
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
  });

  // Method copyWith untuk immutability saat memperbarui data
  TransactionModel copyWith({
    String? id,
    String? title,
    double? amount,
    TransactionType? type,
    DateTime? date,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      date: date ?? this.date,
    );
  }
}