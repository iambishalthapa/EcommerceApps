import 'package:flutter/material.dart';
import '../cart.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final Cart cart = Cart();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1A1A19),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: cart.items.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Your cart is empty'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/shop'); // Navigate to the ShopScreen
              },
              child: const Text(
                'Continue Shopping',
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: cart.items.length,
        itemBuilder: (context, index) {

          CartItem cartItem = cart.items.values.elementAt(index);

          return ListTile(
            leading: Image.network(
              cartItem.image,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(cartItem.title),
            subtitle: Text('Rs. ${cartItem.price.toStringAsFixed(2)}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    _updateQuantity(cartItem.title, -1);
                  },
                ),
                Text(
                  '${cartItem.quantity}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    _updateQuantity(cartItem.title, 1);
                  },
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total: Rs. ${calculateTotal().toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            ElevatedButton(
              onPressed: () {

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Proceeding to Checkout!')),
                );
              },
              child: const Text(
                'Checkout',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateQuantity(String productName, int change) {
    setState(() {
      CartItem cartItem = cart.items[productName]!;
      if (change < 0 && cartItem.quantity > 1) {
        cart.addItem(cartItem.title, cartItem.image, cartItem.price, -1);
      } else if (change < 0) {
        cart.items.remove(cartItem.title);
      } else {
        cart.addItem(cartItem.title, cartItem.image, cartItem.price, 1);
      }
    });
  }

  double calculateTotal() {
    double total = 0.0;
    cart.items.forEach((productName, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }
}
