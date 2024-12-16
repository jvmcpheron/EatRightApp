import 'package:flutter/material.dart';
import 'package:groupies/habit_tracker/q_habit_presenter.dart';
import 'package:groupies/habit_tracker/quantity_habit.dart';
import 'habit.dart';
import 'habit_card.dart';


class QuantityHabitCard extends HabitCard {
  QuantityHabit qHabit;

  QuantityHabitCard({
    super.key,
    required this.qHabit,
  }) : super(habit: qHabit);


  @override
  _QuantityHabitCardState createState() => _QuantityHabitCardState();
}

class _QuantityHabitCardState extends HabitCardState<QuantityHabitCard> {
  QHabitPresenter qHabitPresenter = QHabitPresenter();
  TextStyle textStyle = TextStyle(
    color: Colors.blue.shade900,
    fontSize: 18,
  );

  @override
  void initState() {
    super.initState();
  }

  // void _toggleComplete() {
  //   setState(() {
  //     // widget.complete = !widget.complete;
  //   });
  // }

  Future<void> _showOptionsMenu(BuildContext, Offset offset) async {
    final RenderObject? overlay = Overlay
        .of(context)
        .context
        .findRenderObject();
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
        break;
      case 'Delete':
        qHabitPresenter.removeQuantityHabit(widget.qHabit);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) async {
        final offset = details.globalPosition;
        _showOptionsMenu(context, offset);
      },
      child: SizedBox(
        height: 60, // Fixed height for each recipe card
        child: Card(
          shadowColor: Colors.blue.shade900,
          color: Colors.white,
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.qHabit.getName,
                      overflow: TextOverflow.ellipsis,
                      style: textStyle,
                    ),
                    Row(
                      children: [
                        Text(
                          widget.qHabit.getAmount.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: textStyle,
                        ),
                        SizedBox(width: 10,),
                        Text(
                          widget.qHabit.getUnit,
                          overflow: TextOverflow.ellipsis,
                          style: textStyle,
                        ),
                        SizedBox(width: 16),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
