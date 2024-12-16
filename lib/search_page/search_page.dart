import 'package:flutter/material.dart';
import '../pancake.dart';
import '../search_page/search_button.dart';
import '../recipes/RecipePresenter.dart';

class SearchPage extends StatelessWidget {

  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        backgroundColor: Colors.orange, // Cute red color
        leading: const PancakeMenuButton(), // Pancake menu on the top left corner
        actions: [
          SearchButton(),
        ],
        title: const Text(
          'Search',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const Center(
        child: Text(
          'Search for your favorite recipes!',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
