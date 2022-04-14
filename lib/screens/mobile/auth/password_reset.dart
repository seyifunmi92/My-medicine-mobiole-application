import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mymedicinemobile/constants.dart';
import 'package:mymedicinemobile/screens/mobile/auth/login.dart';
import 'package:mymedicinemobile/screens/mobile/auth/reset_complete.dart';
import 'package:mymedicinemobile/services/services.dart';
import 'package:mymedicinemobile/text_style.dart';

class PasswordReset extends StatefulWidget {
  String resetToken;
  PasswordReset(this.resetToken);
  _PasswordReset createState() => _PasswordReset();
}

class _PasswordReset extends State<PasswordReset> with SingleTickerProviderStateMixin{

  TextEditingController passC = new TextEditingController();
  TextEditingController passC2 = new TextEditingController();
  bool value = false;
  bool passwordVisible = false;
  bool passwordObscure = true;

  bool passwordVisible2 = false;
  bool passwordObscure2 = true;

  Color swapColor = kPrimaryColor.withOpacity(.5);

  bool loading = false;
  bool errorOcurred = false;
  bool dataLoaded = false;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  late AnimationController _animationController;


  @override
  void initState() {
    // TODO: implement initState
    _animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 2),
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
    // TODO: implement build
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ListView(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          InkWell(onTap: (){
                            Navigator.pop(context);
                          },child: Icon(Icons.arrow_back_ios,color: kColorBlack,size: 15,)),
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
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Recover Password?",
                        style: kmediumTextExtra(kPrimaryColor),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "We need your registered email\n address to send you password\n resset link",
                        style: ksmallTextBold(kColorBlack.withOpacity(.7)),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        child: SvgPicture.asset(
                            "assets/svg/forgot_password.svg"),
                      ),

                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  SizedBox(
                    height: 45,
                  ),
                  Text(
                    "New password",
                    style: ksmallMediumText(kColorBlack.withOpacity(.6)),
                  ),

                  Row(children: [
                    Expanded(
                      flex: 1,
                      child: TextField(
                        onChanged: (text) {
                          if (text.isNotEmpty) {
                            if (text.length > 5) {
                              setState(() {
                                passwordVisible = true;
                                if (passC2.text.length > 5 && passC2.text.trim() == passC.text.trim()) {
                                  setState(() {
                                    swapColor = kPrimaryColor;
                                  });
                                }else{
                                  setState(() {
                                    swapColor = kPrimaryColor.withOpacity(.5);
                                  });
                                }
                              });
                            }
                          }
                        },
                        controller: passC,
                        cursorColor: kPrimaryColor,
                        style: kmediumTextBold(kColorBlack),
                        keyboardType: TextInputType.text,
                        obscureText: passwordObscure,
                        decoration: InputDecoration(
                          hintText: "Enter new password",
                          hintStyle: TextStyle(
                              fontSize: 12,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                              color: kColorBlack.withOpacity(.3)),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Visibility(
                        visible: passwordVisible,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              passwordObscure = false;
                            });
                          },
                          child: Text(
                            "show",
                            style: kmediumText(kPrimaryColor),
                          ),
                        ))
                  ],),

                  Divider(height: .5,color: kColorSmoke2,),


                  SizedBox(
                    height: 10,
                  ),

                  Text(
                    "Confirm password",
                    style: ksmallMediumText(kColorBlack.withOpacity(.6)),
                  ),

                  Row(children: [
                    Expanded(
                      flex: 1,
                      child: TextField(
                        onChanged: (text) {
                          if (text.isNotEmpty) {
                            if (text.length > 5) {
                              setState(() {
                                passwordVisible2 = true;
                                if (passC2.text.length > 5 && passC2.text.trim() == passC.text.trim()) {
                                  setState(() {
                                    swapColor = kPrimaryColor;
                                  });
                                }else{
                                  setState(() {
                                    swapColor = kPrimaryColor.withOpacity(.5);
                                  });
                                }
                              });
                            }
                          }
                        },
                        controller: passC2,
                        cursorColor: kPrimaryColor,
                        style: kmediumTextBold(kColorBlack),
                        keyboardType: TextInputType.text,
                        obscureText: passwordObscure2,
                        decoration: InputDecoration(
                          hintText: "Confirm new password",
                          hintStyle: TextStyle(
                              fontSize: 12,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                              color: kColorBlack.withOpacity(.3)),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Visibility(
                        visible: passwordVisible2,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              passwordObscure2 = false;
                            });
                          },
                          child: Text(
                            "show",
                            style: kmediumText(kPrimaryColor),
                          ),
                        ))
                  ],),

                  Divider(height: .5,color: kColorSmoke2,),



                  SizedBox(height: 40,),

                  InkWell(
                    onTap: (){
                      if(passC.text.length > 5){
                        if(passC.text.trim() == passC2.text.trim()){
                          setState(() {
                            loading = true;
                          });
                          resetPassword();
                        }else{
                          _showMessage("Passwords do not match");
                        }
                      }
                    },
                    child: Container(
                      width: width,
                      height: 40,
                      color: swapColor,
                      child: Center(
                        child: Text(
                          "RESET PASSWORD",
                          style: kmediumTextBold(kColorWhite),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),


                  SizedBox(height: 40,),



                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Text("Remember your password?",style: kmediumText(kColorBlack.withOpacity(.4))),
                    SizedBox(width: 4,),
                      InkWell(onTap: (){
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              new Login()));
                    },child: Text("Log In.",style: kmediumText(kPrimaryColor))),
                  ],)

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
    );
  }



  void resetPassword() {
    print("We are In now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.resetPassword(passC.text.trim(),widget.resetToken).then((value) => output(value));
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
          passwordVisible = false;
          passwordVisible2 = false;
        });

        passC.text = "";
        passC2.text = "";
        _showMessage2("Password change was successful, click on login now.");
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => ResetComplete()));

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
    _scaffoldKey.currentState!.showSnackBar(new SnackBar(
      content: new Text(message),
      duration: duration,
      action: new SnackBarAction(
          label: 'CLOSE',
          onPressed: () => _scaffoldKey.currentState!.removeCurrentSnackBar()),
    ));
  }


  _showMessage2(String message,
      [Duration duration = const Duration(seconds: 15)]) {
    _scaffoldKey.currentState!.showSnackBar(new SnackBar(
      content: new Text(message),
      duration: duration,
      action: new SnackBarAction(
          label: 'CLOSE',
          onPressed: () => _scaffoldKey.currentState!.removeCurrentSnackBar()),
    ));
  }

}
