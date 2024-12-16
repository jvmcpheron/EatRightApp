import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupies/habit_tracker/yes_no_habit.dart';
import 'package:groupies/habit_tracker/yn_habit_manager.dart';
import '../UUID.dart';
import 'habit_list.dart';

class YnHabitPresenter {
  final YnHabitManager _ynHabitManager = YnHabitManager();

  List<YesNoHabit> getYesNoHabits() {
    return _ynHabitManager.getYesNoHabits();
  }

  void removeYesNoHabit(YesNoHabit h) {
    _ynHabitManager.removeYesNoHabit(h);
  }

  Future addYesNoHabit(YesNoHabit h) async {
    _ynHabitManager.addYesNoHabit(h);
  }

  Future<void> updateYesNoHabit(YesNoHabit h) async {
    _ynHabitManager.updateYesNoHabit(h);
  }

  Future<void> fetchYesNoHabits() async {
    _ynHabitManager.fetchYesNoHabits();
  }

  // Future<List<YesNoHabit>> getYesNoHabitsFromFirebase() async {
  //   String? userId = UserSingleton.instance.getUserId();
  //
  //   if (userId == null) {
  //     throw Exception("User ID is null. Cannot fetch YesNoHabits.");
  //   }
  //
  //   try {
  //     DocumentSnapshot userYesNoHabitsSnapshot = await FirebaseFirestore.instance
  //         .collection('YesNoHabits')
  //         .doc(userId)
  //         .get();
  //
  //     if (!userYesNoHabitsSnapshot.exists) {
  //       return [];
  //     }
  //
  //     List<dynamic> yesNoHabitsData = userYesNoHabitsSnapshot['yesNoHabits'] as List<dynamic>? ?? [];
  //     return yesNoHabitsData.map((yesNoHabitsData) {
  //       final mapData = yesNoHabitsData as Map<String, dynamic>;
  //       return YesNoHabit(
  //         mapData['name'],
  //         mapData['date'],
  //       );
  //     }).toList();
  //   } catch (e) {
  //     print("Error fetching ynHabits from Firebase: $e");
  //     throw Exception("Failed to fetch ynHabits.");
  //   }
  // }
}
