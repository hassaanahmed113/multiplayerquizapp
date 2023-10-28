import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class QuizProvider extends ChangeNotifier {
  bool isVal = false;
  List<dynamic> answers = [];
  List<dynamic> providedanswers = [];
  void valueChange() {
    isVal = true;
    notifyListeners();
  }

  int correct = 0;
  int wrong = 0;
  calculateResult(index) {
    if (answers[index] == providedanswers[index]) {
      correct += 1;

      final user = FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance
          .collection("user")
          .doc(user!.uid)
          .update({'correct': correct});
      notifyListeners();
    } else {
      wrong += 1;
      final user = FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance
          .collection("user")
          .doc(user!.uid)
          .update({'wrong': wrong});
      notifyListeners();
    }

    print(correct);
    notifyListeners();
  }
}
