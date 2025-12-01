import 'user.dart';
import 'customer.dart';

class Transaction {
  final int id;
  final String invoiceNumber;
  final int? customerId;
  final int userId;
  final double totalAmount;
  final double paidAmount;
  final double changeAmount;
  final String status;
  final String? notes;
  final String createdAt;
  final String updatedAt;
  final Customer? customer;
  final User? user;

  Transaction({
    required this.id,
    required this.invoiceNumber,
    this.customerId,
    required this.userId,
    required this.totalAmount,
    required this.paidAmount,
    required this.changeAmount,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.customer,
    this.user,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      invoiceNumber: json['invoice_number'],
      customerId: json['customer_id'],
      userId: json['user_id'],
      totalAmount: json['total_amount'].toDouble(),
      paidAmount: json['paid_amount'].toDouble(),
      changeAmount: json['change_amount'].toDouble(),
      status: json['status'],
      notes: json['notes'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      customer: json['customer'] != null ? Customer.fromJson(json['customer']) : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoice_number': invoiceNumber,
      'customer_id': customerId,
      'user_id': userId,
      'total_amount': totalAmount,
      'paid_amount': paidAmount,
      'change_amount': changeAmount,
      'status': status,
      'notes': notes,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'customer': customer?.toJson(),
      'user': user?.toJson(),
    };
  }
}