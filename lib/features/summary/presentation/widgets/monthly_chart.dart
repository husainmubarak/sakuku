// lib/features/summary/presentation/widgets/monthly_chart.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/summary_provider.dart';

class MonthlyChart extends StatelessWidget {
  final List<MonthlyData> monthlyData;

  const MonthlyChart({super.key, required this.monthlyData});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.compactCurrency(
      locale: 'id_ID',
      symbol: '',
    );

    double maxY = 0;
    for (var data in monthlyData) {
      if (data.income > maxY) maxY = data.income;
      if (data.expense > maxY) maxY = data.expense;
    }
    if (maxY == 0) maxY = 100000; // Default jika belum ada data

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Grafik Keuangan Bulanan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            // Keterangan Warna (Legend)
            const Row(
              children: [
                Icon(Icons.circle, color: Colors.green, size: 12),
                SizedBox(width: 4),
                Text('Pemasukan', style: TextStyle(fontSize: 12)),
                SizedBox(width: 16),
                Icon(Icons.circle, color: Colors.red, size: 12),
                SizedBox(width: 4),
                Text('Pengeluaran', style: TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  maxY: maxY * 1.2, 
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final isIncome = rodIndex == 0;
                        final label = isIncome ? 'Masuk' : 'Keluar';
                        final val = NumberFormat.currency(
                          locale: 'id_ID',
                          symbol: 'Rp ',
                          decimalDigits: 0,
                        ).format(rod.toY);
                        return BarTooltipItem(
                          '$label\n$val',
                          const TextStyle(color: Colors.white, fontSize: 12),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 42,
                        getTitlesWidget: (value, meta) {
                          if (value == 0) return const SizedBox.shrink();
                          return Text(
                            currencyFormat.format(value),
                            style: const TextStyle(color: Colors.grey, fontSize: 10),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < monthlyData.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                monthlyData[index].monthLabel,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: true, drawVerticalLine: false),
                  barGroups: monthlyData.asMap().entries.map((entry) {
                    final index = entry.key;
                    final data = entry.value;

                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        // Batang Pemasukan (Hijau)
                        BarChartRodData(
                          toY: data.income,
                          color: Colors.green,
                          width: 10,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        // Batang Pengeluaran (Merah)
                        BarChartRodData(
                          toY: data.expense,
                          color: Colors.red,
                          width: 10,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}