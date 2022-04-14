import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mymedicinemobile/screens/mobile/splash_screens/second_page.dart';
import 'package:mymedicinemobile/screens/mobile/splash_screens/splash_screen_two.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';
// ignore: unused_import
import '../../../text_style.dart';

class SplashScreen1 extends StatefulWidget {
  const SplashScreen1({Key? key}) : super(key: key);

  @override
  _SplashScreen1 createState() => _SplashScreen1();
}

class _SplashScreen1 extends State<SplashScreen1> {
  @override
  void initState() {
    Timer(const Duration(seconds: 4), onChange);
    super.initState();
  }

  Future<void> onChange() async {
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            maintainState: true,
            opaque: true,
            pageBuilder: (context, _, __) => SplashScreen2(),
            transitionDuration: const Duration(seconds: 1),
            transitionsBuilder: (context, anim1, anim2, child) {
              return FadeTransition(
                child: child,
                opacity: anim1,
              );
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorWhite,
      body: Stack(
        children: [
          // Positioned(
          //   top: 0,
          //   left: 30,
          //   child: Row(
          //     children: <Widget>[
          //       SvgPicture.asset("assets/svg/up_purple.svg"),
          //     ],
          //   ),
          // ),
          // Positioned(
          //   top: 0,
          //   left: 0,
          //   child: Row(
          //     children: <Widget>[
          //       SvgPicture.asset("assets/svg/up_green.svg"),
          //     ],
          //   ),
          // ),
          // Positioned(
          //   bottom: 15,
          //   right: 0,
          //   child: Column(
          //     children: <Widget>[
          //       SvgPicture.asset("assets/svg/down_purple.svg"),
          //       //SvgPicture.asset("assets/svg/down_red.svg"),
          //     ],
          //   ),
          // ),
          // Positioned(
          //   bottom: 0,
          //   right: 0,
          //   child: Column(
          //     children: <Widget>[
          //       //SvgPicture.asset("assets/svg/down_purple.svg"),
          //       SvgPicture.asset("assets/svg/down_red.svg"),
          //     ],
          //   ),
          // ),
          // Positioned(
          //   bottom: 150,
          //   left: 0,
          //   child: Column(
          //     children: <Widget>[
          //       SvgPicture.asset("assets/svg/elipses_round.svg"),
          //     ],
          //   ),
          // ),
          // Positioned(
          //   top: 50,
          //   right: 60,
          //   child: Container(
          //     width: 12,
          //     height: 12,
          //     decoration: BoxDecoration(
          //       color: kPrimaryColor,
          //       borderRadius: BorderRadius.circular(120),
          //     ),
          //   ),
          // ),

          Positioned(
              child: Align(
            alignment: Alignment.center,
            child: Container(
              child: Image.asset(
                "assets/images/front_logo.png",
                fit: BoxFit.contain,
              ),
            ),
          )),
        ],
      ),
    );
  }
}
