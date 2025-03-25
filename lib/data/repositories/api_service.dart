import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopping_app/data/models/product_model.dart';

class ApiService {
  static const String baseUrl = 'https://dummyjson.com/products';

  Future<List<Product>> fetchProducts(int page, {int limit = 10}) async {
    final response = await http.get(
      Uri.parse('$baseUrl?page=$page&limit=$limit'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> productsJson = data['products'];
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}