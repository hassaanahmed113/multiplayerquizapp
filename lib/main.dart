import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterquizapp/Login_screen.dart';
import 'package:flutterquizapp/Provider/quiz_provider.dart';
import 'package:flutterquizapp/Provider/text_provider.dart';

import 'package:flutterquizapp/firebase_options.dart';
import 'package:flutterquizapp/home_screen.dart';
import 'package:flutterquizapp/services/firebaseauth_services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TextProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => FirebaseServicesProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => QuizProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FirebaseAuth.instance.currentUser != null
            ? const HomeScreen()
            : const LoginScreen(),
      ),
    );
  }
}
