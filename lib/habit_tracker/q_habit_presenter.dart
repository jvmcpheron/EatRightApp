import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupies/habit_tracker/quantity_habit.dart';
import 'package:groupies/habit_tracker/yes_no_habit.dart';
import 'package:groupies/habit_tracker/q_habit_manager.dart';
import '../UUID.dart';
import 'habit_list.dart';

class QHabitPresenter {
  final QHabitManager _ynHabitManager = QHabitManager();

  List<QuantityHabit> getQuantityHabits() {
    return _ynHabitManager.getQuantityHabits();
  }

  void removeQuantityHabit(QuantityHabit h) {
    _ynHabitManager.removeQuantityHabit(h);
  }

  Future addQuantityHabit(QuantityHabit h) async {
    _ynHabitManager.addQuantityHabit(h);
  }

  Future<void> updateQuantityHabit(QuantityHabit h) async {
    _ynHabitManager.updateQuantityHabit(h);
  }

  Future<void> fetchQuantityHabits() async {
    _ynHabitManager.fetchQuantityHabits();
  }

}
