import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupies/recipes/RecipeManager.dart';
import 'package:groupies/recipes/Recipe.dart';
import '../UUID.dart'; // Assuming this is where UserSingleton is defined

class RecipePresenter {
  final RecipeManager _recipeManager = RecipeManager();

  // Daily recipe functionality
  Future<void> getDailyRecipe() async {
    await _recipeManager.fetchDailyRecipe();
  }

  Recipe get dailyRecipe => _recipeManager.getDailyRecipe;

  // Favorite recipes functionality
  void updateFavorites(Recipe r) {
    _recipeManager.updateFavoriteRecipe(r);
  }

  List<Recipe> getFavorites() {
    return _recipeManager.getFavorites.recipes;
  }

  // Search functionality
  Future<List<Recipe>> searchRecipes(String query) async {
    const int numberOfResults = 10; // You can adjust this limit as needed.
    await _recipeManager.fetchSearchResults(numberOfResults, query);
    return _recipeManager.searchResults.getRecipes;
  }

  // Fetch favorite recipes from Firebase
  Future<List<Recipe>> getFavoritesFromFirebase() async {
    String? userId = UserSingleton.instance.getUserId();

    if (userId == null) {
      throw Exception("User ID is null. Cannot fetch favorites.");
    }

    try {
      DocumentSnapshot userFavoritesSnapshot = await FirebaseFirestore.instance
          .collection('Favorites')
          .doc(userId)
          .get();

      if (!userFavoritesSnapshot.exists) {
        return [];
      }

      List<dynamic> recipesData = userFavoritesSnapshot['recipes'] as List<dynamic>? ?? [];
      return recipesData.map((recipeData) {
        final mapData = recipeData as Map<String, dynamic>;
        return Recipe(
          mapData['id'],
          mapData['title'],
          mapData['imageURL'],
          mapData['details'],
        );
      }).toList();
    } catch (e) {
      print("Error fetching favorites from Firebase: $e");
      throw Exception("Failed to fetch favorites.");
    }
  }
}
