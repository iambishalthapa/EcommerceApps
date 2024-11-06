import 'package:flutter/material.dart';
import '../product_model.dart' as product_model;
import '../services/api_service.dart';
import 'product_details_screen.dart';

class SearchPage extends StatefulWidget {
  final String searchQuery;

  const SearchPage({Key? key, required this.searchQuery}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  List<product_model.Product> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _searchProducts(widget.searchQuery);
  }

  void _searchProducts(String query) async {
    try {
      final products = await _apiService.fetchProducts();
      setState(() {
        _filteredProducts = products
            .where((product) =>
            product.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
        _isLoading = false;
      });
    } catch (error) {
      print('Error fetching products: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filteredProducts.isEmpty
          ? const Center(child: Text('No results found.'))
          : ListView.builder(
        itemCount: _filteredProducts.length,
        itemBuilder: (context, index) {
          final product = _filteredProducts[index];
          return ListTile(
            title: Text(product.title),
            subtitle: Text('Rs. ${product.price}'),
            leading: Image.network(
              product.image ?? 'https://via.placeholder.com/150',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            onTap: () {
              // Navigate to the product details
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailsScreen(product: product),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
