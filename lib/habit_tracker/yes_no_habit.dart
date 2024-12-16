import 'habit.dart';


class YesNoHabit extends Habit {

  bool complete = false;

  YesNoHabit(super.name, super.date);

  YesNoHabit.fromHabit(super.name, super.date, this.complete);

  bool get getComplete => complete;

  void setComplete(bool c) {
    complete = c;
  }
}
