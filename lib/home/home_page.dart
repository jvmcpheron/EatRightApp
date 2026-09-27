import 'package:flutter/material.dart';
import 'package:groupies/water_clock/water_clock_widget.dart';
import 'package:groupies/nutrition/learning_page.dart';
import 'package:groupies/navigation/bottom_bar.dart';
import 'package:groupies/recipes/daily_recipe_page.dart';
import 'package:groupies/habit_tracker/weekly_tracker_page.dart';
import 'package:groupies/navigation/pancake.dart';
import 'package:groupies/recipes/favorites_page.dart';
import 'package:groupies/recipes/recipe_presenter.dart';
import 'package:groupies/recipes/daily_recipe_widget.dart';
import 'package:groupies/search/simple_search_delegate.dart';
import 'package:groupies/search/search_button.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ButtonStyle(
        foregroundColor: WidgetStateProperty.all(Colors.white),
        backgroundColor: WidgetStateProperty.all(Colors.orangeAccent),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.white, width: 5.0)
            )
        )
    );

    final TextStyle textStyle = TextStyle(fontSize: 18);
    final double iconSize = 50;
    final double width = MediaQuery.sizeOf(context).width;
    final double height = MediaQuery.sizeOf(context).height;
    final SizedBox separatorBox = SizedBox(width: 10, height: 10);
    final recipePresenter = RecipePresenter();

    return Scaffold(
        backgroundColor: Colors.orange,
        appBar: AppBar(
          backgroundColor: Colors.orange,
          leading: const PancakeMenuButton(),
          // Pancake menu on the top left corner
          actions: const [SearchButton()],
          title: const Row(
            children: [
              Text(
                  'Home',
                  style: TextStyle(color: Colors.white)),
              SizedBox(width: 8), // Spacing between text and icon
              Icon(
                Icons.home,
                color: Colors.white,
              ),
            ],
          ),
        ),

        body: ListView(
            primary: false,
            padding: const EdgeInsets.all(15),

            children: [
              DailyRecipeWidget(),  // Recipe from Daily Recipe Page
              Row(
                  children: <Widget>[
                    Expanded(
                        child: SizedBox(
                          height: 150,
                      child: ElevatedButton( // SEARCH PAGE
                        onPressed: () {
                          showSearch(
                              context: context,
                              delegate: SimpleSearchDelegate(recipePresenter)
                          );
                        },
                        style: buttonStyle,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.search, size: iconSize),
                              Text("Search Recipes", style: textStyle),
                            ]
                        ),
                      ),
                    ),
                    ),
                    separatorBox,
                    Expanded(
                      child: SizedBox(
                        height: 150,
                        child: ElevatedButton( // FAVORITES PAGE
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const FavoritesPage()),
                            );
                          },
                          style: buttonStyle,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.favorite, size: iconSize),
                                Text("Favorites", style: textStyle),
                              ]
                          ),
                        ),
                      ),
                    )

                  ]
              ),
              separatorBox,
              Row(
                  children: <Widget>[
                    Expanded(
                        child: SizedBox(
                          height: 150,
                      child: ElevatedButton( // NUTRITION LEARNING PAGE
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LearningPage()),
                          );
                        },
                        style: buttonStyle,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.play_arrow, size: iconSize),
                              Text("Learn More", style: textStyle),
                            ]
                        ),
                      ),
                    ),
                    ),
                    separatorBox,
                    Expanded(
                        child: SizedBox(
                          height: 150,
                      child: ElevatedButton(  // WATER CLOCK PAGE
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Water_Clock()),
                          );
                        },
                        style: buttonStyle,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.lock_clock, size: iconSize),
                              Text("Water Clock", style: textStyle),
                            ]
                        ),
                      ),
                    ),
                    ),
                  ]
              ),
              separatorBox,
              Row(
                  children: <Widget>[
                    Expanded(
                        child: SizedBox(
                          height: 150,
                      child: ElevatedButton(  // WEEKLY HABIT TRACKER PAGE
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WeeklyTrackerPage()),
                          );
                        },
                        style: buttonStyle,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.check_box_outlined, size: iconSize),
                              Text("Weekly Tracker", style: textStyle),
                            ]
                        ),
                      ),
                    ),
                    ),
                    separatorBox,
                    Expanded(
                        child: SizedBox(
                          height: 150,
                      child: ElevatedButton(  // DAILY RECIPE PAGE
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DailyRecipePage()),
                          );
                        },
                        style: buttonStyle,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.calendar_month, size: iconSize),
                              Text("Daily Recipe", style: textStyle),
                            ]
                        ),
                      ),
                    ),
                    )
                  ]
              )
            ]
        ),
      bottomNavigationBar: const WhiteBottomBar(),
    );
  }
}
