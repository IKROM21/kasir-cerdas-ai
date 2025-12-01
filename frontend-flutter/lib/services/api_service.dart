import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../models/customer.dart';
import '../models/transaction.dart';
import '../models/api_response.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  static const String accessTokenKey = 'access_token';

  String? _accessToken;

  void setAccessToken(String token) {
    _accessToken = token;
  }

  Map<String, String> getHeaders() {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (_accessToken != null) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }

    return headers;
  }

  // Auth endpoints
  Future<ApiResponse<User>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: getHeaders(),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success']) {
        final userData = jsonResponse['data'];
        setAccessToken(userData['token']);
        return ApiResponse.fromJson(
          jsonResponse,
          (data) => User.fromJson(data['user']),
        );
      } else {
        return ApiResponse(success: false, message: jsonResponse['message']);
      }
    } else {
      return ApiResponse(success: false, message: 'Login failed');
    }
  }

  Future<ApiResponse<User>> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: getHeaders(),
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success']) {
        final userData = jsonResponse['data'];
        setAccessToken(userData['token']);
        return ApiResponse.fromJson(
          jsonResponse,
          (data) => User.fromJson(data['user']),
        );
      } else {
        return ApiResponse(success: false, message: jsonResponse['message']);
      }
    } else {
      return ApiResponse(success: false, message: 'Registration failed');
    }
  }

  Future<bool> logout() async {
    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: getHeaders(),
    );

    if (response.statusCode == 200) {
      _accessToken = null;
      return true;
    } else {
      return false;
    }
  }

  // Dashboard endpoint
  Future<Map<String, dynamic>> getDashboardData() async {
    final response = await http.get(
      Uri.parse('$baseUrl/dashboard'),
      headers: getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load dashboard data');
    }
  }

  // Category endpoints
  Future<ApiListResponse<Category>> getCategories() async {
    final response = await http.get(
      Uri.parse('$baseUrl/categories'),
      headers: getHeaders(),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ApiListResponse.fromJson(jsonResponse, Category.fromJson);
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<ApiResponse<Category>> getCategory(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/categories/$id'),
      headers: getHeaders(),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ApiResponse.fromJson(jsonResponse, Category.fromJson);
    } else {
      throw Exception('Failed to load category');
    }
  }

  Future<ApiResponse<Category>> createCategory(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/categories'),
      headers: getHeaders(),
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      return ApiResponse.fromJson(jsonResponse, Category.fromJson);
    } else {
      throw Exception('Failed to create category');
    }
  }

  Future<ApiResponse<Category>> updateCategory(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/categories/$id'),
      headers: getHeaders(),
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ApiResponse.fromJson(jsonResponse, Category.fromJson);
    } else {
      throw Exception('Failed to update category');
    }
  }

  Future<bool> deleteCategory(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/categories/$id'),
      headers: getHeaders(),
    );

    return response.statusCode == 200;
  }

  // Product endpoints
  Future<ApiListResponse<Product>> getProducts({Map<String, dynamic>? filters}) async {
    var url = '$baseUrl/products';
    
    if (filters != null && filters.isNotEmpty) {
      final queryParams = <String>[];
      filters.forEach((key, value) {
        queryParams.add('$key=$value');
      });
      url += '?${queryParams.join('&')}';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: getHeaders(),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ApiListResponse.fromJson(jsonResponse, Product.fromJson);
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<ApiResponse<Product>> getProduct(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/$id'),
      headers: getHeaders(),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ApiResponse.fromJson(jsonResponse, Product.fromJson);
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<ApiResponse<Product>> createProduct(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: getHeaders(),
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      return ApiResponse.fromJson(jsonResponse, Product.fromJson);
    } else {
      throw Exception('Failed to create product');
    }
  }

  Future<ApiResponse<Product>> updateProduct(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/products/$id'),
      headers: getHeaders(),
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ApiResponse.fromJson(jsonResponse, Product.fromJson);
    } else {
      throw Exception('Failed to update product');
    }
  }

  Future<ApiResponse<Product>> updateProductStock(int id, int stock) async {
    final response = await http.put(
      Uri.parse('$baseUrl/products/$id/stock'),
      headers: getHeaders(),
      body: jsonEncode({'stock': stock}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ApiResponse.fromJson(jsonResponse, Product.fromJson);
    } else {
      throw Exception('Failed to update product stock');
    }
  }

  Future<bool> deleteProduct(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/products/$id'),
      headers: getHeaders(),
    );

    return response.statusCode == 200;
  }

  // Customer endpoints
  Future<ApiListResponse<Customer>> getCustomers({Map<String, dynamic>? filters}) async {
    var url = '$baseUrl/customers';
    
    if (filters != null && filters.isNotEmpty) {
      final queryParams = <String>[];
      filters.forEach((key, value) {
        queryParams.add('$key=$value');
      });
      url += '?${queryParams.join('&')}';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: getHeaders(),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ApiListResponse.fromJson(jsonResponse, Customer.fromJson);
    } else {
      throw Exception('Failed to load customers');
    }
  }

  Future<ApiResponse<Customer>> getCustomer(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/customers/$id'),
      headers: getHeaders(),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ApiResponse.fromJson(jsonResponse, Customer.fromJson);
    } else {
      throw Exception('Failed to load customer');
    }
  }

  Future<ApiResponse<Customer>> createCustomer(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/customers'),
      headers: getHeaders(),
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      return ApiResponse.fromJson(jsonResponse, Customer.fromJson);
    } else {
      throw Exception('Failed to create customer');
    }
  }

  Future<ApiResponse<Customer>> updateCustomer(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/customers/$id'),
      headers: getHeaders(),
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ApiResponse.fromJson(jsonResponse, Customer.fromJson);
    } else {
      throw Exception('Failed to update customer');
    }
  }

  Future<bool> deleteCustomer(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/customers/$id'),
      headers: getHeaders(),
    );

    return response.statusCode == 200;
  }

  // Transaction endpoints
  Future<ApiListResponse<Transaction>> getTransactions({Map<String, dynamic>? filters}) async {
    var url = '$baseUrl/transactions';
    
    if (filters != null && filters.isNotEmpty) {
      final queryParams = <String>[];
      filters.forEach((key, value) {
        queryParams.add('$key=$value');
      });
      url += '?${queryParams.join('&')}';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: getHeaders(),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ApiListResponse.fromJson(jsonResponse, Transaction.fromJson);
    } else {
      throw Exception('Failed to load transactions');
    }
  }

  Future<ApiResponse<Transaction>> getTransaction(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/transactions/$id'),
      headers: getHeaders(),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ApiResponse.fromJson(jsonResponse, Transaction.fromJson);
    } else {
      throw Exception('Failed to load transaction');
    }
  }

  Future<ApiResponse<Transaction>> createTransaction(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/transactions'),
      headers: getHeaders(),
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      return ApiResponse.fromJson(jsonResponse, Transaction.fromJson);
    } else {
      throw Exception('Failed to create transaction');
    }
  }

  Future<ApiResponse<Transaction>> completeTransaction(int id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/transactions/$id/complete'),
      headers: getHeaders(),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ApiResponse.fromJson(jsonResponse, Transaction.fromJson);
    } else {
      throw Exception('Failed to complete transaction');
    }
  }

  Future<Map<String, dynamic>> getSalesReport() async {
    final response = await http.get(
      Uri.parse('$baseUrl/transactions/report/sales'),
      headers: getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load sales report');
    }
  }

  // AI endpoints
  Future<Map<String, dynamic>> getProductRecommendations() async {
    final response = await http.get(
      Uri.parse('$baseUrl/ai/recommendations'),
      headers: getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load product recommendations');
    }
  }

  Future<Map<String, dynamic>> getSlowMovingProducts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/ai/slow-products'),
      headers: getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load slow moving products');
    }
  }

  Future<Map<String, dynamic>> getRestockSuggestions() async {
    final response = await http.get(
      Uri.parse('$baseUrl/ai/restock-suggestions'),
      headers: getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load restock suggestions');
    }
  }

  Future<Map<String, dynamic>> getSalesPredictions() async {
    final response = await http.get(
      Uri.parse('$baseUrl/ai/sales-predictions'),
      headers: getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load sales predictions');
    }
  }

  Future<Map<String, dynamic>> getPromoSuggestions() async {
    final response = await http.get(
      Uri.parse('$baseUrl/ai/promo-suggestions'),
      headers: getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load promo suggestions');
    }
  }
}