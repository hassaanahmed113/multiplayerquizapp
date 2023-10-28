import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  int value = 0;
  DbuserServices dbopponent = DbuserServices();
  RoomdbServices roomDb = RoomdbServices();
  final user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final roomData = RoomModel(
        currentUserid: user!.uid,
        opponentUserid: dbopponent.opponentId,
        currentuserCorrect: dbopponent.currentusercorrect,
        currentuserWrong: dbopponent.currentuserwrong,
        opponentuserCorrect: dbopponent.opponentcorrect,
        opponentuserWrong: dbopponent.opponentwrong);

    roomDb.addRoom(roomData);
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
                                  .update({'correct': 0, 'wrong': 0});
                            },
                            icon: Icon(
                              Icons.logout,
                              color: Colors.white,
                            ));
                      },
                    );
                  },
                ),
              ],
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    child: StreamBuilder<List<OpponentModel>>(
                      stream: dbopponent.getOpponentUser(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(
                            color: Colors.transparent,
                          );
                        }
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Text('No User Available');
                        }
                        return ListView.builder(
                          itemCount: 1,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final opponent = snapshot.data![index];
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Wrap(
                                  direction: Axis.horizontal,
                                  children: [
                                    cus.textCus(
                                        "Opponent: ${opponent.name} ",
                                        20,
                                        FontWeight.bold,
                                        AppColor().blackColor),
                                    cus.textCus("Correct: ", 20,
                                        FontWeight.bold, AppColor().blackColor),
                                    cus.textCus(
                                        "${opponent.correct}",
                                        20,
                                        FontWeight.bold,
                                        AppColor().correctColor),
                                    cus.textCus(" Wrong: ", 20, FontWeight.bold,
                                        AppColor().blackColor),
                                    cus.textCus("${opponent.wrong}", 20,
                                        FontWeight.bold, AppColor().wrongColor)
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  cus.sizeboxCus(30),
                  StreamBuilder<List<QuestionModel>>(
                      stream: db.getItems(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Text('No items found.');
                        }
                        return Expanded(
                            flex: 1,
                            child: Consumer<QuizProvider>(
                                builder: (context, quizprovider, child) {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
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
                                        physics: NeverScrollableScrollPhysics(),
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
                                                    print(
                                                        "This is correct of curentuser${dbopponent.currentusercorrect}");
                                                    roomDb.updateRoom(RoomModel(
                                                        currentUserid: user.uid,
                                                        opponentUserid:
                                                            dbopponent
                                                                .opponentId,
                                                        currentuserCorrect:
                                                            quizprovider
                                                                .correct,
                                                        currentuserWrong:
                                                            quizprovider.wrong,
                                                        opponentuserCorrect:
                                                            dbopponent
                                                                .opponentcorrect,
                                                        opponentuserWrong:
                                                            dbopponent
                                                                .opponentwrong));

                                                    setState(() {});
                                                  },
                                                  child: Text(
                                                      "${index + 1}: ${item2}")),
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
        : ResultScreen();
  }
}
