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

  // Dari Supabase JSON ke Dart Object
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      date: DateTime.parse(json['created_at'] as String),
    );
  }

  // Dari Dart Object ke JSON Supabase
  Map<String, dynamic> toJson(String userId) {
    return {
      'user_id': userId,
      'title': title,
      'amount': amount,
      'type': type == TransactionType.income ? 'income' : 'expense',
    };
  }
}