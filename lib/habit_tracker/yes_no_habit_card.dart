import 'package:flutter/material.dart';
import 'package:groupies/habit_tracker/yes_no_habit.dart';
import 'package:groupies/habit_tracker/yn_habit_manager.dart';
import 'package:groupies/habit_tracker/yn_habit_presenter.dart';
import 'habit.dart';
import 'habit_card.dart';


class YesNoHabitCard extends HabitCard {
  final YesNoHabit ynHabit;

  YesNoHabitCard({
    Key? key,
    required this.ynHabit,
  }) : super(key: key, habit : ynHabit);

  String get id => ynHabit.getId;
  String get name => ynHabit.getName;
  DateTime get date => ynHabit.getDate;
  bool get complete => ynHabit.getComplete;

  @override
  _YesNoHabitCardState createState() => _YesNoHabitCardState();
}

class _YesNoHabitCardState extends HabitCardState<YesNoHabitCard> {
  final YnHabitPresenter habitPresenter = YnHabitPresenter();
  final YnHabitManager habitManager = YnHabitManager();
  TextStyle textStyle = TextStyle(
    color: Colors.blue.shade900,
    fontSize: 18,
  );
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


  Future<void> _toggleComplete() async {
    setState(() {
      widget.ynHabit.complete = !widget.ynHabit.complete;
    });

    try {
      await habitPresenter.updateYesNoHabit(widget.ynHabit);
    } catch (e) {
      print ('Error updating complete status: $e"');
    }
  }

  Future<void> _showOptionsMenu(BuildContext, Offset offset) async {
    // final RenderObject? overlay = Overlay
    //     .of(context)
    //     .context
    //     .findRenderObject();
    final choice = await showMenu(
        color: Colors.white,
        context: context,
        position: RelativeRect.fromLTRB(
          offset.dx,
          offset.dy,
          MediaQuery
              .of(context)
              .size
              .width - offset.dx,
          MediaQuery
              .of(context)
              .size
              .height - offset.dy,
        ),
        items: [
          PopupMenuItem(value: "Edit", child: Text('Edit',
              style: TextStyle(color: Colors.blue.shade900))),
          PopupMenuItem(value: "Delete", child: Text('Delete',
              style: TextStyle(color: Colors.blue.shade900)))
        ]
    );

    switch (choice) {
      case 'Edit':
        // _editYesNoHabitDialogBuilder(context);
        break;
      case 'Delete':
        habitPresenter.removeYesNoHabit(widget.ynHabit);
        break;
    }
  }

  // Future<void> _editYesNoHabitDialogBuilder(BuildContext context) {
  //   String name = "";
  //   return showDialog<void>(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //             shape: alertDialogShape,
  //             surfaceTintColor: Colors.white,
  //             backgroundColor: popupColor,
  //             title: const Text('Add Checkbox Habit',
  //                 style: TextStyle(color: Colors.white)),
  //             content: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   TextField(
  //                     cursorColor: textFieldBorder,
  //                     style: textFieldTextStyle,
  //                     decoration: InputDecoration(hintText: "Habit name",
  //                         hintStyle: TextStyle(color: Colors.white),
  //                         border: OutlineInputBorder(
  //                             borderSide: BorderSide(color: textFieldBorder)),
  //                         focusedBorder: OutlineInputBorder(
  //                             borderSide: BorderSide(color: textFieldBorder)),
  //                         enabledBorder: OutlineInputBorder(
  //                             borderSide: BorderSide(color: textFieldBorder))),
  //                     onChanged: (value) {
  //                       name = value;
  //                     },
  //                   ),
  //                   spacer,
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       TextButton(
  //                         style: buttonStyle,
  //                         child: const Text('Cancel'),
  //                         onPressed: () {
  //                           Navigator.of(context).pop();
  //                         },
  //                       ),
  //                       spacer,
  //                       TextButton(
  //                         style: buttonStyle,
  //                         child: const Text('Done'),
  //                         onPressed: () {
  //                           habitPresenter.updateYesNoHabit(widget.ynHabit);
  //                           Navigator.of(context).pop();
  //                         },
  //                       ),
  //                     ],
  //                   )
  //                 ]
  //             )
  //         );
  //       }
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onLongPressStart: (details) async {
          final offset = details.globalPosition;
          _showOptionsMenu(context, offset);
        },
        child: Card(
          shadowColor: Colors.blue.shade900,
          color: Colors.white,
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.name,
                      overflow: TextOverflow.ellipsis,
                      style: textStyle,
                    ),
                    IconButton(
                      icon: Icon(
                        widget.ynHabit.complete
                            ? Icons.check_box_outlined
                            : Icons
                            .check_box_outline_blank,
                      ),
                      color: Colors.blue.shade900, onPressed: () {
                      _toggleComplete();
                    },
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}

