import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mymedicinemobile/constants.dart';
import 'package:mymedicinemobile/models/models.dart';
import 'package:mymedicinemobile/screens/mobile/cart/cart.dart';
import 'package:mymedicinemobile/text_style.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SimilarProducts extends StatefulWidget {
  _SimilarProducts createState() => new _SimilarProducts();
}

class _SimilarProducts extends State<SimilarProducts> {
  bool value = false;
  bool productShow = false;
  TextEditingController searchC = new TextEditingController();

  List<CartModel> trackList = [];
  stt.SpeechToText speech = stt.SpeechToText();

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


    print("Cool Cat ......... man");
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
                          "Similar Products",
                          style: klargeText(kColorSmoke2),
                        ),
                      ],
                    ),

                    Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Cart()));
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                            child: SvgPicture.asset(
                              "assets/svg/cart_popular.svg",
                              color: kPrimaryColor,
                              width: 25,
                              height: 25,
                            ),
                          ),
                        ),
                        Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                  color: Color(0xFFFF7685),
                                  borderRadius:
                                  BorderRadius.circular(10)),
                              child: Center(
                                  child: Text(
                                    "0",
                                    style:
                                    ksmallMediumText(kColorWhite),
                                  )),
                            )),
                      ],
                    ),

                    SvgPicture.asset(
                      "assets/svg/filter.svg",
                      color: kPrimaryColor,
                      width: 20,
                      height: 20,
                    ),

                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // Container(
              //   width: width,
              //   height: 60,
              //   margin: EdgeInsets.symmetric(horizontal: 10),
              //   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(5),
              //     color: kColorWhite,
              //     border: Border.all(
              //         color: kColorSmoke, width: 1, style: BorderStyle.solid),
              //   ),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     //crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       SizedBox(
              //         width: 5,
              //       ),
              //       Expanded(
              //         flex: 1,
              //         child: TextField(
              //           onChanged: (text) {
              //             if (text.isNotEmpty) {
              //               print(text);
              //               bool exists = isDataExist(text);
              //               if (exists) {
              //                 setState(() {
              //                   productShow = true;
              //                 });
              //               } else {
              //                 setState(() {
              //                   trackList.clear();
              //                 });
              //               }
              //             }
              //           },
              //           controller: searchC,
              //           cursorColor: kPrimaryColor,
              //           style: ksmallTextBold(kColorBlack),
              //           keyboardType: TextInputType.name,
              //           decoration: InputDecoration(
              //             hintText: "Search for medicines ...",
              //             hintStyle: kminismall(kColorSmoke2),
              //             border: InputBorder.none,
              //           ),
              //         ),
              //       ),
              //       SizedBox(
              //         width: 5,
              //       ),
              //       InkWell(
              //         onTap: () {
              //
              //         },
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             SvgPicture.asset(
              //               "assets/svg/mic_home.svg",
              //               color: kColorSmoke,
              //               width: 14,
              //               height: 16,
              //             ),
              //             Text(
              //               "Tap to speak",
              //               style: kminismall(kColorSmoke),
              //             )
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),


              ...list.map((e) => cartCustom(e)),
            ],
          ),
        ),
      ),
    );
  }



  bool isDataExist(String value) {
    var data = list.where((row) => (row.name.contains(value)));
    print("All we needdddd ..........");
    print(data);
    if (data.length >= 1) {
      trackList.clear();
      for (int i = 0; i < data.length; i++) {
        trackList.add(data.elementAt(i));
      }
      return true;
    } else {
      return false;
    }
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
                      onTap: (){

                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
            // Positioned(
            //   bottom: 10,
            //   right: 70,
            //   child: Container(
            //     width: 30,
            //     height: 30,
            //     padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(180),
            //       color: kColorSmoke.withOpacity(.4),
            //     ),
            //     child: SvgPicture.asset(
            //       "assets/svg/love.svg",
            //       color: kColorWhite,
            //       width: 20,
            //       height: 20,
            //     ),
            //   ),
            // ),
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
}
