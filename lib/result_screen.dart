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
  String roomId;
  ResultScreen(this.roomId, {super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  CustomWidget cus = CustomWidget();
  DbuserServices dbopponent = DbuserServices();

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
                      onPressed: () {
                        firebaseprovider.signoutFunction(context);

                        quizProvider.answers.clear();
                        quizProvider.providedanswers.clear();
                        quizProvider.correct = 0;
                        quizProvider.wrong = 0;
                        final user = FirebaseAuth.instance.currentUser;
                        FirebaseFirestore.instance
                            .collection("user")
                            .doc(user!.uid)
                            .update({
                          'correct': 0,
                          'wrong': 0,
                          'totalSelectedAnswer': 0
                        });
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
          stream: dbopponent
              .getTotalSelectedOpponentStream(), // Create a new stream getter in DbuserServices
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(color: Colors.blue);
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final totalSelectedOpponent = snapshot.data ?? 0;

              if (totalSelectedOpponent < 3) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Wair opponent result in progress"),
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
                                      StreamBuilder<List<UserModel>>(
                                        stream: dbopponent.getCurrentUser(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator(
                                              color: Colors.transparent,
                                            );
                                          }
                                          if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          }
                                          if (!snapshot.hasData ||
                                              snapshot.data!.isEmpty) {
                                            return const CircularProgressIndicator(
                                              color: Colors.blue,
                                            );
                                          }
                                          return Expanded(
                                            child: ListView.builder(
                                              itemCount: 1,
                                              itemBuilder: (context, index) {
                                                final currentuser =
                                                    snapshot.data![index];
                                                return Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        cus.textCus(
                                                            "Current User: ${currentuser.name} ",
                                                            20,
                                                            FontWeight.bold,
                                                            AppColor()
                                                                .blackColor),
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            cus.textCus(
                                                                "Correct: ",
                                                                20,
                                                                FontWeight.bold,
                                                                AppColor()
                                                                    .blackColor),
                                                            cus.textCus(
                                                                "${currentuser.correct}",
                                                                20,
                                                                FontWeight.bold,
                                                                AppColor()
                                                                    .correctColor),
                                                          ],
                                                        ),
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            cus.textCus(
                                                                " Wrong: ",
                                                                20,
                                                                FontWeight.bold,
                                                                AppColor()
                                                                    .blackColor),
                                                            cus.textCus(
                                                                "${currentuser.wrong}",
                                                                20,
                                                                FontWeight.bold,
                                                                AppColor()
                                                                    .wrongColor)
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 400,
                                  child: Column(
                                    children: [
                                      StreamBuilder<List<OpponentModel>>(
                                        stream: dbopponent
                                            .getOpponentUser(widget.roomId),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator(
                                              color: Colors.transparent,
                                            );
                                          }
                                          if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          }
                                          if (!snapshot.hasData ||
                                              snapshot.data!.isEmpty) {
                                            return const CircularProgressIndicator(
                                              color: Colors.blue,
                                            );
                                          }
                                          return Expanded(
                                            child: ListView.builder(
                                              itemCount: 1,
                                              itemBuilder: (context, index) {
                                                final opponent =
                                                    snapshot.data![index];
                                                return Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        cus.textCus(
                                                            "Opponent User: ${opponent.name} ",
                                                            20,
                                                            FontWeight.bold,
                                                            AppColor()
                                                                .blackColor),
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
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
                                                          ],
                                                        ),
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
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
                                                                AppColor()
                                                                    .wrongColor)
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
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
