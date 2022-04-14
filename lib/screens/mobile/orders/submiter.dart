// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:mymedicinemobile/constants.dart';
import 'package:mymedicinemobile/models/models.dart';
import 'package:mymedicinemobile/screens/mobile/cart/cart.dart';
import 'package:mymedicinemobile/text_style.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:timeline_tile/timeline_tile.dart';

class Submitter extends StatefulWidget {
  const Submitter({Key? key}) : super(key: key);

  @override
  _Submitter createState() => _Submitter();
}

class _Submitter extends State<Submitter> {
  List<OrderModel> list = [
    OrderModel(
        name: "Mushrooms Herb- Energy for men",
        price: "10,500",
        quantity: 0,
        isChecked: true,
        orderStatus: "CLOSED",
        status: "Delivered",
        image: "assets/images/order_img.png"),
    OrderModel(
        name: "Mushrooms Herb- Energy for men",
        price: "10,500",
        quantity: 0,
        isChecked: false,
        status: "PROCESSING",
        orderStatus: "PAYMENT UNSUCCESSFUL",
        image: "assets/images/order_img.png"),
    OrderModel(
        name: "Mushrooms Herb- Energy for men",
        price: "10,500",
        quantity: 0,
        status: "Ready for delivery",
        isChecked: false,
        orderStatus: "CANCELLED",
        image: "assets/images/order_img.png"),
  ];
  TextEditingController emailC = TextEditingController();
  TextEditingController addC = TextEditingController();

  bool toggleStatus = true;

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
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    color: const Color(0xFFF8F5FC),
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
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Request Return",
                              style: klargeText(kColorSmoke2),
                            ),
                          ],
                        ),
                        Row(
                          children: [
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
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    child: SvgPicture.asset(
                                      "assets/svg/cart_popular.svg",
                                      color: kPrimaryColor,
                                      width: 30,
                                      height: 30,
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
                                          color: const Color(0xFFFF7685),
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
                            const SizedBox(
                              width: 30,
                            ),
                            SvgPicture.asset(
                              "assets/svg/loggedin_person.svg",
                              color: kPrimaryColor,
                              width: 30,
                              height: 30,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: height * .83,
                    child: ListView(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "SUBMITTED",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: kColorBlack),
                            ),
                          ],
                        ),
                        //returnTopContainer(list[0]),
                        Container(
                          height: height * .4,
                          margin: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          padding: const EdgeInsets.symmetric(
                              vertical: 25, horizontal: 10),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: kColorSmoke.withOpacity(.2),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                              color: kColorWhite,
                              border: Border.all(
                                  color: const Color(0xFFFBF2FA),
                                  width: 2,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                "assets/svg/radio_return.svg",
                                width: 40,
                                height: 40,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                "Your request was sucessful! Please we would respond within 2 working days",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400,
                                    color: kColorBlack),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: height / 4,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1),
                                color: kPrimaryColor),
                            child: Center(
                              child: Text(
                                "CONTINUE SHOPPING",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: kColorWhite),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ));
  }

  Widget returnTopContainer(OrderModel cartModel) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: kColorSmoke.withOpacity(.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          color: const Color(0xFFFBF2FA),
          border: Border.all(
              color: const Color(0xFFFBF2FA),
              width: 2,
              style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Mode of payment",
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: kColorBlack),
              ),
              SvgPicture.asset(
                "assets/svg/radio_return.svg",
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            height: 2,
            color: kPrimaryColor,
          ),
          const SizedBox(
            height: 40,
          ),
          Container(
            //margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: kColorSmoke.withOpacity(.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
                color: kColorWhite,
                //border: Border.all(color: Color(0xFFFBF2FA),width: 2,style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(5)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Card type",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              color: kColorSmoke2),
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/svg/card2.svg",
                            ),
                            Text(
                              "MasterCard",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                  color: kColorBlack.withOpacity(.6)),
                            ),
                          ],
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Country",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              color: kColorSmoke2),
                        ),
                        Text(
                          "Nigeria NG",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              color: kColorBlack.withOpacity(.6)),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Card number",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              color: kColorSmoke2),
                        ),
                        Text(
                          "539983**********2056",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              color: kColorBlack.withOpacity(.6)),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Expiry",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              color: kColorSmoke2),
                        ),
                        Text(
                          "06/20",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              color: kColorBlack.withOpacity(.6)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ExpansionPanel customExtension(OrderModel cartModel, double width) {
    return ExpansionPanel(
      canTapOnHeader: true,
      //hasIcon: false,
      isExpanded: cartModel.isChecked,
      headerBuilder: (context, isOpen) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 5),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: kColorSmoke.withOpacity(.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ], color: kColorWhite, borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Order Item",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: kColorBlack),
                  ),
                  InkWell(
                    onTap: () {
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => ));
                    },
                    child: const Text(
                      "Request Return",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: kPrimaryColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F2F5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image.asset(
                      cartModel.image,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Mushrooms -",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: kColorBlack),
                          ),
                          Text(
                            "Herbs",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: kColorSmoke2),
                          ),
                        ],
                      ),
                      Text(
                        "Order #1234763",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            color: kColorSmoke2),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            "QTY: 1 PACK: ",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                                color: kColorSmoke2),
                          ),
                          const Text(
                            "capsule",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: kColorBlack),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/svg/naira.svg",
                          ),
                          const Text(
                            "4,500",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                                color: kColorBlack),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      cartModel.status.contains("PROCESSING")
                          ? Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/svg/cancel_1.svg",
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text(
                                  "Cancel order",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFFAF1302)),
                                ),
                              ],
                            )
                          : const Center(),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: 100,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                            color:
                                cartModel.status.contains("Ready for delivery")
                                    ? const Color(0xFF48A7F8)
                                    : cartModel.status.contains("Delivered")
                                        ? const Color(0xFF16C68B)
                                        : const Color(0xFFFFB323),
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                          child: Text(
                            cartModel.status,
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: cartModel.status.contains("Delivered") ||
                                        cartModel.status
                                            .contains("Ready for delivery")
                                    ? kColorWhite
                                    : kColorBlack),
                          ),
                        ),
                      ),
                      cartModel.status.contains("Delivered")
                          ? Text(
                              "On 10/12/2021",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                  color: kColorSmoke2),
                            )
                          : const Center(),
                    ],
                  ))
                ],
              ),
              Container(
                margin: const EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    const Text(
                      "Rate Item",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SvgPicture.asset(
                      "assets/svg/star_rating.svg",
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: kPrimaryColor,
                        width: 3,
                        style: BorderStyle.solid)),
                child: const Center(
                  child: Text(
                    "SCHEDULE REFILL",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                    color: kPrimaryColor),
                child: Center(
                  child: Text(
                    "BUY AGAIN",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: kColorWhite),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "See History",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFAF1302)),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  cartModel.isChecked
                      ? const Icon(
                          Icons.keyboard_arrow_up,
                          color: Color(0xFFAF1302),
                        )
                      : const Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFFAF1302),
                        )
                ],
              ),
            ],
          ),
        );
      },
      body: Container(
        width: width,
        height: 180,
        padding: const EdgeInsets.only(top: 20),
        decoration: const BoxDecoration(
            color: Color(0xFFF0F2F5),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFF0F2F5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TimelineTile(
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.manual,
              afterLineStyle: const LineStyle(
                color: kPrimaryColor,
                thickness: 2,
              ),
              lineXY: 0.3,
              isFirst: true,
              indicatorStyle: IndicatorStyle(
                indicator: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(180),
                    border: Border.all(
                        color: kPrimaryColor,
                        width: 1,
                        style: BorderStyle.solid),
                  ),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(180),
                        color: kPrimaryColor
                        //border: Border.all(color: kPrimaryColor,width: 1,style: BorderStyle.solid),
                        ),
                  ),
                ),
              ),
              startChild: Container(
                width: width / 6,
                child: Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Text(
                      "Placed",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                    const Text(
                      "Order",
                      // ignore: unnecessary_const
                      style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                  ],
                ),
              ),
              endChild: Container(
                child: Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "12:05PM",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                    const Text(
                      "12 MAY 21",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                  ],
                ),
              ),
            ),
            TimelineTile(
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.manual,
              afterLineStyle:
                  const LineStyle(color: kPrimaryColor, thickness: 2),
              beforeLineStyle:
                  const LineStyle(color: kPrimaryColor, thickness: 2),
              lineXY: 0.3,
              isLast: false,
              indicatorStyle: IndicatorStyle(
                indicator: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(180),
                    border: Border.all(
                        color: kPrimaryColor,
                        width: 1,
                        style: BorderStyle.solid),
                  ),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(180),
                        color: kPrimaryColor
                        //border: Border.all(color: kPrimaryColor,width: 1,style: BorderStyle.solid),
                        ),
                  ),
                ),
              ),
              startChild: Container(
                width: width / 6,
                child: Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Text(
                      "Placed",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                    Text(
                      "Order",
                      style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                  ],
                ),
              ),
              endChild: Container(
                child: Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "12:05PM",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                    const Text(
                      "12 MAY 21",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                  ],
                ),
              ),
            ),
            TimelineTile(
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.manual,
              afterLineStyle: LineStyle(color: kColorSmoke, thickness: 2),
              beforeLineStyle:
                  const LineStyle(color: kPrimaryColor, thickness: 2),
              lineXY: 0.3,
              isLast: false,
              indicatorStyle: IndicatorStyle(
                indicator: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(180),
                    border: Border.all(
                        color: kPrimaryColor,
                        width: 1,
                        style: BorderStyle.solid),
                  ),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(180),
                        color: kPrimaryColor
                        //border: Border.all(color: kPrimaryColor,width: 1,style: BorderStyle.solid),
                        ),
                  ),
                ),
              ),
              startChild: Container(
                width: width / 6,
                child: Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Text(
                      "Placed",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                    const Text(
                      "Order",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                  ],
                ),
              ),
              endChild: Container(
                child: Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "12:05PM",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                    const Text(
                      "12 MAY 21",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                  ],
                ),
              ),
            ),
            TimelineTile(
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.manual,
              afterLineStyle: LineStyle(color: kColorSmoke, thickness: 2),
              beforeLineStyle: LineStyle(color: kColorSmoke, thickness: 2),
              lineXY: 0.3,
              isLast: false,
              indicatorStyle: IndicatorStyle(
                indicator: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(180),
                    border: Border.all(
                        color: kColorSmoke, width: 1, style: BorderStyle.solid),
                  ),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(180),
                        color: kColorSmoke
                        //border: Border.all(color: kPrimaryColor,width: 1,style: BorderStyle.solid),
                        ),
                  ),
                ),
              ),
              startChild: Container(
                width: width / 6,
                child: Column(
                  children: [
                    Text(
                      "Placed",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorSmoke2),
                    ),
                    Text(
                      "Order",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorSmoke2),
                    ),
                  ],
                ),
              ),
              endChild: Container(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "12:05PM",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorSmoke2),
                    ),
                    Text(
                      "12 MAY 21",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorSmoke2),
                    ),
                  ],
                ),
              ),
            ),
            TimelineTile(
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.manual,
              afterLineStyle: LineStyle(color: kColorSmoke, thickness: 2),
              beforeLineStyle: LineStyle(color: kColorSmoke, thickness: 2),
              lineXY: 0.3,
              isLast: true,
              indicatorStyle: IndicatorStyle(
                indicator: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(180),
                    border: Border.all(
                        color: kColorSmoke, width: 1, style: BorderStyle.solid),
                  ),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(180),
                        color: kColorSmoke
                        //border: Border.all(color: kPrimaryColor,width: 1,style: BorderStyle.solid),
                        ),
                  ),
                ),
              ),
              startChild: Container(
                width: width / 6,
                child: Column(
                  children: [
                    Text(
                      "Placed",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorSmoke2),
                    ),
                    Text(
                      "Order",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorSmoke2),
                    ),
                  ],
                ),
              ),
              endChild: Container(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "12:05PM",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorSmoke2),
                    ),
                    Text(
                      "12 MAY 21",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorSmoke2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
