import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'Recipe.dart';
import 'RecipePresenter.dart';
import 'RecipeManager.dart';

class RecipeCard extends StatefulWidget {
  final String id;
  final String title;
  final String imageUrl;
  final String recipeDetails;

  const RecipeCard({
    Key? key,
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.recipeDetails,
  }) : super(key: key);

  @override
  _RecipeCardState createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  final RecipePresenter recipePresenter = RecipePresenter();
  final RecipeManager recipeManager = RecipeManager();
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
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
        builder: (context) => RecipeDetailsPage(
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

    final recipe = Recipe(widget.id, widget.title, widget.imageUrl, widget.recipeDetails);
    try {
      await recipeManager.updateFavoriteRecipe(recipe);
    } catch (e) {
      print("Error updating favorite status: $e");
    }
  }

  void _shareRecipe() {
    Share.share(
      'Check out this recipe: ${widget.title}\n\n${widget.recipeDetails}\n\nImage: ${widget.imageUrl}',
      subject: 'Recipe: ${widget.title}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToRecipeDetails(context),
      child: Container(
        height: 300, // Fixed height for each recipe card
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Card(
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                widget.imageUrl,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.broken_image, size: 100, color: Colors.grey),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis, // Ensures long titles are truncated
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
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
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    Text(
                      widget.recipeDetails,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecipeDetailsPage extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String recipeDetails;

  const RecipeDetailsPage({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.recipeDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imageUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.broken_image, size: 100, color: Colors.grey),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    recipeDetails,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


