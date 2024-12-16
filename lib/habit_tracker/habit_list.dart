import 'package:groupies/habit_tracker/yes_no_habit.dart';
import 'package:groupies/habit_tracker/quantity_habit.dart';

import 'habit.dart';

class HabitList {
  List<YesNoHabit> yesNoHabits;
  List<QuantityHabit> quantityHabits;

  HabitList()
      : yesNoHabits = [],
        quantityHabits = [];

  HabitList.fromList(List<YesNoHabit> ynhl, List<QuantityHabit> qhl)
      : yesNoHabits = ynhl,
        quantityHabits = qhl;

  // getter
  List<YesNoHabit> get getYesNoHabits => yesNoHabits;

  List<QuantityHabit> get getQuantityHabits => quantityHabits;

  //setter

  void setYesNoHabits(List<YesNoHabit> ynh) {
    yesNoHabits = ynh;
  }

  void setQuantityHabits(List<QuantityHabit> qh) {
    quantityHabits = qh;
  }

  bool isEmpty() {
    return (yesNoHabits.isEmpty && quantityHabits.isEmpty);
  }

  void editYesNoHabit(YesNoHabit ynh) {
    yesNoHabits[yesNoHabits.indexWhere(
            (habit) => habit.getId == ynh.id)] = ynh;
  }

  void addYesNoHabitToList(YesNoHabit yesNoHabit) {
    yesNoHabits.add(yesNoHabit);
  }

  void removeYesNoHabitFromList(String id) {
    yesNoHabits.removeWhere((yesNoHabit) => yesNoHabit.id == id);
  }

  void clearYesNoHabitList() {
    yesNoHabits.clear();
  }

  void addAllYesNoHabits(List<YesNoHabit> yesNoHabitsToAdd) {
    yesNoHabits.addAll(yesNoHabitsToAdd);
  }

  void editQuantityHabit(QuantityHabit qh) {
    quantityHabits[quantityHabits.indexWhere(
            (habit) => habit.getId == qh.id)] = qh;
  }

  void addQuantityHabitToList(QuantityHabit quantityHabit) {
    quantityHabits.add(quantityHabit);
  }

  void removeQuantityHabitFromList(String id) {
    quantityHabits.removeWhere((quantityHabit) => quantityHabit.id == id);
  }

  void clearQuantityHabitList() {
    quantityHabits.clear();
  }

  void addAllQuantityHabits(List<QuantityHabit> quantityHabitsToAdd) {
    quantityHabits.addAll(quantityHabitsToAdd);
  }


}
