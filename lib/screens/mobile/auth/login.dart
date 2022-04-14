// ignore_for_file: deprecated_member_use
import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mymedicinemobile/constants.dart';
import 'package:mymedicinemobile/models/models.dart';
import 'package:mymedicinemobile/screens/mobile/auth/create_account.dart';
import 'package:mymedicinemobile/screens/mobile/auth/forgot_password.dart';
import 'package:mymedicinemobile/screens/mobile/home_page/homepager.dart';
import 'package:mymedicinemobile/services/services.dart';
import 'package:mymedicinemobile/text_style.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> with SingleTickerProviderStateMixin {
  TextEditingController passC = TextEditingController();
  TextEditingController usernameC = TextEditingController();
  bool value = false;
  bool passwordVisible = false;
  bool emailErrShow = false;
  bool passErrShow = false;
  //bool passwordObscure = true;
  bool isReadyNow = false;
  bool showLoading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animationController;
  String passText = "show";
  bool rememberMe = false;
  String rememberedEmail = "";
  String emailErrorText = "";
  String passwordErrorTest = "";
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animationController.repeat();
    checkUser();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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

  bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void checkUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("SharedEmail") != null) {
      usernameC.text = sharedPreferences.getString("SharedEmail")!;
      passC.text = sharedPreferences.getString("SharedPass")!;
      setState(() {
        emailErrShow = false;
        passwordVisible = true;
        isReadyNow = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    //checkUser();
    //print("Builder.....");
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kColorWhite,
      body: SafeArea(
        // ignore: avoid_unnecessary_containers
        child: Container(
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: ListView(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                child: Image.asset(
                                  "assets/images/newlogo.png",
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Welcome to Mymedicines",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: "Poppins",
                                fontSize: 14,
                                color: kPrimaryColor),
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Text(
                            "Log in if you already have an account",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: "Poppins",
                                fontSize: 12,
                                color: kColorSmoke2),
                          ),
                          const SizedBox(
                            height: 45,
                          ),
                          Text(
                            "Email",
                            style:
                                ksmallMediumText(kColorBlack.withOpacity(.6)),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: 50,
                                  child: TextField(
                                    onChanged: (text) {
                                      if (text.isNotEmpty) {
                                        if (text.length > 2) {
                                          emailErrShow = true;
                                        }
                                        if (!text.contains("@")) {
                                          setState(() {
                                            emailErrShow = true;
                                            emailErrorText =
                                                "Enter a valid email address";
                                            isReadyNow = false;
                                          });
                                        } else if (!text.contains(".")) {
                                          setState(() {
                                            emailErrorText =
                                                "Enter a valid email address";
                                            emailErrShow = true;
                                            isReadyNow = false;
                                          });
                                        } else {
                                          setState(() {
                                            emailErrShow = false;
                                            emailErrorText = "";
                                            if (passC.text.length > 4 &&
                                                passErrShow == false) {
                                              isReadyNow = true;
                                            }
                                          });
                                        }
                                      } else {
                                        setState(() {
                                          emailErrorText =
                                              "Input email address";
                                        });
                                      }
                                    },
                                    controller: usernameC,
                                    cursorColor: kPrimaryColor,
                                    style: ksmallTextBold(kColorBlack),
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      hintText: "Enter Email",
                                      hintStyle: ksmallTextBold(kColorSmoke),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                  visible: emailErrShow,
                                  child:
                                      SvgPicture.asset("assets/svg/error.svg"))
                            ],
                          ),
                          Divider(
                            height: .5,
                            color: kColorSmoke2,
                          ),
                          Text(
                            emailErrorText,
                            style: ksmallTextBold(const Color(0xFFD0021B)),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Password",
                            style: ksmallTextBold(kColorBlack.withOpacity(.6)),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: 50,
                                  child: TextField(
                                    onChanged: (text) {
                                      if (text.isNotEmpty) {
                                        if (text.length > 1) {
                                          passErrShow = true;
                                          passwordErrorTest =
                                              "password is too weak";
                                        }
                                        // passwordObscure = true;
                                        if (text.length > 5) {
                                          setState(() {
                                            passwordVisible = true;
                                            passErrShow = false;
                                            passwordErrorTest = "";
                                            if (emailErrShow == false) {
                                              isReadyNow = true;
                                            }
                                          });
                                        } else {
                                          setState(() {
                                            isReadyNow = false;
                                            passwordVisible = false;
                                            passErrShow = true;
                                          });
                                        }
                                      } else {
                                        setState(() {
                                          passwordErrorTest = "Input password";
                                        });
                                      }
                                    },
                                    controller: passC,
                                    cursorColor: kPrimaryColor,
                                    style: ksmallTextBold(kColorBlack),
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: _obscureText,
                                    decoration: InputDecoration(
                                      hintText: "Enter password",
                                      hintStyle: ksmallTextBold(kColorSmoke),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                  visible: passwordVisible,
                                  child: InkWell(
                                    onTap: () {
                                      _toggle();
                                      if (passText == "show") {
                                        setState(() {
                                          passText = "hide";
                                        });
                                      } else {
                                        setState(() {
                                          passText = "show";
                                        });
                                      }
                                    },
                                    child: Text(
                                      passText,
                                      style: ksmallTextBold(kPrimaryColor),
                                    ),
                                  )),
                              Visibility(
                                  visible: passErrShow,
                                  child:
                                      SvgPicture.asset("assets/svg/error.svg"))
                            ],
                          ),
                          Divider(
                            height: .5,
                            color: kColorSmoke,
                          ),
                          Text(
                            passwordErrorTest,
                            style: ksmallTextBold(const Color(0xFFD0021B)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 16, right: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                activeColor: Colors.purpleAccent,
                                value: this.value,
                                onChanged: (newvalue) async {
                                  print("Worker");
                                  //print(value);
                                  print(newvalue);
                                  setState(() {
                                    rememberMe = newvalue!;
                                    this.value = newvalue;
                                  });
                                },
                              ),
                              Text("Remember me",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Poppins",
                                      fontSize: 12,
                                      color: kColorSmoke2)),
                            ],
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ForgotPassword()));
                              },
                              child: const Text(
                                "Forgot password",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Poppins",
                                    fontSize: 11,
                                    color: kPrimaryColor),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              if (passErrShow == false &&
                                  emailErrShow == false) {
                                setState(() {
                                  showLoading = true;
                                });
                                signIn();
                                //catListTest();
                              } else {
                                print("Not working ....");
                              }
                            },
                            child: Container(
                              width: width,
                              height: 40,
                              color: isReadyNow
                                  ? kPrimaryColor
                                  : kPrimaryColor.withOpacity(.58),
                              child: Center(
                                child: Text(
                                  "LOG IN",
                                  style: kmediumTextBold(kColorWhite),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "or sign in with",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: "Poppins",
                                fontSize: 12,
                                color: kColorSmoke),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: width,
                            height: 40,
                            color: kfacebookColor,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, top: 5, bottom: 5),
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 7, vertical: 5),
                                        decoration: BoxDecoration(
                                            color: kColorWhite,
                                            borderRadius:
                                                BorderRadius.circular(180)),
                                        child: SvgPicture.asset(
                                          "assets/svg/facebook.svg",
                                          color: kfacebookColor,
                                          width: 10,
                                          height: 10,
                                        )),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    "FACEBOOK",
                                    style: kmediumTextBold(kColorWhite),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text("")
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: width,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: .6,
                                  color: kColorSmoke,
                                  style: BorderStyle.solid),
                              color: kColorWhite,
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: SvgPicture.asset(
                                        "assets/svg/google_icon.svg"),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    "GOOGLE",
                                    style: kmediumTextBold(kColorSmoke2),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text("")
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don’t have an Account?",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Poppins",
                                    fontSize: 12,
                                    color: kColorBlack.withOpacity(.6)),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                new CreateAccount()));
                                  },
                                  child: const Text(
                                    "REGISTER",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Poppins",
                                        fontSize: 12,
                                        decoration: TextDecoration.underline,
                                        color: kPrimaryColor),
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: showLoading,
                child: Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: width,
                      height: height,
                      color: Color(0xFF000000).withOpacity(0.3),
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
                                      angle:
                                          _animationController.value * 2 * pi,
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
      ),
    );
  }

  void signIn() {
    print("We are In now...");
    ServiceClass serviceClass = ServiceClass();
    serviceClass
        .loginUser(usernameC.text, passC.text, "Pixel 2A", 2)
        .then((value) => output(value));
  }

  void output(ResponseObject object) async {
    var bodyT = jsonDecode(object.responseBody!);

    if (object.responseCode == 700) {
      setState(() {
        showLoading = false;
      });
      _showMessage("Networ error encountered ..");
    } else {
      if (object.responseCode == 200) {
        if (bodyT["status"] == "Successful") {
          MedUser medUser = MedUser.fromJson(bodyT["data"]);
          //MedUserToken token = MedUserToken.fromJson(medUser.token.toString());
          //MedUserRole role = MedUserRole.fromJson(medUser.role);
          Provider.of<ServiceClass>(context, listen: false)
              .notifyLogin(medUser);
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          sharedPreferences.setString(
              "Token", bodyT["data"]["token"]["accessToken"]);
          sharedPreferences.setString("Email", bodyT["data"]["email"]);
          sharedPreferences.setString("LastName", bodyT["data"]["lastName"]);
          sharedPreferences.setString("FirstName", bodyT["data"]["firstName"]);
          sharedPreferences.setString("Phone", bodyT["data"]["phoneNumber"]);
          setState(() {
            showLoading = false;
          });
          if (rememberMe) {
            sharedPreferences.setString("SharedEmail", usernameC.text);
            sharedPreferences.setString("SharedPass", passC.text);
          } else {}
          print("This is good oo");
          print(medUser);
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePager()));
        }
      } else if (object.responseCode == 404) {
        //User email noot found
        setState(() {
          showLoading = false;
          emailErrShow = true;
          emailErrorText =
              "Incorrect email address, please enter and try again";
        });
      } else if (object.responseCode == 401) {
        setState(() {
          showLoading = false;
          passErrShow = true;
          passwordErrorTest = "Incorrect password, please try again";
        });
      } else {
        setState(() {
          showLoading = false;
        });
        _showMessage("Error encountered .......");
      }
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('rememberMe', rememberMe));
  }
/*
  mary.jane@qa.team
  Maryjane1991
   */
}
/*
ChannelId is 2
 */
