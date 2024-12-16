import 'package:flutter/material.dart';
import 'package:groupies/habit_tracker/quantity_habit.dart';
import 'package:groupies/habit_tracker/quantity_habit_card.dart';
import 'package:groupies/habit_tracker/yes_no_habit.dart';
import 'package:groupies/habit_tracker/yes_no_habit_card.dart';


class HabitListView extends StatefulWidget {
  late List<Widget> habits;
  List<YesNoHabit> ynHabits;
  List<QuantityHabit> qHabits;
  late List<Widget> qHabitCards;
  late List<Widget> ynHabitCards;
  late List<Widget> habitCards;

  HabitListView(this.ynHabits, this.qHabits) {
    ynHabitCards = ynHabits.map((habit) {
      return YesNoHabitCard(
        ynHabit: habit,
      );
    }).toList();
    qHabitCards = qHabits.map((habit) {
      return QuantityHabitCard(
        qHabit: habit,
      );
    }).toList();
    habitCards = [...ynHabitCards,...qHabitCards];
  }

  @override
  _HabitListViewState createState() => _HabitListViewState();
}

class _HabitListViewState extends State<HabitListView> {


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5),
      height: 70,
      width: double.infinity,
      child: ListView(
        children: widget.habitCards,
      ),
    );
  }
}