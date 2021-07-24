import 'package:flutter/material.dart';
import 'package:guru_blog/screen/register.dart';
import 'package:lottie/lottie.dart';


class LottieSplash extends StatefulWidget {
  static const String id = "splash";

  @override
  _LottieSplashState createState() => _LottieSplashState();
}

class _LottieSplashState extends State<LottieSplash> {
  @override
  void initState() {
    if (this.mounted)
      Future.delayed(Duration(seconds: 5), () {
        Navigator.pushNamedAndRemoveUntil(
            context, Register.id, (route) => false);
      });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Lottie.asset(
                'assets/lottie/blog.json',
                alignment: Alignment.center,
                fit: BoxFit.cover,
                height: size.height / 2,
                width: size.width,
              ),
            ),
            Text(
              "Guru Blog",
              style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
