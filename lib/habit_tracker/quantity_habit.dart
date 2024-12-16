import 'habit.dart';

class QuantityHabit extends Habit {
  double amount = -1;
  String unit;

  QuantityHabit(super.name, super.date, this.unit);

  QuantityHabit.fromHabit(super.name, super.date, this.amount, this.unit);


  // set setAmount(double amount) {this.amount;}
  double get getAmount => amount;
  String get getUnit => unit;

  void setAmount(double amnt) {
    amount = amnt;
  }
}
