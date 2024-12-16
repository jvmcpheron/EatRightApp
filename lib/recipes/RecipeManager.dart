import 'package:groupies/recipes/Recipe.dart';
import 'package:groupies/recipes/RecipeList.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'recipeParser.dart';
import '../json_parse.dart';
import '../UUID.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecipeManager {
  Recipe _dailyRecipe = Recipe('', '', '', '');
  //update favorites to be
  final RecipeList favorites;
  final RecipeList searchResults;

  RecipeManager._internal(this.favorites, this.searchResults);

  static final RecipeManager _instance = RecipeManager._internal(
    RecipeList(),
    RecipeList(),
  );

  factory RecipeManager() => _instance;

  Recipe get getDailyRecipe => _dailyRecipe;
  RecipeList get getFavorites => favorites;

  //keywords for daily recipe
  static const List<String> recipeKeywords = [
     "Chicken", "Beef", "Salmon", "Pasta", "Pizza",
    "Sandwich"
  ];

  //91f181e349cb474082bcd508f8c39a07
  //1003a26d0f3d418c8d9876e4634b74d8
  static const String apiKey = "91f181e349cb474082bcd508f8c39a07";

  //get daily recipe from api
  Future<void> fetchDailyRecipe() async {
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays + 1;
    final keywordIndex = dayOfYear % recipeKeywords.length;
    final recipeKeyword = recipeKeywords[keywordIndex];
    if(_dailyRecipe.getId != ''){
      return;
    }
    //get recipe
    final searchUri = Uri.parse(
        'https://api.spoonacular.com/recipes/complexSearch?apiKey=$apiKey&query=$recipeKeyword');

    try {
      final searchResponse = await http.get(searchUri);

      if (searchResponse.statusCode == 200) {
        final searchData = jsonDecode(searchResponse.body);
        final List<dynamic>? results = searchData['results'];

        if (results != null && results.isNotEmpty) {
          final recipeId = results.first['id'];

          //get details!
          final detailsUri = Uri.parse(
              'https://api.spoonacular.com/recipes/$recipeId/information?apiKey=$apiKey');

          final detailsResponse = await http.get(detailsUri);

          if (detailsResponse.statusCode == 200) {
            final detailsData = jsonDecode(detailsResponse.body);
            _dailyRecipe = RecipeParser.parseSpoonacularRecipeWithDetails(detailsData);
          } else {
            print('Failed to fetch recipe details: ${detailsResponse.reasonPhrase}');
            _dailyRecipe = Recipe('', '', '', 'No details available.');
          }
        } else {
          print('No recipes found for the keyword: $recipeKeyword');
          _dailyRecipe = Recipe('', '', '', 'No recipe found.');
        }
      } else {
        print('Failed to fetch recipe search: ${searchResponse.reasonPhrase}');
        _dailyRecipe = Recipe('', '', '', 'No recipe found.');
      }
    } catch (e) {
      print('Error fetching daily recipe: $e');
      _dailyRecipe = Recipe('', '', '', 'Error fetching recipe.');
    }
  }

  //functionality for favorite button
  //edit this to work with the firebase String? userId = UserSingleton.instance.getUserId();

  Future<void> updateFavoriteRecipe(Recipe r) async {
    String? userId = UserSingleton.instance.getUserId();

    if (userId == null) {
      print("User ID is null. Cannot update favorites.");
      return;
    }

    Map<String, dynamic> recipeData = {
      'id': r.id,
      'title': r.title,
      'imageURL': r.imageURL,
      'details': r.recipeDetails,
    };

    DocumentReference userFavoritesRef = FirebaseFirestore.instance.collection('Favorites').doc(userId);
    try {
      DocumentSnapshot userFavoritesSnapshot = await userFavoritesRef.get();

      if (!userFavoritesSnapshot.exists) {
        await userFavoritesRef.set({'recipes': [recipeData]});
        print("Favorites document created and recipe added.");
      } else {
        List<dynamic>? currentFavorites = userFavoritesSnapshot['recipes'] as List<dynamic>?;

        if (currentFavorites == null) {
          await userFavoritesRef.update({'recipes': [recipeData]});
          print("Favorites array initialized and recipe added.");
        } else {
          bool recipeExists = currentFavorites.any((recipe) => recipe['id'] == r.id);

          if (recipeExists) {
            currentFavorites.removeWhere((recipe) => recipe['id'] == r.id);
            await userFavoritesRef.update({'recipes': currentFavorites});
            print("Recipe removed from favorites.");
          } else {
            currentFavorites.add(recipeData);
            await userFavoritesRef.update({'recipes': currentFavorites});
            print("Recipe added to favorites.");
          }
        }
      }
    } catch (e) {
      print("Error updating favorites: $e");
    }
  }

  void fetchFavoriteRecipes() {
    // todo goes to database and gets favorite recipes and makes it list
  }

  void removeFavoriteRecipe() {
    //todo removes recipe from list, and from database
  }

  static String previousSearchInput = '';

  Future<void> fetchSearchResults(int numberOfResults, String searchInput) async {
    //Prevents repeat searches
    if (!searchInput.startsWith('&') && previousSearchInput != searchInput) {
      //print("Searching...");
      final searchUri = Uri.parse(
          'https://api.spoonacular.com/recipes/complexSearch?apiKey=$apiKey'
              '&query=$searchInput&number=$numberOfResults');

      final searchResponse = await http.get(searchUri);

      if (searchResponse.statusCode == 200) {
        searchResults.clearRecipeList();
        final searchData = jsonDecode(searchResponse.body);
        final List<dynamic> results = searchData['results'];

        if (results.isNotEmpty) {
          //get details!
          for (int i = 0; i < results.length; i++) {
            final recipeId = results.elementAt(i)['id'];
            final detailsUri = Uri.parse(
                'https://api.spoonacular.com/recipes/$recipeId/'
                    'information?apiKey=$apiKey');
            //print("Searching for details...");
            final detailsResponse = await http.get(detailsUri);

            if (detailsResponse.statusCode == 200) {
              final detailsData = jsonDecode(detailsResponse.body);
              searchResults.addRecipeToList(
                  RecipeParser.parseSpoonacularRecipeWithDetails(detailsData));
            } else {
              print('Failed to fetch recipe details: ${detailsResponse
                  .reasonPhrase}');
            }
          }
        } else {
          print('No recipes found for the keyword: $searchInput');
        }
      } else {
        print('Failed to fetch recipe search: ${searchResponse.reasonPhrase}');
      }
      previousSearchInput = searchInput;
    }
    //hardcode searchinput in main
    //parse the input in here and put it in recipe.dart
    //return search results from the recipe.dart
  }
}





