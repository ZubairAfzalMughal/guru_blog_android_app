import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ErrorLottie extends StatelessWidget {
  static const String id = "error";

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Connection Error",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30.0),
        ),
        Lottie.asset('assets/lottie/error-lottie.json', fit: BoxFit.cover),
      ],
    );
  }
}
