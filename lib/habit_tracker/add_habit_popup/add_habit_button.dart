// import 'package:flutter/material.dart';
//
// class AddHabitPopup extends StatelessWidget {
//   const AddHabitPopup({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Padding(
//       padding: const EdgeInsets.all(32),
//       child: GestureDetector(
//         onTap: () {
//           Navigator.of(context).push(HeroDialogueRoute(
//             builder: (context) {
//               return const _AddHabitPopupCard();
//             },
//           ));
//         },
//         child: Hero(
//           tag: _heroAddHabit,
//           createRectTween: (begin,end) {
//             return CustomRectTween(begin: begin, end: end);
//           },
//           child: Material(
//             color: Colors.blue.shade900,
//             elevation: 2,
//           )
//         )
//       )
//     );
//   }
// }
