import 'dart:async';
import 'package:flutter/material.dart';
import 'waterClockFuncs.dart';


class NotificationPresenter {
  final NotificationHelper notificationHelper;
  final Function updateStateCallback;

  NotificationPresenter({
    required this.notificationHelper,
    required this.updateStateCallback
  });

  bool isTimerActive = false;
  int remainingSeconds = 0;
  Timer? timer;

  // Initialize notifications
  Future<void> initialize() async {
    await notificationHelper.initializeNotifications();

  }

  // Function to start the timer based on user input
  void startTimer(String inputText, BuildContext context) {
    final int? durationInMinutes = int.tryParse(inputText);

    if (durationInMinutes != null && durationInMinutes > 0) {
      final duration = Duration(minutes: durationInMinutes);
      remainingSeconds = duration.inSeconds;

      // Schedule the notification after the given duration
      notificationHelper.scheduleNotification(
        title: 'Water clock',
        body: 'Time to drink more water',
        duration: duration,
      );

      // Set the timer status to active
      isTimerActive = true;

      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (remainingSeconds > 0) {
          remainingSeconds--;
        } else {
          timer.cancel();
          isTimerActive = false;
        }
        updateStateCallback();
      });

      // Show a confirmation Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Timer set for $durationInMinutes minutes')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number of minutes')),
      );
      updateStateCallback();
    }
  }

  // Function to cancel the scheduled timer
  void cancelTimer(BuildContext context) {
    // Cancel the scheduled notification
    notificationHelper.cancelNotification();

    // Reset the timer status
    isTimerActive = false;
    remainingSeconds = 0;

    // Cancel the timer if it's running
    timer?.cancel();

    // Show a confirmation Snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Timer canceled')),
    );
    updateStateCallback();
  }

  // Function to format the remaining time in minutes:seconds
  String getFormattedTime() {
    int minutes = remainingSeconds ~/ 60;
    int seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void resumeTimer() {
    if (isTimerActive && remainingSeconds > 0) {
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (remainingSeconds > 0) {
          remainingSeconds--;
        } else {
          timer.cancel();
          isTimerActive = false;
          notificationHelper.cancelNotification();
        }
        updateStateCallback();
      });
    }
  }



}
