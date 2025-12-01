import 'package:flutter/material.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String _selectedFilter = 'all';
  final List<Transaction> _transactions = [
    Transaction(
      id: 1,
      invoiceNumber: 'INV-2023001',
      customerName: 'John Doe',
      amount: 150000,
      status: 'completed',
      date: '2023-05-15 10:30',
    ),
    Transaction(
      id: 2,
      invoiceNumber: 'INV-2023002',
      customerName: 'Jane Smith',
      amount: 85000,
      status: 'completed',
      date: '2023-05-15 14:45',
    ),
    Transaction(
      id: 3,
      invoiceNumber: 'INV-2023003',
      customerName: 'Robert Johnson',
      amount: 220000,
      status: 'pending',
      date: '2023-05-16 09:15',
    ),
    Transaction(
      id: 4,
      invoiceNumber: 'INV-2023004',
      customerName: 'Emily Davis',
      amount: 95000,
      status: 'completed',
      date: '2023-05-16 16:20',
    ),
    Transaction(
      id: 5,
      invoiceNumber: 'INV-2023005',
      customerName: 'Michael Wilson',
      amount: 310000,
      status: 'cancelled',
      date: '2023-05-17 11:10',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryItem('Total', '5'),
                  _buildSummaryItem('Selesai', '3'),
                  _buildSummaryItem('Pending', '1'),
                  _buildSummaryItem('Batal', '1'),
                ],
              ),
            ),
          ),
          // Transaction list
          Expanded(
            child: ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final transaction = _transactions[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(transaction.invoiceNumber),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(transaction.customerName),
                        Text(transaction.date),
                        const SizedBox(height: 5),
                        _buildStatusChip(transaction.status),
                      ],
                    ),
                    trailing: Text(
                      'Rp ${transaction.amount.toString()}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      _showTransactionDetails(transaction);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String text;

    switch (status) {
      case 'completed':
        color = Colors.green;
        text = 'Selesai';
        break;
      case 'pending':
        color = Colors.orange;
        text = 'Pending';
        break;
      case 'cancelled':
        color = Colors.red;
        text = 'Batal';
        break;
      default:
        color = Colors.grey;
        text = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter Transaksi'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('Semua'),
                value: 'all',
                groupValue: _selectedFilter,
                onChanged: (value) {
                  setState(() {
                    _selectedFilter = value!;
                  });
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: const Text('Selesai'),
                value: 'completed',
                groupValue: _selectedFilter,
                onChanged: (value) {
                  setState(() {
                    _selectedFilter = value!;
                  });
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: const Text('Pending'),
                value: 'pending',
                groupValue: _selectedFilter,
                onChanged: (value) {
                  setState(() {
                    _selectedFilter = value!;
                  });
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: const Text('Batal'),
                value: 'cancelled',
                groupValue: _selectedFilter,
                onChanged: (value) {
                  setState(() {
                    _selectedFilter = value!;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTransactionDetails(Transaction transaction) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Detail Transaksi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildDetailRow('No. Invoice', transaction.invoiceNumber),
              _buildDetailRow('Pelanggan', transaction.customerName),
              _buildDetailRow('Tanggal', transaction.date),
              _buildDetailRow('Status', transaction.status),
              const SizedBox(height: 10),
              const Text(
                'Item',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ...[
                TransactionItem('Kopi Latte', 2, 25000),
                TransactionItem('Croissant', 1, 15000),
              ].map((item) => _buildItemRow(item)).toList(),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Rp ${transaction.amount}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Tutup'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildItemRow(TransactionItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text('${item.quantity}x ${item.name}'),
          ),
          Text('Rp ${item.price * item.quantity}'),
        ],
      ),
    );
  }
}

class Transaction {
  final int id;
  final String invoiceNumber;
  final String customerName;
  final int amount;
  final String status;
  final String date;

  Transaction({
    required this.id,
    required this.invoiceNumber,
    required this.customerName,
    required this.amount,
    required this.status,
    required this.date,
  });
}

class TransactionItem {
  final String name;
  final int quantity;
  final int price;

  TransactionItem(this.name, this.quantity, this.price);
}