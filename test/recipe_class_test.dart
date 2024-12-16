import 'package:flutter_test/flutter_test.dart';
import 'package:groupies/recipes/Recipe.dart';
import 'package:groupies/recipes/RecipeList.dart';
import 'package:groupies/recipes/RecipeManager.dart';

void main() {
  group('Recipe Class Tests', () {
    test('Recipe object creation and getters', () {
      Recipe chicken = Recipe("123", "Chicken", "imageURL", "recipeDetails");



      expect(chicken.getId, '123');
      expect(chicken.getTitle, 'Chicken');

      expect(chicken.getImageURL, 'imageURL');
      expect(chicken.getRecipeDetails, 'recipeDetails');
    });

    test('Recipe properties are correct', () {
      Recipe pasta = Recipe("456", "Pasta", "pastaImageURL", "pastaDetails");



      expect(pasta.getId, '456');
      expect(pasta.getTitle, 'Pasta');
      expect(pasta.getImageURL, 'pastaImageURL');
      expect(pasta.getRecipeDetails, 'pastaDetails');
    });
  });

  group('RecipeList Class Tests', () {
    test('Adding and retrieving a single recipe', () {
      Recipe chicken = Recipe("123", "Chicken", "imageURL", "recipeDetails");
      RecipeList list = RecipeList();
      list.addRecipeToList(chicken);




      expect(list.getRecipes.length, 1);
      expect(list.getRecipes[0].getTitle, 'Chicken');
      expect(list.getRecipes[0].getId, '123');


      expect(list.getRecipes[0].getImageURL, 'imageURL');
      expect(list.getRecipes[0].getRecipeDetails, 'recipeDetails');
    });

    test('Adding multiple recipes to RecipeList', () {
      Recipe chicken = Recipe("123", "Chicken", "imageURL", "recipeDetails");
      Recipe pasta = Recipe("456", "Pasta", "pastaImageURL", "pastaDetails");
      Recipe salad = Recipe("789", "Salad", "saladImageURL", "saladDetails");
      RecipeList list = RecipeList();

      list.addRecipeToList(chicken);
      list.addRecipeToList(pasta);
      list.addRecipeToList(salad);

      //  all recipes were added
      expect(list.getRecipes.length, 3);
      expect(list.getRecipes[1].getTitle, 'Pasta');
      expect(list.getRecipes[1].getImageURL, 'pastaImageURL');
      expect(list.getRecipes[2].getTitle, 'Salad');
      expect(list.getRecipes[2].getImageURL, 'saladImageURL');
    });

    test('Clearing RecipeList', () {
      Recipe chicken = Recipe("123", "Chicken", "imageURL", "recipeDetails");
      RecipeList list = RecipeList();

      list.addRecipeToList(chicken);
      expect(list.getRecipes.isNotEmpty, true);

      list.clearRecipeList();
      expect(list.getRecipes.length, 0);
      expect(list.getRecipes.isEmpty, true);
    });

    test('Ensuring immutability of RecipeList after clearing', () {
      Recipe chicken = Recipe("123", "Chicken", "imageURL", "recipeDetails");
      Recipe pasta = Recipe("456", "Pasta", "pastaImageURL", "pastaDetails");
      RecipeList list = RecipeList();

      list.addRecipeToList(chicken);
      list.addRecipeToList(pasta);

      list.clearRecipeList();
      expect(list.getRecipes, isEmpty);

      // add recipes again to test persistence after clearing
      list.addRecipeToList(chicken);
      expect(list.getRecipes.length, 1);
      expect(list.getRecipes[0].getTitle, 'Chicken');
    });
  });
  group('RecipeManager Class Tests', () {
    late RecipeManager recipeManager;

    setUp(() {
      recipeManager = RecipeManager();
    });

    test('Singleton instance ensures only one RecipeManager exists', () {
      final anotherInstance = RecipeManager();
      expect(identical(recipeManager, anotherInstance), true);
    });

    test('Add and remove favorite recipe', () {
      Recipe spaghetti = Recipe("001", "Spaghetti", "imageURL", "recipeDetails");

      // initially no favorites
      expect(recipeManager.getFavorites.getRecipes.length, 0);

      // add to favorites
      recipeManager.updateFavoriteRecipe(spaghetti);
      expect(recipeManager.getFavorites.getRecipes.length, 1);
      expect(recipeManager.getFavorites.getRecipes.first.getTitle, 'Spaghetti');

      // remove from favorites
      recipeManager.updateFavoriteRecipe(spaghetti);
      expect(recipeManager.getFavorites.getRecipes.length, 0);
    });

    test('Fetch daily recipe sets a valid Recipe', () async {
      await recipeManager.fetchDailyRecipe();
      expect(recipeManager.getDailyRecipe.getTitle.isNotEmpty, true);
    });

  });
}


