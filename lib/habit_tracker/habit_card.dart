import 'package:flutter/material.dart';
import 'habit.dart';


class HabitCard extends StatefulWidget {
  Habit habit;

  HabitCard({
    Key? key,
    required this.habit
  }) : super(key: key);

  @override
  HabitCardState createState() => HabitCardState();
}

class HabitCardState<T extends HabitCard> extends State<T> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        widget.habit.name,
      ),
    );
  }
}

// class HabitDetailsPage extends StatelessWidget {
//   final String name;
//   final DateTime date;
//   bool complete;
//
//   HabitDetailsPage({
//     Key? key,
//     required this.name,
//     required this.date,
//     required this.complete,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(name)),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     name,
//                     style: const TextStyle(
//                       color: Colors.orange,
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     date.toString(),
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
