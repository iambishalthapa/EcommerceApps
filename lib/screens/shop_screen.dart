import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'search_bar.dart';
import '../CategoryModel.dart' as category_model;
import '../product_model.dart' as product_model;
import '../services/api_service.dart';
import 'product_details_screen.dart';

class ShopScreen extends StatefulWidget {
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final ApiService _apiService = ApiService();
  List<category_model.Category> _categories = [];
  List<product_model.Product> _allProducts = [];
  List<product_model.Product> _filteredProducts = [];
  bool _isLoadingCategories = true;
  bool _isLoadingProducts = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchFeaturedProducts();
  }

  // Fetch categories from the API
  void _fetchCategories() async {
    try {
      final categories = await _apiService.fetchCategories();
      setState(() {
        _categories = categories;
        _isLoadingCategories = false;
      });
    } catch (error) {
      print('Error fetching categories: $error');
    }
  }

  // Fetch products from the API
  void _fetchFeaturedProducts() async {
    try {
      final products = await _apiService.fetchProducts();
      setState(() {
        _allProducts = products;
        _filteredProducts = products;  // Initially display all products
        _isLoadingProducts = false;
      });
    } catch (error) {
      print('Error fetching products: $error');
    }
  }

  // Perform search
  void _performSearch(String query) {
    setState(() {
      // If search query is empty, display all products
      if (query.isEmpty) {
        _filteredProducts = _allProducts;
      } else {
        // Filter products based on the title
        _filteredProducts = _allProducts
            .where((product) => product.title
            .toLowerCase()
            .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: CustomSearchBar(
          controller: _searchController,
          onSubmitted: _performSearch,
        ),
        backgroundColor: const Color(0xFF1A1A19),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _isLoadingProducts
            ? Center(child: CircularProgressIndicator())
            : GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
          itemCount: _filteredProducts.length,
          itemBuilder: (context, index) {
            final product = _filteredProducts[index];
            return GestureDetector(
              onTap: () {
                // Navigate to the product details
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsScreen(
                      product: product,
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    // Display product image
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          product.image ?? 'https://via.placeholder.com/150',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product title
                          ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 40),
                            child: Text(
                              product.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Product price
                          Text(
                            'Rs. ${product.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
