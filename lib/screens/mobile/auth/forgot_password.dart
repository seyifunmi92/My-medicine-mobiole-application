import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mymedicinemobile/constants.dart';
import 'package:mymedicinemobile/screens/mobile/auth/login.dart';
import 'package:mymedicinemobile/screens/mobile/auth/verify_reset_email.dart';
import 'package:mymedicinemobile/services/services.dart';
import 'package:mymedicinemobile/text_style.dart';

class ForgotPassword extends StatefulWidget {
  _ForgotPassword createState() => _ForgotPassword();
}

class _ForgotPassword extends State<ForgotPassword>
    with SingleTickerProviderStateMixin {
  TextEditingController emailC = TextEditingController();
  bool value = false;
  bool passwordVisible = false;
  bool passwordObscure = true;
  Color swapColor = kPrimaryColor.withOpacity(.5);
  bool emailOkay = false;
  bool loading = false;
  bool errorOcurred = false;
  bool dataLoaded = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animationController.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ListView(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Icons.arrow_back_ios,
                                color: kColorBlack,
                                size: 15,
                              )),
                          Text(
                            "Back",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: kColorSmoke2),
                          ),
                        ],
                      ),
                      //loading ? CircularProgressIndicator() : Text("Error Occured"),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Recover Password?",
                        style: kmediumTextExtra(kPrimaryColor),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "We need your registered email\n address to send you password\n resset link",
                        style: ksmallTextBold(kColorBlack.withOpacity(.7)),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        child:
                            SvgPicture.asset("assets/svg/forgot_password.svg"),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                  Text(
                    "Email",
                    style: ksmallMediumText(kColorBlack.withOpacity(.6)),
                  ),
                  TextField(
                    onChanged: (text) {
                      if (text.isNotEmpty) {
                        if (text.contains("@")) {
                          if (text.contains(".")) {
                            setState(() {
                              swapColor = kPrimaryColor;
                              emailOkay = true;
                            });
                          } else {
                            setState(() {
                              swapColor = kPrimaryColor.withOpacity(.5);
                              emailOkay = false;
                            });
                          }
                        }
                      }
                    },
                    controller: emailC,
                    cursorColor: kPrimaryColor,
                    style: ksmallTextBold(kColorBlack),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "email",
                      hintStyle: ksmallTextBold(kColorSmoke),
                      border: InputBorder.none,
                    ),
                  ),
                  Divider(
                    height: .5,
                    color: kColorSmoke2,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  InkWell(
                    onTap: () {
                      if (emailOkay) {
                        setState(() {
                          loading = true;
                        });
                        forgotPassword();
                      } else {
                        _showMessage("Enter a valid email");
                      }
                    },
                    child: Container(
                      width: width,
                      height: 40,
                      color: swapColor,
                      child: Center(
                        child: Text(
                          "SEND INSTRUCTIONS",
                          style: kmediumTextBold(kColorWhite),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Remember your password?",
                          style: kmediumText(kColorBlack.withOpacity(.4))),
                      const SizedBox(
                        width: 4,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()));
                          },
                          child: Text("Log In.",
                              style: kmediumText(kPrimaryColor))),
                    ],
                  )
                ],
              ),
            ),
            Visibility(
              visible: loading,
              child: Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: width,
                    height: height,
                    color: const Color(0xFF000000).withOpacity(0.3),
                    child: Stack(
                      children: [
                        Positioned(
                          top: height * .4,
                          left: 50,
                          right: 50,
                          child: Container(
                              width: 100,
                              decoration: BoxDecoration(
                                  //color: kColorWhite,
                                  borderRadius: BorderRadius.circular(5)),
                              child: AnimatedBuilder(
                                animation: _animationController,
                                builder: (context, child) {
                                  return Transform.rotate(
                                    angle: _animationController.value * 2 * pi,
                                    child: child,
                                  );
                                },
                                child: Image.asset(
                                  "assets/images/newlogo.png",
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.contain,
                                ),
                              )),
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void forgotPassword() {
    print("We are In now...");
    ServiceClass serviceClass = ServiceClass();
    serviceClass.forgotPassword(emailC.text).then((value) => output(value));
  }

  void output(String body) {
    print("We are In second haven now...");
    print(body);
    if (body.contains("Network Error")) {
      setState(() {
        loading = false;
        errorOcurred = true;
      });
    } else {
      var bodyT = jsonDecode(body);
      if (bodyT["status"] == "Successful") {
        var data = json.decode(body);
        print("Counter ....");
        print("List Course ....");
        setState(() {
          loading = false;
          errorOcurred = false;
          dataLoaded = true;
        });

        int codeID = int.parse(data["data"]["result"]);
        int channelID = data["data"]["id"];
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ResetEmailVerify(emailC.text, codeID, channelID)));
      } else {
        _showMessage(bodyT["message"]);
        setState(() {
          loading = false;
          errorOcurred = true;
        });
      }
    }
  }

  _showMessage(String message,
      [Duration duration = const Duration(seconds: 4)]) {
    _scaffoldKey.currentState!.showSnackBar(SnackBar(
      content: Text(message),
      duration: duration,
      action: SnackBarAction(
          label: 'CLOSE',
          onPressed: () => _scaffoldKey.currentState!.removeCurrentSnackBar()),
    ));
  }
}
