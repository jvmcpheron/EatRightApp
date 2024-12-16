import 'dart:convert';
import 'package:groupies/recipes/Recipe.dart';

class RecipeParser {
  static Recipe parseSpoonacularRecipeWithDetails(Map<String, dynamic> recipeData) {
    final ingredients = recipeData['extendedIngredients'] as List<dynamic>? ?? [];

    // join ingredients into a string
    final ingredientList = ingredients
        .map((ingredient) => "${ingredient['original'] ?? 'Unknown ingredient'}")
        .join(', ');

    // get the instructions and clean up any  HTML
    String recipeInfo = recipeData['instructions'] ?? 'No instructions provided.';
    recipeInfo = _cleanInstructions(recipeInfo);

    // Recipe object
    return Recipe(
      recipeData['id'].toString(),
      recipeData['title'] ?? '',
      recipeData['image'] ?? '',
      'Ingredients: $ingredientList\n\nInstructions: $recipeInfo',
    );
  }

  static String _cleanInstructions(String instructions) {
    // replace  HTML
    instructions = instructions
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&nbsp;', ' ');

    // Remove all HTML tags (e.g., <ol>, <li>, <p>, <br>, etc.)
    instructions = instructions.replaceAll(RegExp(r'<[^>]*>'), '');

    return instructions;
  }
}


