import 'package:flutter/material.dart';

class POSScreen extends StatefulWidget {
  const POSScreen({super.key});

  @override
  State<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends State<POSScreen> {
  final List<CartItem> _cartItems = [];
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _amountReceivedController = TextEditingController();
  double _amountReceived = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaksi Penjualan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // Navigate to transaction history
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Cari produk...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                // Search product
                _addToCart(value);
              },
            ),
          ),
          // Cart items
          Expanded(
            child: _cartItems.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 80,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Keranjang kosong',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Silakan tambahkan produk ke keranjang',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(item.productName),
                          subtitle: Text(
                              '${item.quantity} x Rp ${item.price.toStringAsFixed(0)}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  _decreaseQuantity(index);
                                },
                              ),
                              Text('${item.quantity}'),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  _increaseQuantity(index);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _removeFromCart(index);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          // Payment section
          if (_cartItems.isNotEmpty) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Rp ${_calculateTotal().toStringAsFixed(0)}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _amountReceivedController,
                    decoration: const InputDecoration(
                      labelText: 'Jumlah Bayar',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _amountReceived = double.tryParse(value) ?? 0.0;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Kembalian:',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Rp ${_calculateChange().toStringAsFixed(0)}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _processPayment,
                    child: const Text('Proses Pembayaran'),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _addToCart(String productCode) {
    // In a real app, this would search for the product in the database
    // For demo purposes, we'll add a sample product
    setState(() {
      _cartItems.add(
        CartItem(
          productName: 'Produk $productCode',
          price: 10000.0,
          quantity: 1,
        ),
      );
    });
    _searchController.clear();
  }

  void _increaseQuantity(int index) {
    setState(() {
      _cartItems[index].quantity++;
    });
  }

  void _decreaseQuantity(int index) {
    setState(() {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      } else {
        _cartItems.removeAt(index);
      }
    });
  }

  void _removeFromCart(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  double _calculateTotal() {
    return _cartItems.fold(
        0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  double _calculateChange() {
    return _amountReceived - _calculateTotal();
  }

  void _processPayment() {
    if (_amountReceived < _calculateTotal()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jumlah bayar tidak mencukupi'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Process payment logic here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pembayaran berhasil'),
        backgroundColor: Colors.green,
      ),
    );

    // Clear cart
    setState(() {
      _cartItems.clear();
      _amountReceived = 0.0;
      _amountReceivedController.clear();
    });
  }
}

class CartItem {
  String productName;
  double price;
  int quantity;

  CartItem({
    required this.productName,
    required this.price,
    required this.quantity,
  });
}