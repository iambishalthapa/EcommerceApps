import 'package:flutter/material.dart';
import 'product_details_screen.dart';
import 'search_bar.dart';
import '../services/api_service.dart';
import '../product_model.dart' as product_model;

class CategoryScreen extends StatefulWidget {
  final String categoryName;

  const CategoryScreen({Key? key, required this.categoryName}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String? selectedFilter;
  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService();
  List<product_model.Product> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProductsByCategory();
  }

  Future<void> _fetchProductsByCategory() async {
    try {
      // Fetch all products
      final allProducts = await _apiService.fetchProducts();
      setState(() {
        // Filter products based on the selected category
        _products = allProducts.where((product) => product.category.categoryName == widget.categoryName).toList();
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
        backgroundColor: const Color(0xFF1A1A19),
        iconTheme: IconThemeData(color: Colors.white),
        title: CustomSearchBar(
          controller: _searchController,
          onSubmitted: _performSearch,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Filter Options
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilter = 'Filter';
                      });
                    },
                    child: _buildFilterOption('Filter', true),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilter = 'Best Match';
                      });
                    },
                    child: _buildTextOption('Best Match'),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilter = 'Top Sales';
                      });
                    },
                    child: _buildTextOption('Top Sales'),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilter = 'Discount';
                      });
                    },
                    child: _buildTextOption('Discount'),
                  ),
                ],
              ),
            ),
            // Product List
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to ProductDetailsScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(product: product),
                        ),
                      );
                    },
                    child: Card(
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.network(
                              product.image ?? 'https://via.placeholder.com/150',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.title,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
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
          ],
        ),
      ),
    );
  }

  void _performSearch(String query) {
    // Implement the search functionality
    print('Searching for: $query');

  }

  Widget _buildFilterOption(String title, bool isRectangle) {
    return Container(
      decoration: BoxDecoration(
        border: isRectangle
            ? Border.all(color: Colors.orange, width: 2)
            : null,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text(
        title,
        style: TextStyle(
          color: selectedFilter == title ? Colors.orange : Colors.black,
        ),
      ),
    );
  }

  Widget _buildTextOption(String title) {
    return Text(
      title,
      style: TextStyle(
        color: selectedFilter == title ? Colors.orange : Colors.black,
      ),
    );
  }
}
