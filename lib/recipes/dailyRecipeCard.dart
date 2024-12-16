import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'Recipe.dart';
import 'RecipeCard.dart';
import 'RecipeManager.dart';
import 'RecipePresenter.dart';

class DailyRecipeCard extends StatefulWidget {
  final String id;
  final String title;
  final String imageUrl;
  final String recipeDetails;

  const DailyRecipeCard({
    super.key,
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.recipeDetails,
  });

  @override
  DailyRecipeCardState createState() => DailyRecipeCardState();
}

class DailyRecipeCardState extends State<DailyRecipeCard> {
  final RecipePresenter recipePresenter = RecipePresenter();
  final RecipeManager recipeManager = RecipeManager();
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
    // final favoriteRecipes = recipePresenter.getFavorites();
    // isFavorite = favoriteRecipes.any((recipe) => recipe.id == widget.id);
  }

  Future<void> _checkIfFavorite() async {
    try {
      final favorites = await recipePresenter.getFavoritesFromFirebase();
      setState(() {
        isFavorite = favorites.any((recipe) => recipe.id == widget.id);
      });
    } catch (e) {
      print("Error checking favorite status: $e");
    }
  }

  void _navigateToRecipeDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            RecipeDetailsPage(
              title: widget.title,
              imageUrl: widget.imageUrl,
              recipeDetails: widget.recipeDetails,
            ),
      ),
    );
  }

  Future<void> _toggleFavorite() async {
    setState(() {
      isFavorite = !isFavorite;
    });

    final recipe = Recipe(
        widget.id, widget.title, widget.imageUrl, widget.recipeDetails);
    // recipePresenter.updateFavorites(recipe);

    try {
      await recipeManager.updateFavoriteRecipe(recipe);
    } catch (e) {
      print("Error updating favorite status: $e");
    }
  }

  void _shareRecipe() {
    Share.share(
      'Check out this recipe: ${widget.title}\n\n${widget
          .recipeDetails}\n\nImage: ${widget.imageUrl}',
      subject: 'Recipe: ${widget.title}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToRecipeDetails(context),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        height: 230,
        // Fixed height for each recipe card
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Card(
          color: Colors.white,
          elevation: 0,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Image.network(
                    widget.imageUrl,
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                            Icons.broken_image, size: 100, color: Colors.grey),
                      );
                    },
                  ),
                ),
                ListTile(
                    title: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    trailing: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                          ),
                          color: Colors.redAccent,
                          onPressed: _toggleFavorite,
                        ),
                          IconButton(
                            icon: const Icon(Icons.share),
                            color: Colors.blueAccent,
                            onPressed: _shareRecipe,
                          ),
                        ]
                    )

                )
              ]
          ),
        ),
      ),
    );
  }
}
