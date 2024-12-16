import 'package:groupies/recipes/Recipe.dart';

class RecipeList {
  final List<Recipe> recipes;

  RecipeList() : recipes = [];

  RecipeList.fromList(List<Recipe> rl) : recipes = rl;

  // getter
  List<Recipe> get getRecipes => recipes;

  void addRecipeToList(Recipe recipe) {
    recipes.add(recipe);
  }

  void removeRecipeFromList(String recipeID) {
    recipes.removeWhere((recipe) => recipe.id == recipeID);
  }

  void clearRecipeList() {
    recipes.clear();
  }

  void addAll(List<Recipe> recipesToAdd) {
    recipes.addAll(recipesToAdd);
  }
}



