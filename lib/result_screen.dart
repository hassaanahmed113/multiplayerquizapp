import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterquizapp/Model/OpponentModel.dart';
import 'package:flutterquizapp/Model/user_model.dart';
import 'package:flutterquizapp/Provider/quiz_provider.dart';
import 'package:flutterquizapp/Utils/app_colors.dart';
import 'package:flutterquizapp/Utils/custom_widgets.dart';
import 'package:flutterquizapp/services/dbuser_services.dart';
import 'package:flutterquizapp/services/firebaseauth_services.dart';
import 'package:provider/provider.dart';

class ResultScreen extends StatefulWidget {
  String opponentId;
  ResultScreen(this.opponentId, {super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  CustomWidget cus = CustomWidget();
  DbuserServices dbopponent = DbuserServices();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    final user = FirebaseAuth.instance.currentUser;
    const isBusy = false;

// Reference to the Firestore collection and document current user
    final userDocRef =
        FirebaseFirestore.instance.collection('user').doc(user!.uid);

    userDocRef.update({
      'isBusy': isBusy,
    }).then((value) {
      print('isBusy updated successfully');
    }).catchError((error) {
      print('Error updating isBusy: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Consumer<FirebaseServicesProvider>(
              builder: (context, firebaseprovider, child) {
                return Consumer<QuizProvider>(
                  builder: (context, quizProvider, child) {
                    return IconButton(
                      onPressed: () async {
                        firebaseprovider.signoutFunction(context);

                        quizProvider.answers.clear();
                        quizProvider.providedanswers.clear();
                        quizProvider.correct = 0;
                        quizProvider.wrong = 0;

                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: // In your ResultScreen widget
            StreamBuilder<num>(
          stream: dbopponent.getTotalSelectedOpponentStream(widget
              .opponentId), // Create a new stream getter in DbuserServices
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(color: Colors.blue);
            } else if (snapshot.hasError) {
              return const CircularProgressIndicator(color: Colors.blue);
            } else {
              final totalSelectedOpponent = snapshot.data ?? 0;

              if (totalSelectedOpponent < 3) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Wait opponent result in progress"),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(color: Colors.blue),
                      ),
                    ],
                  ),
                );
              } else {
                // Your existing code for showing the opponent details
                return Consumer<QuizProvider>(
                  builder: (context, providerquiz, child) {
                    return Consumer<QuizProvider>(
                      builder: (context, providerquiz, child) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Wrap(
                            direction: Axis.horizontal,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 400,
                                  child: Column(
                                    children: [
                                      StreamBuilder<UserModel?>(
                                        stream: dbopponent.getCurrentUser(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            // While waiting for data
                                            return const SizedBox(
                                              height: 100,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                              ),
                                            );
                                          } else if (snapshot.hasError) {
                                            // If an error occurs
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          } else if (snapshot.data != null) {
                                            // If opponent data is available
                                            final opponent = snapshot.data!;

                                            return Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Wrap(
                                                    direction: Axis.horizontal,
                                                    children: [
                                                      cus.textCus(
                                                          "Opponent: ${opponent.name} ",
                                                          20,
                                                          FontWeight.bold,
                                                          AppColor()
                                                              .blackColor),
                                                      cus.textCus(
                                                          "Correct: ",
                                                          20,
                                                          FontWeight.bold,
                                                          AppColor()
                                                              .blackColor),
                                                      cus.textCus(
                                                          "${opponent.correct}",
                                                          20,
                                                          FontWeight.bold,
                                                          AppColor()
                                                              .correctColor),
                                                      cus.textCus(
                                                          " Wrong: ",
                                                          20,
                                                          FontWeight.bold,
                                                          AppColor()
                                                              .blackColor),
                                                      cus.textCus(
                                                          "${opponent.wrong}",
                                                          20,
                                                          FontWeight.bold,
                                                          AppColor().wrongColor)
                                                    ]),
                                              ),
                                            );
                                          } else {
                                            // If no opponent data is available
                                            return const Text(
                                                'No opponent data found.');
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 400,
                                  child: Column(
                                    children: [
                                      StreamBuilder<OpponentModel?>(
                                        stream:
                                            dbopponent.getFirstOpponentByUserId(
                                                widget.opponentId),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            // While waitin\g for data
                                            return const SizedBox(
                                              height: 100,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                              ),
                                            );
                                          } else if (snapshot.hasError) {
                                            // If an error occurs
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          } else if (snapshot.data != null) {
                                            // If opponent data is available
                                            final opponent = snapshot.data!;

                                            return Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Wrap(
                                                    direction: Axis.horizontal,
                                                    children: [
                                                      cus.textCus(
                                                          "Opponent: ${opponent.name} ",
                                                          20,
                                                          FontWeight.bold,
                                                          AppColor()
                                                              .blackColor),
                                                      cus.textCus(
                                                          "Correct: ",
                                                          20,
                                                          FontWeight.bold,
                                                          AppColor()
                                                              .blackColor),
                                                      cus.textCus(
                                                          "${opponent.correct}",
                                                          20,
                                                          FontWeight.bold,
                                                          AppColor()
                                                              .correctColor),
                                                      cus.textCus(
                                                          " Wrong: ",
                                                          20,
                                                          FontWeight.bold,
                                                          AppColor()
                                                              .blackColor),
                                                      cus.textCus(
                                                          "${opponent.wrong}",
                                                          20,
                                                          FontWeight.bold,
                                                          AppColor().wrongColor)
                                                    ]),
                                              ),
                                            );
                                          } else {
                                            // If no opponent data is available
                                            return const Text(
                                                'No opponent data found.');
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              }
            }
          },
        ));
  }
}
