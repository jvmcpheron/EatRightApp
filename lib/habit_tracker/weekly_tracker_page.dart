import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groupies/habit_tracker/q_habit_manager.dart';
import 'package:groupies/habit_tracker/q_habit_presenter.dart';
import 'package:groupies/habit_tracker/quantity_habit.dart';
import 'package:groupies/habit_tracker/yes_no_habit.dart';
import 'package:groupies/habit_tracker/yn_habit_manager.dart';
import 'package:groupies/habit_tracker/yn_habit_presenter.dart';
import 'package:groupies/pancake.dart';
import 'package:table_calendar/table_calendar.dart';
import '../BottomBar.dart';
import 'habit.dart';
import 'habit_list_view.dart';


class WeeklyTrackerPage extends StatefulWidget {
  const WeeklyTrackerPage({super.key});

  @override
  State<WeeklyTrackerPage> createState() => _WeeklyTrackerPage();
}

class _WeeklyTrackerPage extends State<WeeklyTrackerPage> {
  late final YnHabitPresenter ynHabitPresenter;
  late final YnHabitManager ynHabitManager;
  late final QHabitPresenter qHabitPresenter;
  late final QHabitManager qHabitManager;

  Color popupColor = Colors.blue.shade900;
  Color textFieldBorder = Colors.white;

  ButtonStyle buttonStyle = TextButton.styleFrom(
      elevation: 2,
      padding: EdgeInsets.symmetric(horizontal: 16),
      backgroundColor: Colors.white,
      foregroundColor: Colors.blue.shade900,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)))
  );

  TextStyle textFieldTextStyle = TextStyle(
    color: Colors.white,
  );

  RoundedRectangleBorder alertDialogShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)));


  SizedBox spacer = SizedBox(width: 5, height: 15);


  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late final ValueNotifier<List<YesNoHabit>> _selectedHabits;
  List<YesNoHabit> selectedYnHabits = [];
  List<QuantityHabit> selectedQHabits = [];
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  DateTime firstDay = DateTime(
      2020,
      1,
      1,
      0,
      0,
      0,
      0,
      0);
  DateTime lastDay = DateTime(
      2030,
      1,
      1,
      0,
      0,
      0,
      0,
      0);


  @override
  void initState() {
    super.initState();

    ynHabitPresenter = YnHabitPresenter();
    ynHabitManager = YnHabitManager();
    qHabitPresenter = QHabitPresenter();
    qHabitManager = QHabitManager();
    ynHabitPresenter.fetchYesNoHabits();


    _selectedDay = _focusedDay;
    _selectedHabits = ValueNotifier(_getYnHabitsForDay(_selectedDay!));
    selectedYnHabits = _getYnHabitsForDay(_selectedDay!);
    selectedQHabits = _getQHabitsForDay(_selectedDay!);
  }

  @override
  void dispose() {
    _selectedHabits.dispose();
    super.dispose();
  }

  List<YesNoHabit> _getYnHabitsForDay(DateTime day) {

    List<YesNoHabit> ynHabits =
    ynHabitPresenter.getYesNoHabits().where((habit) =>
    (DateTime(habit.getDate.year, habit.getDate.month, habit.getDate.day) ==
        DateTime(day.year, day.month, day.day))).toList();

    return ynHabits;
  }


  List<QuantityHabit> _getQHabitsForDay(DateTime day) {
    List<QuantityHabit> qHabits = qHabitPresenter.getQuantityHabits().where((habit) =>
    (DateTime(habit.getDate.year, habit.getDate.month, habit.getDate.day) ==
        DateTime(day.year, day.month, day.day))).toList();


    return qHabits;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    // if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });


      selectedYnHabits = _getYnHabitsForDay(selectedDay);
      selectedQHabits = _getQHabitsForDay(selectedDay);
    // }
  }

  Future<void> _addQuantityHabit(BuildContext context, String name, double? amount,
      String unit) async {

    if (name.isNotEmpty && unit.isNotEmpty && amount.toString().isNotEmpty) {
      try {
        QuantityHabit h = QuantityHabit(name, _selectedDay!, unit);
        h.setAmount(amount!);
        await qHabitPresenter.addQuantityHabit(h);
      } catch (e) {
        print ('Error updating complete status: $e"');
      }
    }
  }

  Future<void> _addYesNoHabit(BuildContext context, String name) async {
    if (name.isNotEmpty) {
      try {
        YesNoHabit newHabit = YesNoHabit(name, _selectedDay!);
        await ynHabitPresenter.addYesNoHabit(newHabit);
      } catch (e) {
        print ('Error updating complete status: $e"');
      }
    }
  }

  Future<void> _addYesNoHabitDialogBuilder(BuildContext context) {
    String name = "";
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: alertDialogShape,
              surfaceTintColor: Colors.white,
              backgroundColor: popupColor,
              title: const Text('Add Checkbox Habit',
                  style: TextStyle(color: Colors.white)),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      cursorColor: textFieldBorder,
                      style: textFieldTextStyle,
                      decoration: InputDecoration(hintText: "Habit name",
                          hintStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: textFieldBorder)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: textFieldBorder)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: textFieldBorder))),
                      onChanged: (value) {
                        name = value;
                      },
                    ),
                    spacer,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          style: buttonStyle,
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        spacer,
                        TextButton(
                          style: buttonStyle,
                          child: const Text('Add'),
                          onPressed: () {
                            _addYesNoHabit(context, name);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    )
                  ]
              )
          );
        }
    );
  }

  Future<void> _addQuantityHabitDialogBuilder(BuildContext context) {
    String name = "";
    double? amount = 0;
    String unit = "";
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: alertDialogShape,
              surfaceTintColor: Colors.white,
              backgroundColor: popupColor,
              title: const Text('Add Quantity Habit',
                  style: TextStyle(color: Colors.white)),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      cursorColor: textFieldBorder,
                      style: textFieldTextStyle,
                      decoration: InputDecoration(hintText: "Habit name",
                          hintStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: textFieldBorder)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: textFieldBorder)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: textFieldBorder))),
                      onChanged: (value) {
                        name = value;
                      },
                    ),
                    spacer,
                    TextField(
                        cursorColor: textFieldBorder,
                        style: textFieldTextStyle,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: "Amount",
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: textFieldBorder)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: textFieldBorder)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: textFieldBorder))),
                        onChanged: (value) {
                          amount = double.tryParse(value);
                        }
                    ),
                    spacer,
                    TextField(
                        cursorColor: textFieldBorder,
                        style: textFieldTextStyle,
                        decoration: InputDecoration(hintText: "Unit",
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: textFieldBorder)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: textFieldBorder)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: textFieldBorder))),
                        onChanged: (value) {
                          unit = value;
                        }
                    ),
                    spacer,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          style: buttonStyle,
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        spacer,
                        TextButton(
                          style: buttonStyle,
                          child: const Text('Add'),
                          onPressed: () {
                            setState(() {
                              _addQuantityHabit(context, name, amount, unit);
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    )
                  ]
              )
          );
        }
    );
  }


  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: alertDialogShape,
              surfaceTintColor: Colors.white,
              backgroundColor: popupColor,
              title: const Text('Add Habit',
                  style: TextStyle(color: Colors.white)),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Do you want to add a Checkbox Habit '
                            'or a Quantity Habit?',
                        style: TextStyle(color: Colors.white)
                    ),
                    spacer,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          style: buttonStyle,
                          child: const Text('Checkbox'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            _addYesNoHabitDialogBuilder(context);
                          },
                        ),
                        spacer,
                        TextButton(
                          style: buttonStyle,
                          child: const Text('Quantity'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            _addQuantityHabitDialogBuilder(context);
                          },
                        ),
                      ],
                    )
                  ]
              )
          );
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        leading: const PancakeMenuButton(),
        title: const Row(
          children: [
            Text(
              'Weekly Habit Tracker',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(width: 8),
          ],
        ),
      ),

      body: Column(
          children: [
            const SizedBox(height: 10),
            TableCalendar<Habit>(
              firstDay: firstDay,
              lastDay: lastDay,
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: _onDaySelected,
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: HabitListView(selectedYnHabits, selectedQHabits),
            ),
          ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _dialogBuilder(context);
        },
        splashColor: Colors.blue.shade900,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        backgroundColor: Colors.blue.shade900,
        child: const Icon(Icons.add, size: 50, color: Colors.white),
      ),
      bottomNavigationBar: const WhiteBottomBar(),
    );
  }
}
