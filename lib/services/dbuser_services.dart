import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterquizapp/Model/OpponentModel.dart';
import 'package:flutterquizapp/Model/user_model.dart';

class DbuserServices extends ChangeNotifier {
  Future<void> addUser(UserModel User) async {
    final quizdatauser = FirebaseFirestore.instance.collection('user');
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      final user = auth.currentUser;
      if (user != null) {
        final uuserr = UserModel(
            id: User.id,
            email: User.email,
            name: User.name,
            correct: 0,
            wrong: 0,
            totalSelectedAnswer: 0,
            isBusy: false);
        await quizdatauser.doc(user.uid).set(uuserr.toMap());
      }
    } catch (e) {
      print('Error adding item: $e');
    }
  }

  Stream<UserModel?> getCurrentUser() {
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      CollectionReference items = FirebaseFirestore.instance.collection('user');
      return items
          .where('id', isEqualTo: user.uid)
          .limit(1) // Limit the results to one
          .snapshots()
          .map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          final doc = snapshot.docs[0]; // Take the first opponent found
          opponentId = doc['id'];
          totalSelectedOpponent = doc['totalSelectedAnswer'];
          opponentcorrect = doc['correct'];
          opponentwrong = doc['wrong'];
          opponentuserName = doc['name'];
          notifyListeners();
          return UserModel(
              id: doc['id'],
              email: doc['email'],
              name: doc['name'],
              correct: doc['correct'],
              wrong: doc['wrong'],
              totalSelectedAnswer: doc['totalSelectedAnswer'],
              isBusy: doc['isBusy']);
        } else {
          return null; // Return null if no opponent is found
        }
      });
    }
    // If there is no currently authenticated user, return null.
    return Stream.value(null);
  }

  int currentusercorrect = 0;
  int currentuserwrong = 0;
  String opponentId = "";
  int totalSelectedOpponent = 0;
  int opponentcorrect = 0;
  int opponentwrong = 0;
  String currentuserName = '';
  String opponentuserName = '';
  Stream<OpponentModel?> getFirstOpponent() {
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      CollectionReference items = FirebaseFirestore.instance.collection('user');
      return items
          .where('isBusy', isEqualTo: false) // Only select available opponents
          .snapshots()
          .map((snapshot) {
        if (snapshot.docs.length >= 2) {
          final doc = snapshot.docs[1]; // Take the second opponent found
          opponentId = doc['id'];
          totalSelectedOpponent = doc['totalSelectedAnswer'];
          opponentcorrect = doc['correct'];
          opponentwrong = doc['wrong'];
          opponentuserName = doc['name'];
          notifyListeners();
          return OpponentModel(
            id: doc['id'],
            name: doc['name'],
            correct: doc['correct'],
            wrong: doc['wrong'],
            totalSelectedAnswer: doc['totalSelectedAnswer'],
          );
        } else {
          return null; // Return null if there are fewer than two opponents available.
        }
      });
    }
    // If there is no currently authenticated user, return null.
    return Stream.value(null);
  }

  Stream<OpponentModel?> getFirstOpponentByUserId(opponentid) {
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      CollectionReference items = FirebaseFirestore.instance.collection('user');
      return items
          .where('id', isEqualTo: opponentid) // Limit the results to one
          .snapshots()
          .map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          final doc = snapshot.docs[0]; // Take the first opponent found
          notifyListeners();
          return OpponentModel(
            id: doc['id'],
            name: doc['name'],
            correct: doc['correct'],
            wrong: doc['wrong'],
            totalSelectedAnswer: doc['totalSelectedAnswer'],
          );
        } else {
          return null; // Return null if no opponent is found
        }
      });
    }
    // If there is no currently authenticated user, return null.
    return Stream.value(null);
  }

  Stream<num> getTotalSelectedOpponentStream(oppponent) {
    final user = FirebaseAuth.instance.currentUser;
    return FirebaseFirestore.instance
        .collection('user')
        .where('id', isEqualTo: oppponent)
        .snapshots()
        .map((querySnapshot) {
      num totalSelectedAnswer = 0;

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        totalSelectedAnswer += doc['totalSelectedAnswer'] ?? 0;
      }

      return totalSelectedAnswer;
    });
  }
}
