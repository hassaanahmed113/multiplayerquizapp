import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterquizapp/Model/OpponentModel.dart';
import 'package:flutterquizapp/Model/RoomModel.dart';
import 'package:flutterquizapp/Provider/quiz_provider.dart';
import 'package:flutterquizapp/Utils/app_colors.dart';
import 'package:flutterquizapp/Utils/custom_widgets.dart';
import 'package:flutterquizapp/result_screen.dart';
import 'package:flutterquizapp/services/db_services.dart';
import 'package:flutterquizapp/services/dbuser_services.dart';
import 'package:flutterquizapp/services/firebaseauth_services.dart';
import 'package:flutterquizapp/services/roomdb_services.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CustomWidget cus = CustomWidget();
  DBServices db = DBServices();
  FirebaseFirestore dbfirestore = FirebaseFirestore.instance;
  int value = 0;
  DbuserServices dbopponent = DbuserServices();
  RoomdbServices roomDb = RoomdbServices();
  final user = FirebaseAuth.instance.currentUser;
  String opponentId = '';
  bool opponentValue = true;
  bool opponentFound = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return value - 1 != 2
        ? Scaffold(
            backgroundColor: Colors.grey[200],
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.blue,
              centerTitle: true,
              title: cus.textCus(
                  "QUIZ APP", 23, FontWeight.bold, AppColor().textColor),
              // actions: [
              //   Consumer<FirebaseServicesProvider>(
              //     builder: (context, firebaseprovider, child) {
              //       return Consumer<QuizProvider>(
              //         builder: (context, quizProvider, child) {
              //           return IconButton(
              //               onPressed: () {
              //                 firebaseprovider.signoutFunction(context,);

              //                 quizProvider.answers.clear();
              //                 quizProvider.providedanswers.clear();
              //                 quizProvider.correct = 0;
              //                 quizProvider.wrong = 0;

              //                 final user = FirebaseAuth.instance.currentUser;

              //                 FirebaseFirestore.instance
              //                     .collection("user")
              //                     .doc(user!.uid)
              //                     .update({'correct': 0, 'wrong': 0});
              //               },
              //               icon: const Icon(
              //                 Icons.logout,
              //                 color: Colors.white,
              //               ));
              //         },
              //       );
              //     },
              //   ),
              // ],
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 100,
                      child: StreamBuilder<OpponentModel?>(
                        stream: opponentValue
                            ? dbopponent.getFirstOpponent()
                            : dbopponent.getFirstOpponentByUserId(opponentId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // While waiting for data
                            return const SizedBox(
                              height: 100,
                              child: CircularProgressIndicator(
                                color: Colors.transparent,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            // If an error occurs
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.data != null) {
                            // If opponent data is available
                            final opponent = snapshot.data!;
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    Wrap(direction: Axis.horizontal, children: [
                                  cus.textCus("Opponent: ${opponent.name} ", 20,
                                      FontWeight.bold, AppColor().blackColor),
                                  cus.textCus("Correct: ", 20, FontWeight.bold,
                                      AppColor().blackColor),
                                  cus.textCus("${opponent.correct}", 20,
                                      FontWeight.bold, AppColor().correctColor),
                                  cus.textCus(" Wrong: ", 20, FontWeight.bold,
                                      AppColor().blackColor),
                                  cus.textCus("${opponent.wrong}", 20,
                                      FontWeight.bold, AppColor().wrongColor)
                                ]),
                              ),
                            );
                          } else {
                            // If no opponent data is available
                            return const Text('No opponent Available');
                          }
                        },
                      )),
                  cus.sizeboxCus(30),
                  StreamBuilder<List<QuestionModel>>(
                      stream: db.getItems(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Text('No items found.');
                        }
                        return Expanded(
                            flex: 1,
                            child: Consumer<QuizProvider>(
                                builder: (context, quizprovider, child) {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 1,
                                itemBuilder: (context, index) {
                                  final item = snapshot.data![0 + value];
                                  quizprovider.providedanswers.add(item.answer);

                                  final item1 = item.option.length;
                                  return Column(
                                    children: [
                                      Text(
                                          "Question ${value + 1}: ${item.question}"),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: item1,
                                        itemBuilder: (context, index) {
                                          final item2 = item.option[index];
                                          return Column(
                                            children: [
                                              InkWell(
                                                  onTap: () {
                                                    quizprovider.valueChange();
                                                    quizprovider.answers.add(
                                                        item.option[index]);

                                                    quizprovider
                                                        .calculateResult(
                                                            value + 0);
                                                    value += 1;
                                                    final user = FirebaseAuth
                                                        .instance.currentUser;

                                                    FirebaseFirestore.instance
                                                        .collection("user")
                                                        .doc(user!.uid)
                                                        .update({
                                                      'totalSelectedAnswer':
                                                          value + 0,
                                                    });
                                                    setState(() {
                                                      opponentId =
                                                          dbopponent.opponentId;
                                                      opponentValue = false;
                                                    });

                                                    roomDb.updateRoom(RoomModel(
                                                      currentUserid: user.uid,
                                                      opponentUserid:
                                                          dbopponent.opponentId,
                                                      currentuserCorrect:
                                                          quizprovider.correct,
                                                      currentuserWrong:
                                                          quizprovider.wrong,
                                                      opponentuserCorrect:
                                                          dbopponent
                                                              .opponentcorrect,
                                                      opponentuserWrong:
                                                          dbopponent
                                                              .opponentwrong,
                                                    ));

                                                    final opponentDocRef =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('user')
                                                            .doc(dbopponent
                                                                .opponentId);

                                                    opponentDocRef.update({
                                                      'isBusy': true,
                                                    }).then((value) {
                                                      print(
                                                          'isBusy updated successfully');
                                                    }).catchError((error) {
                                                      print(
                                                          'Error updating isBusy: $error');
                                                    });
                                                    const isBusy = true;

// Reference to the Firestore collection and document current user
                                                    final userDocRef =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('user')
                                                            .doc(user.uid);

                                                    userDocRef.update({
                                                      'isBusy': isBusy,
                                                    }).then((value) {
                                                      print(
                                                          'isBusy updated successfully');
                                                    }).catchError((error) {
                                                      print(
                                                          'Error updating isBusy: $error');
                                                    });
                                                    setState(() {});
                                                  },
                                                  child: Text(
                                                      "${index + 1}: $item2")),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }));
                      }),
                ],
              ),
            ),
          )
        : ResultScreen(dbopponent.opponentId);
  }
}
