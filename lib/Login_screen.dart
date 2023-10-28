import 'package:flutter/material.dart';
import 'package:flutterquizapp/Provider/text_provider.dart';
import 'package:flutterquizapp/Utils/app_colors.dart';
import 'package:flutterquizapp/Utils/custom_widgets.dart';
import 'package:flutterquizapp/services/firebaseauth_services.dart';
import 'package:flutterquizapp/signup_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  CustomWidget cus = CustomWidget();

  @override
  Widget build(BuildContext context) {
    return Consumer<TextProvider>(builder: (context, textprovider, child) {
      return SafeArea(
          child: Scaffold(
              body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          cus.paddingCus(
            const EdgeInsets.symmetric(horizontal: 20),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: AppColor().headingColor,
              ),
              child: cus.paddingCus(
                const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                Column(
                  children: [
                    cus.textCus(
                        "Login", 26, FontWeight.bold, AppColor().textColor),
                    cus.sizeboxCus(20),
                    cus.textFieldCus(textprovider.emailControllerlogin,
                        "Enter your Email here", false),
                    cus.sizeboxCus(20),
                    cus.textFieldCus(textprovider.passControllerlogin,
                        "Enter your Password here", true),
                    cus.sizeboxCus(20),
                    Consumer<FirebaseServicesProvider>(
                      builder: (context, firebaseprovider, child) {
                        return cus.buttonCus("Login", () {
                          firebaseprovider.loginFunction(
                              textprovider.emailControllerlogin.text,
                              textprovider.passControllerlogin.text,
                              context);

                          textprovider.emailControllerlogin.clear();
                          textprovider.passControllerlogin.clear();
                        });
                      },
                    ),
                    cus.sizeboxCus(20),
                    cus.rowNavigation(
                        "Register Yourself", context, "SignUp", SignupScreen())
                  ],
                ),
              ),
            ),
          )
        ],
      )));
    });
  }
}
