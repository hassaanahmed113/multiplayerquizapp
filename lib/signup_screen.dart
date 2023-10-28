import 'package:flutter/material.dart';
import 'package:flutterquizapp/Login_screen.dart';
import 'package:flutterquizapp/Provider/text_provider.dart';
import 'package:flutterquizapp/Utils/app_colors.dart';
import 'package:flutterquizapp/Utils/custom_widgets.dart';
import 'package:flutterquizapp/services/firebaseauth_services.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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
                    cus.textCus("Register Yourself", 26, FontWeight.bold,
                        AppColor().textColor),
                    cus.sizeboxCus(20),
                    cus.textFieldCus(textprovider.emailControllersignup,
                        "Enter your Email here", false),
                    cus.sizeboxCus(20),
                    cus.textFieldCus(textprovider.passControllersignup,
                        "Enter your Password here", true),
                    cus.sizeboxCus(20),
                    cus.textFieldCus(textprovider.nameController,
                        "Enter your name here", false),
                    cus.sizeboxCus(20),
                    Consumer<FirebaseServicesProvider>(
                      builder: (context, firebaseprovider, child) {
                        return cus.buttonCus("SignUp", () {
                          firebaseprovider.signupFunction(
                              textprovider.emailControllersignup.text,
                              textprovider.passControllersignup.text,
                              textprovider.nameController.text,
                              0,
                              0,
                              0,
                              context);

                          textprovider.emailControllersignup.clear();
                          textprovider.passControllersignup.clear();
                          textprovider.nameController.clear();
                        });
                      },
                    ),
                    cus.sizeboxCus(20),
                    cus.rowNavigation("Already have an account?", context,
                        "Login", const LoginScreen())
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
