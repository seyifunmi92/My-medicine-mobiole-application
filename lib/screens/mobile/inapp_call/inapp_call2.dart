// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
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

class InAppCall2 extends StatefulWidget {
  _InAppCall2 createState() => new _InAppCall2();
}

class _InAppCall2 extends State<InAppCall2> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.purpleAccent,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: kColorWhite,
      body: SafeArea(
        child: Container(
          width: width,
          height: height,
          child: Center(
            child: ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 5,
                ),
                Column(
                  children: [
                    SvgPicture.asset(
                      "assets/svg/med_avatar.svg",
                      width: 60,
                      height: 60,
                    ),
                    Text(
                      "Mymedicines",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          color: kColorBlack.withOpacity(.7),
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      "Calling....",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          color: kColorBlack.withOpacity(.7),
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SvgPicture.asset(
                          "assets/svg/call_speaker.svg",
                          width: 60,
                          height: 60,
                        ),
                        Text(
                          "Speaker",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14,
                              color: kColorBlack.withOpacity(.7),
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 80,
                    ),
                    Column(
                      children: [
                        SvgPicture.asset(
                          "assets/svg/call_mic.svg",
                          width: 60,
                          height: 60,
                        ),
                        Text(
                          "Mute",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14,
                              color: kColorBlack.withOpacity(.7),
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 80,
                ),
                Column(
                  children: [
                    SvgPicture.asset(
                      "assets/svg/calling.svg",
                      width: 40,
                      height: 40,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "End Call",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          color: kColorBlack.withOpacity(.7),
                          fontWeight: FontWeight.w400),
                    ),
                  ],
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
        //padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
            content: Text(
                "Are you sure you want to schedule medicine refill order?"),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Refillorders()));
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
