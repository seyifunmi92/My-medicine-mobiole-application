// ignore_for_file: unnecessary_new

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mymedicinemobile/constants.dart';
import 'package:mymedicinemobile/models/models.dart';
import 'package:mymedicinemobile/screens/mobile/cart/cart.dart';
import 'package:mymedicinemobile/screens/mobile/medicine_refill/medicine_refill.dart';
import 'package:mymedicinemobile/services/services.dart';
import 'package:mymedicinemobile/text_style.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class Productetails extends StatefulWidget {
  _Productetails createState() => new _Productetails();
}

class _Productetails extends State<Productetails>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool value = false;
  bool productShow = false;
  int currentIndex = 0;
  TextEditingController searchC = new TextEditingController();
  List<CartModel> trackList = [];
  stt.SpeechToText speech = stt.SpeechToText();
  bool addedToWishList = false;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

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

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

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
    _tabController = new TabController(length: 4, vsync: this);
    _tabController.addListener(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kColorWhite,
      body: SafeArea(
        child: Container(
          width: width,
          height: height,
          child: Stack(
            children: [


              Column(
                children: [
                  Container(
                    height: height * .07,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
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
                              "Details",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: kColorBlack,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/svg/search_icon.svg",
                              color: kPrimaryColor,
                              width: 17,
                              height: 16,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Stack(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Cart()));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    child: SvgPicture.asset(
                                      "assets/svg/cart_popular.svg",
                                      color: kPrimaryColor,
                                      width: 18,
                                      height: 18,
                                    ),
                                  ),
                                ),
                                Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      width: 16,
                                      height: 17,
                                      decoration: BoxDecoration(
                                          color: Color(0xFFFF7685),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                          child: Text(
                                        "0",
                                        style: ksmallMediumText(kColorWhite),
                                      )),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: height * .89,
                    child: ListView(
                      children: [
                        SizedBox(
                          height: 20,
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
                        //   child: PageView(
                        //     children: [
                        //
                        //     ],
                        //   ),
                        // ),

                        Container(
                          width: width * .6,
                          height: 250,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: kColorWhite,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: kColorSmoke.withOpacity(.4),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Container(
                                height: 200,
                                child: PageView(
                                  onPageChanged: (var int) {
                                    setState(() {
                                      currentIndex = int;
                                    });
                                  },
                                  controller: pageController,
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    Image.asset(
                                      "assets/images/details3.png",
                                      fit: BoxFit.contain,
                                    ),
                                    Image.asset(
                                      "assets/images/details1.png",
                                      fit: BoxFit.contain,
                                    ),
                                    Image.asset(
                                      "assets/images/details2.png",
                                      fit: BoxFit.contain,
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                left: 20,
                                right: 20,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 5,
                                      width: 80,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          Container(
                                            width: currentIndex == 0 ? 20 : 10,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              color: currentIndex == 0
                                                  ? kPrimaryColor
                                                  : kColorSmoke,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Container(
                                            width: currentIndex == 1 ? 20 : 10,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              color: currentIndex == 1
                                                  ? kPrimaryColor
                                                  : kColorSmoke,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Container(
                                            width: currentIndex == 2 ? 20 : 10,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              color: currentIndex == 2
                                                  ? kPrimaryColor
                                                  : kColorSmoke,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              color: currentIndex == 3
                                                  ? kPrimaryColor
                                                  : kColorSmoke,
                                            ),
                                            width: currentIndex == 3 ? 20 : 10,
                                            height: 5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                          decoration: BoxDecoration(
                            color: kColorWhite,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                color: kColorSmoke.withOpacity(.4),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                        "Mushrooms Herb- Energy for men",
                                        style: klargeText(kColorBlack)),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      createWishlist();
                                    },
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(180),
                                        color: addedToWishList
                                            ? kPrimaryColor
                                            : kColorWhite,
                                        boxShadow: [
                                          BoxShadow(
                                            color: kColorSmoke.withOpacity(.4),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: SvgPicture.asset(
                                        "assets/svg/love_icon.svg",
                                        width: 20,
                                        height: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text("Product code ",
                                      style: ksmallTextBold(kColorSmoke)),
                                  Text(
                                    "AHA13424",
                                    style: ksmallTextBold(kColorBlack),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      RatingBar.builder(
                                        itemSize: 20,
                                        initialRating: 4,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          print(rating);
                                        },
                                      ),
                                      Text(
                                        "( 10 Ratings )",
                                        style: ksmallTextBold(kPrimaryColor),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 30,
                                    height: 30,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(180),
                                      color: kColorWhite,
                                      boxShadow: [
                                        BoxShadow(
                                          color: kColorSmoke.withOpacity(.4),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: SvgPicture.asset(
                                      "assets/svg/share_icon.svg",
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Item requires a valid prescription",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text("PACKAGE SIZE: ",
                                          style: ksmallTextBold(kColorSmoke)),
                                      Text(" 1 BOTTLE",
                                          style: ksmallTextBold(kColorBlack)),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "In Stock",
                                        style:
                                            ksmallTextBold(Colors.greenAccent),
                                      ),
                                      Text(
                                        "Mfg:Top Health company",
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            color: kColorSmoke2,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                          decoration: BoxDecoration(
                            color: kColorWhite,
                            boxShadow: [
                              BoxShadow(
                                color: kColorSmoke.withOpacity(.4),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "From ",
                                    style: kmediumTextBold(kColorBlack),
                                  ),
                                  Text(
                                    "N10,000",
                                    style: kmediumTextBold(kPrimaryColor),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Quantity",
                                    style: kmediumTextBold(kColorBlack),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 2),
                                    decoration: BoxDecoration(
                                        color: Color(0xFFECECEC),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      children: [
                                        Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 1),
                                            decoration: BoxDecoration(
                                                color: kColorWhite,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Icon(Icons.remove)),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          "1",
                                          style: kmediumTextBold(kColorSmoke2),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 1),
                                            decoration: BoxDecoration(
                                                color: kColorWhite,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Icon(Icons.add)),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 20,
                        ),

                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                          decoration: BoxDecoration(
                            color: kColorWhite,
                            boxShadow: [
                              BoxShadow(
                                color: kColorSmoke.withOpacity(.4),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Product Description",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  )),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                  "This drug is a good medicine to help your child's growth, so that it can increase appetite and also make your body taller and more muscular, make your brain smart and also good for eye health and hair health so you will look fresher.",
                                  style:TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Read more ...",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: kPrimaryColor
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 20,
                        ),

                        Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                          decoration: BoxDecoration(
                            color: kColorWhite,
                            boxShadow: [
                              BoxShadow(
                                color: kColorSmoke.withOpacity(.4),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                constraints: BoxConstraints.expand(height: 50),
                                child: TabBar(
                                  indicatorColor: kPrimaryColor,
                                  tabs: [
                                    Tab(
                                      child: Container(
                                        child: Text(
                                          "Precautions",
                                          style: kminismall(kColorBlack),
                                        ),
                                      ),
                                    ),
                                    Tab(
                                      child: Container(
                                        child: Text(
                                          "How to use",
                                          style: kminismall(kColorBlack),
                                        ),
                                      ),
                                    ),
                                    Tab(
                                      child: Container(
                                        child: Text(
                                          "Warnings",
                                          style: kminismall(kColorBlack),
                                        ),
                                      ),
                                    ),
                                    Tab(
                                      child: Container(
                                        child: Text(
                                          "Storage",
                                          style: kminismall(kColorBlack),
                                        ),
                                      ),
                                    ),
                                  ],
                                  controller: _tabController,
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: TabBarView(
                                          controller: _tabController,
                                          children: [
                                            /* All Tabs  */

                                            Container(
                                              child: ListView(
                                                children: [
                                                  Text(
                                                    ". Shake before use",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14,
                                                        fontFamily: "Poppins",
                                                        color: kColorBlack
                                                            .withOpacity(.6)),
                                                  ),
                                                  Text(
                                                    ". Do not take more than the stated recommendation",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14,
                                                        fontFamily: "Poppins",
                                                        color: kColorBlack
                                                            .withOpacity(.6)),
                                                  ),
                                                  Text(
                                                    ". Do not take if not properly sealed",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14,
                                                        fontFamily: "Poppins",
                                                        color: kColorBlack
                                                            .withOpacity(.6)),
                                                  ),
                                                  Text(
                                                    ". Do not take if not properly sealed",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14,
                                                        fontFamily: "Poppins",
                                                        color: kColorBlack
                                                            .withOpacity(.6)),
                                                  ),
                                                  Text(
                                                    ". Do not take overdose",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14,
                                                        fontFamily: "Poppins",
                                                        color: kColorBlack
                                                            .withOpacity(.6)),
                                                  ),
                                                  Text(
                                                    ". Sleep after taking this medication",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14,
                                                        fontFamily: "Poppins",
                                                        color: kColorBlack
                                                            .withOpacity(.6)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              child: ListView(
                                                children: [
                                                  ratingCustom(
                                                      "SA",
                                                      "21-06-2021",
                                                      "Cool Drug",
                                                      "This medication really helped boost my energy, I wonder why nobody gave me this prescription ealier on😂.",
                                                      "by Samuel"),
                                                ],
                                              ),
                                            ),
                                            Container(),
                                            Container(),
                                          ]))),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: kColorWhite,
                            boxShadow: [
                              BoxShadow(
                                color: kColorSmoke.withOpacity(.4),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              ratingCustom(
                                  "PA",
                                  "22-04-2021",
                                  "The relief is unbelievable.",
                                  "This medication really helped boost my energy, I wonder why nobody gave me this prescription ealier on😂.",
                                  "by otonye clement"),
                              ratingCustom(
                                  "SA",
                                  "21-06-2021",
                                  "Cool Drug",
                                  "This medication really helped boost my energy, I wonder why nobody gave me this prescription ealier on😂.",
                                  "by Samuel"),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            color: kColorWhite,
                            boxShadow: [
                              BoxShadow(
                                color: kColorSmoke.withOpacity(.4),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Shipping Policy",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: kPrimaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: SvgPicture.asset(
                                        "assets/svg/shipping_policy.svg",
                                        width: 20,
                                        height: 20),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                        "Shipping fee is calculated at checkout and orders fufilled by multiple pharmacies may attract additional shipping fee",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black.withOpacity(.5),
                                          fontSize: 13,
                                        )),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            color: kColorWhite,
                            boxShadow: [
                              BoxShadow(
                                color: kColorSmoke.withOpacity(.4),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Return Policy",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: kPrimaryColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: SvgPicture.asset(
                                        "assets/svg/return_policy.svg",
                                        width: 20,
                                        height: 20),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                        "Items can only be returned or exchanged before 2 calendar days",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black.withOpacity(.5),
                                          fontSize: 13,
                                        )),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 40,
                        ),

                        Container(
                          height: 360,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          decoration: BoxDecoration(
                            color: kColorWhite,
                            boxShadow: [
                              BoxShadow(
                                color: kColorSmoke.withOpacity(.4),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Recently Viewed",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: kColorBlack,
                                    ),
                                  ),

                                  Row(
                                    children: [
                                      Text(
                                        "View more",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                      Icon(Icons.arrow_forward_ios,color: kPrimaryColor,size: 10,)
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 20,),
                              Container(
                                height: 270,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                    ),
                                    popularProductsCustom(
                                        "assets/images/product1.png",
                                        "Skin Glow",
                                        "Vitamin C serum",
                                        "6,500"),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    popularProductsCustom(
                                        "assets/images/product2.png",
                                        "Boost Immune",
                                        "Resorb Sport",
                                        "4,500"),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    popularProductsCustom(
                                        "assets/images/product1.png",
                                        "Skin Glow",
                                        "Vitamin C serum",
                                        "6,500"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 70,
                        ),
                        //...list.map((e) => cartCustom(e)),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 10,
                right: 10,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => AddMedicine(0)));
                  },
                  child: Container(
                    width: width * .8,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kPrimaryColor),
                    child: Center(
                      child: Text(
                        "ADD TO CART",
                        style: klargeTextBold(kColorWhite),
                      ),
                    ),
                  ),
                ),
              )
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

  Widget popularProductsCustom(
      String asset, String category, String name, price) {
    double width = MediaQuery.of(context).size.width / 2.4;
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Productetails()));
      },
      child: Container(
        width: width,
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: kColorWhite,
          boxShadow: [
            BoxShadow(
              color: kColorSmoke.withOpacity(.4),
              spreadRadius: 2,
              blurRadius: 12,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Center(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: width,
                    height: 150,
                    child: Image.asset(
                      asset,
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: width,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: kColorWhite,
                    ),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          name,
                          style: kmediumText(kColorBlack),
                        ),
                        Text(
                          category,
                          style: kmediumText(kColorSmoke),
                        ),
                        Text(
                          "From N" + price,
                          style: ksmallTextBold(kColorBlack),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 60,
                        height: 30,
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
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget ratingCustom(String initials, String date, String subject, String text,
          String poster) =>
      Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          color: Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    initials,
                    style: klargeText(kColorWhite),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        subject,
                        style: kmediumText(kColorBlack),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        date,
                        style: ksmallTextBold(kColorSmoke),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RatingBar.builder(
                    itemSize: 20,
                    initialRating: 4,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    text,
                    style: ksmallTextBold(kColorBlack),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        poster,
                        style: ksmallTextBold(kColorSmoke),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      );

  void createWishlist() {
    print("We are In now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.createWishList(2, 69).then((value) => output(value));

  }

  void output(String body) {
    print("We are In second  now...");
    var bodyT = jsonDecode(body);
    print(bodyT);
    _showMessage(bodyT["message"]);
    if (bodyT["status"] == true) {
      setState(() {
        addedToWishList = true;
      });
    }
  }
}
