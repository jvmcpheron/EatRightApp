import 'package:groupies/habit_tracker/quantity_habit.dart';
import 'package:groupies/habit_tracker/habit_list.dart';
import '../UUID.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QHabitManager {

  final HabitList habits;

  QHabitManager._internal(this.habits);

  static final QHabitManager _instance = QHabitManager._internal(
      HabitList()
  );

  factory QHabitManager() => _instance;

  HabitList get getFavorites => habits;

  List<QuantityHabit> getQuantityHabits() {
    fetchQuantityHabits();
    return habits.getQuantityHabits;
  }

  Future<void> fetchQuantityHabits() async {
    String? userId = UserSingleton.instance.getUserId();

    if (userId == null) {
      throw Exception("User ID is null. Cannot fetch habits.");
    }

    try {
      DocumentSnapshot userQHabitsSnapshot = await FirebaseFirestore.instance
          .collection('QuantityHabits')
          .doc(userId)
          .get();

      if (!userQHabitsSnapshot.exists) {
        return;
      }

      List<dynamic> qHabitsData = userQHabitsSnapshot['quantityHabits'];

      List<QuantityHabit> qHabits = qHabitsData.map((qHabitData) {
        final mapData = qHabitData as Map<String, dynamic>;
        return QuantityHabit.fromHabit(
            mapData['name'],
            mapData['date'].toDate(),
            mapData['amount'],
            mapData['unit']
        );
      }).toList();

      habits.setQuantityHabits(qHabits);
    } catch (e) {
      print("Error fetching quantityHabits: $e");
      throw Exception("Failed to fetch quantityHabits");
    }
  }


  Future<void> removeQuantityHabit(QuantityHabit h) async {
    //todo removes quantityHabit from list, and from database
    String? userId = UserSingleton.instance.getUserId();

    if (userId == null) {
      print("User ID is null. Cannot update habits.");
      return;
    }

    DocumentReference userQHabitsRef = FirebaseFirestore.instance
        .collection('QuantityHabits').doc(userId);

    try {
      DocumentSnapshot userQHabitsSnapshot = await userQHabitsRef.get();

      if (userQHabitsSnapshot.exists) {
        List<dynamic>? currQHabits = userQHabitsSnapshot['quantityHabits'];

        if (currQHabits != null) {
          bool qHabitExists = currQHabits.any(
                  (quantityHabit) => quantityHabit['id'] == h.id);
          if (qHabitExists) {
            currQHabits.removeWhere((quantityHabit) => quantityHabit['id'] == h.id);
            await userQHabitsRef.update({'quantityHabits': currQHabits});
          }
        }
      }
    } catch (e) {
      print("Error removing habit: $e");
    }
  }

  Future addQuantityHabit(QuantityHabit h) async {
    String? userId = UserSingleton.instance.getUserId();

    if (userId == null) {
      print("User ID is null. Cannot update habits.");
      return;
    }

    Map<String, dynamic> qHabitData = {
      'id': h.id,
      'name': h.name,
      'date': h.date,
      'amount': h.amount,
      'unit': h.unit,
    };

    DocumentReference userQHabitsRef = FirebaseFirestore.instance
        .collection('QuantityHabits').doc(userId);

    try {
      DocumentSnapshot userQHabitsSnapshot = await userQHabitsRef.get();

      if (!userQHabitsSnapshot.exists) {
        await userQHabitsRef.set({'quantityHabits': [qHabitData]});
      } else {
        List<dynamic>? currQHabits = userQHabitsSnapshot['quantityHabits'];

        if (currQHabits == null) {
          await userQHabitsRef.update({'quantityHabits': [qHabitData]});
        } else {
          bool qHabitExists = currQHabits.any(
                  (quantityHabit) => quantityHabit['id'] == h.id);
          if (qHabitExists) {
            currQHabits[currQHabits.indexWhere(
                    (quantityHabit) => quantityHabit['id'] == h.id)] = qHabitData;
            await userQHabitsRef.update({'quantityHabits': currQHabits});
            print("quantityHabit removed from quantityHabits.");
          } else {
            currQHabits.add(qHabitData);

            // habits.addQuantityHabitToList(h);

            await userQHabitsRef.update({'quantityHabits': currQHabits});
            print("quantityHabit added to quantityHabits.");
          }
        }
      }
    } catch (e) {
      print("Error adding habit: $e");
    }
  }
  
  
  Future<void> updateQuantityHabit(QuantityHabit h) async {
    String? userId = UserSingleton.instance.getUserId();

    if (userId == null) {
      print("User ID is null. Cannot update habits.");
      return;
    }

    Map<String, dynamic> qHabitData = {
      'id': h.id,
      'name': h.name,
      'date': h.date,
      'amount': h.amount,
      'unit': h.unit,
    };

    DocumentReference userQHabitsRef = FirebaseFirestore.instance
        .collection('QuantityHabits').doc(userId);
    try {
      DocumentSnapshot userQHabitsSnapshot = await userQHabitsRef.get();

      if (!userQHabitsSnapshot.exists) {
        await userQHabitsRef.set({'quantityHabits': [qHabitData]});
        print("Habits document created and quantityHabit added.");
      } else {
        List<dynamic>? currQHabits =
        userQHabitsSnapshot['quantityHabits'] as List<dynamic>?;

        // if user has no habits stored, just add the habit
        if (currQHabits == null) {
          await userQHabitsRef.update({'quantityHabits': [qHabitData]});
          print("Habits array initialized and quantityHabit added.");
        } else { // else, check whether habit is already in database
          bool qHabitExists = currQHabits.any((quantityHabit) =>
          quantityHabit['id'] == h.id);
          
          if (qHabitExists) {
            currQHabits[currQHabits.indexWhere(
                    (quantityHabit) => quantityHabit['id'] == h.id)] = qHabitData;

            habits.editQuantityHabit(h);

            await userQHabitsRef.update(
                {'quantityHabits': currQHabits});
            print("quantityHabit removed from quantityHabits.");
          } else {
            currQHabits.add(qHabitData);
            await userQHabitsRef.update(
                {'quantityHabits': currQHabits});
            print("quantityHabit added to quantityHabits.");
          }
        }
      }
    } catch (e) {
      print("Error updating quantityHabits: $e");
    }
  }
}