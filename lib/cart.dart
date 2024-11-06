class Cart {
  static final Cart _instance = Cart._internal();
  factory Cart() => _instance;

  final Map<String, CartItem> _items = {};

  Cart._internal();

  Map<String, CartItem> get items => _items;

  // Add item to cart or update quantity
  void addItem(String title, String image, double price, int quantity) {
    if (_items.containsKey(title)) {
      _items[title] = _items[title]!.copyWith(quantity: _items[title]!.quantity + quantity);
    } else {
      _items[title] = CartItem(title, image, price, quantity);
    }
  }

  void clear() {
    _items.clear(); // Clear all items from the cart
  }

  int get totalItems {
    return _items.values.fold(0, (sum, item) => sum + item.quantity); // Calculate total quantity
  }
}

class CartItem {
  final String title;
  final String image;
  final double price;
  final int quantity;

  CartItem(this.title, this.image, this.price, this.quantity);

  // Return a copy of the CartItem with updated properties
  CartItem copyWith({String? title, String? image, double? price, int? quantity}) {
    return CartItem(
      title ?? this.title,
      image ?? this.image,
      price ?? this.price,
      quantity ?? this.quantity,
    );
  }
}