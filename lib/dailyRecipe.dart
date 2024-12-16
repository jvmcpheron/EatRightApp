import 'package:flutter/material.dart';
import 'pancake.dart';
import 'recipes/RecipeCard.dart';
import 'package:groupies/recipes/RecipePresenter.dart';
import 'BottomBar.dart';

class DailyRecipePage extends StatelessWidget {
  const DailyRecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    final recipePresenter = RecipePresenter();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        leading: const PancakeMenuButton(),
        title: Row(
          children: const [
            Text(
              'Daily Recipe',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.calendar_month,
              color: Colors.white,
            ),
          ],
        ),
      ),
      body: FutureBuilder<void>(

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
              child: RecipeCard(
                id: recipe.getId,
                title: recipe.getTitle,
                imageUrl: recipe.getImageURL,
                recipeDetails: recipe.getRecipeDetails,
              ),
            );
          }
        },
      ),
      bottomNavigationBar: const WhiteBottomBar(),
    );
  }
}
