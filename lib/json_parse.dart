import 'recipes/Recipe.dart';
import 'dart:convert';

class JSONParser {
  static List<Recipe> parseRecipeList(String responseBody) {
    final parsed = jsonDecode(responseBody)['meals'] as List<dynamic>;
    return parsed.map((json) => Recipe(
      json['idMeal'] as String,
      json['strMeal'] as String,
      json['strMealThumb'] as String,
      json['strInstructions'] as String,
    ))
        .toList();
  }
}