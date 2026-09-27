import 'package:flutter/material.dart';
import 'package:groupies/recipes/recipe_presenter.dart';
import 'package:groupies/search/simple_search_delegate.dart';

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

