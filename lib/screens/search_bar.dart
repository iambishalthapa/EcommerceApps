import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSubmitted;

  const CustomSearchBar({
    Key? key,
    required this.controller,
    required this.onSubmitted,
  }) : super(key: key);

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Icon(Icons.search, color: Colors.grey),
          ),
          Expanded(
            child: TextField(
              controller: widget.controller,
              onSubmitted: widget.onSubmitted,
              decoration: InputDecoration(
                hintText: 'Search products...',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,  // Remove border
                contentPadding: EdgeInsets.symmetric(vertical: 8.0),
              ),
              style: TextStyle(color: Colors.black),
            ),
          ),
          // Clear button to reset search field
          IconButton(
            icon: Icon(Icons.clear, color: Colors.grey),
            onPressed: () {
              widget.controller.clear();
              widget.onSubmitted('');
            },
          ),
        ],
      ),
    );
  }
}
