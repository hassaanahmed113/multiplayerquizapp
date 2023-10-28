import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutterquizapp/Utils/app_colors.dart';

class CustomWidget {
  Widget textCus(data, double font, fontweight, color) {
    return Text(
      data,
      style: TextStyle(fontSize: font, fontWeight: fontweight, color: color),
    );
  }

  Widget imageCus(image) {
    return Image.asset(image);
  }

  Widget textFieldCus(TextEditingController controller, hinttext, val) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      obscureText: val,
      decoration: InputDecoration(
        hintText: hinttext,
        hintStyle: const TextStyle(color: Colors.white60),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  Widget sizeboxCus(double height) {
    return SizedBox(
      height: height,
    );
  }

  Widget sizeboxCusHorzon(double width) {
    return SizedBox(
      width: width,
    );
  }

  Widget paddingCus(padding, child) {
    return Padding(padding: padding, child: child);
  }

  Widget buttonCus(text, onpressed) {
    return ElevatedButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
        ),
        onPressed: () {
          onpressed();
        },
        child: Text(
          text,
          style: const TextStyle(color: Colors.black, fontSize: 20),
        ));
  }

  Widget rowNavigation(text1, context, text, screen) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        textCus(text1, 20, FontWeight.normal, AppColor().textColor),
        sizeboxCusHorzon(5),
        TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => screen,
                  ));
            },
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontStyle: FontStyle.italic,
              ),
            )),
      ],
    );
  }
}
