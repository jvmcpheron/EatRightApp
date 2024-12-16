class Recipe {
  final String id;
  final String title;
  final String imageURL;
  final String recipeDetails;

  Recipe(this.id, this.title, this.imageURL, this.recipeDetails);

  // Getters
  String get getId => id;
  String get getTitle => title;
  String get getImageURL => imageURL;
  String get getRecipeDetails => recipeDetails;
}
