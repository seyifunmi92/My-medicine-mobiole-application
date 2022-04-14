import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mymedicinemobile/screens/mobile/splash_screens/second_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';

class SplashScreen2 extends StatefulWidget {
  const SplashScreen2({Key? key}) : super(key: key);

  @override
  _SplashScreen2 createState() => _SplashScreen2();
}


class _SplashScreen2 extends State<SplashScreen2> {
  @override
  void initState() {
    Timer(const Duration(seconds: 4), onClose);
    super.initState();
  }

  Future<void> onClose() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? fullname = sharedPreferences.getString("Fullname");

    if (fullname != null) {
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              maintainState: true,
              opaque: true,
              pageBuilder: (context, _, __) => const SecondPage(),
              transitionDuration: const Duration(seconds: 4),
              transitionsBuilder: (context, anim1, anim2, child) {
                return FadeTransition(
                  child: child,
                  opacity: anim1,
                );
              }));
    } else {
      print("name is null");
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              maintainState: true,
              opaque: true,
              pageBuilder: (context, _, __) => const SecondPage(),
              transitionDuration: const Duration(seconds: 4),
              transitionsBuilder: (context, anim1, anim2, child) {
                return FadeTransition(
                  child: child,
                  opacity: anim1,
                );
              }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorWhite,
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset("assets/images/faded_logo.png"),
          ),
          Positioned(
              child: Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Image.asset(
                    "assets/images/newlogo.png",
                    width: 30,
                    height: 30,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                SvgPicture.asset("assets/svg/mymedicines.svg"),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
