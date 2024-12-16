import 'package:flutter/material.dart';
import '../recipes/RecipePresenter.dart';
import '../recipes/RecipeCard.dart';

class SimpleSearchDelegate extends SearchDelegate {
  final RecipePresenter recipePresenter;

  SimpleSearchDelegate(this.recipePresenter);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: recipePresenter.searchRecipes(query+diet), // Use RecipePresenter for the search
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final recipes = snapshot.data as List; // Assuming it returns List<Recipe>
          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return RecipeCard(
                id: recipe.id,
                title: recipe.title,
                imageUrl: recipe.imageURL,
                recipeDetails: recipe.recipeDetails,
              );
            },
          );
        } else {
          return const Center(child: Text('No results found.'));
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: ToggleButtonsSample(),
    );
  }
}

const List<String> dietType = [
  '', 'gluten free', 'ketogenic', 'vegetarian', 'lacto-vegetarian',
  'ovo-vegetarian', 'vegan', 'pescetarian', 'paleo', 'primal', 'whole30'
];
String diet = '&diet=';

const List<Widget> diets = <Widget>[
  Text('None'),
  Text('Gluten Free'),
  Text('Ketogenic'),
  Text('Vegetarian'),
  Text('Lacto-Vegetarian'),
  Text('Ovo-Vegetarian'),
  Text('Vegan'),
  Text('Pescetarian'),
  Text('Paleo'),
  Text('Primal'),
  Text('Whole30')
];

class ToggleButtonsSample extends StatefulWidget {
  const ToggleButtonsSample({super.key});

  @override
  State<ToggleButtonsSample> createState() => _ToggleButtonsSampleState();
}

class _ToggleButtonsSampleState extends State<ToggleButtonsSample> {
  final List<bool> _selectedDiets = <bool>[true, false, false, false, false,
    false, false, false, false, false, false];
  bool vertical = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Align(
            alignment: Alignment.topLeft,
            child:Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Text('Diets', textAlign: TextAlign.start),
                ),
                ToggleButtons(
                  direction: vertical ? Axis.vertical : Axis.horizontal,
                  onPressed: (int index) {
                    setState(() {
                      for (int i = 0; i < _selectedDiets.length; i++) {
                        _selectedDiets[i] = i == index;
                      }
                      //Sets the diet to be added to the query
                      diet = '&diet=${dietType[index]}';
                    });
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  selectedBorderColor: Colors.red[700],
                  selectedColor: Colors.white,
                  fillColor: Colors.red[200],
                  color: Colors.red[400],
                  constraints: const BoxConstraints(
                    minHeight: 40.0,
                    minWidth: 80.0,
                  ),
                  isSelected: _selectedDiets,
                  children: diets,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
