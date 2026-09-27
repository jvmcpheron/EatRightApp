import 'package:flutter/material.dart';
import 'package:groupies/habit_tracker/weekly_tracker_page.dart';
import 'package:groupies/home/home_page.dart';
import 'package:groupies/recipes/favorites_page.dart';
import 'package:groupies/main.dart';
import 'package:groupies/water_clock/water_clock_widget.dart';
import 'package:groupies/recipes/daily_recipe_page.dart';
import 'package:groupies/nutrition/learning_page.dart';

class PancakeMenuButton extends StatelessWidget {
  const PancakeMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'Home':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
            break;
          case 'Water Clock':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Water_Clock()),
            );
            break;
          case 'Favorites':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoritesPage()),
            );
            break;
          case 'Weekly Habits':  // Add this new case
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WeeklyTrackerPage()),
            );
            break;
          case 'Daily Recipe':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DailyRecipePage()),
            );
            break;
          case 'Learn Nutrition':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LearningPage()),
            );
            break;
        }
      },
      itemBuilder: (BuildContext context) {

        return {'Home', 'Water Clock', 'Favorites', 'Weekly Habits', 'Daily Recipe', 'Learn Nutrition'}.map((String choice) {

          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
      icon: const Icon(Icons.menu, color: Colors.white),
    );
  }
}

// Create the views
