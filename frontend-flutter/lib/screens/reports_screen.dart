import 'package:flutter/material.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _selectedPeriod = '7_days';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Penjualan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period selector
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Periode Laporan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: '7_days', label: Text('7 Hari')),
                        ButtonSegment(value: '30_days', label: Text('30 Hari')),
                        ButtonSegment(value: '90_days', label: Text('90 Hari')),
                      ],
                      selected: {_selectedPeriod},
                      onSelectionChanged: (Set<String> newSelection) {
                        setState(() {
                          _selectedPeriod = newSelection.first;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Summary cards
            const Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'Total Penjualan',
                    value: 'Rp 50.000.000',
                    change: '+12%',
                    isPositive: true,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: SummaryCard(
                    title: 'Total Transaksi',
                    value: '1.250',
                    change: '+8%',
                    isPositive: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'Rata-rata Transaksi',
                    value: 'Rp 40.000',
                    change: '+5%',
                    isPositive: true,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: SummaryCard(
                    title: 'Produk Terlaris',
                    value: 'Kopi Latte',
                    change: '150 pcs',
                    isPositive: null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Chart placeholder
            const Text(
              'Grafik Penjualan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'Grafik Penjualan akan ditampilkan di sini',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Top products
            const Text(
              'Produk Terlaris',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const TopProductsList(),
          ],
        ),
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final bool? isPositive;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.change,
    this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            if (isPositive != null)
              Row(
                children: [
                  Icon(
                    isPositive! ? Icons.arrow_upward : Icons.arrow_downward,
                    color: isPositive! ? Colors.green : Colors.red,
                    size: 16,
                  ),
                  Text(
                    change,
                    style: TextStyle(
                      color: isPositive! ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class TopProductsList extends StatelessWidget {
  const TopProductsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Text('${index + 1}'),
            ),
            title: Text('Produk ${index + 1}'),
            subtitle: Text('Terjual: ${(5 - index) * 30} pcs'),
            trailing: Text('Rp ${(5 - index) * 150000}'),
          );
        },
      ),
    );
  }
}