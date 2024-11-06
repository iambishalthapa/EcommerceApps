import 'dart:convert';
import 'package:http/http.dart' as http;
import '../CategoryModel.dart' as category_model;
import '../product_model.dart' as product_model;

class ApiService {
  // URL for fetching categories
  final String categoriesApiUrl = 'https://admin.wwginvestment.com/api/product/Product_category/';

  // URL for fetching all products
  final String productsApiUrl = 'https://admin.wwginvestment.com/api/product/all/';

  /// Fetch categories from the API
  Future<List<category_model.Category>> fetchCategories() async {
    final response = await http.get(Uri.parse(categoriesApiUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> results = jsonData['data']['results'];

      // Map each JSON result into a Category object
      return results.map((json) => category_model.Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
  Future<List<product_model.Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('https://admin.wwginvestment.com/api/product/all/'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> results = jsonData['data']['results']; //  API response structure

      return results.map((json) => product_model.Product.fromJson(json)).toList(); //  Product model
    } else {
      throw Exception('Failed to load products');
    }
  }
  Future<product_model.Product> fetchProductById(int id) async {
    final response = await http.get(Uri.parse('https://admin.wwginvestment.com/api/product/all/$id/'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body)['data'];
      return product_model.Product.fromJson(jsonData);
    } else {
      throw Exception('Failed to load product details');
    }
  }
}
