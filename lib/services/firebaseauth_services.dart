import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterquizapp/Login_screen.dart';
import 'package:flutterquizapp/Model/user_model.dart';
import 'package:flutterquizapp/home_screen.dart';
import 'package:flutterquizapp/services/dbuser_services.dart';

class FirebaseServicesProvider extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  DbuserServices db = DbuserServices();
  void loginFunction(email, password, context) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ));
    } on FirebaseAuthException catch (e) {
      print(e.code);
      String errorMessage = "";

      if (e.code == 'invalid-email') {
        errorMessage = "Invalid Email Entered";
      } else if (e.code == 'missing-password') {
        errorMessage = "Enter your Password";
      } else {
        errorMessage = "User not Found";
      }
      var snackbar = SnackBar(content: Text(errorMessage));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      notifyListeners();
    }
    notifyListeners();
  }

  void signupFunction(email, password, name, correct, wrong,
      totalSelectedAnswer, context) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ));
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        db.addUser(UserModel(
          id: user.uid,
          email: email,
          name: name,
          correct: correct,
          wrong: wrong,
          totalSelectedAnswer: totalSelectedAnswer,
        ));
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
      String errorMessage = "";

      if (e.code == 'invalid-email') {
        errorMessage = "Invalid Email Entered";
      } else if (e.code == 'missing-password') {
        errorMessage = "Enter your Password";
      } else if (e.code == 'weak-password') {
        errorMessage = "Enter password more than 6 characters";
      } else {
        errorMessage = "Already exist";
      }
      var snackbar = SnackBar(content: Text(errorMessage));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      notifyListeners();
    }
    notifyListeners();
  }

  DbuserServices dbopponent = DbuserServices();
  void signoutFunction(context) async {
    try {
      await _auth.signOut();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ));
    } catch (e) {
      print("thhis is $e");
    }
  }
}
