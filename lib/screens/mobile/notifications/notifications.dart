import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mymedicinemobile/constants.dart';
import 'package:mymedicinemobile/models/models.dart';
import 'package:mymedicinemobile/text_style.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class Notifications extends StatefulWidget {
  _Notifications createState() => new _Notifications();
}

class _Notifications extends State<Notifications> {
  bool value = false;
  bool noticleared = true;



  List<CartModel> list = [
    new CartModel(
        name: "Alfonso",
        price: "10,500",
        quantity: 0,
        isChecked: false,
        image: "assets/images/product_search.png"),
    new CartModel(
        name: "Mushrooms Herb- Energy for men",
        price: "10,500",
        quantity: 0,
        isChecked: false,
        image: "assets/images/product_search.png"),
    new CartModel(
        name: "Alfonso X",
        price: "10,500",
        quantity: 0,
        isChecked: false,
        image: "assets/images/product_search.png"),
    new CartModel(
        name: "Paracetamol",
        price: "10,500",
        quantity: 0,
        isChecked: false,
        image: "assets/images/product_search.png"),
    new CartModel(
        name: "Prolactin",
        price: "4,500",
        quantity: 10,
        isChecked: false,
        image: "assets/images/product_search.png"),
  ];



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
      backgroundColor: kColorWhite,
      body: SafeArea(
        child: Container(
          width: width,
          height: height,
          child: noticleared ? Container(
            width: width,
            height: height,
            child: Center(
              child: Column(
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
                              "Notifications",
                              style: klargeText(kColorSmoke2),
                            ),
                          ],
                        ),


                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  SvgPicture.asset(
                    "assets/svg/noty.svg",
                  ),

                  Text(
                    "You have no new notifications",
                    style: kmediumTextBold(kPrimaryColor),
                  ),

                ],
              ),
            ),
          ) : ListView(
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
                          "Notifications",
                          style: klargeText(kColorSmoke2),
                        ),
                      ],
                    ),


                    InkWell(
                      onTap: (){
                        setState(() {
                          noticleared = true;
                        });
                      },
                      child: Text(
                        "Clear all",
                        style: kmediumTextBold(kPrimaryColor),
                      ),
                    ),


                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),

              Container(
                padding: EdgeInsets.only(left: 25,top: 20),
                color: kColorSmoke.withOpacity(.1),
                child: Text(
                  "Today",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                    color: kColorSmoke2,
                    fontSize: 16,
                  ),
                ),
              ),

              ...list.map((e) => notyCustom(e)),

              Container(
                padding: EdgeInsets.only(left: 25,top: 20),
                color: kColorSmoke.withOpacity(.1),
                child: Text(
                  "30th June, 2021",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                    color: kColorSmoke2,
                    fontSize: 16,
                  ),
                ),
              ),

              ...list.map((e) => notyCustom(e)),


            ],
          ),
        ),
      ),
    );
  }





  Widget notyCustom(CartModel cartModel) => Container(

    margin: EdgeInsets.symmetric(vertical: list.indexOf(cartModel) == 0 ?0 : 10,),
    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 18),
    decoration: BoxDecoration(boxShadow: [
      BoxShadow(
        color: kColorSmoke.withOpacity(.4),
        spreadRadius: 1,
        blurRadius: 7,
        offset: Offset(0, 3), // changes position of shadow
      ),
    ], color: kColorWhite,
        //borderRadius: BorderRadius.circular(20)
    ),
    child: Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 10,
            ),

            Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Medicine Refill",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                        color: kColorBlack,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      "You have 5 days to your medicine refill",
                      style: ksmallTextBold(kColorBlack),
                    ),
                  ],
                )),

            InkWell(
              onTap: (){

              },
              child: Container(
                width: 30,
                height: 30,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(180),
                  color: kPrimaryColor,
                ),
                child: SvgPicture.asset(
                  "assets/svg/refill.svg",
                  color: kColorWhite,
                  width: 40,
                  height: 40,
                ),
              ),
            )
          ],
        ),


      ],
    ),
  );
}
