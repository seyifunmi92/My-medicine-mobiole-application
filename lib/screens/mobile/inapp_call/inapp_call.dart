// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, avoid_unnecessary_containers, prefer_const_declarations

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mymedicinemobile/constants.dart';
import 'package:mymedicinemobile/models/models.dart';
import 'package:mymedicinemobile/screens/mobile/cart/cart.dart';
import 'package:mymedicinemobile/screens/mobile/medicine_refill/refill_orders.dart';
import 'package:mymedicinemobile/screens/mobile/product_search/similar_products.dart';
import 'package:mymedicinemobile/text_style.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;


import 'inapp_call2.dart';

class InAppCall extends StatefulWidget {
  _InAppCall createState() => new _InAppCall();
}

class _InAppCall extends State<InAppCall> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void>_makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }else{
      throw "Could not launch $url";
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final number = 'tel: +2349062386463';
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kColorWhite,
      body: SafeArea(
        child: Container(
          width: width,
          height: height,
          child: Center(
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  color: Color(0xFFF8F5FC),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(""),
                      Text(
                        "IN-APP CALL",
                        style: klargeText(kColorSmoke2),
                      ),
                      SvgPicture.asset(
                        "assets/svg/loggedin_person.svg",
                        color: kPrimaryColor,
                        width: 30,
                        height: 30,
                      ),

                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),

                SvgPicture.asset(
                  "assets/svg/inapp_call.svg",
                ),

                SizedBox(
                  height: 20,
                ),

                Container(
                  child: Center(
                    child: Text(
                      "Safe Calling From Mymedicines App",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 15,
                          color: kColorBlack,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Center(
                    child: Text(
                      "You can call our pharmacist and Agents using data,be rest asure your personal contact information is protected.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),

                SizedBox(
                  height: 40,
                ),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Center(
                    child: Text(
                      "To do this we will need to access your microphone",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          color: kColorBlack.withOpacity(.7),
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),

                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        _makePhoneCall(number);
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => InAppCall2()));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: kColorSmoke.withOpacity(.4),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.circular(5),
                          color: kPrimaryColor,
                        ),
                        child: Center(
                          child: Text(
                            "TURN ON",
                            style: kmediumText(kColorWhite),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 20,),

                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: kColorSmoke.withOpacity(.4),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.circular(5),
                          color: kColorWhite,
                        ),
                        child: Center(
                          child: Text(
                            "CANCEL",
                            style: kmediumText(kPrimaryColor),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),

                SizedBox(
                  height: 10,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget cartCustom(CartModel cartModel) => Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        //spadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: kColorSmoke.withOpacity(.4),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ], color: kColorWhite, borderRadius: BorderRadius.circular(20)),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Color(0xFFF0F2F5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.asset(
                    cartModel.image,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cartModel.name,
                      style: ksmallTextBold(kColorBlack),
                    ),
                    Text(
                      " N " + cartModel.price,
                      style: kmediumTextBold(kPrimaryColor),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Row(
                      children: [
                        Text(
                          "Type",
                          style: ksmallTextBold(kColorSmoke2),
                        ),
                        Text(
                          " Capsule" + cartModel.price,
                          style: ksmallTextBold(kColorSmoke2),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          "Manufacturer",
                          style: ksmallTextBold(kColorSmoke2),
                        ),
                        Text(
                          ": Emzor",
                          style: ksmallTextBold(kColorSmoke2),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        width: 30,
                        height: 30,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(180),
                          color: kColorSmoke.withOpacity(.4),
                        ),
                        child: SvgPicture.asset(
                          "assets/svg/love.svg",
                          color: kColorWhite,
                          width: 20,
                          height: 20,
                        ),
                      ),
                    )
                  ],
                ))
              ],
            ),
            Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 70,
                  height: 34,
                  decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/svg/cart_popular.svg",
                      color: kColorWhite,
                      width: 20,
                      height: 20,
                    ),
                  ),
                ))
          ],
        ),
      );

  Widget cartCustom2(CartModel cartModel) => Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: kColorSmoke.withOpacity(.4),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(10),
          color: kColorWhite,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 10,
            ),
            Image.asset(cartModel.image),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartModel.name,
                  style: ksmallTextBold(kColorBlack),
                ),
                Text(
                  "Energy for men",
                  style: klargeText(kColorSmoke2),
                ),
                Text(
                  " N " + cartModel.price,
                  style: kmediumTextBold(kPrimaryColor),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                          color: Color(0xFFECECEC),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 1),
                              decoration: BoxDecoration(
                                  color: kColorWhite,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Icon(Icons.remove)),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            cartModel.quantity.toString(),
                            style: kmediumTextBold(kColorSmoke2),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 1),
                              decoration: BoxDecoration(
                                  color: kColorWhite,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Icon(Icons.add)),
                        ],
                      ),
                    ),
                    SvgPicture.asset(
                      "assets/svg/cart_delete.svg",
                      color: Color(0xFFAF1302),
                      width: 20,
                      height: 25,
                    ),
                  ],
                ),
              ],
            ))
          ],
        ),
      );


  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Refill Medicine!'),
            content: Text("Are you sure you want to schedule medicine refill order?"),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(context,MaterialPageRoute(builder: (context) => Refillorders()));
                },
              ),
              new FlatButton(
                child: new Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

}
