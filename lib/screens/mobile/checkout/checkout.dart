// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutterwave_standard/core/flutterwave.dart';
import 'package:flutterwave_standard/models/requests/customer.dart';
import 'package:flutterwave_standard/models/requests/customizations.dart';
import 'package:flutterwave_standard/models/responses/charge_response.dart';
import 'package:flutterwave_standard/view/flutterwave_style.dart';
import 'package:mymedicinemobile/constants.dart';
import 'package:mymedicinemobile/models/models.dart';
import 'package:mymedicinemobile/reusables/location_class.dart';
import 'package:mymedicinemobile/services/services.dart';
import 'package:mymedicinemobile/text_style.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'cash_checkout_complete.dart';
import 'checkout_complete.dart';

class Checkout extends StatefulWidget {
  double total;
  String uniqueSalesOrderId;
  List<CartItems> items;
  int salesOrderId;
  Checkout(this.salesOrderId, this.uniqueSalesOrderId, this.items, this.total);
  _Checkout createState() => _Checkout();
}

class _Checkout extends State<Checkout> with SingleTickerProviderStateMixin {
  bool value = false;
  bool passwordShow = false;
  bool showNewCard = false;
  bool showNewAddress = false;
  bool checker = false;
  late TabController _tabController;
  TextEditingController nameC = TextEditingController();
  TextEditingController phoneC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController genderC = TextEditingController();
  TextEditingController bdayC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController cardType = TextEditingController();
  TextEditingController cardName = TextEditingController();
  TextEditingController cardNumber = TextEditingController();
  TextEditingController currentP = TextEditingController();
  TextEditingController newP = TextEditingController();
  TextEditingController retypeP = TextEditingController();
  TextEditingController cvv2 = TextEditingController();
  TextEditingController expiry = TextEditingController();
  TextEditingController streetC = TextEditingController();
  TextEditingController regionC = TextEditingController();
  TextEditingController phoneEditC = TextEditingController();
  TextEditingController emailEditC = TextEditingController();
  TextEditingController promoTextController = TextEditingController();
  List<MedShipAddrees> addressList = [];
  late MedShipAddrees medShipAddrees;
  bool addressLoaded = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool deliveryLoaded = false;
  bool toggleStatus = true;
  bool showSummary = false;
  bool showConfirm = false;
  int currentIndex = 0;
  double deliveryCharge = 500;
  bool deliveryFeeLoaded = false;
  late int deliveryId;
  late String _ref;
  bool createAddressLoading = false;

  void setRef() {
    Random rand = Random();
    int number = rand.nextInt(2000);
    if (Platform.isAndroid) {
      setState(() {
        _ref = "AndroidRef1789$number";
      });
    } else {
      setState(() {
        _ref = "IOSRef1789$number";
      });
    }
  }

  //int pageCurrent = 0;
  int pagerCurrentIndex = 0;
  int firstPagerCurrent = 0;
  bool showUseAddressBtn = true;
  bool showProceedToPayment = false;
  List<DeliveryType> deliverySelectList = [];

  List<AllMyCards> cardSelector = [
    AllMyCards("3452", false, "assets/svg/mastercard.svg"),
    AllMyCards("5466", false, "assets/svg/visa.svg"),
    AllMyCards("1123", false, "assets/svg/mastercard.svg"),
  ];

  List<PaymentType> paymentSelectionType = [
    PaymentType("FlutterWave", false),
    PaymentType("Cash", false),
    PaymentType("Card", false),
    PaymentType("Wallet", false),
    PaymentType("Bank Transfer", false)
  ];

  List<LogisticsDelivery> logisticsList = [];

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  void onAddButtonTapped(int index) {
    // use this to animate to the page
    // pageController.animateToPage(index,curve: Curve(22));
    // or this to jump to it without animating
    pageController.jumpToPage(index);
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      print("Hello people of country...");
      setState(() {
        currentIndex = _tabController.index;
      });
      print(currentIndex);
    });
    setUser();
    setRef();
    viewShipmentAddress();
    super.initState();

    //print("Makahahahhhahahahahahaha");
    print(widget.total.toString());
  }

  setUser() {
    nameC.text = "";
    phoneC.text = "";
    emailC.text = "";
    genderC.text = "";
    bdayC.text = "";
    passwordC.text = "";

    streetC.text = "";
    regionC.text = "";
    phoneEditC.text = "";
    emailEditC.text = "";
  }

  bool validateAddressInput() {
    if (streetC.text.isEmpty) {
      _showMessage("Input Street");
      return false;
    } else if (regionC.text.isEmpty) {
      _showMessage("Input Region");
      return false;
    } else if (phoneEditC.text.length != 11) {
      _showMessage("Input a valid phone");
      return false;
    } else if (!emailEditC.text.contains("@")) {
      _showMessage("Input a valid email");
      return false;
    } else if (!emailEditC.text.contains(".")) {
      _showMessage("Input a valid email");
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: kColorWhite,
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
          width: width,
          height: height,
          child: Stack(
            children: [
              ListView(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    height: height * .96,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(
                        vertical: 5, horizontal: showConfirm ? 0 : 10),
                    child: PageView(
                      controller: pageController,
                      physics: NeverScrollableScrollPhysics(),
                      onPageChanged: (var int) {
                        setState(() {
                          pagerCurrentIndex = int;
                        });
                      },
                      children: [
                        ListView(
                          children: [
                            Container(
                              //color: kPrimaryColor,
                              height: 70,
                              width: width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  //Container(height: 40,width: 30,color: kColorBlack,),
                                  TimelineTile(
                                    axis: TimelineAxis.horizontal,
                                    alignment: TimelineAlign.manual,
                                    afterLineStyle: LineStyle(
                                      color: kColorSmoke,
                                      thickness: 2,
                                    ),
                                    lineXY: 0.3,
                                    isFirst: true,
                                    indicatorStyle: IndicatorStyle(
                                      indicator: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2, vertical: 2),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(180),
                                          border: Border.all(
                                              color: kPrimaryColor,
                                              width: 1,
                                              style: BorderStyle.solid),
                                        ),
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(180),
                                              color: kPrimaryColor
                                              //border: Border.all(color: kPrimaryColor,width: 1,style: BorderStyle.solid),
                                              ),
                                        ),
                                      ),
                                    ),
                                    endChild: Container(
                                      width: width * .3,
                                      //padding: EdgeInsets.only(left: 0),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Delivery",
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 9,
                                                fontWeight: FontWeight.w400,
                                                color: kColorBlack),
                                          ),
                                          Text(
                                            "Details",
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 9,
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
                                    afterLineStyle: LineStyle(
                                        color: kColorSmoke, thickness: 2),
                                    beforeLineStyle: LineStyle(
                                        color: kColorSmoke, thickness: 2),
                                    lineXY: 0.3,
                                    isLast: false,
                                    indicatorStyle: IndicatorStyle(
                                      indicator: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2, vertical: 2),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(180),
                                          border: Border.all(
                                              color: kColorSmoke,
                                              width: 1,
                                              style: BorderStyle.solid),
                                        ),
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(180),
                                              color: kColorSmoke
                                              //border: Border.all(color: kPrimaryColor,width: 1,style: BorderStyle.solid),
                                              ),
                                        ),
                                      ),
                                    ),
                                    startChild: Container(
                                      width: width * .3,
                                      child: Column(
                                        children: [],
                                      ),
                                    ),
                                    endChild: Container(
                                      width: width * .3,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Delivery",
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 9,
                                                fontWeight: FontWeight.w400,
                                                color: kColorBlack),
                                          ),
                                          Text(
                                            "Method",
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 9,
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
                                    beforeLineStyle: LineStyle(
                                        color: kColorSmoke, thickness: 2),
                                    lineXY: 0.3,
                                    isLast: true,
                                    indicatorStyle: IndicatorStyle(
                                      indicator: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2, vertical: 2),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(180),
                                          border: Border.all(
                                              color: kColorSmoke,
                                              width: 1,
                                              style: BorderStyle.solid),
                                        ),
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(180),
                                              color: kColorSmoke
                                              //border: Border.all(color: kPrimaryColor,width: 1,style: BorderStyle.solid),
                                              ),
                                        ),
                                      ),
                                    ),
                                    startChild: Container(
                                      width: width * .3,
                                      child: Column(
                                        children: [],
                                      ),
                                    ),
                                    endChild: Container(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Payment",
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 9,
                                                fontWeight: FontWeight.w400,
                                                color: kColorBlack),
                                          ),
                                          Text(
                                            "Method",
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 9,
                                                fontWeight: FontWeight.w400,
                                                color: kColorBlack),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Delivery Details",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: kColorBlack),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: height * .8,
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: kColorWhite,
                                boxShadow: [
                                  BoxShadow(
                                    color: kColorSmoke.withOpacity(.4),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    constraints:
                                        BoxConstraints.expand(height: 50),
                                    child: TabBar(
                                      indicatorColor: kPrimaryColor,
                                      onTap: (int current) {
                                        print("Tapped");
                                        print(current);
                                        if (current == 1) {
                                          setState(() {
                                            showUseAddressBtn = false;
                                          });
                                        } else {
                                          setState(() {
                                            showUseAddressBtn = true;
                                          });
                                        }
                                      },
                                      tabs: [
                                        Tab(
                                          child: Container(
                                            child: Text(
                                              "Select Delivery Address",
                                              style: currentIndex == 0
                                                  ? ksmallTextBold(
                                                      kPrimaryColor)
                                                  : ksmallTextBold(kColorBlack),
                                            ),
                                          ),
                                        ),
                                        Tab(
                                          child: Container(
                                            child: Text(
                                              "Add New Address",
                                              style: currentIndex == 1
                                                  ? ksmallTextBold(
                                                      kPrimaryColor)
                                                  : ksmallTextBold(kColorBlack),
                                            ),
                                          ),
                                        ),
                                      ],
                                      controller: _tabController,
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                          height: height * .7,
                                          padding: EdgeInsets.all(10),
                                          child: TabBarView(
                                              controller: _tabController,
                                              children: [
                                                /* All Tabs  */

                                                addressLoaded == true
                                                    ? Container(
                                                        height: height * .8,
                                                        child: ListView(
                                                          children: [
                                                            ...addressList.map(
                                                                (e) =>
                                                                    customAddress(
                                                                        e)),
                                                            SizedBox(
                                                              height: 140,
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : Container(
                                                        width: 120,
                                                        child: Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                          strokeWidth: 30,
                                                          color: kPrimaryColor,
                                                        ))),
                                                /*
                                              New Address is here.
                                           */
                                                ListView(
                                                  children: [
                                                    Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 5,
                                                                vertical: 10),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10,
                                                                vertical: 20),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          color: kColorWhite,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: kColorSmoke
                                                                  .withOpacity(
                                                                      .4),
                                                              spreadRadius: 5,
                                                              blurRadius: 7,
                                                              offset: Offset(0,
                                                                  3), // changes position of shadow
                                                            ),
                                                          ],
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    SvgPicture
                                                                        .asset(
                                                                      "assets/svg/add_plus.svg",
                                                                      width: 20,
                                                                      height:
                                                                          25,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Text(
                                                                      "YOUR NEW ADDRESS",
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            "Poppins",
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        color: kColorBlack
                                                                            .withOpacity(.6),
                                                                        fontSize:
                                                                            14,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    SvgPicture
                                                                        .asset(
                                                                      "assets/svg/saver.svg",
                                                                      width: 15,
                                                                      height:
                                                                          15,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        if (validateAddressInput()) {
                                                                          setState(
                                                                              () {
                                                                            createAddressLoading =
                                                                                true;
                                                                          });
                                                                          createAddress();
                                                                        }
                                                                      },
                                                                      child: createAddressLoading
                                                                          ? CircularProgressIndicator(
                                                                              color: kPrimaryColor,
                                                                            )
                                                                          : Text(
                                                                              "SAVE",
                                                                              style: TextStyle(
                                                                                fontFamily: "Poppins",
                                                                                fontWeight: FontWeight.w500,
                                                                                color: kPrimaryColor.withOpacity(.6),
                                                                                fontSize: 15,
                                                                              ),
                                                                            ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 30,
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => LocationState(
                                                                            "Country",
                                                                            0)));
                                                              },
                                                              child: Text(
                                                                Provider.of<ServiceClass>(
                                                                        context)
                                                                    .Country
                                                                    .toString(),
                                                                style: ksmallTextBold(
                                                                    kColorBlack),
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                              ),
                                                            ),
                                                            Divider(
                                                              thickness: 1,
                                                              color:
                                                                  kColorSmoke2,
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => LocationState(
                                                                            "State",
                                                                            Provider.of<ServiceClass>(context).CountryId)));
                                                              },
                                                              child: Text(
                                                                Provider.of<ServiceClass>(
                                                                        context)
                                                                    .State
                                                                    .toString(),
                                                                style: ksmallTextBold(
                                                                    kColorBlack),
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                              ),
                                                            ),
                                                            Divider(
                                                              thickness: 1,
                                                              color:
                                                                  kColorSmoke2,
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => LocationState(
                                                                            "LGA",
                                                                            Provider.of<ServiceClass>(context).StateId)));
                                                              },
                                                              child: Text(
                                                                Provider.of<ServiceClass>(
                                                                        context)
                                                                    .LGA
                                                                    .toString(),
                                                                style: ksmallTextBold(
                                                                    kColorBlack),
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                              ),
                                                            ),
                                                            Divider(
                                                              thickness: 1,
                                                              color:
                                                                  kColorSmoke2,
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                              "Street Address",
                                                              style: ksmallTextBold(
                                                                  kColorSmoke),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          12,
                                                                      vertical:
                                                                          5),
                                                              child: TextField(
                                                                controller:
                                                                    streetC,
                                                                cursorColor:
                                                                    kPrimaryColor,
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      "Poppins",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color:
                                                                      kColorBlack,
                                                                  fontSize: 14,
                                                                ),
                                                                keyboardType:
                                                                    TextInputType
                                                                        .name,
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText: "",
                                                                  hintStyle:
                                                                      ksmallTextBold(
                                                                          kColorSmoke),
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                ),
                                                              ),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  border: Border.all(
                                                                      color:
                                                                          kColorSmoke,
                                                                      width: 1,
                                                                      style: BorderStyle
                                                                          .solid)),
                                                            ),
                                                            SizedBox(
                                                              height: 15,
                                                            ),
                                                            Text(
                                                              "Region/State",
                                                              style: ksmallTextBold(
                                                                  kColorSmoke),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          12,
                                                                      vertical:
                                                                          5),
                                                              child: TextField(
                                                                controller:
                                                                    regionC,
                                                                cursorColor:
                                                                    kPrimaryColor,
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      "Poppins",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color:
                                                                      kColorBlack,
                                                                  fontSize: 14,
                                                                ),
                                                                keyboardType:
                                                                    TextInputType
                                                                        .name,
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText: "",
                                                                  hintStyle:
                                                                      ksmallTextBold(
                                                                          kColorSmoke),
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                ),
                                                              ),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  border: Border.all(
                                                                      color:
                                                                          kColorSmoke,
                                                                      width: 1,
                                                                      style: BorderStyle
                                                                          .solid)),
                                                            ),
                                                            SizedBox(
                                                              height: 15,
                                                            ),
                                                            Text(
                                                              "Phone Number",
                                                              style: ksmallTextBold(
                                                                  kColorSmoke),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          12,
                                                                      vertical:
                                                                          5),
                                                              child: TextField(
                                                                controller:
                                                                    phoneEditC,
                                                                cursorColor:
                                                                    kPrimaryColor,
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      "Poppins",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color:
                                                                      kColorBlack,
                                                                  fontSize: 14,
                                                                ),
                                                                keyboardType:
                                                                    TextInputType
                                                                        .name,
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText: "",
                                                                  hintStyle:
                                                                      ksmallTextBold(
                                                                          kColorSmoke),
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                ),
                                                              ),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  border: Border.all(
                                                                      color:
                                                                          kColorSmoke,
                                                                      width: 1,
                                                                      style: BorderStyle
                                                                          .solid)),
                                                            ),
                                                            SizedBox(
                                                              height: 15,
                                                            ),
                                                            Text(
                                                              "Email Address",
                                                              style: ksmallTextBold(
                                                                  kColorSmoke),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          12,
                                                                      vertical:
                                                                          5),
                                                              child: TextField(
                                                                controller:
                                                                    emailEditC,
                                                                cursorColor:
                                                                    kPrimaryColor,
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      "Poppins",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color:
                                                                      kColorBlack,
                                                                  fontSize: 14,
                                                                ),
                                                                keyboardType:
                                                                    TextInputType
                                                                        .name,
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText: "",
                                                                  hintStyle:
                                                                      ksmallTextBold(
                                                                          kColorSmoke),
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                ),
                                                              ),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  border: Border.all(
                                                                      color:
                                                                          kColorSmoke,
                                                                      width: 1,
                                                                      style: BorderStyle
                                                                          .solid)),
                                                            ),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Text(
                                                                    "Make this my default address",
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          "Poppins",
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color:
                                                                          kColorSmoke,
                                                                      fontSize:
                                                                          14,
                                                                    )),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Container(
                                                                    child:
                                                                        FlutterSwitch(
                                                                  width: 70.0,
                                                                  height: 30.0,
                                                                  activeColor:
                                                                      kPrimaryColor,
                                                                  valueFontSize:
                                                                      15.0,
                                                                  toggleSize:
                                                                      10.0,
                                                                  value:
                                                                      toggleStatus,
                                                                  borderRadius:
                                                                      30.0,
                                                                  padding: 8.0,
                                                                  showOnOff:
                                                                      true,
                                                                  onToggle:
                                                                      (val) {
                                                                    setState(
                                                                        () {
                                                                      if (toggleStatus) {
                                                                        toggleStatus =
                                                                            false;
                                                                      } else {
                                                                        toggleStatus =
                                                                            true;
                                                                      }
                                                                    });
                                                                  },
                                                                ))
                                                              ],
                                                            ),
                                                          ],
                                                        )),
                                                    SizedBox(
                                                      height: 50,
                                                    ),
                                                  ],
                                                ),
                                              ]))),
                                ],
                              ),
                            ),
                          ],
                        ),

                        /*
                        Second Page
                         */

                        ListView(
                          children: [
                            Container(
                              //color: kPrimaryColor,
                              height: 70,
                              width: width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  //Container(height: 40,width: 30,color: kColorBlack,),
                                  TimelineTile(
                                    axis: TimelineAxis.horizontal,
                                    alignment: TimelineAlign.manual,
                                    afterLineStyle: LineStyle(
                                      color: kPrimaryColor,
                                      thickness: 2,
                                    ),
                                    lineXY: 0.3,
                                    isFirst: true,
                                    indicatorStyle: IndicatorStyle(
                                      indicator: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2, vertical: 2),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(180),
                                          border: Border.all(
                                              color: kPrimaryColor,
                                              width: 1,
                                              style: BorderStyle.solid),
                                        ),
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(180),
                                              color: kPrimaryColor
                                              //border: Border.all(color: kPrimaryColor,width: 1,style: BorderStyle.solid),
                                              ),
                                        ),
                                      ),
                                    ),
                                    endChild: Container(
                                      width: width * .3,
                                      //padding: EdgeInsets.only(left: 0),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Delivery",
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 9,
                                                fontWeight: FontWeight.w400,
                                                color: kColorBlack),
                                          ),
                                          Text(
                                            "Details",
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 9,
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
                                    afterLineStyle: LineStyle(
                                        color: kColorSmoke, thickness: 2),
                                    beforeLineStyle: LineStyle(
                                        color: kPrimaryColor, thickness: 2),
                                    lineXY: 0.3,
                                    isLast: false,
                                    indicatorStyle: IndicatorStyle(
                                      indicator: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2, vertical: 2),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(180),
                                          border: Border.all(
                                              color: kPrimaryColor,
                                              width: 1,
                                              style: BorderStyle.solid),
                                        ),
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(180),
                                              color: kPrimaryColor
                                              //border: Border.all(color: kPrimaryColor,width: 1,style: BorderStyle.solid),
                                              ),
                                        ),
                                      ),
                                    ),
                                    startChild: Container(
                                      width: width * .3,
                                      child: Column(
                                        children: [],
                                      ),
                                    ),
                                    endChild: Container(
                                      width: width * .3,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Delivery",
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 9,
                                                fontWeight: FontWeight.w400,
                                                color: kColorBlack),
                                          ),
                                          Text(
                                            "Method",
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 9,
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
                                    beforeLineStyle: LineStyle(
                                        color: kColorSmoke, thickness: 2),
                                    lineXY: 0.3,
                                    isLast: true,
                                    indicatorStyle: IndicatorStyle(
                                      indicator: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2, vertical: 2),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(180),
                                          border: Border.all(
                                              color: kColorSmoke,
                                              width: 1,
                                              style: BorderStyle.solid),
                                        ),
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(180),
                                              color: kColorSmoke
                                              //border: Border.all(color: kPrimaryColor,width: 1,style: BorderStyle.solid),
                                              ),
                                        ),
                                      ),
                                    ),
                                    startChild: Container(
                                      width: width * .3,
                                      child: Column(
                                        children: [],
                                      ),
                                    ),
                                    endChild: Container(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Payment",
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 9,
                                                fontWeight: FontWeight.w400,
                                                color: kColorBlack),
                                          ),
                                          Text(
                                            "Method",
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 9,
                                                fontWeight: FontWeight.w400,
                                                color: kColorBlack),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ExpansionPanelList(
                              dividerColor: Colors.red,
                              children: [
                                customExtension(width),
                              ],
                              expansionCallback: (i, isOpen) {
                                setState(() {
                                  checker = !checker;
                                });
                              },
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: 5, right: 5, bottom: 5, top: 10),
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: kColorSmoke.withOpacity(.2),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                  color: kColorWhite,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      topLeft: Radius.circular(20))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Select delivery Method",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w600,
                                      color: kColorBlack,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: 5, bottom: 5, left: 5, right: 5),
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: kColorSmoke.withOpacity(.2),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                  color: kColorWhite,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                "Kindly select how you want order delivered",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w400,
                                  color: kColorBlack,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: 5, bottom: 5, left: 5, right: 5),
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: kColorSmoke.withOpacity(.2),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                  color: kColorWhite,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        logisticsList.isNotEmpty
                                            ? logisticsList[0]
                                                .logisticsDeliveryType!
                                            : "Home Delivery",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w400,
                                          color: kColorBlack,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Checkbox(
                                        checkColor: Colors.white,
                                        fillColor: MaterialStateProperty.all(
                                            kPrimaryColor),
                                        value: deliverySelectList.isNotEmpty
                                            ? deliverySelectList[0].clicked
                                            : false,
                                        shape: CircleBorder(),
                                        onChanged: (bool? value) {
                                          for (var x in deliverySelectList) {
                                            x.clicked = false;
                                          }

                                          print("Cashing ....");
                                          //print(logisticsList.isEmpty);

                                          setState(() {
                                            deliverySelectList[0].clicked =
                                                !deliverySelectList[0].clicked;
                                            //deliveryId = logisticsList[1].logisticsDeliveryOptionId!;
                                            getShipmentFee();
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 5, bottom: 5, left: 5, right: 5),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 10),
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: kColorSmoke.withOpacity(.2),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                        color: Color(0xFFFFECFD),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Text(
                                      "Hi ${Provider.of<ServiceClass>(context).MedUsers.firstName}, Your Items will be delivered to you within 5 working days if you are based in Lagos.",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFFC926B4),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "*Payment must be done before package is opened",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFFFF656F),
                                      fontSize: 11,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  // InkWell(
                                  //   onTap: () {
                                  //     setState(() {
                                  //       deliveryLoaded = true;
                                  //     });
                                  //     logisticsDelivery(medShipAddrees.stateId!,medShipAddrees.lgaId!);
                                  //   },
                                  //   child: Text(
                                  //     "SELECT LOGISTICS SERVICE *",
                                  //     style: TextStyle(
                                  //       fontFamily: "Poppins",
                                  //       fontWeight: FontWeight.w600,
                                  //       color: kPrimaryColor,
                                  //       fontSize: 11,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            // Container(
                            //   margin: EdgeInsets.only(
                            //       top: 5, bottom: 5, left: 5, right: 5),
                            //   padding: EdgeInsets.symmetric(
                            //       vertical: 5, horizontal: 10),
                            //   decoration: BoxDecoration(
                            //       boxShadow: [
                            //         BoxShadow(
                            //           color: kColorSmoke.withOpacity(.2),
                            //           spreadRadius: 5,
                            //           blurRadius: 7,
                            //           offset: Offset(
                            //               0, 3), // changes position of shadow
                            //         ),
                            //       ],
                            //       color: kColorWhite,
                            //       borderRadius: BorderRadius.circular(5)),
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Row(
                            //         mainAxisAlignment:
                            //             MainAxisAlignment.spaceBetween,
                            //         children: [
                            //           Text(
                            //             logisticsList.isNotEmpty ? logisticsList[0].logisticsDeliveryType!
                            //            : "PickUp Location",
                            //             style: TextStyle(
                            //               fontFamily: "Poppins",
                            //               fontWeight: FontWeight.w400,
                            //               color: kColorBlack,
                            //               fontSize: 15,
                            //             ),
                            //           ),
                            //           Checkbox(
                            //             checkColor: Colors.white,
                            //             fillColor: MaterialStateProperty.all(
                            //                 kPrimaryColor),
                            //             value: deliverySelectList.isNotEmpty ? deliverySelectList[1].clicked : false,
                            //             shape: CircleBorder(),
                            //             onChanged: (bool? value) {
                            //               for (var x in deliverySelectList) {
                            //                 x.clicked = false;
                            //               }
                            //               setState(() {
                            //                 deliverySelectList[1].clicked =
                            //                     !deliverySelectList[1].clicked;
                            //                 deliveryId = logisticsList[0].logisticsDeliveryOptionId!;
                            //                 getShipmentFee(deliveryId);
                            //                 //logisticsDelivery(medShipAddrees.stateId!,medShipAddrees.lgaId!);
                            //
                            //               });
                            //             },
                            //           ),
                            //         ],
                            //       ),
                            //       Container(
                            //         margin: EdgeInsets.only(
                            //             top: 5, bottom: 5, left: 5, right: 5),
                            //         padding: EdgeInsets.symmetric(
                            //             vertical: 15, horizontal: 10),
                            //         decoration: BoxDecoration(
                            //             boxShadow: [
                            //               BoxShadow(
                            //                 color: kColorSmoke.withOpacity(.2),
                            //                 spreadRadius: 5,
                            //                 blurRadius: 7,
                            //                 offset: Offset(0,
                            //                     3), // changes position of shadow
                            //               ),
                            //             ],
                            //             color: Color(0xFFFFECFD),
                            //             borderRadius: BorderRadius.circular(5)),
                            //         child: Text(
                            //           "Available from Wednesday 3 Nov and Wednesday 7 December",
                            //           style: TextStyle(
                            //             fontFamily: "Poppins",
                            //             fontWeight: FontWeight.w400,
                            //             color: Color(0xFFC926B4),
                            //             fontSize: 12,
                            //           ),
                            //         ),
                            //       ),
                            //       Text(
                            //         "*Payment must be done before package is opened",
                            //         style: TextStyle(
                            //           fontFamily: "Poppins",
                            //           fontWeight: FontWeight.w400,
                            //           color: Color(0xFFFF656F),
                            //           fontSize: 11,
                            //         ),
                            //         textAlign: TextAlign.start,
                            //       ),
                            //       SizedBox(
                            //         height: 10,
                            //       ),
                            //
                            //       // InkWell(
                            //       //   onTap:(){
                            //       //     setState(() {
                            //       //       deliveryLoaded = true;
                            //       //     });
                            //       //     logisticsDelivery(medShipAddrees.stateId!,medShipAddrees.lgaId!);
                            //       //   },
                            //       //   child: Text(
                            //       //     "SELECT PICKUP LOCATION *",
                            //       //     style: TextStyle(
                            //       //       fontFamily: "Poppins",
                            //       //       fontWeight: FontWeight.w600,
                            //       //       color: kPrimaryColor,
                            //       //       fontSize: 11,
                            //       //     ),
                            //       //   ),
                            //       // ),
                            //
                            //
                            //
                            //     ],
                            //   ),
                            // ),
                            // Container(
                            //   margin: EdgeInsets.only(
                            //       top: 5, bottom: 5, left: 5, right: 5),
                            //   padding: EdgeInsets.symmetric(
                            //       vertical: 5, horizontal: 10),
                            //   decoration: BoxDecoration(
                            //       boxShadow: [
                            //         BoxShadow(
                            //           color: kColorSmoke.withOpacity(.2),
                            //           spreadRadius: 5,
                            //           blurRadius: 7,
                            //           offset: Offset(
                            //               0, 3), // changes position of shadow
                            //         ),
                            //       ],
                            //       color: kColorWhite,
                            //       borderRadius: BorderRadius.circular(5)),
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Text(
                            //         "Shipment Details",
                            //         style: TextStyle(
                            //           fontFamily: "Poppins",
                            //           fontWeight: FontWeight.w600,
                            //           color: kColorBlack,
                            //           fontSize: 16,
                            //         ),
                            //       ),
                            //       SizedBox(
                            //         height: 10,
                            //       ),
                            //       Text(
                            //         "Shipment prices differ based on delivery from different fulfilment pharmacies.",
                            //         style: TextStyle(
                            //           fontFamily: "Poppins",
                            //           fontWeight: FontWeight.w400,
                            //           color: kColorBlack,
                            //           fontSize: 12,
                            //         ),
                            //         textAlign: TextAlign.start,
                            //       ),
                            //       Container(
                            //         margin: EdgeInsets.only(
                            //             top: 5, bottom: 5, left: 5, right: 5),
                            //         padding: EdgeInsets.symmetric(
                            //             vertical: 15, horizontal: 10),
                            //         decoration: BoxDecoration(
                            //             boxShadow: [
                            //               BoxShadow(
                            //                 color: kColorSmoke.withOpacity(.2),
                            //                 spreadRadius: 5,
                            //                 blurRadius: 7,
                            //                 offset: Offset(0,
                            //                     3), // changes position of shadow
                            //               ),
                            //             ],
                            //             color: Color(0xFFFFECFD),
                            //             borderRadius: BorderRadius.circular(5)),
                            //         child: Column(
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.start,
                            //           children: [
                            //             Text(
                            //               "Shipment 1 of 2",
                            //               style: TextStyle(
                            //                 fontFamily: "Poppins",
                            //                 fontWeight: FontWeight.w400,
                            //                 color: kColorBlack,
                            //                 fontSize: 12,
                            //               ),
                            //             ),
                            //             Row(
                            //               mainAxisAlignment:
                            //                   MainAxisAlignment.spaceBetween,
                            //               children: [
                            //                 Text(
                            //                   "1x  Mushroom Herb-Energy for men",
                            //                   style: TextStyle(
                            //                     fontFamily: "Poppins",
                            //                     fontWeight: FontWeight.w400,
                            //                     color: Color(0xFFC926B4),
                            //                     fontSize: 12,
                            //                   ),
                            //                 ),
                            //                 Text(
                            //                   "N2,000",
                            //                   style: TextStyle(
                            //                     fontFamily: "Poppins",
                            //                     fontWeight: FontWeight.w400,
                            //                     color: kColorBlack,
                            //                     fontSize: 12,
                            //                   ),
                            //                 ),
                            //               ],
                            //             ),
                            //             SizedBox(
                            //               height: 10,
                            //             ),
                            //             Text(
                            //               "Shipment 1 of 2",
                            //               style: TextStyle(
                            //                 fontFamily: "Poppins",
                            //                 fontWeight: FontWeight.w400,
                            //                 color: kColorBlack,
                            //                 fontSize: 12,
                            //               ),
                            //             ),
                            //             Row(
                            //               mainAxisAlignment:
                            //                   MainAxisAlignment.spaceBetween,
                            //               children: [
                            //                 Text(
                            //                   "1x  Mushroom Herb-Energy for men",
                            //                   style: TextStyle(
                            //                     fontFamily: "Poppins",
                            //                     fontWeight: FontWeight.w400,
                            //                     color: Color(0xFFC926B4),
                            //                     fontSize: 12,
                            //                   ),
                            //                 ),
                            //                 Text(
                            //                   "N2,000",
                            //                   style: TextStyle(
                            //                     fontFamily: "Poppins",
                            //                     fontWeight: FontWeight.w400,
                            //                     color: kColorBlack,
                            //                     fontSize: 12,
                            //                   ),
                            //                 ),
                            //               ],
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //       Text(
                            //         "*Shipment for different local government area",
                            //         style: TextStyle(
                            //           fontFamily: "Poppins",
                            //           fontWeight: FontWeight.w400,
                            //           color: Color(0xFFFF656F),
                            //           fontSize: 11,
                            //         ),
                            //         textAlign: TextAlign.start,
                            //       ),
                            //       SizedBox(
                            //         height: width / 1.3,
                            //       ),
                            //     ],
                            //   ),
                            // ),

                            SizedBox(
                              height: width / 1,
                            ),
                          ],
                        ),

                        /*
                           Third Section
                         */

                        showConfirm == false
                            ? ListView(
                                children: [
                                  Container(
                                    //color: kPrimaryColor,
                                    height: 70,
                                    width: width,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        //Container(height: 40,width: 30,color: kColorBlack,),
                                        TimelineTile(
                                          axis: TimelineAxis.horizontal,
                                          alignment: TimelineAlign.manual,
                                          afterLineStyle: LineStyle(
                                            color: kPrimaryColor,
                                            thickness: 2,
                                          ),
                                          lineXY: 0.3,
                                          isFirst: true,
                                          indicatorStyle: IndicatorStyle(
                                            indicator: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 2, vertical: 2),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(180),
                                                border: Border.all(
                                                    color: kPrimaryColor,
                                                    width: 1,
                                                    style: BorderStyle.solid),
                                              ),
                                              child: Container(
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            180),
                                                    color: kPrimaryColor
                                                    //border: Border.all(color: kPrimaryColor,width: 1,style: BorderStyle.solid),
                                                    ),
                                              ),
                                            ),
                                          ),
                                          endChild: Container(
                                            width: width * .3,
                                            //padding: EdgeInsets.only(left: 0),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "Delivery",
                                                  style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 9,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: kColorBlack),
                                                ),
                                                Text(
                                                  "Details",
                                                  style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 9,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: kColorBlack),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        TimelineTile(
                                          axis: TimelineAxis.horizontal,
                                          alignment: TimelineAlign.manual,
                                          afterLineStyle: LineStyle(
                                            color: kPrimaryColor,
                                            thickness: 2,
                                          ),
                                          beforeLineStyle: LineStyle(
                                              color: kPrimaryColor,
                                              thickness: 2),
                                          lineXY: 0.3,
                                          isLast: false,
                                          indicatorStyle: IndicatorStyle(
                                            indicator: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 2, vertical: 2),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(180),
                                                border: Border.all(
                                                    color: kPrimaryColor,
                                                    width: 1,
                                                    style: BorderStyle.solid),
                                              ),
                                              child: Container(
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            180),
                                                    color: kPrimaryColor
                                                    //border: Border.all(color: kPrimaryColor,width: 1,style: BorderStyle.solid),
                                                    ),
                                              ),
                                            ),
                                          ),
                                          startChild: Container(
                                            width: width * .3,
                                            child: Column(
                                              children: [],
                                            ),
                                          ),
                                          endChild: Container(
                                            width: width * .3,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "Delivery",
                                                  style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 9,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: kColorBlack),
                                                ),
                                                Text(
                                                  "Method",
                                                  style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 9,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: kColorBlack),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        TimelineTile(
                                          axis: TimelineAxis.horizontal,
                                          alignment: TimelineAlign.manual,
                                          beforeLineStyle: LineStyle(
                                              color: kPrimaryColor,
                                              thickness: 2),
                                          lineXY: 0.3,
                                          isLast: true,
                                          indicatorStyle: IndicatorStyle(
                                            indicator: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 2, vertical: 2),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(180),
                                                border: Border.all(
                                                    color: kPrimaryColor,
                                                    width: 1,
                                                    style: BorderStyle.solid),
                                              ),
                                              child: Container(
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            180),
                                                    color: kPrimaryColor
                                                    //border: Border.all(color: kPrimaryColor,width: 1,style: BorderStyle.solid),
                                                    ),
                                              ),
                                            ),
                                          ),
                                          startChild: Container(
                                            width: width * .3,
                                            child: Column(
                                              children: [],
                                            ),
                                          ),
                                          endChild: Container(
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "Payment",
                                                  style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 9,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: kColorBlack),
                                                ),
                                                Text(
                                                  "Method",
                                                  style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 9,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: kColorBlack),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    "Payment Methods",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w600,
                                      color: kColorBlack,
                                      fontSize: 16,
                                    ),
                                  ),
                                  ExpansionPanelList(
                                    children: [
                                      flutterWavePaymentCustom(width),
                                      cashOnDeliveryPaymentCustom(width),
                                      // cardPaymentCustom(width),
                                      // walletPaymentCustom(width),
                                      // cashPaymentCustom(width)
                                    ],
                                    expansionCallback: (i, isOpen) {
                                      print(i);
                                      print("Whats up there");
                                      setState(() {
                                        paymentSelectionType[i].clicked =
                                            !paymentSelectionType[i].clicked;
                                      });
                                    },
                                    dividerColor: kColorWhite,
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Promo Code",
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w600,
                                            color: kColorBlack,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                height: 50,
                                                child: TextField(
                                                  controller:
                                                      promoTextController,
                                                  cursorColor: kPrimaryColor,
                                                  style: ksmallTextBold(
                                                      kColorBlack),
                                                  keyboardType:
                                                      TextInputType.text,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Enter promotion or discount code",
                                                    hintStyle: ksmallTextBold(
                                                        kColorSmoke2),
                                                    //border: InputBorder.none,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                if (promoTextController
                                                    .text.isNotEmpty) {
                                                  applyPromocode(
                                                      widget.salesOrderId,
                                                      promoTextController.text
                                                          .trim());
                                                }
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 10),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: kPrimaryColor),
                                                child: Center(
                                                  child: Text(
                                                    "APPLY",
                                                    style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: kColorWhite,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: height / 0.2,
                                  ),
                                ],
                              )
                            : ListView(
                                children: [
                                  Container(
                                    //color: kPrimaryColor,
                                    height: 70,
                                    width: width,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        //Container(height: 40,width: 30,color: kColorBlack,),
                                        TimelineTile(
                                          axis: TimelineAxis.horizontal,
                                          alignment: TimelineAlign.manual,
                                          afterLineStyle: LineStyle(
                                            color: kPrimaryColor,
                                            thickness: 2,
                                          ),
                                          lineXY: 0.3,
                                          isFirst: true,
                                          indicatorStyle: IndicatorStyle(
                                            indicator: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 2, vertical: 2),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(180),
                                                border: Border.all(
                                                    color: kPrimaryColor,
                                                    width: 1,
                                                    style: BorderStyle.solid),
                                              ),
                                              child: Container(
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            180),
                                                    color: kPrimaryColor
                                                    //border: Border.all(color: kPrimaryColor,width: 1,style: BorderStyle.solid),
                                                    ),
                                              ),
                                            ),
                                          ),
                                          endChild: Container(
                                            width: width * .3,
                                            //padding: EdgeInsets.only(left: 0),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "Delivery",
                                                  style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 9,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: kColorBlack),
                                                ),
                                                Text(
                                                  "Details",
                                                  style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 9,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: kColorBlack),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        TimelineTile(
                                          axis: TimelineAxis.horizontal,
                                          alignment: TimelineAlign.manual,
                                          afterLineStyle: LineStyle(
                                            color: kPrimaryColor,
                                            thickness: 2,
                                          ),
                                          beforeLineStyle: LineStyle(
                                              color: kPrimaryColor,
                                              thickness: 2),
                                          lineXY: 0.3,
                                          isLast: false,
                                          indicatorStyle: IndicatorStyle(
                                            indicator: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 2, vertical: 2),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(180),
                                                border: Border.all(
                                                    color: kPrimaryColor,
                                                    width: 1,
                                                    style: BorderStyle.solid),
                                              ),
                                              child: Container(
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            180),
                                                    color: kPrimaryColor
                                                    //border: Border.all(color: kPrimaryColor,width: 1,style: BorderStyle.solid),
                                                    ),
                                              ),
                                            ),
                                          ),
                                          startChild: Container(
                                            width: width * .3,
                                            child: Column(
                                              children: [],
                                            ),
                                          ),
                                          endChild: Container(
                                            width: width * .3,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "Delivery",
                                                  style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 9,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: kColorBlack),
                                                ),
                                                Text(
                                                  "Method",
                                                  style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 9,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: kColorBlack),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        TimelineTile(
                                          axis: TimelineAxis.horizontal,
                                          alignment: TimelineAlign.manual,
                                          beforeLineStyle: LineStyle(
                                              color: kPrimaryColor,
                                              thickness: 2),
                                          lineXY: 0.3,
                                          isLast: true,
                                          indicatorStyle: IndicatorStyle(
                                            indicator: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 2, vertical: 2),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(180),
                                                border: Border.all(
                                                    color: kPrimaryColor,
                                                    width: 1,
                                                    style: BorderStyle.solid),
                                              ),
                                              child: Container(
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            180),
                                                    color: kPrimaryColor
                                                    //border: Border.all(color: kPrimaryColor,width: 1,style: BorderStyle.solid),
                                                    ),
                                              ),
                                            ),
                                          ),
                                          startChild: Container(
                                            width: width * .3,
                                            child: Column(
                                              children: [],
                                            ),
                                          ),
                                          endChild: Container(
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "Payment",
                                                  style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 9,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: kColorBlack),
                                                ),
                                                Text(
                                                  "Method",
                                                  style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 9,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: kColorBlack),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    color: Color(0xFFF1F1F1),
                                    child: Text(
                                      "Your Order",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w500,
                                        color: kColorBlack.withOpacity(.6),
                                        fontSize: 16,
                                      ),
                                    ),
                                    padding: EdgeInsets.only(
                                        top: 10, bottom: 10, left: 15),
                                  ),
                                  Container(
                                    color: kColorWhite,
                                    padding: EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 15,
                                        right: 15),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Sub Total",
                                              style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                color: kColorBlack,
                                                fontSize: 12,
                                              ),
                                            ),
                                            SvgPicture.asset(
                                              "assets/svg/elipse.svg",
                                              color: kColorSmoke2,
                                            ),
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/svg/naira.svg",
                                                  color: kColorSmoke2,
                                                ),
                                                Text(
                                                  "${widget.total}",
                                                  style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontWeight: FontWeight.w500,
                                                    color: kColorBlack,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Delivery charges",
                                              style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                color: kColorBlack,
                                                fontSize: 12,
                                              ),
                                            ),
                                            SvgPicture.asset(
                                              "assets/svg/elipse.svg",
                                              color: kColorSmoke2,
                                            ),
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/svg/naira.svg",
                                                  color: kColorSmoke2,
                                                  width: 10,
                                                  height: 10,
                                                ),
                                                Text(
                                                  "$deliveryCharge",
                                                  style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontWeight: FontWeight.w500,
                                                    color: kColorBlack,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Divider(
                                          height: 2,
                                          color: kColorSmoke2,
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Total",
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: kColorBlack),
                                            ),
                                            SvgPicture.asset(
                                              "assets/svg/elipse.svg",
                                              color: kColorSmoke2,
                                            ),
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/svg/naira.svg",
                                                  color: kPrimaryColor,
                                                ),
                                                Text(
                                                  "${widget.total + deliveryCharge}",
                                                  style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontWeight: FontWeight.w500,
                                                    color: kPrimaryColor,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    color: Color(0xFFF1F1F1),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Your Address",
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w500,
                                            color: kColorBlack.withOpacity(.6),
                                            fontSize: 16,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            onAddButtonTapped(
                                                pagerCurrentIndex - 2);
                                            setState(() {
                                              showUseAddressBtn = true;
                                              showProceedToPayment = false;
                                              showConfirm = false;
                                            });
                                          },
                                          child: Text(
                                            "CHANGE",
                                            style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFFAF1302),
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      ],
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                    ),
                                    padding: EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 15,
                                        right: 15),
                                  ),
                                  customAddress2(medShipAddrees),
                                  Container(
                                    color: Color(0xFFF1F1F1),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Delivery Method",
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w500,
                                            color: kColorBlack.withOpacity(.6),
                                            fontSize: 16,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            onAddButtonTapped(
                                                pagerCurrentIndex - 1);
                                            setState(() {
                                              showProceedToPayment = true;
                                              showSummary = false;
                                              showConfirm = false;
                                            });
                                          },
                                          child: Text(
                                            "CHANGE",
                                            style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFFAF1302),
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 15,
                                        right: 15),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 30, horizontal: 30),
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: kColorSmoke.withOpacity(.2),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                        color: kColorWhite,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Home Delivery",
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w400,
                                            color: kColorBlack.withOpacity(.8),
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          " Give it 5 working days to get your Items ",
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w500,
                                            color: kPrimaryColor,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    color: Color(0xFFF1F1F1),
                                    child: Text(
                                      "Payment Method",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w500,
                                        color: kColorBlack.withOpacity(.6),
                                        fontSize: 16,
                                      ),
                                    ),
                                    padding: EdgeInsets.only(
                                        top: 10, bottom: 10, left: 15),
                                  ),
                                  paymentSelectionType[0].clicked
                                      ? Container(
                                          margin:
                                              EdgeInsets.symmetric(vertical: 5),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 3, horizontal: 10),
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: kColorSmoke
                                                      .withOpacity(.2),
                                                  spreadRadius: 5,
                                                  blurRadius: 7,
                                                  offset: Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                              color: kColorWhite,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Image.asset(
                                                    "assets/images/flutterwave_logo.png",
                                                    width: 50,
                                                    height: 70,
                                                  ),
                                                  SizedBox(
                                                    width: 3,
                                                  ),
                                                  Text(
                                                    "Pay with FlutterWave",
                                                    style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: kColorBlack,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Checkbox(
                                                checkColor: Colors.white,
                                                fillColor:
                                                    MaterialStateProperty.all(
                                                        kPrimaryColor),
                                                value: true,
                                                shape: CircleBorder(),
                                                onChanged: (bool? value) {},
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(
                                          margin:
                                              EdgeInsets.symmetric(vertical: 5),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 10),
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: kColorSmoke
                                                      .withOpacity(.2),
                                                  spreadRadius: 5,
                                                  blurRadius: 7,
                                                  offset: Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                              color: kColorWhite,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  SvgPicture.asset(
                                                    "assets/svg/cashpayment.svg",
                                                  ),
                                                  SizedBox(
                                                    width: 3,
                                                  ),
                                                  Text(
                                                    "Cash/Card on Delivery",
                                                    style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: kColorBlack,
                                                    ),
                                                  ),

                                                  // SvgPicture.asset(
                                                  //   "assets/svg/tick3ple.svg",
                                                  // ),
                                                ],
                                              ),
                                              SvgPicture.asset(
                                                "assets/svg/tick3ple.svg",
                                              ),
                                            ],
                                          ),
                                        ),
                                  SizedBox(
                                    height: width / 1.3,
                                  ),
                                ],
                              )
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    color: Color(0xFFF8F5FC),
                    width: width,
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
                                width: 20,
                                height: 20,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Checkout",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Poppins",
                                  fontSize: 16,
                                  color: kColorBlack.withOpacity(.5)),
                            )
                          ],
                        ),
                      ],
                    ),
                  )),
              Visibility(
                visible: showUseAddressBtn,
                child: Positioned(
                  bottom: 5,
                  left: 10,
                  right: 10,
                  child: InkWell(
                    onTap: () {
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => Checkout()));
                    },
                    child: Container(
                      color: kColorWhite,
                      padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                      child: InkWell(
                        onTap: () {
                          bool selected = false;
                          for (var x in addressList) {
                            if (x.clicker) {
                              selected = true;
                            }
                          }
                          if (selected) {
                            selectShippingAddress(medShipAddrees);

                            print("Cool clicked");
                            print(medShipAddrees.stateId!);
                            print(medShipAddrees.lgaId!);
                            logisticsDelivery(
                                medShipAddrees.stateId!, medShipAddrees.lgaId!);
                          } else {
                            _showMessage("Select an address");
                          }
                          // onAddButtonTapped(pagerCurrentIndex + 1);
                          // setState(() {
                          //   showUseAddressBtn = false;
                          //   showProceedToPayment = true;
                          // });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: kPrimaryColor),
                          child: Center(
                            child: Text(
                              "USE THIS ADDRESS",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                                color: kColorWhite,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: showProceedToPayment,
                child: Positioned(
                  bottom: 0,
                  child: Container(
                    width: width,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    color: kColorWhite,
                    child: Column(
                      children: [
                        Divider(
                          height: 2,
                          color: kColorSmoke2,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Sub Total",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                                color: kColorSmoke2,
                                fontSize: 13,
                              ),
                            ),
                            SvgPicture.asset(
                              "assets/svg/elipse.svg",
                              color: kColorSmoke2,
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/svg/naira.svg",
                                  color: kColorSmoke2,
                                ),
                                Text(
                                  "${widget.total}",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    color: kColorSmoke2,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Delivery charges",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                                color: kColorSmoke2,
                                fontSize: 13,
                              ),
                            ),
                            SvgPicture.asset(
                              "assets/svg/elipse.svg",
                              color: kColorSmoke2,
                            ),
                            Text(
                              "Calculating \n charges",
                              style: ksmallTextBold(kColorSmoke2),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Divider(
                          height: 2,
                          color: kColorSmoke2,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: kColorBlack),
                            ),
                            SvgPicture.asset(
                              "assets/svg/elipse.svg",
                              color: kColorSmoke2,
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/svg/naira.svg",
                                  color: kPrimaryColor,
                                ),
                                Text(
                                  "${widget.total}",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    color: kPrimaryColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Add promocode at payments",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            color: kColorSmoke2,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        InkWell(
                          onTap: () {
                            if (deliveryFeeLoaded == false) {
                              _showMessage(
                                  "Delivery fee is not loaded, select a delivery option again");
                            } else {
                              onAddButtonTapped(pagerCurrentIndex + 1);
                              setState(() {
                                showProceedToPayment = false;
                                showSummary = true;
                              });
                            }

                            // onAddButtonTapped(pagerCurrentIndex + 1);
                            // setState(() {
                            //   showProceedToPayment = false;
                            //   showSummary = true;
                            // });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: kPrimaryColor),
                            child: Center(
                              child: Text(
                                "PROCEED TO PAYMENT",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: kColorWhite,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: showSummary,
                child: Positioned(
                  bottom: 0,
                  child: Container(
                    width: width,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    color: kColorWhite,
                    child: Column(
                      children: [
                        Divider(
                          height: 2,
                          color: kColorSmoke2,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Sub Total",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                                color: kColorSmoke2,
                                fontSize: 13,
                              ),
                            ),
                            SvgPicture.asset(
                              "assets/svg/elipse.svg",
                              color: kColorSmoke2,
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/svg/naira.svg",
                                  color: kColorSmoke2,
                                ),
                                Text(
                                  "${widget.total}",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    color: kColorSmoke2,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Delivery charges",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                                color: kColorSmoke2,
                                fontSize: 13,
                              ),
                            ),
                            SvgPicture.asset(
                              "assets/svg/elipse.svg",
                              color: kColorSmoke2,
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/svg/naira.svg",
                                  color: kColorSmoke2,
                                  width: 10,
                                  height: 10,
                                ),
                                Text(
                                  "$deliveryCharge",
                                  style: ksmallTextBold(kColorSmoke2),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Divider(
                          height: 2,
                          color: kColorSmoke2,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: kColorBlack),
                            ),
                            SvgPicture.asset(
                              "assets/svg/elipse.svg",
                              color: kColorSmoke2,
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/svg/naira.svg",
                                  color: kPrimaryColor,
                                ),
                                Text(
                                  "${widget.total + deliveryCharge}",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    color: kPrimaryColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Add promocode at payments",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            color: kColorSmoke2,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        InkWell(
                          onTap: () {
                            int counter = 0;
                            for (int i = 0;
                                i < paymentSelectionType.length;
                                i++) {
                              if (paymentSelectionType[i].clicked) {
                                counter++;
                              }
                            }
                            if (counter != 0) {
                              setState(() {
                                showConfirm = true;
                                showSummary = false;
                              });
                            } else {
                              _showMessage("Select a payment method.");
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: kPrimaryColor),
                            child: Center(
                              child: Text(
                                "SUMMARY",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: kColorWhite,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                  visible: showConfirm,
                  child: Positioned(
                    bottom: 15,
                    left: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        if (paymentSelectionType[0].clicked) {
                          double total = widget.total + deliveryCharge;
                          _makePayment(context, total);
                        } else {
                          paywithCashNow();
                        }
                      },
                      child: Container(
                        width: width,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: kPrimaryColor),
                        child: Center(
                          child: Text(
                            "Confirm",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              color: kColorWhite,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
              Visibility(
                visible: deliveryLoaded,
                child: Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          deliveryLoaded = false;
                        });
                      },
                      child: Container(
                        width: width,
                        height: height,
                        color: Color(0xFF000000).withOpacity(0.3),
                        child: Stack(
                          children: [
                            Positioned(
                              top: height * .3,
                              left: 50,
                              right: 50,
                              child: Container(
                                  width: width * .8,
                                  //color: kColorWhite,
                                  height: height * .6,
                                  decoration: BoxDecoration(
                                      color: kColorWhite,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: ListView(
                                    children: [
                                      Container(
                                          padding: EdgeInsets.only(
                                              left: 15,
                                              right: 5,
                                              top: 10,
                                              bottom: 10),
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: kColorSmoke
                                                      .withOpacity(.2),
                                                  spreadRadius: 5,
                                                  blurRadius: 7,
                                                  offset: Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                              color: kColorWhite,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Image.asset(
                                                  "assets/images/logistics.png"),
                                            ],
                                          )),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "  Select any preferable logistics service",
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: kColorBlack.withOpacity(.8)),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      ...logisticsList
                                          .map((e) => logisticsCustom(e)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  )),
                            ),
                          ],
                        ),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _makePayment(BuildContext context, double amount) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? email = sharedPreferences.getString("Email");
    String? lastname = sharedPreferences.getString("LastName");
    String? firstName = sharedPreferences.getString("FirstName");
    String? phone = sharedPreferences.getString("Phone");

    print(email);
    print(phone);
    print(firstName! + "" + lastname!);

    final style = FlutterwaveStyle(
        appBarText: "My Medicine Paymennt",
        buttonColor: kPrimaryColor,
        appBarIcon: Icon(Icons.message, color: Colors.white),
        buttonTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        appBarColor: kPrimaryColor,
        appBarTitleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
        dialogCancelTextStyle: TextStyle(
          color: Colors.redAccent,
          fontSize: 18,
        ),
        dialogContinueTextStyle: TextStyle(
          color: Colors.blue,
          fontSize: 18,
        ));

    final Customer customer = Customer(
        name: firstName + lastname, phoneNumber: phone!, email: email!);

    final Flutterwave flutterwave = Flutterwave(
      context: context,
      style: style,
      publicKey: pkKey,
      //publicKey: "FLWPUBK_TEST-a1337f7f72e762d0675f14339dfa8c20-X",
      currency: "NGN",
      txRef: _ref,
      amount: "$amount",
      customer: customer,
      paymentOptions: "ussd, card, barter, payattitude",
      customization: Customization(title: "Mymedicine Payment"),
      isTestMode: false,
    );

    final ChargeResponse response = await flutterwave.charge();
    if (response != null) {
      print(response.toJson());
      //print("Transaction failed");
      if (response.status == "success") {
        print(response.success);
        print("successful payment .............. .....");
        //_showMessage("Transaction was successful");
        completeOrder(_ref, 1);
      } else {
        //Transaction not successful
        print("Transaction not successful");
        _showMessage("Transaction was Unsuccessful");
      }
    }

    // const SK_KEY = "FLWSECK-53a18c18a24e922a6c2fbaf5b3f004fd-X";
    // const PK_KEY = "FLWPUBK-4b37f2395382eb74b60fee56155852bf-X";
    // const ENC_KEY = "53a18c18a24e9a41ed7a9647";
    //
    // final Flutterwave flutterwave = Flutterwave.forUIPayment(
    //     context: this.context,
    //     currency: FlutterwaveCurrency.NGN,
    //     amount: "$amount",
    //     encryptionKey: ENC_KEY,
    //     publicKey: "FLWPUBK-4b37f2395382eb74b60fee56155852bf-X",
    //     email: email!,
    //     fullName: firstName +  lastname,
    //     txRef: _ref,
    //     isDebugMode: false,
    //     phoneNumber: phone!,
    //     acceptCardPayment: true,
    //     acceptUSSDPayment: true,
    //     acceptAccountPayment: true,
    //     acceptFrancophoneMobileMoney: false,
    //     acceptGhanaPayment: false,
    //     acceptMpesaPayment: false,
    //     acceptRwandaMoneyPayment: true,
    //     acceptUgandaPayment: false,
    //     acceptZambiaPayment: false);
    //
    // try {
    //   final ChargeResponse response = await flutterwave.initializeForUiPayments();
    //   if (response == null) {
    //     // user didn't complete the transaction.
    //   } else {
    //     final isSuccessful = checkPaymentIsSuccessful(response,amount,_ref,"NGN");
    //     if (isSuccessful) {
    //       // provide value to customer
    //       print("successful payment .............. .....");
    //       _showMessage("Transaction was successful ooooo");
    //       completeOrder(_ref,1);
    //     } else {
    //       // check message
    //       print(response.message);
    //
    //       // check status
    //       print(response.status);
    //       print("Transaction not successful");
    //       _showMessage("Transaction was Unsuccessful");
    //       // check processor error
    //       print(response.data!.processorResponse);
    //     }
    //   }
    // } catch (error, stacktrace) {
    //   print("Transaction not successful .... errror ${error.toString()}");
    // }
  }

  // bool checkPaymentIsSuccessful(final ChargeResponse response,amount,txref,currency) {
  //   return response.data!.status == FlutterwaveConstants.SUCCESSFUL &&
  //       response.data!.currency == currency &&
  //       response.data!.amount == amount &&
  //       response.data!.txRef == txref;
  // }

  Widget logisticsCustom(LogisticsDelivery delivery) {
    return Container(
      child: Column(
        children: [
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Checkbox(
                value: delivery.isClicked,
                onChanged: (value) async {
                  setState(() {
                    deliveryCharge = delivery.fee!;
                    deliveryId = delivery.logisticsDeliveryOptionId!;
                    logisticsList[logisticsList.indexOf(delivery)].isClicked =
                        !logisticsList[logisticsList.indexOf(delivery)]
                            .isClicked!;
                  });
                },
              ),
              Image.network(
                "https://image.shutterstock.com/image-vector/gig-tie-logo-icon-design-260nw-1978485320.jpg",
                width: 70,
                height: 80,
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/svg/naira.svg",
                    width: 10,
                    height: 10,
                  ),
                  Text(delivery.fee.toString(),
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                        color: kColorBlack,
                        fontSize: 13,
                      )),
                ],
              ),
            ],
          ),
          Divider(
            color: kColorSmoke2,
            height: 1,
          )
        ],
      ),
    );
  }

  Widget customCards(AllMyCards cards) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      //padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: kColorWhite,
        boxShadow: [
          BoxShadow(
            color: kColorSmoke.withOpacity(.4),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin: EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: Color(0xFFF5F6F5),
              borderRadius: BorderRadius.circular(30),
            ),
            child: SvgPicture.asset(
              cards.asset,
              width: 15,
              height: 15,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text("******** ***** **** " + cards.lastDigit,
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w400,
                  color: kColorBlack,
                  fontSize: 14,
                )),
          ),
          Checkbox(
            checkColor: Colors.white,
            fillColor: MaterialStateProperty.all(kPrimaryColor),
            value: cards.clicked,
            shape: CircleBorder(),
            onChanged: (bool? value) {
              for (var x in cardSelector) {
                x.clicked = false;
              }
              setState(() {
                cardSelector[cardSelector.indexOf(cards)].clicked =
                    !cardSelector[cardSelector.indexOf(cards)].clicked;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget customAddress(MedShipAddrees address) {
    print("Check it out now ..... address 1");
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: kColorWhite,
          boxShadow: [
            BoxShadow(
              color: kColorSmoke.withOpacity(.4),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/svg/location.svg",
                      width: 15,
                      height: 20,
                      color: kColorSmoke2,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                        address.firstName != null && address.lastName != null
                            ? address.firstName! + " " + address.lastName!
                            : "",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                          color: kColorBlack,
                          fontSize: 13,
                        )),
                  ],
                ),
                Checkbox(
                  checkColor: Colors.white,
                  fillColor: MaterialStateProperty.all(kPrimaryColor),
                  value: address.clicker,
                  shape: CircleBorder(),
                  onChanged: (bool? value) {
                    for (var x in addressList) {
                      x.clicker = false;
                    }
                    setState(() {
                      medShipAddrees = address;
                      addressList[addressList.indexOf(address)].clicker =
                          !addressList[addressList.indexOf(address)].clicker;
                    });
                  },
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 30,
                ),
                Text(
                  address.street != null
                      ? address.street! + ", " + address.city!
                      : "",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w400,
                    color: kColorSmoke2,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    Text(address.state != null ? address.state! : "",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                          color: kColorSmoke2,
                          fontSize: 13,
                        )),
                  ],
                ),
                // SvgPicture.asset(
                //   "assets/svg/cart_delete.svg",
                //   width: 7,
                //   height: 15,
                // ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 30,
                ),
                Text(address.phoneNumber != null ? address.phoneNumber! : "",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400,
                      color: kColorSmoke2,
                      fontSize: 13,
                    )),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                SizedBox(
                  width: 30,
                ),
                Text(address.emailAddress != null ? address.emailAddress! : "",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400,
                      color: kColorSmoke2,
                      fontSize: 13,
                    )),
              ],
            ),
            address.isDefault!
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Default address",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                          color: kPrimaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  )
                : Center()
          ],
        ));
  }

  Widget customAddress2(MedShipAddrees address) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: kColorWhite,
          boxShadow: [
            BoxShadow(
              color: kColorSmoke.withOpacity(.4),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/svg/location.svg",
                      width: 15,
                      height: 20,
                      color: kColorSmoke2,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                        address.firstName != null && address.lastName != null
                            ? address.firstName! + " " + address.lastName!
                            : "",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                          color: kColorBlack,
                          fontSize: 13,
                        )),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 30,
                ),
                Text(
                  address.street != null
                      ? address.street! + ", " + address.city!
                      : "",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w400,
                    color: kColorSmoke2,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    Text(address.state != null ? address.state! : "",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                          color: kColorSmoke2,
                          fontSize: 13,
                        )),
                  ],
                ),
                // SvgPicture.asset(
                //   "assets/svg/cart_delete.svg",
                //   width: 7,
                //   height: 15,
                // ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 30,
                ),
                Text(address.phoneNumber != null ? address.phoneNumber! : "",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400,
                      color: kColorSmoke2,
                      fontSize: 13,
                    )),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                SizedBox(
                  width: 30,
                ),
                Text(address.emailAddress != null ? address.emailAddress! : "",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400,
                      color: kColorSmoke2,
                      fontSize: 13,
                    )),
              ],
            ),
            address.isDefault!
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Default address",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                          color: kPrimaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  )
                : Center()
          ],
        ));
  }

  ExpansionPanel customExtension(double width) {
    return ExpansionPanel(
      canTapOnHeader: true,
      //hasIcon: false,
      isExpanded: checker,
      headerBuilder: (context, isOpen) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: kColorSmoke.withOpacity(.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ], color: kColorWhite, borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order Summary",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: kColorBlack,
                ),
              ),
              checker ? Icon(Icons.remove) : Icon(Icons.add)
            ],
          ),
        );
      },
      body: Container(
        width: width,
        padding: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[...widget.items.map((e) => cartCustom(e))],
        ),
      ),
    );
  }

  ExpansionPanel flutterWavePaymentCustom(double width) {
    return ExpansionPanel(
      canTapOnHeader: false,
      //hasIcon: false,
      //isExpanded: paymentSelectionType[0].clicked,
      headerBuilder: (context, isOpen) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 15),
          padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: kColorSmoke.withOpacity(.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ], color: kColorWhite, borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.all(kPrimaryColor),
                    value: paymentSelectionType[0].clicked,
                    shape: CircleBorder(),
                    onChanged: (bool? value) {
                      for (var x in paymentSelectionType) {
                        x.clicked = false;
                      }
                      setState(() {
                        paymentSelectionType[0].clicked =
                            !paymentSelectionType[0].clicked;
                      });
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Image.asset(
                    "assets/images/flutterwave_logo.png",
                    width: 50,
                    height: 70,
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    "Pay with FlutterWave",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: kColorBlack,
                    ),
                  ),
                ],
              ),
              paymentSelectionType[0].clicked
                  ? Icon(Icons.remove)
                  : Icon(Icons.add)
            ],
          ),
        );
      },
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: kColorSmoke.withOpacity(.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ], color: Color(0xFFFFECFD), borderRadius: BorderRadius.circular(5)),
        child: Text(""),
      ),
    );
  }

  ExpansionPanel cardPaymentCustom(double width) {
    return ExpansionPanel(
      canTapOnHeader: true,
      //hasIcon: false,
      //isExpanded: paymentSelectionType[2].clicked,
      headerBuilder: (context, isOpen) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 15),
          padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: kColorSmoke.withOpacity(.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ], color: kColorWhite, borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.all(kPrimaryColor),
                    value: paymentSelectionType[2].clicked,
                    shape: CircleBorder(),
                    onChanged: (bool? value) {
                      for (var x in paymentSelectionType) {
                        x.clicked = false;
                      }
                      setState(() {
                        paymentSelectionType[2].clicked =
                            !paymentSelectionType[2].clicked;
                      });
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SvgPicture.asset("assets/svg/cardpayment.svg"),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    "Card Transactions",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: kColorBlack,
                    ),
                  ),
                ],
              ),
              paymentSelectionType[2].clicked
                  ? Icon(Icons.remove)
                  : Icon(Icons.add)
            ],
          ),
        );
      },
      body: Container(
        width: width,
        padding: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
            color: Color(0xFFF0F2F5),
            boxShadow: [
              BoxShadow(
                color: kColorWhite,
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ...cardSelector.map((e) => customCards(e)),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  ExpansionPanel cashOnDeliveryPaymentCustom(double width) {
    return ExpansionPanel(
      canTapOnHeader: false,
      //hasIcon: false,
      isExpanded: paymentSelectionType[1].clicked,
      headerBuilder: (context, isOpen) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 15),
          padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: kColorSmoke.withOpacity(.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ], color: kColorWhite, borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.all(kPrimaryColor),
                    value: paymentSelectionType[1].clicked,
                    shape: CircleBorder(),
                    onChanged: (bool? value) {
                      for (var x in paymentSelectionType) {
                        x.clicked = false;
                      }
                      setState(() {
                        paymentSelectionType[1].clicked =
                            !paymentSelectionType[1].clicked;
                      });
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SvgPicture.asset("assets/svg/cashpayment.svg"),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    "Cash on Delivery",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: kColorBlack,
                    ),
                  ),
                ],
              ),
              paymentSelectionType[1].clicked
                  ? Icon(Icons.remove)
                  : Icon(Icons.add)
            ],
          ),
        );
      },
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: kColorSmoke.withOpacity(.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ], color: Color(0xFFFFECFD), borderRadius: BorderRadius.circular(5)),
        child: Text(
          "Hi ${Provider.of<ServiceClass>(context).MedUsers.firstName}, you are to make payment before opening package.",
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w400,
            color: Color(0xFFC926B4),
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  ExpansionPanel walletPaymentCustom(double width) {
    return ExpansionPanel(
      canTapOnHeader: true,
      //hasIcon: false,
      //isExpanded: paymentSelectionType[3].clicked,
      headerBuilder: (context, isOpen) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 15),
          padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: kColorSmoke.withOpacity(.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ], color: kColorWhite, borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.all(kPrimaryColor),
                    value: paymentSelectionType[3].clicked,
                    shape: CircleBorder(),
                    onChanged: (bool? value) {
                      for (var x in paymentSelectionType) {
                        x.clicked = false;
                      }
                      setState(() {
                        paymentSelectionType[3].clicked =
                            !paymentSelectionType[3].clicked;
                      });
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SvgPicture.asset("assets/svg/walletpayment.svg"),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    "myMedicine Wallet",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: kColorBlack,
                    ),
                  ),
                ],
              ),
              paymentSelectionType[3].clicked
                  ? Icon(Icons.remove)
                  : Icon(Icons.add)
            ],
          ),
        );
      },
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: kColorSmoke.withOpacity(.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ], color: Color(0xFFFFECFD), borderRadius: BorderRadius.circular(5)),
        child: Text(""),
      ),
    );
  }

  ExpansionPanel cashPaymentCustom(double width) {
    return ExpansionPanel(
      canTapOnHeader: true,
      //hasIcon: false,
      //isExpanded: paymentSelectionType[4].clicked,
      headerBuilder: (context, isOpen) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 15),
          padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: kColorSmoke.withOpacity(.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ], color: kColorWhite, borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.all(kPrimaryColor),
                    value: paymentSelectionType[4].clicked,
                    shape: CircleBorder(),
                    onChanged: (bool? value) {
                      for (var x in paymentSelectionType) {
                        x.clicked = false;
                      }
                      setState(() {
                        paymentSelectionType[4].clicked =
                            !paymentSelectionType[4].clicked;
                      });
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SvgPicture.asset("assets/svg/banktransfer.svg"),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    "Bank Transfer",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: kColorBlack,
                    ),
                  ),
                ],
              ),
              paymentSelectionType[4].clicked
                  ? Icon(Icons.remove)
                  : Icon(Icons.add)
            ],
          ),
        );
      },
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: kColorSmoke.withOpacity(.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ], color: Color(0xFFFFECFD), borderRadius: BorderRadius.circular(5)),
        child: Text(""),
      ),
    );
  }

  Widget cartCustom(CartItems cartModel) => Container(
        margin: EdgeInsets.symmetric(vertical: 10),
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
          color: kColorWhite,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [],
            ),
            SizedBox(
              width: 10,
            ),
            Container(
                constraints: BoxConstraints(
                  maxWidth: 100,
                  maxHeight: 100,
                ),
                child: Image.network(cartModel.imageUrl!)),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${cartModel.productName!}",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: kColorBlack),
                ),
                Row(
                  children: [
                    Text(
                      " N " + cartModel.minUnitPrice!.toString(),
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 9,
                          fontWeight: FontWeight.w400,
                          color: kPrimaryColor),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      "Quantity",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 9,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                    SizedBox(
                      width: 10,
                    ),
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
                    SizedBox(
                      width: 15,
                    ),
                    SvgPicture.asset(
                      "assets/svg/cart_delete.svg",
                      color: Color(0xFFAF1302),
                      width: 12,
                      height: 15,
                    ),
                  ],
                ),
              ],
            ))
          ],
        ),
      );

  void viewShipmentAddress() {
    print("We are In now...");
    ServiceClass serviceClass = ServiceClass();
    serviceClass.viewShipmentAddresses().then((value) => output(value));
    serviceClass.getDeliveryType().then((value) => outputDeliveryType(value));
  }

  void logisticsDelivery(int stateId, int lgaID) {
    print("Logistics delivery guys ........");
    ServiceClass serviceClass = ServiceClass();
    serviceClass
        .logisticsDeliveryGet(stateId, lgaID)
        .then((value) => outputLogistics(value));
  }

  void completeOrder(String ref, int paymentProviderID) {
    Provider.of<ServiceClass>(context, listen: false).increaseCart();
    print("We are In completeOrder...");
    ServiceClass serviceClass = ServiceClass();
    serviceClass
        .completeOrder(
            widget.uniqueSalesOrderId, ref, widget.total, paymentProviderID, 1)
        .then((value) => orderOutput(value));
  }

  void paywithCashNow() {
    Provider.of<ServiceClass>(context, listen: false).increaseCart();
    print("We are In cash completeOrder...");
    ServiceClass serviceClass = ServiceClass();
    serviceClass
        .completeCashOrder(widget.salesOrderId)
        .then((value) => cashOrderOutput(value));
  }

  void applyPromocode(int salesOrderId, String code) {
    print("We are In promocode...");
    ServiceClass serviceClass = ServiceClass();
    serviceClass
        .applyPromoCode(salesOrderId, code)
        .then((value) => promoCodeOutput(value));
  }

  void selectShippingAddress(MedShipAddrees address) {
    print("We are In select shipment order...");
    ServiceClass serviceClass = ServiceClass();
    serviceClass
        .selectShippingAddress(address, widget.salesOrderId)
        .then((value) => shipmentOutput(value));
  }

  void output(String body) {
    print("We are In second haven now...");
    print(body);
    if (body.contains("Network Error")) {
      _showMessage("Network Error");
    } else {
      print("This the body");
      print(body);
      var data = jsonDecode(body);
      //_showMessage(bodyT["message"]);
      dynamic value = data["data"]["value"];
      print("Addresses");
      setState(() {
        addressLoaded = true;
        addressList = value
            .map<MedShipAddrees>((element) => MedShipAddrees.fromJson(element))
            .toList();
      });
    }
  }

  void promoCodeOutput(String body) {
    print("We are In promoCodeOutput now...");
    print(body);
    if (body.contains("Network Error")) {
      _showMessage("Network Error");
    } else {
      print("This the body");
      print(body);
      var data = jsonDecode(body);
      _showMessage(data["message"]);
      if (data["status"] != "Failed") {
        var dynamic = data["data"];
      }
    }
  }

  void outputDeliveryType(String body) {
    print("We are In second haven now...");
    print(body);
    if (body.contains("Network Error")) {
      //_showMessage("Network Error");
    } else {
      print("This the body");
      print(body);
      var data = jsonDecode(body);
      dynamic value = data["data"];
      print("Addresses");
      setState(() {
        deliverySelectList = value
            .map<DeliveryType>((element) => DeliveryType.fromJson(element))
            .toList();
      });
    }
  }

  void getShipmentFee() {
    print("We are In select shipment order...");
    ServiceClass serviceClass = ServiceClass();
    serviceClass
        .getShipmentFee(widget.salesOrderId, 4)
        .then((value) => shipmentFeeOutput(value));
  }

  void shipmentFeeOutput(String body) {
    print("We are in select shipment address  output now...");
    print(body);
    if (body.contains("Network Error")) {
      _showMessage("Network Error");
    } else {
      var data = jsonDecode(body);
      if (data["status"] == "Successful") {
        dynamic fee = data["data"]["deliveryFee"];

        print("This the fee $fee");
        setState(() {
          deliveryCharge = double.parse(fee.toString());
          deliveryFeeLoaded = true;
        });
      }
    }
  }

  void shipmentOutput(String body) {
    print("We are in select shipment address  output now...");
    print(body);
    if (body.contains("Network Error")) {
      _showMessage("Network Error");
    } else {
      print("This the body");
      print(body);
      onAddButtonTapped(pagerCurrentIndex + 1);
      setState(() {
        showUseAddressBtn = false;
        showProceedToPayment = true;
      });
    }
  }

  void createAddress() {
    print("We are In now...");
    ServiceClass serviceClass = ServiceClass();

    int CID = Provider.of<ServiceClass>(context, listen: false).CountryId;
    int StateID = Provider.of<ServiceClass>(context, listen: false).StateId;
    int LGaID = Provider.of<ServiceClass>(context, listen: false).LGAID;
    String firstName =
        Provider.of<ServiceClass>(context, listen: false).MedUsers.lastName;
    String lastName =
        Provider.of<ServiceClass>(context, listen: false).MedUsers.lastName;
    serviceClass
        .createShipmentAddress(LGaID, StateID, CID, streetC.text, regionC.text,
            firstName, lastName, toggleStatus, emailEditC.text, phoneEditC.text)
        .then((value) => createAddressOutput(value));
  }

  void createAddressOutput(String body) {
    setState(() {
      createAddressLoading = false;
    });

    print("We are In second haven now...");
    print(body);
    if (body.contains("Network Error")) {
      _showMessage("Network Error");
    } else {
      var bodyT = jsonDecode(body);
      if (bodyT["status"] == "Successful") {
        print("This the body");
        print(body);
        // _showMessage(bodyT["message"]);
        streetC.text = "";
        regionC.text = "";
        emailEditC.text = "";
        phoneEditC.text = "";
        addressList.clear();
        viewShipmentAddress();

        // set up the button
        Widget okButton = TextButton(
          child: Text("Okay"),
          onPressed: () {
            Navigator.pop(context);
          },
        );
        // set up the AlertDialog
        AlertDialog alert = AlertDialog(
          title: Text("Successful!"),
          content: Text("Address added successfully"),
          actions: [
            okButton,
          ],
        );

        // show the dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      }
    }
  }

  void outputLogistics(String body) {
    print("We are logistics output now for me now...");
    print(body);
    if (body.contains("Network Error")) {
      _showMessage("Network Error");
    } else {
      print("This the body of our logistics now...");
      print(body);
      var data = jsonDecode(body);
      if (data["status"] == "Successful") {
        dynamic value = data["data"];
        print("Addresses");
        //print()
        setState(() {
          logisticsList = value
              .map<LogisticsDelivery>(
                  (element) => LogisticsDelivery.fromJson(element))
              .toList();
        });
      } else {}
    }
  }

  void orderOutput(String body) {
    print("We are In second haven now...");
    print(body);
    if (body.contains("Network Error")) {
      _showMessage("Network Error");
    } else {
      print("This the body");
      print(body);
      var data = jsonDecode(body);
      if (data["status"] == "Successful") {
        //Provider.of<ServiceClass>(context, listen: false).increaseCart();
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OrderComplete(widget.uniqueSalesOrderId)));
      }
    }
  }

  void cashOrderOutput(String body) {
    print("We are In 24th haven now...");
    print(body);
    if (body.contains("Network Error")) {
      _showMessage("Network Error");
    } else {
      print("This the body");
      print(body);
      var data = jsonDecode(body);
      if (data["status"] == "Successful") {
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OrderComplete2(widget.uniqueSalesOrderId)));
      }
    }
  }

  _showMessage(String message,
      [Duration duration = const Duration(seconds: 10)]) {
    _scaffoldKey.currentState!.showSnackBar(SnackBar(
      content: Text(message),
      duration: duration,
      action: SnackBarAction(
          label: 'CLOSE',
          onPressed: () => _scaffoldKey.currentState!.removeCurrentSnackBar()),
    ));
  }
}

class DeliveryType {
  bool clicked = false;
  String name;
  int id;

  DeliveryType({required this.id, required this.name});

  factory DeliveryType.fromJson(Map<String, dynamic> json) {
    return DeliveryType(
      id: json['typeId'],
      name: json['name'],
    );
  }
}

class PaymentType {
  bool clicked = false;
  String name;

  PaymentType(this.name, this.clicked);
}

class AllMyCards {
  bool clicked = false;
  String lastDigit;
  String asset;

  AllMyCards(this.lastDigit, this.clicked, this.asset);
}
