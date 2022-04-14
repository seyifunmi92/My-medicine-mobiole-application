import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mymedicinemobile/constants.dart';
import 'package:mymedicinemobile/models/models.dart';
import 'package:mymedicinemobile/reusables/bars.dart';
import 'package:mymedicinemobile/screens/mobile/cart/cart.dart';
import 'package:mymedicinemobile/text_style.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SubScription extends StatefulWidget {
  const SubScription({Key? key}) : super(key: key);
  @override
  _SubScription createState() => _SubScription();
}

class _SubScription extends State<SubScription> {
  bool value = false;
  bool productShow = false;
  bool showBanner = false;
  bool showPicker = false;
  bool showPicker2 = false;
  bool showSecond = false;
  bool showCongrats = false;
  TextEditingController searchC = TextEditingController();
  List<CartModel> trackList = [];
  stt.SpeechToText speech = stt.SpeechToText();
  List<CartModel> list = [
    CartModel(
        name: "Alfonso",
        price: "10,500",
        quantity: 0,
        isChecked: false,
        image: "assets/images/product_search.png"),
    CartModel(
        name: "Mushrooms Herb- Energy for men",
        price: "10,500",
        quantity: 0,
        isChecked: false,
        image: "assets/images/product_search.png"),
    CartModel(
        name: "Alfonso X",
        price: "10,500",
        quantity: 0,
        isChecked: false,
        image: "assets/images/product_search.png"),
    CartModel(
        name: "Paracetamol",
        price: "10,500",
        quantity: 0,
        isChecked: false,
        image: "assets/images/product_search.png"),
    CartModel(
        name: "Prolactin",
        price: "4,500",
        quantity: 10,
        isChecked: false,
        image: "assets/images/product_search.png"),
  ];
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
          child: Stack(
            children: [
              showSecond
                  ? Container(
                      child: Column(
                        children: [
                          navBarCustomCartBeforePerson(
                              'Payment Method', context, Cart(), true),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  SvgPicture.asset(
                                    "assets/svg/logos_mastercard.svg",
                                    width: 30,
                                    height: 30,
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  const Text("Mastercard-1234",
                                      style: TextStyle(
                                          color: kColorBlack,
                                          fontSize: 15,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    showSecond = false;
                                    showBanner = false;
                                    showPicker2 = true;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 15),
                                  width: 25,
                                  height: 25,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(180),
                                      color: kColorWhite,
                                      border: Border.all(
                                          color: kColorSmoke2,
                                          width: 1,
                                          style: BorderStyle.solid)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Divider(
                            height: 2,
                            color: kColorSmoke2,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  SvgPicture.asset(
                                    "assets/svg/credit_card.svg",
                                    width: 30,
                                    height: 30,
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  const Text("Add credit or debit card",
                                      style: TextStyle(
                                          color: kColorBlack,
                                          fontSize: 15,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    showSecond = false;
                                    showBanner = false;
                                    showPicker2 = true;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 15),
                                  width: 25,
                                  height: 25,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(180),
                                      color: kColorWhite,
                                      border: Border.all(
                                          color: kColorSmoke2,
                                          width: 1,
                                          style: BorderStyle.solid)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        navBarCustomCartBeforePerson(
                            'Refill Subscription', context, Cart(), true),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text("Get  your medicine refill",
                            style: TextStyle(
                                color: kColorBlack,
                                fontSize: 13,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w400)),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                              color: const Color(0xFFF7F5FC),
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/svg/naira.svg",
                                        color: kPrimaryColor,
                                        width: 10,
                                        height: 10,
                                      ),
                                      const Text(
                                        "20,000/First year",
                                        style: TextStyle(
                                            color: kPrimaryColor,
                                            fontSize: 11,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        showBanner = true;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      decoration: BoxDecoration(
                                          color: const Color(0xFF3CA455),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text("Subscribe now",
                                          style: TextStyle(
                                              color: kColorWhite,
                                              fontSize: 12,
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  )
                                ],
                              ),
                              SvgPicture.asset(
                                "assets/svg/sub_img.svg",
                                width: 100,
                                height: 100,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Subscription includes",
                                  style: TextStyle(
                                      color: kColorBlack,
                                      fontSize: 15,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/svg/radio_return.svg",
                                    color: const Color(0xFF3CA455),
                                    width: 15,
                                    height: 15,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text("20% discount for first year",
                                      style: TextStyle(
                                          color: kColorBlack,
                                          fontSize: 11,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w400)),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/svg/radio_return.svg",
                                    color: Color(0xFF3CA455),
                                    width: 15,
                                    height: 15,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text("Automated refill and reminder",
                                      style: TextStyle(
                                          color: kColorBlack,
                                          fontSize: 11,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w400)),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/svg/radio_return.svg",
                                    color: const Color(0xFF3CA455),
                                    width: 15,
                                    height: 15,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text("No price change/increment",
                                      style: TextStyle(
                                          color: kColorBlack,
                                          fontSize: 11,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w400)),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/svg/radio_return.svg",
                                    color: const Color(0xFF3CA455),
                                    width: 15,
                                    height: 15,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                      "Quarterly medication review with our pharmacist",
                                      style: TextStyle(
                                          color: kColorBlack,
                                          fontSize: 11,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w400)),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/svg/radio_return.svg",
                                    color: const Color(0xFF3CA455),
                                    width: 15,
                                    height: 15,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                      "Free delivery for up to 3 fulfilments",
                                      style: TextStyle(
                                          color: kColorBlack,
                                          fontSize: 11,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w400)),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
              showBanner
                  ? Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: width,
                        height: height,
                        color: const Color(0xFF000000).withOpacity(0.25),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 150,
                              left: 20,
                              right: 20,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                width: 200,
                                decoration: BoxDecoration(
                                    color: kColorWhite,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Text("Mymedicines Terms of Service",
                                        style: TextStyle(
                                            color: kColorBlack,
                                            fontSize: 13,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w600)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                        "By subscribing to mymedicine medicine refill, you agree to the mymedicines Terms of Service. Note: The mymedicines Privacy Policy describes how data is handled in this service.",
                                        style: TextStyle(
                                            color: kColorBlack,
                                            fontSize: 13,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w400)),
                                    const SizedBox(
                                      height: 40,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              showBanner = false;
                                            });
                                          },
                                          child: const Text("Cancel",
                                              style: TextStyle(
                                                  color: kColorBlack,
                                                  fontSize: 13,
                                                  fontFamily: "Poppins",
                                                  fontWeight: FontWeight.w400)),
                                        ),
                                        const SizedBox(
                                          width: 30,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              showPicker = true;
                                            });
                                          },
                                          child: const Text("Agree",
                                              style: TextStyle(
                                                  color: kPrimaryColor,
                                                  fontSize: 13,
                                                  fontFamily: "Poppins",
                                                  fontWeight: FontWeight.w400)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            showPicker
                                ? Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      decoration: BoxDecoration(
                                          color: kColorWhite,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 15, right: 15, top: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/svg/med_refill.svg",
                                                      width: 30,
                                                      height: 30,
                                                    ),
                                                    Text("Medicine Refill",
                                                        style: TextStyle(
                                                            color: kColorBlack,
                                                            fontSize: 13,
                                                            fontFamily:
                                                                "Poppins",
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text("Starting 10 July 2021",
                                                    style: TextStyle(
                                                        color: kColorBlack,
                                                        fontSize: 13,
                                                        fontFamily: "Poppins",
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    textAlign: TextAlign.start),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                    "Cancel at anytime on your account page",
                                                    style: TextStyle(
                                                        color: kColorBlack
                                                            .withOpacity(.6),
                                                        fontSize: 11,
                                                        fontFamily: "Poppins",
                                                        fontWeight:
                                                            FontWeight.w400)),
                                                SizedBox(
                                                  height: 1,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        "Your first charge will occur on 10 July 2021",
                                                        style: TextStyle(
                                                            color: kColorBlack
                                                                .withOpacity(
                                                                    .6),
                                                            fontSize: 11,
                                                            fontFamily:
                                                                "Poppins",
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                    SizedBox(
                                                      width: 30,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          showPicker = false;
                                                        });
                                                      },
                                                      child: Text("CANCEL",
                                                          style: TextStyle(
                                                              color:
                                                                  kPrimaryColor,
                                                              fontSize: 11,
                                                              fontFamily:
                                                                  "Poppins",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400)),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Divider(
                                            height: 2,
                                            color: kColorSmoke2,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  SvgPicture.asset(
                                                    "assets/svg/credit_card.svg",
                                                  ),
                                                  SizedBox(
                                                    width: 30,
                                                  ),
                                                  Text(
                                                      "Add credit or debit card",
                                                      style: TextStyle(
                                                          color: kColorBlack,
                                                          fontSize: 13,
                                                          fontFamily: "Poppins",
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                ],
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(right: 10),
                                                child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        showSecond = true;
                                                        showBanner = false;
                                                      });
                                                    },
                                                    child: Icon(
                                                      Icons.arrow_forward_ios,
                                                    )),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Divider(
                                            height: 2,
                                            color: kColorSmoke2,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            margin: EdgeInsets.only(
                                                left: 15, right: 15, top: 10),
                                            decoration: BoxDecoration(
                                                color: Colors.green
                                                    .withOpacity(.3),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Center(
                                                child: Text(
                                              "Subscribe",
                                              style: TextStyle(
                                                  color: kColorWhite,
                                                  fontSize: 13,
                                                  fontFamily: "Poppins",
                                                  fontWeight: FontWeight.w400),
                                            )),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 15, right: 15, top: 10),
                                            child: Column(
                                              children: const [
                                                Text(
                                                  "You will be charged N20,000 + tax automatically every month until you cancel ",
                                                  style: TextStyle(
                                                      color: kColorBlack,
                                                      fontSize: 9,
                                                      fontFamily: "Poppins",
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  textAlign: TextAlign.start,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                    "By tapping subscribe, you accept mymedicines Privacy Policy and Terms of Service ",
                                                    style: TextStyle(
                                                        color: kColorBlack,
                                                        fontSize: 9,
                                                        fontFamily: "Poppins",
                                                        fontWeight:
                                                            FontWeight.w400),
                                                    textAlign: TextAlign.center)
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Center()
                          ],
                        ),
                      ))
                  : const Center(),
              showPicker2
                  ? Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                            color: kColorWhite,
                            boxShadow: [
                              BoxShadow(
                                color: kColorSmoke.withOpacity(.4),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 15, right: 15, top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/svg/med_refill.svg",
                                        width: 30,
                                        height: 30,
                                      ),
                                      const Text("Medicine Refill",
                                          style: TextStyle(
                                              color: kColorBlack,
                                              fontSize: 13,
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text("Starting 10 July 2021",
                                      style: TextStyle(
                                          color: kColorBlack,
                                          fontSize: 13,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.start),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text("Cancel at anytime on your account page",
                                      style: TextStyle(
                                          color: kColorBlack.withOpacity(.6),
                                          fontSize: 11,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w400)),
                                  const SizedBox(
                                    height: 1,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          "Your first charge will occur on 10 July 2021",
                                          style: TextStyle(
                                              color:
                                                  kColorBlack.withOpacity(.6),
                                              fontSize: 11,
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w400)),
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            showPicker2 = false;
                                          });
                                        },
                                        child: const Text("CANCEL",
                                            style: TextStyle(
                                                color: kPrimaryColor,
                                                fontSize: 11,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w400)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Divider(
                              height: 2,
                              color: kColorSmoke2,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    SvgPicture.asset(
                                      "assets/svg/logos_mastercard.svg",
                                    ),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    const Text("Mastercard-1234",
                                        style: TextStyle(
                                            color: kColorBlack,
                                            fontSize: 13,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w400)),
                                  ],
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          showSecond = true;
                                          showBanner = false;
                                        });
                                      },
                                      child: const Icon(
                                        Icons.arrow_forward_ios,
                                      )),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Divider(
                              height: 2,
                              color: kColorSmoke2,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  showCongrats = true;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                margin: const EdgeInsets.only(
                                    left: 15, right: 15, top: 10),
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                    child: Text(
                                  "Subscribe",
                                  style: TextStyle(
                                      color: kColorWhite,
                                      fontSize: 13,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w400),
                                )),
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(left: 15, right: 15, top: 10),
                              child: Column(
                                children: const [
                                  Text(
                                    "You will be charged N20,000 + tax automatically every month until you cancel ",
                                    style: TextStyle(
                                        color: kColorBlack,
                                        fontSize: 9,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                      "By tapping subscribe, you accept mymedicines Privacy Policy and Terms of Service ",
                                      style: TextStyle(
                                          color: kColorBlack,
                                          fontSize: 9,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.center)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const Center(),
              showCongrats
                  ? Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                          width: width,
                          height: height,
                          color: const Color(0xFF000000).withOpacity(0.25),
                          child: Stack(children: [
                            Positioned(
                                top: 150,
                                left: 20,
                                right: 20,
                                child: Container(
                                    width: 200,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Image.asset(
                                      "assets/images/congrats.png",
                                      fit: BoxFit.contain,
                                      width: 200,
                                    )))
                          ])))
                  : const Center()
            ],
          ),
        ),
      ),
    );
  }
}
