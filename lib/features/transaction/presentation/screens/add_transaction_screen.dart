// lib/features/transaction/presentation/screens/add_transaction_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/transaction_model.dart';
import '../providers/transaction_provider.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  TransactionType _selectedType = TransactionType.expense;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submitData() {
    final title = _titleController.text.trim();
    final amountText = _amountController.text.trim();
    final double? amount = double.tryParse(amountText);

    if (title.isEmpty || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi judul dan nominal dengan benar!')),
      );
      return;
    }

    ref.read(transactionProvider.notifier).addTransaction(
          title: title,
          amount: amount,
          type: _selectedType,
        );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Transaksi'),
        centerTitle: true,
      ),
      // Gunakan SingleChildScrollView agar tidak overflow saat keyboard terbuka
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Field Judul
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Judul Transaksi',
                border: OutlineInputBorder(),
                hintText: 'Contoh: Beli Bensin, Honor Project, dll',
              ),
            ),
            const SizedBox(height: 16),

            // Field Nominal
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nominal (Rp)',
                border: OutlineInputBorder(),
                hintText: 'Contoh: 50000',
              ),
            ),
            const SizedBox(height: 16),

            // Pilihan Jenis Transaksi
            SegmentedButton(
              segments: const [
                ButtonSegment(
                  value: TransactionType.expense,
                  label: Text('Pengeluaran'),
                  icon: Icon(Icons.arrow_upward, color: Colors.red),
                ),
                ButtonSegment(
                  value: TransactionType.income,
                  label: Text('Pemasukan'),
                  icon: Icon(Icons.arrow_downward, color: Colors.green),
                ),
              ],
              selected: {_selectedType},
              onSelectionChanged: (newSelection) {
                setState(() {
                  _selectedType = newSelection.first;
                });
              },
            ),
            const SizedBox(height: 24),

            // Tombol Simpan
            ElevatedButton(
              onPressed: _submitData,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
              child: const Text('Simpan Transaksi', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}