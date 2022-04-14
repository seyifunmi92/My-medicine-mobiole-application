// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, unnecessary_new
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mymedicinemobile/constants.dart';
import 'package:mymedicinemobile/models/models.dart';
import 'package:mymedicinemobile/reusables/bars.dart';
import 'package:mymedicinemobile/screens/mobile/cart/cart.dart';
import 'package:mymedicinemobile/services/services.dart';
import 'package:mymedicinemobile/text_style.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class TermsAndC extends StatefulWidget {
  const TermsAndC({Key? key}) : super(key: key);
  @override
  _TermsAndC createState() => _TermsAndC();
}

class _TermsAndC extends State<TermsAndC> {
  bool loading = true;
  bool dataLoaded = false;
  bool value = false;
  bool productShow = false;
  TextEditingController searchC = new TextEditingController();
  String TandC = "";
  List<TermsAndCondition> list = [];
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    showTermsAndCondition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kColorWhite,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: width,
            height: height,
            child: Column(
              children: [
                navBarCustomCartBeforePerson(
                    'Terms & Conditions', context, Cart(), true),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: height * .83,
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: ListView(
                    children: [
                      Text(
                        "MyMedicines Terms of Service",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: kColorBlack,
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      // Text(
                      //   "Introduction",
                      //   style: TextStyle(
                      //     fontFamily: "Poppins",
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.w500,
                      //     color: kColorBlack.withOpacity(.9),
                      //   ),
                      // ),

                      Html(data: """ 
                      // ignore: unnecessary_brace_in_string_interps
                      ${TandC}
                      """),
                      SizedBox(
                        height: 10,
                      ),

                      // SizedBox(height: 10,),
                      //
                      // Text(
                      //   "Registration and account",
                      //   style: TextStyle(
                      //     fontFamily: "Poppins",
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.w500,
                      //     color: kColorBlack.withOpacity(.9),
                      //   ),
                      // ),

                      SizedBox(
                        height: 10,
                      ),

                      // Text(
                      //   "Duis ultrices augue id feugiat commodo. Vivamus elit convallis, posuere neque at, ultricies tortor. ec eleifend tortor vel laoreet convallis. ",
                      //   style: TextStyle(
                      //     fontFamily: "Poppins",
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.w400,
                      //     color: kColorBlack.withOpacity(.6),
                      //   ),
                      // ),

                      SizedBox(
                        height: 10,
                      ),

                      // Text(
                      //   "Terms and conditions of sale",
                      //   style: TextStyle(
                      //     fontFamily: "Poppins",
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.w500,
                      //     color: kColorBlack.withOpacity(.9),
                      //   ),
                      // ),
                      //
                      // SizedBox(height: 10,),

                      // Text(
                      //   "Duis ultrices augue id feugiat commodo. Vivamus elit convallis, posuere neque at, ultricies tortor. ec eleifend tortor vel laoreet convallis. ",
                      //   style: TextStyle(
                      //     fontFamily: "Poppins",
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.w400,
                      //     color: kColorBlack.withOpacity(.6),
                      //   ),
                      // ),

                      // SizedBox(height: 10,),
                      //
                      // Text(
                      //   "Your content in our services",
                      //   style: TextStyle(
                      //     fontFamily: "Poppins",
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.w500,
                      //     color: kColorBlack.withOpacity(.9),
                      //   ),
                      // ),
                      //
                      // SizedBox(height: 10,),

                      // Text(
                      //   "Duis ultrices augue id feugiat commodo. Vivamus elit convallis, posuere neque at, ultricies tortor. ec eleifend tortor vel laoreet convallis. ",
                      //   style: TextStyle(
                      //     fontFamily: "Poppins",
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.w400,
                      //     color: kColorBlack.withOpacity(.6),
                      //   ),
                      // ),

                      SizedBox(
                        height: 10,
                      ),
                      //
                      // Text(
                      //   "International transfers",
                      //   style: TextStyle(
                      //     fontFamily: "Poppins",
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.w500,
                      //     color: kColorBlack.withOpacity(.9),
                      //   ),
                      // ),
                      //
                      // SizedBox(height: 10,),

                      // Text(
                      //   "Duis ultrices augue id feugiat commodo. Vivamus elit convallis, posuere neque at, ultricies tortor. ec eleifend tortor vel laoreet convallis. ",
                      //   style: TextStyle(
                      //     fontFamily: "Poppins",
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.w400,
                      //     color: kColorBlack.withOpacity(.6),
                      //   ),
                      // ),

                      // SizedBox(height: 10,),
                      //
                      // Text(
                      //   "Data security",
                      //   style: TextStyle(
                      //     fontFamily: "Poppins",
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.w500,
                      //     color: kColorBlack.withOpacity(.9),
                      //   ),
                      // ),
                      //
                      // SizedBox(height: 10,),

                      // Text(
                      //   "Duis ultrices augue id feugiat commodo. Vivamus elit convallis, posuere neque at, ultricies tortor. ec eleifend tortor vel laoreet convallis. ",
                      //   style: TextStyle(
                      //     fontFamily: "Poppins",
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.w400,
                      //     color: kColorBlack.withOpacity(.6),
                      //   ),
                      // ),

                      // SizedBox(height: 10,),
                      //
                      // Text(
                      //   "Registration and account",
                      //   style: TextStyle(
                      //     fontFamily: "Poppins",
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.w500,
                      //     color: kColorBlack.withOpacity(.9),
                      //   ),
                      // ),
                      //
                      // SizedBox(height: 10,),

                      // Text(
                      //   "Duis ultrices augue id feugiat commodo. Vivamus elit convallis, posuere neque at, ultricies tortor. ec eleifend tortor vel laoreet convallis. ",
                      //   style: TextStyle(
                      //     fontFamily: "Poppins",
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.w400,
                      //     color: kColorBlack.withOpacity(.6),
                      //   ),
                      // ),

                      // SizedBox(height: 10,),
                      //
                      // Text(
                      //   "Registration and account",
                      //   style: TextStyle(
                      //     fontFamily: "Poppins",
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.w500,
                      //     color: kColorBlack.withOpacity(.9),
                      //   ),
                      // ),
                      //
                      // SizedBox(height: 10,),

                      // Text(
                      //   "Duis ultrices augue id feugiat commodo. Vivamus elit convallis, posuere neque at, ultricies tortor. ec eleifend tortor vel laoreet convallis. ",
                      //   style: TextStyle(
                      //     fontFamily: "Poppins",
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.w400,
                      //     color: kColorBlack.withOpacity(.6),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

  void showTermsAndCondition() {
    print("We are In product now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.viewTermsAndCondition().then((value) => categoryOutput(value));
  }

  void categoryOutput(String body) {
    print("We are In T&C now...");
    print(body);
    if (body.contains("Network Error")) {
      _showMessage("Network Error");
      setState(() {
        loading = false;
      });
    } else {
      var bodyT = jsonDecode(body);
      if (bodyT["message"] == "Successful") {
        var data = json.decode(body);
        print(data);
        var value = data["data"]["htmlText"];
        print(value);
        dynamic myValue = value;
        print(myValue);

        TandC = value;
        // list = myValue.map<TermsAndCondition>((element) => TermsAndCondition.fromJson(element)).toList();
        // print(list);

        setState(() {
          loading = false;
          dataLoaded = true;
        });
      } else {
        _showMessage(bodyT["message"]);
        setState(() {
          loading = false;
          //errorOcurred = true;
        });
      }
    }
  }
}
