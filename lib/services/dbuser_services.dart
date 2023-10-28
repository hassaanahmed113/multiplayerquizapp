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
        );
        await quizdatauser.doc(user.uid).set(uuserr.toMap());
      }
    } catch (e) {
      print('Error adding item: $e');
    }
  }

  Stream<List<UserModel>> getCurrentUser() {
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      CollectionReference items = FirebaseFirestore.instance.collection('user');
      return items.where('id', isEqualTo: user.uid).snapshots().map((snapshot) {
        snapshot.docs.forEach((doc) {
          currentusercorrect = doc['correct'];
          currentuserwrong = doc['wrong'];
          notifyListeners();
        });
        return snapshot.docs.map((doc) {
          return UserModel(
              id: doc['id'],
              email: doc['email'],
              name: doc['name'],
              correct: doc['correct'],
              wrong: doc['wrong'],
              totalSelectedAnswer: doc['totalSelectedAnswer']);
        }).toList();
      });
    }

    // If there is no currently authenticated user, return an empty stream.
    return Stream.value([]);
  }

  int currentusercorrect = 0;
  int currentuserwrong = 0;
  String opponentId = "";
  int totalSelectedOpponent = 0;
  int opponentcorrect = 0;
  int opponentwrong = 0;

  Stream<List<OpponentModel>> getOpponentUser() {
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      CollectionReference items = FirebaseFirestore.instance.collection('user');
      return items
          .where('id', isNotEqualTo: user.uid)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          opponentId = doc['id'];
          totalSelectedOpponent = doc['totalSelectedAnswer'];
          opponentcorrect = doc['correct'];
          opponentwrong = doc['wrong'];
          notifyListeners();
          return OpponentModel(
              id: doc['id'],
              name: doc['name'],
              correct: doc['correct'],
              wrong: doc['wrong'],
              totalSelectedAnswer: doc['totalSelectedAnswer']);
        }).toList();
      });
    }
    // If there is no currently authenticated user, return an empty stream.
    return Stream.value([]);
  }

  Stream<num> getTotalSelectedOpponentStream() {
    final user = FirebaseAuth.instance.currentUser;
    return FirebaseFirestore.instance
        .collection('user')
        .where('id', isNotEqualTo: user!.uid)
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
