import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'category_screen.dart';
import 'search_page.dart';
import 'search_bar.dart';
import '../CategoryModel.dart' as category_model;
import '../product_model.dart' as product_model;
import '../services/api_service.dart';
import '../screens/shop_screen.dart';
import 'product_details_screen.dart';
import 'cart_screen.dart';
import '../screens/side_drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // GlobalKey for Scaffold
  final List<String> imagePaths = [
    'lib/assets/imageslider1.jpg',
    'lib/assets/imageslider2.jpg',
    'lib/assets/imageslider3.png',
  ];

  final ApiService _apiService = ApiService();
  List<category_model.Category> _categories = [];
  List<product_model.Product> _featuredProducts = [];
  bool _isLoadingCategories = true;
  bool _isLoadingProducts = true;
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchFeaturedProducts();
  }

  // Fetch categories
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

  // Fetch featured
  void _fetchFeaturedProducts() async {
    try {
      final products = await _apiService.fetchProducts();
      setState(() {
        _featuredProducts = products;
        _isLoadingProducts = false;
      });
    } catch (error) {
      print('Error fetching products: $error');
    }
  }

  // Handle bottom navigation
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CartScreen()),
      );
    } else if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else if (index == 2) {
      _scaffoldKey.currentState?.openDrawer();
    }
  }

  // Handle search
  void _onSearchSubmitted(String query) {
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchPage(searchQuery: query),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,  // Assign the global key to the Scaffold
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('lib/assets/logo.png'),
        ),
        title: CustomSearchBar(
          controller: _searchController,
          onSubmitted: _onSearchSubmitted,
        ),
        backgroundColor: const Color(0xFF1A1A19),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          width: 250.0,  // Set the width of the drawer
          child: SideDrawer(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          _buildImageSlider(),
          _buildCategoriesSection(),
          const SizedBox(height: 16),
          _buildBannerImage(),
          const SizedBox(height: 16),
          _buildServiceSection(),
          const SizedBox(height: 16),
          _buildFeaturedProducts(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Image slider
  Widget _buildImageSlider() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SizedBox(
        height: 145,
        child: Swiper(
          itemBuilder: (context, index) => Image.asset(
            imagePaths[index],
            fit: BoxFit.cover,
          ),
          itemCount: imagePaths.length,
          autoplay: true,
          pagination: SwiperPagination(
            builder: DotSwiperPaginationBuilder(
                activeColor: Colors.orange,
                color: Colors.orangeAccent[100]!),
          ),
        ),
      ),
    );
  }

  // Categories section
  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ShopScreen()),
                );
              },
              child: const Text(
                'Shop More',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _isLoadingCategories
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 0.8,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final category = _categories[index];
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryScreen(
                    categoryName: category.categoryName,
                  ),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      category.imageUrl,
                      height: 55,
                      width: 55,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category.categoryName,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  // Banner image
  Widget _buildBannerImage() {
    return Image.asset(
      'lib/assets/banner1.jpg',
      fit: BoxFit.cover,
    );
  }

  // Service section
  Widget _buildServiceSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildServiceItem(Icons.local_shipping, 'Free Delivery'),
          _buildServiceItem(Icons.shopping_cart, 'Buy More, Save More'),
          _buildServiceItem(Icons.support_agent, '24/7 Support'),
        ],
      ),
    );
  }

  // Featured products
  Widget _buildFeaturedProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        _isLoadingProducts
            ? Center(child: CircularProgressIndicator())
            : GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _featuredProducts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final product = _featuredProducts[index];
            return GestureDetector(
              onTap: () {
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
                      child: Text(
                        product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Rs. ${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // widget for the service section
  Widget _buildServiceItem(IconData icon, String label) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.black,
          size: 30,
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  // Bottom navigation bar
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Profile',
        ),
      ],
    );
  }
}
