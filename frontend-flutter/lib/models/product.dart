import 'category.dart';

class Product {
  final int id;
  final String name;
  final String? description;
  final double price;
  final int stock;
  final String sku;
  final int categoryId;
  final String createdAt;
  final String updatedAt;
  final Category? category;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    required this.sku,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      stock: json['stock'],
      sku: json['sku'],
      categoryId: json['category_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      category: json['category'] != null ? Category.fromJson(json['category']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'sku': sku,
      'category_id': categoryId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'category': category?.toJson(),
    };
  }
}