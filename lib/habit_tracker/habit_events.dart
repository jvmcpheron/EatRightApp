// import 'package:flutter/material.dart';
// import 'package:groupies/habit_tracker/habit.dart';
// import 'package:groupies/habit_tracker/yes_no_habit.dart';
// import 'package:groupies/habit_tracker/yn_habit_manager.dart';
// import 'package:groupies/habit_tracker/yn_habit_presenter.dart';
// import 'package:table_calendar/table_calendar.dart';
//
//
// class HabitEvents extends StatefulWidget {
//   @override
//   _HabitEventsState createState() => _HabitEventsState();
// }
//
// class _HabitEventsState extends State<HabitEvents> {
//   final YnHabitManager ynHabitManager = YnHabitManager();
//   final YnHabitPresenter ynHabitPresenter = YnHabitPresenter();
//
//   late final ValueNotifier<List<Habit>> _selectedHabits;
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
//       .toggledOff; // Can be toggled on/off by longpressing a date
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
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
//     _selectedHabits = ValueNotifier(_getYnHabitsForDay(_selectedDay!) as List<Habit>);
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
//       _selectedHabits.value = _getYnHabitsForDay(selectedDay) as List<Habit>;
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
//       _selectedHabits.value = _getYnHabitsForDay(start) as List<Habit>;
//     } else if (end != null) {
//       _selectedHabits.value = _getYnHabitsForDay(end) as List<Habit>;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('TableCalendar - Habits'),
//       ),
//       body: Column(
//         children: [
//           TableCalendar<Habit>(
//             firstDay: firstDay,
//             lastDay: lastDay,
//             focusedDay: _focusedDay,
//             selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//             rangeStartDay: _rangeStart,
//             rangeEndDay: _rangeEnd,
//             calendarFormat: _calendarFormat,
//             rangeSelectionMode: _rangeSelectionMode,
//             eventLoader: _getYnHabitsForDay,
//             startingDayOfWeek: StartingDayOfWeek.monday,
//             calendarStyle: CalendarStyle(
//               // Use `CalendarStyle` to customize the UI
//               outsideDaysVisible: false,
//             ),
//             onDaySelected: _onDaySelected,
//             onRangeSelected: _onRangeSelected,
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
//           const SizedBox(height: 8.0),
//           Expanded(
//             child: ValueListenableBuilder<List<Habit>>(
//               valueListenable: _selectedHabits,
//               builder: (context, value, _) {
//                 return ListView.builder(
//                   itemCount: value.length,
//                   itemBuilder: (context, index) {
//                     return Container(
//                       margin: const EdgeInsets.symmetric(
//                         horizontal: 12.0,
//                         vertical: 4.0,
//                       ),
//                       decoration: BoxDecoration(
//                         border: Border.all(),
//                         borderRadius: BorderRadius.circular(12.0),
//                       ),
//                       child: ListTile(
//                         onTap: () => print('${value[index]}'),
//                         title: Text('${value[index]}'),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }