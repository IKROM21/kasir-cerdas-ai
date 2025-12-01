import 'package:flutter/material.dart';

class AIFeaturesScreen extends StatelessWidget {
  const AIFeaturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Recommendations'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rekomendasi Produk',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const ProductRecommendationsList(),
            const SizedBox(height: 30),
            const Text(
              'Produk Slow-moving',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const SlowMovingProductsList(),
            const SizedBox(height: 30),
            const Text(
              'Saran Restock',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const RestockSuggestionsList(),
            const SizedBox(height: 30),
            const Text(
              'Prediksi Penjualan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const SalesPredictionChart(),
            const SizedBox(height: 30),
            const Text(
              'Promo Otomatis',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const PromoSuggestionsList(),
          ],
        ),
      ),
    );
  }
}

class ProductRecommendationsList extends StatelessWidget {
  const ProductRecommendationsList({super.key});

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
            title: Text('Produk Rekomendasi ${index + 1}'),
            subtitle: Text('Terjual: ${(index + 1) * 50} pcs'),
            trailing: const Icon(Icons.trending_up, color: Colors.green),
          );
        },
      ),
    );
  }
}

class SlowMovingProductsList extends StatelessWidget {
  const SlowMovingProductsList({super.key});

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
              backgroundColor: Colors.orange[100],
              child: Text('${index + 1}'),
            ),
            title: Text('Produk Slow-moving ${index + 1}'),
            subtitle: Text('Terjual: ${(5 - index)} pcs dalam 30 hari'),
            trailing: const Icon(Icons.trending_down, color: Colors.red),
          );
        },
      ),
    );
  }
}

class RestockSuggestionsList extends StatelessWidget {
  const RestockSuggestionsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) {
          final priority = index == 0 ? 'Tinggi' : (index < 3 ? 'Sedang' : 'Rendah');
          final color = index == 0 ? Colors.red : (index < 3 ? Colors.orange : Colors.green);
          
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: color[100],
              child: Icon(index == 0 ? Icons.error : Icons.info, color: color),
            ),
            title: Text('Produk ${index + 1}'),
            subtitle: Text('Stok saat ini: ${index * 2} pcs'),
            trailing: Chip(
              label: Text(priority),
              backgroundColor: color[300],
            ),
          );
        },
      ),
    );
  }
}

class SalesPredictionChart extends StatelessWidget {
  const SalesPredictionChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Prediksi 7 hari ke depan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: CustomPaint(
                painter: SalesChartPainter(),
              ),
            ),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text('Rata-rata/hari'),
                    Text(
                      '15 transaksi',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Prediksi pendapatan'),
                    Text(
                      'Rp 15.000.000',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SalesChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    
    // Sample data points
    final points = [
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.2, size.height * 0.5),
      Offset(size.width * 0.4, size.height * 0.6),
      Offset(size.width * 0.6, size.height * 0.3),
      Offset(size.width * 0.8, size.height * 0.4),
      Offset(size.width, size.height * 0.2),
    ];
    
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    
    canvas.drawPath(path, paint);
    
    // Draw data points
    final pointPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
      
    for (final point in points) {
      canvas.drawCircle(point, 5, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PromoSuggestionsList extends StatelessWidget {
  const PromoSuggestionsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.purple[100],
              child: const Icon(Icons.local_offer, color: Colors.purple),
            ),
            title: Text('Diskon ${(index + 2) * 5}% untuk Produk ${index + 1}'),
            subtitle: const Text('Alasan: Penjualan rendah 30 hari terakhir'),
            trailing: ElevatedButton(
              onPressed: () {
                // Apply promo
              },
              child: const Text('Terapkan'),
            ),
          );
        },
      ),
    );
  }
}