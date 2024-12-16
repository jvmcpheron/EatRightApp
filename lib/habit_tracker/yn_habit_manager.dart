import 'package:groupies/habit_tracker/yes_no_habit.dart';
import 'package:groupies/habit_tracker/habit_list.dart';
import '../UUID.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class YnHabitManager {

  final HabitList habits;

  YnHabitManager._internal(this.habits);

  static final YnHabitManager _instance = YnHabitManager._internal(
      HabitList()
  );

  factory YnHabitManager() => _instance;

  List<YesNoHabit> getYesNoHabits() {
    fetchYesNoHabits();
    return habits.getYesNoHabits;
  }

  Future<void> fetchYesNoHabits() async {
    // todo goes to database and gets favorite yesNoHabits and makes it list

    String? userId = UserSingleton.instance.getUserId();

    if (userId == null) {
      throw Exception("User ID is null. Cannot fetch habits.");
    }

    try {
      DocumentSnapshot userYnHabitsSnapshot = await FirebaseFirestore.instance
          .collection('YesNoHabits')
          .doc(userId)
          .get();

      if (!userYnHabitsSnapshot.exists) {
        return;
      }

      List<dynamic> ynHabitsData = userYnHabitsSnapshot['yesNoHabits'];

      List<YesNoHabit> ynHabits = ynHabitsData.map((ynHabitData) {
        final mapData = ynHabitData as Map<String, dynamic>;
        return YesNoHabit.fromHabit(
            mapData['name'],
            mapData['date'].toDate(),
            mapData['complete']
        );
      }).toList();

      // return ynHabits;
      habits.setYesNoHabits(ynHabits);

    } catch (e) {
      print("Error fetching yesNoHabits: $e");
      throw Exception("Failed to fetch yesNoHabits");
    }
  }

  Future<void> removeYesNoHabit(YesNoHabit h) async {
    //todo removes yesNoHabit from list, and from database
    String? userId = UserSingleton.instance.getUserId();

    if (userId == null) {
      print("User ID is null. Cannot update habits.");
      return;
    }

    DocumentReference userYnHabitsRef = FirebaseFirestore.instance
        .collection('YesNoHabits').doc(userId);

    try {
      DocumentSnapshot userYnHabitsSnapshot = await userYnHabitsRef.get();

      if (userYnHabitsSnapshot.exists) {
        List<dynamic>? currYnHabits = userYnHabitsSnapshot['yesNoHabits'];

        if (currYnHabits != null) {
          bool ynHabitExists = currYnHabits.any(
                  (yesNoHabit) => yesNoHabit['id'] == h.id);
          if (ynHabitExists) {
            currYnHabits.removeWhere((yesNoHabit) => yesNoHabit['id'] == h.id);
            await userYnHabitsRef.update({'yesNoHabits': currYnHabits});

            // habits.removeYesNoHabitFromList(h.id);
          }
        }
      }
    } catch (e) {
      print("Error removing habit: $e");
    }
  }

  Future addYesNoHabit(YesNoHabit h) async {
    String? userId = UserSingleton.instance.getUserId();

    if (userId == null) {
      print("User ID is null. Cannot update habits.");
      return;
    }

    Map<String, dynamic> ynHabitData = {
      'id': h.id,
      'name': h.name,
      'date': h.date,
      'complete': h.complete,
    };

    DocumentReference userYnHabitsRef = FirebaseFirestore.instance
        .collection('YesNoHabits').doc(userId);

    try {
      DocumentSnapshot userYnHabitsSnapshot = await userYnHabitsRef.get();

      if (!userYnHabitsSnapshot.exists) {
        await userYnHabitsRef.set({'yesNoHabits': [ynHabitData]});
      } else {
        List<dynamic>? currYnHabits = userYnHabitsSnapshot['yesNoHabits'];

        if (currYnHabits == null) {
          await userYnHabitsRef.update({'yesNoHabits': [ynHabitData]});
        } else {
          bool ynHabitExists = currYnHabits.any(
                  (yesNoHabit) => yesNoHabit['id'] == h.id);
          if (ynHabitExists) {
            currYnHabits[currYnHabits.indexWhere(
                    (yesNoHabit) => yesNoHabit['id'] == h.id)] = ynHabitData;
            await userYnHabitsRef.update({'yesNoHabits': currYnHabits});
            print("yesNoHabit removed from yesNoHabits.");
          } else {
            currYnHabits.add(ynHabitData);

            // habits.addYesNoHabitToList(h);

            await userYnHabitsRef.update({'yesNoHabits': currYnHabits});
            print("yesNoHabit added to yesNoHabits.");
          }
        }
      }
    } catch (e) {
      print("Error adding habit: $e");
    }
  }

  Future<void> updateYesNoHabit(YesNoHabit h) async {
    String? userId = UserSingleton.instance.getUserId();

    if (userId == null) {
      print("User ID is null. Cannot update habits.");
      return;
    }

    Map<String, dynamic> ynHabitData = {
      'id': h.id,
      'name': h.name,
      'date': h.date,
      'complete': h.complete,
    };

    DocumentReference userYnHabitsRef = FirebaseFirestore.instance
        .collection('YesNoHabits').doc(userId);
    try {
      DocumentSnapshot userYnHabitsSnapshot = await userYnHabitsRef.get();

      if (!userYnHabitsSnapshot.exists) {
        await userYnHabitsRef.set({'yesNoHabits': [ynHabitData]});
        print("Habits document created and yesNoHabit added.");
      } else {
        List<dynamic>? currYnHabits =
        userYnHabitsSnapshot['yesNoHabits'] as List<dynamic>?;

        // if user has no habits stored, just add the habit
        if (currYnHabits == null) {
          await userYnHabitsRef.update({'yesNoHabits': [ynHabitData]});
          print("Habits array initialized and yesNoHabit added.");
        } else { // else, check whether habit is already in database
          bool yesNoHabitExists = currYnHabits.any((yesNoHabit) =>
          yesNoHabit['id'] == h.id);


          if (yesNoHabitExists) {
            currYnHabits[currYnHabits.indexWhere(
                    (yesNoHabit) => yesNoHabit['id'] == h.id)] = ynHabitData;

            habits.editYesNoHabit(h);

            await userYnHabitsRef.update(
                {'yesNoHabits': currYnHabits});
            print("yesNoHabit removed from yesNoHabits.");
          } else {
            currYnHabits.add(ynHabitData);
            await userYnHabitsRef.update(
                {'yesNoHabits': currYnHabits});
            print("yesNoHabit added to yesNoHabits.");
          }
        }
      }
    } catch (e) {
      print("Error updating yesNoHabits: $e");
    }
  }

}
