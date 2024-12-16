import 'package:flutter/material.dart';
import '../pancake.dart';
import '../recipes/RecipeCard.dart';
import 'package:groupies/recipes/RecipePresenter.dart';
import '../BottomBar.dart';
import 'Recipe.dart';
import 'dailyRecipeCard.dart';

class DailyRecipeWidget extends StatelessWidget {
  const DailyRecipeWidget({super.key});


  @override
  Widget build(BuildContext context) {
    final recipePresenter = RecipePresenter();

    return FutureBuilder<void>(

        //use presenter to get daily recipe
        future: recipePresenter.getDailyRecipe(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error fetching recipe"));
          } else {
            final recipe = recipePresenter.dailyRecipe;
            if (recipe.getTitle.isEmpty) {
              return const Center(child: Text("No recipe found"));
            }
            return Center(
              child: DailyRecipeCard(
                id: recipe.getId,
                title: recipe.getTitle,
                imageUrl: recipe.getImageURL,
                recipeDetails: recipe.getRecipeDetails,
              ),
            );
          }
        },
    );
  }
}
