import 'package:flutter/material.dart';
import 'pancake.dart';
import 'recipes/RecipeCard.dart';
import 'recipes/RecipePresenter.dart';
import 'recipes/Recipe.dart';
import 'BottomBar.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final RecipePresenter recipePresenter = RecipePresenter();
  List<Recipe> favoriteRecipes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  Future<void> _fetchFavorites() async {
    try {
      final favorites = await recipePresenter.getFavoritesFromFirebase();
      setState(() {
        favoriteRecipes = favorites;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching favorites: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> recipeCards = favoriteRecipes.map((recipe) {
      return RecipeCard(
        id: recipe.getId,
        title: recipe.getTitle,
        imageUrl: recipe.getImageURL,
        recipeDetails: recipe.getRecipeDetails,
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        leading: const PancakeMenuButton(),
        title: Row(
          children: const [
            Text(
              'Favorites',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.favorite,
              color: Colors.white,
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : favoriteRecipes.isEmpty
          ? const Center(child: Text("No favorites added yet!"))
          : ListView(
        children: recipeCards,
      ),
      bottomNavigationBar: const WhiteBottomBar(),
    );
  }
}
