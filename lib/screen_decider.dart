import 'package:flutter/material.dart';
import 'package:mymedicinemobile/screens/mobile/home_page/homepager.dart';
import 'package:mymedicinemobile/screens/mobile/splash_screens/splash_screen_one.dart';
import 'package:mymedicinemobile/screens/mobile/splash_screens/third_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenDecider extends StatefulWidget {
  const ScreenDecider({Key? key}) : super(key: key);
  @override
  _Welcome createState() => _Welcome();
}

class _Welcome extends State<ScreenDecider> {
  final bool installed = true;
  late SharedPreferences sharedPreferences;
  @override
  void initState() {
    onClose();
    super.initState();
  }
  Future<void> onClose() async {
    SharedPreferences? sharedPreferences =
        await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");
    bool? installed = sharedPreferences.getBool("FirstInstall");
    if (installed != null) {
      if (token != null) {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                maintainState: true,
                opaque: true,
                pageBuilder: (context, _, __) => HomePager(),
                transitionDuration: const Duration(seconds: 1),
                transitionsBuilder: (context, anim1, anim2, child) {
                  return FadeTransition(
                    child: child,
                    opacity: anim1,
                  );
                }));
      } else {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                maintainState: true,
                opaque: true,
                pageBuilder: (context, _, __) => ThirdScreen(),
                transitionDuration: const Duration(seconds: 1),
                transitionsBuilder: (context, anim1, anim2, child) {
                  return FadeTransition(
                    child: child,
                    opacity: anim1,
                  );
                }));
      }
    } else {
      sharedPreferences.setBool("FirstInstall", true);
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              maintainState: true,
              opaque: true,
              pageBuilder: (context, _, __) => const SplashScreen1(),
              transitionDuration: const Duration(seconds: 1),
              transitionsBuilder: (context, anim1, anim2, child) {
                return FadeTransition(
                  child: child,
                  opacity: anim1,
                );
              }));
    }
  }

  Future<String> checkUser() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("Token") != null) {
      return "Not Null";
    } else {
      return "Empty";
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraint) {
          double size = constraint.maxWidth;
          double heigth = constraint.maxHeight;
          print("Mobile device width ----- $size");
          print("Mobile device height ----- $heigth");
          if (size < 700) {
            onClose();
          }
          // else if(size > 700){
          //   return SplashScreen1();
          // }
          return const Text("");
        },
      ),
    );
  }
}
