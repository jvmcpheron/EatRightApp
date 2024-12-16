// import 'package:flutter/material.dart';
// import 'package:groupies/habit_tracker/yn_habit_manager.dart';
// import 'package:groupies/habit_tracker/yn_habit_presenter.dart';
// import 'package:table_calendar/table_calendar.dart';
//
// import 'habit.dart';
//
//
// class HabitCalendar extends StatefulWidget {
//   @override
//   _HabitCalendarState createState() => _HabitCalendarState();
//   List<Habit> habits = [];
//   List<Habit> get getHabits => habits;
// }
//
// class _HabitCalendarState extends State<HabitCalendar> {
//   CalendarFormat _calendarFormat = CalendarFormat.week;
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//   final YnHabitManager ynHabitManager = YnHabitManager();
//   final YnHabitPresenter ynHabitPresenter = YnHabitPresenter();
//   late final ValueNotifier<List<Habit>> _selectedHabits;
//   RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
//       .toggledOff; // Can be toggled on/off by longpressing a date
//   DateTime? _rangeStart;
//   DateTime? _rangeEnd;
//   DateTime firstDay = DateTime(
//       2020,
//       1,
//       1,
//       0,
//       0,
//       0,
//       0,
//       0);
//   DateTime lastDay = DateTime(
//       2030,
//       1,
//       1,
//       0,
//       0,
//       0,
//       0,
//       0);
//
//   @override
//   void initState() {
//     super.initState();
//
//     _selectedDay = _focusedDay;
//     _selectedHabits = ValueNotifier(_getYnHabitsForDay(_selectedDay!));
//   }
//
//   @override
//   void dispose() {
//     _selectedHabits.dispose();
//     super.dispose();
//   }
//
//   List<Habit> _getYnHabitsForDay(DateTime day) {
//     // Implementation example
//     return ynHabitPresenter.getYesNoHabitsFromFirebase() as List<Habit>;
//   }
//
//   List<Habit> _getHabitsForRange(DateTime start, DateTime end) {
//     int daysBetween = getDaysBetween(start, end);
//     // Implementation example
//     List<Habit> habits = [];
//     for (int i = 0; i < daysBetween; ++i) {
//       _getYnHabitsForDay(start.add(Duration(days: i)));
//     }
//     return habits;
//   }
//
//   int getDaysBetween(DateTime start, DateTime end) {
//     start = DateTime(start.year, start.month, start.day);
//     end = DateTime(end.year, end.month, end.day);
//     return (end.difference(start).inHours/24).round();
//   }
//
//   void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
//     if (!isSameDay(_selectedDay, selectedDay)) {
//       setState(() {
//         _selectedDay = selectedDay;
//         _focusedDay = focusedDay;
//         _rangeStart = null; // Important to clean those
//         _rangeEnd = null;
//         _rangeSelectionMode = RangeSelectionMode.toggledOff;
//       });
//
//       _selectedHabits.value = _getYnHabitsForDay(selectedDay);
//       widget.habits = _getYnHabitsForDay(selectedDay);
//     }
//   }
//
//   void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
//     setState(() {
//       _selectedDay = null;
//       _focusedDay = focusedDay;
//       _rangeStart = start;
//       _rangeEnd = end;
//       _rangeSelectionMode = RangeSelectionMode.toggledOn;
//     });
//
//     // `start` or `end` could be null
//     if (start != null && end != null) {
//       _selectedHabits.value = _getHabitsForRange(start, end);
//     } else if (start != null) {
//       _selectedHabits.value = _getYnHabitsForDay(start);
//     } else if (end != null) {
//       _selectedHabits.value = _getYnHabitsForDay(end);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//         children: [
//           const SizedBox(height: 10),
//           TableCalendar<Habit>(
//             firstDay: firstDay,
//             lastDay: lastDay,
//             focusedDay: _focusedDay,
//             calendarFormat: _calendarFormat,
//             selectedDayPredicate: (day) {
//               return isSameDay(_selectedDay, day);
//             },
//             onDaySelected: _onDaySelected,
//             onFormatChanged: (format) {
//               if (_calendarFormat != format) {
//                 setState(() {
//                   _calendarFormat = format;
//                 });
//               }
//             },
//             onPageChanged: (focusedDay) {
//               _focusedDay = focusedDay;
//             },
//           ),
//         ]
//     );
//   }
// }
