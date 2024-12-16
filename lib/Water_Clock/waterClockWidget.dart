import 'dart:async';
import 'package:flutter/material.dart';
import 'package:groupies/pancake.dart';
import 'waterClockFuncs.dart';
import 'waterClockPresenter.dart';
import 'package:groupies/BottomBar.dart';


class Water_Clock extends StatelessWidget {
  const Water_Clock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        leading: const PancakeMenuButton(),
        title: Row(
          children: const [
            Text('Water Clock', style: TextStyle(color: Colors.white)),
            SizedBox(width: 8),
            Icon(Icons.lock_clock, color: Colors.white),
          ],
        ),
      ),
      backgroundColor: Colors.lightBlueAccent,
      body: const NotificationBody(key: PageStorageKey('water_clock_timer')),
      bottomNavigationBar: const WhiteBottomBar(),
    );
  }
}

class NotificationBody extends StatefulWidget {
  const NotificationBody({Key? key}) : super(key: key);

  @override
  NotificationBodyState createState() => NotificationBodyState();
}
class NotificationBodyState extends State<NotificationBody>  {
  final NotificationHelper notificationHelper = NotificationHelper();
  late final NotificationPresenter presenter;
  final TextEditingController controller = TextEditingController();

  bool isTimerActive = false;
  int remainingSeconds = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    presenter = NotificationPresenter(
      notificationHelper: notificationHelper,
      updateStateCallback: updateState,
    );
    presenter.initialize(); // Initialize notifications

  }

  @override
  void dispose() {
    controller.dispose();
    timer?.cancel();
    super.dispose();
  }

  // Callback function that updates the state of the view
  void updateState() {
    setState(() {
      isTimerActive = presenter.isTimerActive;
      remainingSeconds = presenter.remainingSeconds;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display the remaining time above the input field

            Text(

              presenter.getFormattedTime(),
              style: const TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          const SizedBox(height: 16),

          // Input field for the timer duration
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter timer duration (in minutes)',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Start Timer Button
          ElevatedButton(
            onPressed: () {
              presenter.startTimer(controller.text,context);
            },
            child: const Text('Start Timer'),
          ),
          const SizedBox(height: 16),



            ElevatedButton(
              onPressed: () {
                presenter.cancelTimer(context);
              },
              child: const Text('Cancel Timer'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
        ],
      ),
    );
  }
}