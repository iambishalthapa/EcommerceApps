import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../product_model.dart' as product_model;
import '../cart.dart';
import 'search_page.dart';
import 'search_bar.dart';

class ProductDetailsScreen extends StatefulWidget {
  final product_model.Product product; // Accept product object

  const ProductDetailsScreen({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1; // Initialize quantity
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

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
          onSubmitted: (value) {
            _performSearch(value);
          },
        ),
        backgroundColor: const Color(0xFF1A1A19),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/cart'); // Navigate to Cart Screen
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                product.image ?? 'https://via.placeholder.com/300',
                fit: BoxFit.cover,
                height: 200,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Rs. ${product.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            const SizedBox(height: 8),
            Text(
              product.stock > 0
                  ? 'In Stock: ${product.stock} available'
                  : 'Out of Stock',
              style: TextStyle(
                color: product.stock > 0 ? Colors.green : Colors.red,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.returnPolicy.isNotEmpty
                  ? product.returnPolicy
                  : "No return policy available",
              style: const TextStyle(color: Colors.green),
            ),
            const SizedBox(height: 16),
            const Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Html(
              data: product.description.isNotEmpty ? product.description : "<p>No description available</p>",
              style: {
                "h2": Style(fontSize: FontSize.large, fontWeight: FontWeight.bold),
                "ul": Style(padding: HtmlPaddings.only(left: 20)),
                "li": Style(fontSize: FontSize(16)),
                "p": Style(fontSize: FontSize(16)),
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Quantity:', style: TextStyle(fontSize: 18)),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (quantity > 1) {
                      setState(() {
                        quantity--;
                      });
                    }
                  },
                ),
                Text(quantity.toString(), style: const TextStyle(fontSize: 18)),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (quantity < product.stock) {
                      setState(() {
                        quantity++;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                Cart().addItem(
                  product.title,
                  product.image ?? 'https://via.placeholder.com/300',
                  product.price,
                  quantity,
                ); // Add product to cart with quantity
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Added to cart! Quantity: $quantity')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(150, 50),
              ),
              child: const Text(
                'Add to Cart',
                style: TextStyle(color: Colors.white),
              ),
            ),
            OutlinedButton(
              onPressed: () {
                // Handle buy now functionality
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.yellow),
                minimumSize: const Size(150, 50),
              ),
              child: const Text(
                'Buy Now',
                style: TextStyle(color: Colors.black),
              ),

            ),

          ],
        ),
      ),
    );
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchPage(searchQuery: query),
        ),
      );
    }
  }
}
