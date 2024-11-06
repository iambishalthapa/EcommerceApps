import 'package:flutter/material.dart';

class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.orange,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Drawer Header Section
              Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    // Profile Image Placeholder
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                    ),
                    SizedBox(height: 12),
                  ],
                ),
              ),

              // Drawer Menu Items
              _buildDrawerItem(
                text: 'Login',
                icon: Icons.login,
                onTap: () {
                  Navigator.pushNamed(context, '/login');
                },
              ),
              _buildDrawerItem(
                text: 'Sign Up',
                icon: Icons.app_registration,
                onTap: () {
                  Navigator.pushNamed(context, '/signup');
                },
              ),
              _buildDrawerItem(
                text: 'My Account',
                icon: Icons.account_circle,
                onTap: () {
                  Navigator.pushNamed(context, '/account');
                },
              ),
              _buildDrawerItem(
                text: 'Order History',
                icon: Icons.history,
                onTap: () {
                  Navigator.pushNamed(context, '/order-history');
                },
              ),
              _buildDrawerItem(
                text: 'Wishlist',
                icon: Icons.favorite_border,
                onTap: () {
                  Navigator.pushNamed(context, '/wishlist');
                },
              ),
              _buildDrawerItem(
                text: 'Cart',
                icon: Icons.shopping_cart,
                onTap: () {
                  Navigator.pushNamed(context, '/cart');
                },
              ),
              _buildDrawerItem(
                text: 'Settings',
                icon: Icons.settings,
                onTap: () {
                  Navigator.pushNamed(context, '/settings');
                },
              ),
              Divider(color: Colors.white30, thickness: 1),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to create each drawer item with an icon
  Widget _buildDrawerItem({
    required String text,
    required IconData icon,
    required Function() onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.black,
        size: 24,
      ),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
      horizontalTitleGap: 15,
    );
  }
}
