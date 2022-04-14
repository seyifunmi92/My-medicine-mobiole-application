// ignore_for_file: prefer_const_constructors, unnecessary_new, sized_box_for_whitespace, prefer_const_declarations

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mymedicinemobile/constants.dart';
import 'package:mymedicinemobile/models/models.dart';
import 'package:mymedicinemobile/reusables/bars.dart';
import 'package:mymedicinemobile/screens/mobile/cart/cart.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:url_launcher/url_launcher.dart';


class ContactUs extends StatefulWidget {
  _ContactUs createState() => new _ContactUs();
}


class _ContactUs extends State<ContactUs> {

  bool value = false;
  bool productShow = false;
  TextEditingController searchC = new TextEditingController();

  List<CartModel> trackList = [];
  stt.SpeechToText speech = stt.SpeechToText();

  ValueNotifier<User> currentUser = new ValueNotifier(
      User(name: "Clem", email: "clem@gmail.com", quantity: 22));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
      );
    } else {
      throw "Could not launch $url";
    }
  }

  // Future _launchFacebook(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(
  //       url,
  //       forceSafariVC: true,
  //       forceWebView: true,
  //       enableJavaScript: true
  //     );
  //   }
  // }

  _sendEmail() async {
    launch("mailto:info@mypharmacy.africa");
  }

  _myLapEmail() async {
    launch("mailto:info@mypharmacy.africa");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final number = 'tel: +2349062386463';

    return Scaffold(
      backgroundColor: kColorWhite,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: width,
            height: height,
            child: Column(
              children: [
                navBarCustomCartBeforePerson('Contact Us',context, Cart(),true),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  height: height * .83,
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            child: Image.asset(
                              "assets/images/newlogo.png",
                              width: 25,
                              height: 25,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "myMedicines",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: kColorBlack,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                          onTap: () {
                            _makePhoneCall(number);
                          },
                          child: customInAppCall(
                            "+234 906 238 6463",
                            "assets/svg/caller.svg",
                          )),
                      //customInAppCall("+234 907 067 7609","assets/svg/watsapp.svg",Container()),
                      InkWell(
                        onTap: () async {
                          final url = 'https://www.facebook.com/ordermymedicines';
                          if (await canLaunch(url)) {
                            await launch(url,
                                forceSafariVC: true,
                                forceWebView: true,
                                enableJavaScript: true);
                          }
                        },
                        child: customInAppCall(
                          "@ordermymedicines",
                          "assets/svg/facebook.svg",
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          final url = 'https://twitter.com/my_medicines';
                          if (await canLaunch(url)) {
                            await launch(url,
                                forceSafariVC: true,
                                forceWebView: true,
                                enableJavaScript: true);
                          }
                        },
                        child: customInAppCall(
                          "@my_medicines",
                          "assets/svg/twittersvg.svg",
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _sendEmail();
                        },
                        child: customInAppCall(
                          "Info@mypharmacy.africa",
                          "assets/svg/emailnoty.svg",
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          final url = 'https://www.instagram.com/my_medicines/';
                          if (await canLaunch(url)) {
                            await launch(url,
                                forceSafariVC: true,
                                forceWebView: true,
                                enableJavaScript: true);
                          }
                        },
                        child: customInAppCall(
                          "@my_medicines",
                          "assets/svg/instagram.svg",
                        ),
                      ),

                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            child: Image.asset(
                              "assets/images/mylabs2.png",
                              width: 25,
                              height: 25,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "myLabs",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: kColorBlack,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          _makePhoneCall(number);
                        },
                        child: customInAppCall(
                          "++234 906 238 6463",
                          "assets/svg/caller.svg",
                        ),
                      ),
                      //customInAppCall("+234 907 067 7609","assets/svg/watsapp.svg",Container()),
                      InkWell(
                        onTap: () async {
                          final url = 'https://www.facebook.com/ordermymedicines';
                          if (await canLaunch(url)) {
                            await launch(url,
                                forceSafariVC: true,
                                forceWebView: true,
                                enableJavaScript: true);
                          }
                        },
                        child: customInAppCall(
                          "@ordermymedicines",
                          "assets/svg/facebook.svg",
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          final url = 'https://twitter.com/my_medicines';
                          if (await canLaunch(url)) {
                            await launch(url,
                                forceSafariVC: true,
                                forceWebView: true,
                                enableJavaScript: true);
                          }
                        },
                        child: customInAppCall(
                          "@my_medicines",
                          "assets/svg/twittersvg.svg",
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _myLapEmail();
                        },
                        child: customInAppCall(
                          "Info@mypharmacy.africa",
                          "assets/svg/emailnoty.svg",
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          final url = 'https://www.instagram.com/my_medicines/';
                          if (await canLaunch(url)) {
                            await launch(url,
                                forceSafariVC: true,
                                forceWebView: true,
                                enableJavaScript: true);
                          }
                        },
                        child: customInAppCall(
                          "@my_medicines",
                          "assets/svg/instagram.svg",
                        ),
                      ),
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

  Widget customInAppCall(
    String text,
    String asset,
  ) {
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
                Container(
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
              ],
            ),
          ],
        ));
  }
}
