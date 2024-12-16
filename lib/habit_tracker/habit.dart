class Habit {

  final String name;
  late final DateTime date;
  late final String id;

  Habit(this.name, DateTime d) {
    this.date = DateTime(d.year, d.month, d.day);
    this.id = name + date.toString();
  }

  String get getId => id;
  String get getName => name;
  DateTime get getDate => date;


}