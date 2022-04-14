import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mymedicinemobile/constants.dart';
import 'package:mymedicinemobile/models/models.dart';
import 'package:mymedicinemobile/screens/mobile/cart/cart.dart';
import 'package:mymedicinemobile/screens/mobile/inapp_call/inapp_call.dart';
import 'package:mymedicinemobile/text_style.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class LiveChat extends StatefulWidget {
  const LiveChat({Key? key}) : super(key: key);
  @override
  _LiveChat createState() => _LiveChat();
}

class _LiveChat extends State<LiveChat> {
  bool value = false;
  bool productShow = false;
  TextEditingController searchC = TextEditingController();
  List<CartModel> trackList = [];
  stt.SpeechToText speech = stt.SpeechToText();
  ValueNotifier<User> currentUser =
      ValueNotifier(User(name: "Clem", email: "clem@gmail.com", quantity: 22));

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: kColorWhite,
      body: SafeArea(
        child: Container(
          width: width,
          height: height,
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                color: Color(0xFFF8F5FC),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: SvgPicture.asset(
                            "assets/svg/backward_arrow.svg",
                            color: kPrimaryColor,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Contact Us",
                          style: klargeText(kColorSmoke2),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 30,
                        ),
                        SvgPicture.asset(
                          "assets/svg/live_shuffle.svg",
                          color: kPrimaryColor,
                          width: 30,
                          height: 30,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customInAppCall(String text, String asset, Widget widget) {
    return Container(
        decoration: new BoxDecoration(
          color: kColorWhite,
          border: Border(
            top: BorderSide(
                width: 1.0, color: Color(0xFFCCCED0).withOpacity(.4)),
            bottom: BorderSide(
                width: 1.0, color: Color(0xFFCCCED0).withOpacity(.4)),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 17),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                SvgPicture.asset(
                  asset,
                  color: kColorSmoke2,
                  width: 25,
                  height: 25,
                ),
                //SizedBox(width: 50,),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => widget));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: asset.contains("facebook") ? 35 : 25),
                    child: Text(
                      text,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                        color: kColorBlack,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
