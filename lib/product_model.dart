class ProductResponse {
  final bool success;
  final ProductData data;

  ProductResponse({required this.success, required this.data});

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      success: json['success'],
      data: ProductData.fromJson(json['data']),
    );
  }
}

class ProductData {
  final List<Product> results;
  final int count;

  ProductData({required this.results, required this.count});

  factory ProductData.fromJson(Map<String, dynamic> json) {
    var list = json['results'] as List;
    List<Product> productList = list.map((i) => Product.fromJson(i)).toList();

    return ProductData(
      results: productList,
      count: json['count'],
    );
  }
}

class Product {
  final int id;
  final String title;
  final String? image;
  final double price;
  final int stock;
  final String description;
  final Category category;
  final String returnPolicy;

  Product({
    required this.id,
    required this.title,
    this.image,
    required this.price,
    required this.stock,
    required this.description,
    required this.category,
    required this.returnPolicy,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      image: json['image'], // Nullable
      price: json['price'].toDouble(),
      stock: json['stock'],
      description: json['description'],
      category: Category.fromJson(json['category']),
      returnPolicy: json['return_policy'] ?? "No return policy available",
    );
  }
}

class Category {
  final int id;
  final String categoryName;
  final String? image; // Nullable

  Category({
    required this.id,
    required this.categoryName,
    this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      categoryName: json['category_name'],
      image: json['image'], // Nullable
    );
  }
}
