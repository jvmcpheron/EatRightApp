import 'package:flutter/material.dart';
import 'package:groupies/recipes/RecipePresenter.dart';
import 'SimpleSearchDelegate.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    final recipePresenter = RecipePresenter();
    return IconButton(
      icon: const Icon(Icons.search, color: Colors.white),
      onPressed: () {
        showSearch(
          context: context,
          delegate: SimpleSearchDelegate(recipePresenter),
        );
      },
    );
  }
}

