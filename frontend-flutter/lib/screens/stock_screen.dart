import 'package:flutter/material.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  final List<ProductStock> _products = [
    ProductStock(
      id: 1,
      name: 'Kopi Latte',
      currentStock: 25,
      minStock: 10,
      category: 'Minuman',
    ),
    ProductStock(
      id: 2,
      name: 'Croissant',
      currentStock: 5,
      minStock: 15,
      category: 'Makanan',
    ),
    ProductStock(
      id: 3,
      name: 'Smartphone XYZ',
      currentStock: 12,
      minStock: 5,
      category: 'Elektronik',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Stok'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Filter functionality
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
                  _buildSummaryItem('Total Produk', '${_products.length}'),
                  _buildSummaryItem(
                      'Stok Rendah', '${_getLowStockCount()}'),
                  _buildSummaryItem('Out of Stock', '${_getOutOfStockCount()}'),
                ],
              ),
            ),
          ),
          // Product list
          Expanded(
            child: ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                final isLowStock = product.currentStock <= product.minStock;
                final isOutOfStock = product.currentStock == 0;

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(product.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.category),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Text('Stok: '),
                            Text(
                              '${product.currentStock}',
                              style: TextStyle(
                                color: isOutOfStock
                                    ? Colors.red
                                    : (isLowStock ? Colors.orange : Colors.green),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(' / '),
                            Text('${product.minStock} (min)'),
                          ],
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _showEditStockDialog(context, product);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_shopping_cart),
                          onPressed: () {
                            _showRestockDialog(context, product);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddStockDialog(context);
        },
        child: const Icon(Icons.add),
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

  int _getLowStockCount() {
    return _products
        .where((product) =>
            product.currentStock > 0 && product.currentStock <= product.minStock)
        .length;
  }

  int _getOutOfStockCount() {
    return _products.where((product) => product.currentStock == 0).length;
  }

  void _showAddStockDialog(BuildContext context) {
    final nameController = TextEditingController();
    final stockController = TextEditingController();
    final minStockController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tambah Stok Produk'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Produk',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: stockController,
                  decoration: const InputDecoration(
                    labelText: 'Jumlah Stok',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: minStockController,
                  decoration: const InputDecoration(
                    labelText: 'Stok Minimum',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add stock logic
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showEditStockDialog(BuildContext context, ProductStock product) {
    final stockController =
        TextEditingController(text: product.currentStock.toString());
    final minStockController =
        TextEditingController(text: product.minStock.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Stok: ${product.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: stockController,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Stok',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: minStockController,
                decoration: const InputDecoration(
                  labelText: 'Stok Minimum',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                // Edit stock logic
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showRestockDialog(BuildContext context, ProductStock product) {
    final quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Restock: ${product.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Stok saat ini: ${product.currentStock}'),
              const SizedBox(height: 16),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Restock',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                // Restock logic
                Navigator.pop(context);
              },
              child: const Text('Restock'),
            ),
          ],
        );
      },
    );
  }
}

class ProductStock {
  final int id;
  final String name;
  final int currentStock;
  final int minStock;
  final String category;

  ProductStock({
    required this.id,
    required this.name,
    required this.currentStock,
    required this.minStock,
    required this.category,
  });
}