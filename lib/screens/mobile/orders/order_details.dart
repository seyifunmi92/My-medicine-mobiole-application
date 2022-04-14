import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:mymedicinemobile/constants.dart';
import 'package:mymedicinemobile/models/models.dart';
import 'package:mymedicinemobile/reusables/bars.dart';
import 'package:mymedicinemobile/screens/mobile/cart/cart.dart';
import 'package:mymedicinemobile/screens/mobile/medicine_refill/medicine_refill.dart';
import 'package:mymedicinemobile/screens/mobile/orders/request_return.dart';
import 'package:mymedicinemobile/services/services.dart';
import 'package:mymedicinemobile/text_style.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:timeline_tile/timeline_tile.dart';
import 'package:mymedicinemobile/models/models.dart';

class OrderDetails extends StatefulWidget {
  //int OrderID;
  OrderData orderData;

  OrderDetails(this.orderData, {Key? key}) : super(key: key);

  @override
  _OrderDetails createState() => _OrderDetails();
}

class _OrderDetails extends State<OrderDetails>
    with SingleTickerProviderStateMixin {
  bool toggleStatus = true;
  late OrderDataDetails2? OrderDataDetails = null;
  late List<OrderItems> orderItems = [];
  List<OrderHistory> history = [];
  late OrderData orderData;
  bool loading = true;
  bool showAdded = false;
  late AnimationController _animationController;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isChecked = false;
  bool showRateItem = false;
  TextEditingController rateComment = new TextEditingController();
  int selectedRating = 0;
  int selectedProductId = 0;
  bool rateLoading = false;

  List<SmileySelect> smileList = [
    SmileySelect(
        Icon(
          Icons.emoji_emotions_sharp,
          color: kColorSmoke,
          size: 40,
        ),
        false,
        1),
    SmileySelect(
        Icon(
          Icons.emoji_emotions_sharp,
          color: kColorSmoke,
          size: 40,
        ),
        false,
        2),
    SmileySelect(
        Icon(
          Icons.emoji_emotions_sharp,
          color: kColorSmoke,
          size: 40,
        ),
        false,
        3),
    SmileySelect(
        Icon(
          Icons.emoji_emotions_sharp,
          color: kColorSmoke,
          size: 40,
        ),
        false,
        4),
    SmileySelect(
        Icon(
          Icons.emoji_emotions_sharp,
          color: kColorSmoke,
          size: 40,
        ),
        false,
        5),
  ];

  _showMessage(String message,
      [Duration duration = const Duration(seconds: 4)]) {
    _scaffoldKey.currentState!.showSnackBar(SnackBar(
      content:  Text(message),
      duration: duration,
      action:  SnackBarAction(
          label: 'CLOSE',
          onPressed: () => _scaffoldKey.currentState!.removeCurrentSnackBar()),
    ));
  }
  @override
  void initState() {
    // TODO: implement initState
    orderData = widget.orderData;
    _animationController = AnimationController(
      vsync: this,
      duration:  Duration(seconds: 2),
    );
    _animationController.repeat();
    viewProductByID(widget.orderData.salesOrderId!);
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var formatter = NumberFormat('#,###,000');
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kColorWhite,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: width,
              height: height,
              child: Column(
                children: [
                  navBarSearchCustom("Order Details", context, Cart(), true),
                  const SizedBox(
                    height: 10,
                  ),
                  loading == true
                      ? Center()
                      : Container(
                          height: height * .83,
                          width: MediaQuery.of(context).size.width,
                          padding:
                              const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
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
                          child: ListView(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 5),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 25, horizontal: 5),
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
                                    borderRadius: BorderRadius.circular(5)),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Order number: ",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: kColorSmoke2),
                                        ),
                                        Text(
                                          OrderDataDetails == null
                                              ? ""
                                              : OrderDataDetails!.salesOrderId
                                                  .toString(),
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  kColorBlack.withOpacity(.8)),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          orderItems.isNotEmpty
                                              ? "${orderItems.length} items Placed: "
                                              : "0 items Placed: ",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: kColorSmoke2),
                                        ),
                                        Text(
                                          "On " +
                                              OrderDataDetails!.orderDate!
                                                  .split("T")[0],
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  kColorBlack.withOpacity(.8)),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Total amount: ",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: kColorSmoke2),
                                        ),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              "assets/svg/naira.svg",
                                              width: 10,
                                              height: 10,
                                              color: kColorBlack,
                                            ),
                                            Text(
                                              "${formatter.format(OrderDataDetails!.subTotal!)}",
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: kColorBlack
                                                      .withOpacity(.8)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ExpansionPanelList(
                                children: [
                                  ...orderItems
                                      .map((e) => customExtension(e, width))
                                ],
                                dividerColor: Colors.white,
                                expansionCallback: (i, isOpen) {
                                  setState(() {
                                    orderItems[i].isChecked =
                                        !orderItems[i].isChecked;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 5),
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
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "PRESCRIPTION ATTACHED",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: kColorBlack),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Divider(
                                      height: 1,
                                      color: kColorSmoke,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      //mainAxisAlignment: MainAxisAlignment.spac,
                                      children: [
                                        OrderDataDetails!
                                            .uploadPrescriptionUrl !=
                                            null
                                            ?
                                        // SvgPicture.asset(
                                        //     "assets/svg/check_primary.svg"),
                                        Container(
                                          width:width * .3,
                                          constraints: BoxConstraints(
                                            maxHeight: height * 200,
                                          ),
                                          child: Image.network(OrderDataDetails!
                                              .uploadPrescriptionUrl!,fit: BoxFit.cover,),
                                        )
                                            : const Text(""),
                                        // Image.asset(
                                        //   "assets/images/prescription2.png",
                                        //   fit: BoxFit.contain,
                                        // ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Row(
                                          children: [

                                                SvgPicture.asset(
                                                    "assets/svg/check_primary.svg"),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Prescription Approved",
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: kPrimaryColor),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 5),
                                padding: EdgeInsets.symmetric(
                                    vertical: 25, horizontal: 10),
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
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Payment Summary",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: kColorBlack),
                                        ),
                                        SvgPicture.asset(
                                          "assets/svg/shuffler.svg",
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Divider(
                                      height: 1,
                                      color: kColorSmoke,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Mode of Payment",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: kColorBlack),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "${OrderDataDetails!.paymentMethod}",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: kColorSmoke2),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Divider(
                                      height: 1,
                                      color: kColorSmoke,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Payment Details",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: kColorBlack),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Sub Total: ",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: kColorSmoke2),
                                        ),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              "assets/svg/naira.svg",
                                            ),
                                            Text(
                                              "${formatter.format(OrderDataDetails!.subTotal)}",
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: kColorBlack),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Delivery Charges: ",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: kColorSmoke2),
                                        ),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              "assets/svg/naira.svg",
                                            ),
                                            Text(
                                              "${formatter.format(OrderDataDetails!.deliveryCharge)}",
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                  color: kColorBlack),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Total: ",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: kColorSmoke2),
                                        ),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              "assets/svg/naira.svg",
                                            ),
                                            Text(
                                              "${formatter.format(OrderDataDetails!.subTotal! + OrderDataDetails!.deliveryCharge!)}",
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                  color: kColorBlack),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 5),
                                padding: EdgeInsets.symmetric(
                                    vertical: 25, horizontal: 10),
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
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Delivery Information",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: kColorBlack),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    //Divider(height: 1,color: kColorSmoke,),
                                    SizedBox(
                                      height: 20,
                                    ),

                                    Text(
                                      "Delivery Method",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: kColorBlack),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "${OrderDataDetails!.logisticDeliveryType}",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: kColorSmoke2),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Divider(
                                      height: 1,
                                      color: kColorSmoke,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),

                                    Text(
                                      "Delivery Address",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: kColorBlack),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    // Text(
                                    //   "${OrderDataDetails!.}",
                                    //   style: TextStyle(
                                    //       fontFamily: "Poppins",
                                    //       fontSize: 12,
                                    //       fontWeight: FontWeight.w400,
                                    //       color: kColorSmoke2),
                                    // ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      "${OrderDataDetails!.streetNumber}, ${OrderDataDetails!.street}",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: kColorSmoke2),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      "${OrderDataDetails!.lga}, ${OrderDataDetails!.state}",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: kColorSmoke2),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    // Text(
                                    //   "+234 893465769",
                                    //   style: TextStyle(
                                    //       fontFamily: "Poppins",
                                    //       fontSize: 12,
                                    //       fontWeight: FontWeight.w400,
                                    //       color: kColorSmoke2),
                                    // ),
                                    //
                                    // SizedBox(height: 2,),
                                    // Text(
                                    //   "ssanator@yahoo.co.uk",
                                    //   style: TextStyle(
                                    //       fontFamily: "Poppins",
                                    //       fontSize: 12,
                                    //       fontWeight: FontWeight.w400,
                                    //       color: kColorSmoke2),
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                ],
              ),
            ),
            Visibility(
              visible: loading,
              child: Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: width,
                    height: height,
                    color: Color(0xFF000000).withOpacity(0.3),
                    child: Stack(
                      children: [
                        Positioned(
                          top: height * .4,
                          left: 50,
                          right: 50,
                          child: Container(
                              width: 100,
                              decoration: BoxDecoration(
                                  //color: kColorWhite,
                                  borderRadius: BorderRadius.circular(5)),
                              child: AnimatedBuilder(
                                animation: _animationController,
                                builder: (context, child) {
                                  return Transform.rotate(
                                    angle: _animationController.value * 2 * pi,
                                    child: child,
                                  );
                                },
                                child: Image.asset(
                                  "assets/images/newlogo.png",
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.contain,
                                ),
                              )),
                        ),
                      ],
                    ),
                  )),
            ),
            Visibility(
              visible: showRateItem,
              child: ListView(
                children: [
                  Container(
                    width: width,
                    height: height,
                    color: Color(0xFF000000).withOpacity(0.3),
                    child: Container(
                      width: width * .95,
                      height: height * .8,
                      decoration: BoxDecoration(
                          color: kColorWhite,
                          borderRadius: BorderRadius.circular(5)),
                      child: ListView(
                        children: [
                          Card(
                            elevation: 5,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Rate Product",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: kColorBlack),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        showRateItem = false;
                                      });
                                    },
                                    child: Text(
                                      "close",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: kPrimaryColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Card(
                            elevation: 5,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Tell us how you feel about our product",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: kColorBlack),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ...smileList.map((e) => InkWell(
                                            onTap: () {
                                              int index = smileList.indexOf(e);
                                              for (int i = 0;
                                                  i < smileList.length;
                                                  i++) {
                                                smileList[i].selected = false;
                                              }
                                              setState(() {
                                                smileList[index].selected =
                                                    true;
                                                selectedRating =
                                                    smileList[index].rating;
                                              });
                                            },
                                            child: Icon(
                                              e.icon.icon,
                                              color: e.selected
                                                  ? Colors.yellow
                                                  : kColorSmoke,
                                              size: 40,
                                            ),
                                          ))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Text(
                              "Kindly give us more details",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: kColorBlack),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                color: kColorWhite,
                                border: Border.all(
                                    color: kColorSmoke,
                                    width: 1.0,
                                    style: BorderStyle.solid)),
                            height: 120,
                            child: TextField(
                              onChanged: (text) {},
                              controller: rateComment,
                              cursorColor: kPrimaryColor,
                              style: ksmallTextBold(kColorBlack),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "Enter comment",
                                hintStyle: ksmallTextBold(kColorSmoke),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          rateLoading
                              ? Container(
                                  width: 100,
                                  height: 100,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 20,
                                    ),
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    if (selectedRating == 0) {
                                      _showMessage("Pick a rating");
                                    } else {
                                      setState(() {
                                        rateLoading = true;
                                      });
                                      postReview(
                                          selectedRating,
                                          rateComment.text.trim(),
                                          selectedProductId);
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration:
                                          BoxDecoration(color: kPrimaryColor),
                                      child: Text(
                                        "Submit Rating",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            color: kColorWhite),
                                      ),
                                    ),
                                  ),
                                )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _displayDialog(BuildContext context, int productId) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Refill Medicine!'),
            content: Container(
              height: 300,
              width: 400,
              child: ListView(
                children: [
                  Card(
                    elevation: 5,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Rate Product",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: kColorBlack),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                showRateItem = false;
                              });
                            },
                            child: Text(
                              "cancel",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: kPrimaryColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    elevation: 5,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Tell us how you feel about our product",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: kColorBlack),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ...smileList.map((e) => InkWell(
                                    onTap: () {
                                      int index = smileList.indexOf(e);
                                      for (int i = 0;
                                          i < smileList.length;
                                          i++) {
                                        smileList[i].selected = false;
                                      }
                                      setState(() {
                                        smileList[index].selected = true;
                                        selectedRating =
                                            smileList[index].rating;
                                      });
                                    },
                                    child: Icon(
                                      e.icon.icon,
                                      color: e.selected
                                          ? Colors.yellow
                                          : kColorSmoke,
                                      size: 40,
                                    ),
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(
                      "Kindly give us more details",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        color: kColorWhite,
                        border: Border.all(
                            color: kColorSmoke,
                            width: 1.0,
                            style: BorderStyle.solid)),
                    height: 120,
                    child: TextField(
                      onChanged: (text) {},
                      controller: rateComment,
                      cursorColor: kPrimaryColor,
                      style: ksmallTextBold(kColorBlack),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "Enter comment",
                        hintStyle: ksmallTextBold(kColorSmoke),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  InkWell(
                    onTap: () {
                      if (selectedRating == 0) {
                        _showMessage("Pick a rating");
                      } else {
                        postReview(
                            selectedRating, rateComment.text.trim(), productId);
                      }
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(color: kPrimaryColor),
                        child: Text(
                          "Submit Rating",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: kColorWhite),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop();
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

  Widget customMedia(OrderModel cartModel) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      padding: EdgeInsets.symmetric(vertical: 25, horizontal: 5),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: kColorSmoke.withOpacity(.2),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ], color: kColorWhite, borderRadius: BorderRadius.circular(20)),
      child: Column(
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
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
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
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    decoration: BoxDecoration(
                        color: Color(0xFF8E8E93),
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: Text(
                        cartModel.orderStatus,
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: kColorWhite),
                      ),
                    ),
                  ),
                  Text(
                    cartModel.orderStatus.contains("CLOSED")
                        ? ""
                        : "On 10/12/2021",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: kColorSmoke2),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  ExpansionPanel customExtension(OrderItems orderItem, double width) {
    String date = "", activity = "";
    String timer = "";
    print("Kringe ..........");
    var now = DateTime.now();
    print(DateFormat().format(now));

    //November 4, 2021 6:36:42 AM
    if (history.isNotEmpty) {
      activity = history[0].activity;
      print("Lag");
      print(history.length);
      String x = DateFormat().format(DateTime.parse(history[0].activityDate));
      print(x);
      print(x.split(", ")[1]);
      String f = x.split(", ")[0];
      String datex = f.split(" ")[1];
      String l = x.split(", ")[1];
      print(f.substring(0, 4));
      print(x.split(", ")[0].substring(0, 3) +
          " " +
          datex +
          "," +
          l.substring(0, 4));
      print(l.substring(4, l.length));
      date = x.split(", ")[0].substring(0, 3) +
          " " +
          datex +
          "," +
          l.substring(0, 4);
      timer = l.substring(4, l.length).trim();
    }

    int index = orderItems.indexOf(orderItem);
    return ExpansionPanel(
      //canTapOnHeader: true,
      //hasIcon: false,
      isExpanded: orderItems[index].isChecked,
      headerBuilder: (context, isOpen) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 9),
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
                    "  Order Item",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: kColorBlack),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RequestReturn(
                                  OrderDataDetails!, orderItems)));
                    },
                    child: const Text(
                      "Request Return",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFAF1302)),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 3,
              ),
              Divider(
                color: kColorSmoke.withOpacity(.6),
                thickness: 1,
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
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    constraints: BoxConstraints(maxWidth: width / 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F2F5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image.network(
                      "${orderItem.productImageUrl}",
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
                        children:  [
                          Expanded(
                            child: Text(
                              "${orderItem.productName.toString().trim()}",
                              style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: kColorBlack),
                            ),
                          ),
                          // Text(
                          //   "Herbs",
                          //   style: TextStyle(
                          //       fontFamily: "Poppins",
                          //       fontSize: 13,
                          //       fontWeight: FontWeight.w500,
                          //       color: kColorSmoke2),
                          // ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Order #${OrderDataDetails!.uniqueOrderId.toString()}",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: kColorSmoke2),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            "QTY: ${orderItem.quantity}   PACK: ",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: kColorSmoke2),
                          ),
                          const Text(
                            "capsule",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 11,
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
                          Text(
                            "${orderItem.unitprice}",
                            style: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: kColorBlack),
                          ),
                        ],
                      ),
                     const SizedBox(
                        height: 8,
                      ),
                      orderData.orderStatus!.contains("PROCESSING")
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
                        padding:
                           const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                            color: orderData.orderStatus!
                                    .contains("Ready for delivery")
                                ? const Color(0xFF48A7F8)
                                : orderData.orderStatus!.contains("Delivered")
                                    ? const Color(0xFF16C68B)
                                    : const Color(0xFFFFB323),
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                          child: Text(
                            "${orderData.orderStatus}",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: orderData.orderStatus!
                                            .contains("Delivered") ||
                                        orderData.orderStatus!
                                            .contains("Ready for delivery")
                                    ? kColorWhite
                                    : kColorBlack),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      orderData.orderStatus!.contains("Delivered")
                          ? Text(
                              "On ${OrderDataDetails!.orderDate!.split("T")[0]}",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: kColorSmoke2),
                            )
                          : const Center(),
                    ],
                  ))
                ],
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    showRateItem = true;
                    selectedProductId = orderItem.productId!;
                  });
                  //_displayDialog(context,orderItem.productId!);
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 50),
                  child: Row(
                    children: [
                      Text(
                        "RATE ITEM",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: kColorBlack.withOpacity(.6)),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SvgPicture.asset(
                        "assets/svg/raterx.svg",
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  RefillObj refillObj =  RefillObj(
                    productId: orderItem.productId!,
                    productName: orderItem.productName!,
                    productImage: orderItem.productImageUrl!,
                    price: orderItem.unitprice!,
                    quantity: orderItem.quantity!,
                  );
                  Provider.of<ServiceClass>(context, listen: false)
                      .notifyRefill(refillObj);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AddMedicine(orderItem.productId!)));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: kPrimaryColor,
                          width: 1,
                          style: BorderStyle.solid)),
                  child: const Center(
                    child: Text(
                      "SCHEDULE REFILL",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: kPrimaryColor),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  addToCart(orderItem.productId!);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1),
                      color: kPrimaryColor),
                  child: Center(
                    child: Text(
                      "BUY AGAIN",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: kColorWhite),
                    ),
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
                  orderItems[index].isChecked
                      ? InkWell(
                          onTap: () {
                            setState(() {
                              orderItems[index].isChecked =
                                  !orderItems[index].isChecked;
                            });
                          },
                          child: const Icon(
                            Icons.keyboard_arrow_up,
                            color: Color(0xFFAF1302),
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            setState(() {
                              orderItems[index].isChecked =
                                  !orderItems[index].isChecked;
                            });
                          },
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Color(0xFFAF1302),
                          ),
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
              afterLineStyle: LineStyle(
                color: kPrimaryColor,
                thickness: 2,
              ),
              lineXY: 0.3,
              isFirst: true,
              indicatorStyle: IndicatorStyle(
                indicator: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
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
                  children: [
                    Text(
                      activity,
                      style: const TextStyle(
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
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      timer,
                      style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                    Text(
                      date,
                      style: const TextStyle(
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
              afterLineStyle: LineStyle(
                  color: history.length > 1 ? kPrimaryColor : kColorSmoke,
                  thickness: 2),
              beforeLineStyle: LineStyle(
                  color: history.length > 1 ? kPrimaryColor : kColorSmoke,
                  thickness: 2),
              lineXY: 0.3,
              isLast: false,
              indicatorStyle: IndicatorStyle(
                indicator: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(180),
                    border: Border.all(
                        color: history.length > 1 ? kPrimaryColor : kColorSmoke,
                        width: 1,
                        style: BorderStyle.solid),
                  ),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(180),
                        color: history.length > 1 ? kPrimaryColor : kColorSmoke
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
                      history.length > 1 ? history[1].activity : "",
                      style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                    Text(
                      history.length > 1 ? "Order" : "",
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
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      history.length > 1
                          ? timerCustom(history[1].activityDate).split(".")[1]
                          : "",
                      style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                    Text(
                      history.length > 1
                          ? timerCustom(history[1].activityDate).split(".")[0]
                          : "",
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
              afterLineStyle: LineStyle(
                  color: history.length > 2 ? kPrimaryColor : kColorSmoke,
                  thickness: 2),
              beforeLineStyle: LineStyle(
                  color: history.length > 2 ? kPrimaryColor : kColorSmoke,
                  thickness: 2),
              lineXY: 0.3,
              isLast: false,
              indicatorStyle: IndicatorStyle(
                indicator: Container(
                  padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(180),
                    border: Border.all(
                        color: history.length > 2 ? kPrimaryColor : kColorSmoke,
                        width: 1,
                        style: BorderStyle.solid),
                  ),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(180),
                        color: history.length > 2 ? kPrimaryColor : kColorSmoke
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
                      history.length > 2 ? history[2].activity : "",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                    Text(
                      history.length > 2 ? "Order" : "",
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
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      history.length > 2
                          ? timerCustom(history[2].activityDate).split(".")[1]
                          : "",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                    Text(
                      history.length > 2
                          ? timerCustom(history[2].activityDate).split(".")[0]
                          : "",
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
              afterLineStyle: LineStyle(
                  color: history.length > 3 ? kPrimaryColor : kColorSmoke,
                  thickness: 2),
              beforeLineStyle: LineStyle(
                  color: history.length > 3 ? kPrimaryColor : kColorSmoke,
                  thickness: 2),
              lineXY: 0.3,
              isLast: false,
              indicatorStyle: IndicatorStyle(
                indicator: Container(
                  padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(180),
                    border: Border.all(
                        color: history.length > 3 ? kPrimaryColor : kColorSmoke,
                        width: 1,
                        style: BorderStyle.solid),
                  ),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(180),
                        color: history.length > 3 ? kPrimaryColor : kColorSmoke
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
                      history.length > 3 ? history[3].activity : "",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                    Text(
                      history.length > 3 ? "Order" : "",
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
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      history.length > 3
                          ? timerCustom(history[3].activityDate).split(".")[1]
                          : "",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                    Text(
                      history.length > 3
                          ? timerCustom(history[3].activityDate).split(".")[0]
                          : "",
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
              afterLineStyle: LineStyle(
                  color: history.length > 4 ? kPrimaryColor : kColorSmoke,
                  thickness: 2),
              beforeLineStyle: LineStyle(
                  color: history.length > 4 ? kPrimaryColor : kColorSmoke,
                  thickness: 2),
              lineXY: 0.3,
              isLast: true,
              indicatorStyle: IndicatorStyle(
                indicator: Container(
                  padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(180),
                    border: Border.all(
                        color: history.length > 4 ? kPrimaryColor : kColorSmoke,
                        width: 1,
                        style: BorderStyle.solid),
                  ),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(180),
                        color: history.length > 4 ? kPrimaryColor : kColorSmoke
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
                      history.length > 4 ? history[4].activity : "",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                    Text(
                      history.length > 4 ? "Order" : "",
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
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      history.length > 4
                          ? timerCustom(history[4].activityDate).split(".")[1]
                          : "",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                    Text(
                      history.length > 4
                          ? timerCustom(history[4].activityDate).split(".")[0]
                          : "",
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
          ],
        ),
      ),
    );
  }

  void viewProductByID(int id) {
    print("We are In now...");
    print("This the ID .... $id");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.viewOrderDetails(id).then((value) => productOutput(value));
    serviceClass.viewOrderHistory(id).then((value) => historyOutput(value));
  }

  //uploadPrescriptionUrl

  void productOutput(String body) {
    print("We are In Order now...");
    print(body);
    if (body.contains("Network Error")) {
      _showMessage("Network Error");
      setState(() {
        loading = false;
      });
    } else {
      var bodyT = jsonDecode(body);
      if (bodyT["status"] == "Successful") {
        var data = json.decode(body);
        dynamic data2 = data;
        print("In now .........");
        print(data2);
        dynamic value = data["data"];
        setState(() {
          OrderDataDetails = OrderDataDetails2.fromJson(value);
          List<dynamic> items = OrderDataDetails!.orderItems;
          orderItems =
              items.map<OrderItems>((e) => OrderItems.fromJson(e)).toList();
          print(OrderDataDetails!.state);
          loading = false;
        });
      } else {
        _showMessage(bodyT["message"]);
      }
    }
  }

  void addToCart(int productId) {
    print("We are In Add to cart now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.addToCart(productId, 1).then((value) => addCartOutput(value));
  }

  void postReview(int rating, String comment, int productId) {
    print("Post review now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass
        .postReview(rating, comment, productId)
        .then((value) => postReviewOutput(value));
  }

  void postReviewOutput(String body) {
    print("oops bro");
    print(body);
    if (body.contains("Network Error")) {
      _showMessage("Network Error");
    } else {
      var bodyT = jsonDecode(body);
      print("Inside Calming now");
      print(bodyT);
      _showMessage(bodyT["message"]);

      rateComment.text = "";
      setState(() {
        rateLoading = false;
      });
    }
  }

  void addCartOutput(String body) {
    print("Whats is wrong bruv");
    print(body);
    if (body.contains("Network Error")) {
      _showMessage("Network Error");
    } else {
      var bodyT = jsonDecode(body);
      print("Inside Calming now");
      print(bodyT);
      _showMessage(bodyT["message"]);
      Provider.of<ServiceClass>(context, listen: false).increaseCart();
    }
  }

  void historyOutput(String body) {
    print("We are In History now...");
    print(body);
    if (body.contains("Network Error")) {
    } else {
      var bodyT = jsonDecode(body);
      if (bodyT["status"] == "Successful") {
        var data = json.decode(body);
        dynamic value = data["data"];
        setState(() {
          history =
              value.map<OrderHistory>((e) => OrderHistory.fromJson(e)).toList();
        });
        print("We are in history");
        print(history[0].activity);
        print(history[0].comments);
      } else {
        _showMessage(bodyT["message"]);
      }
    }
  }

  String timerCustom(String dater) {
    print("Lag");
    String x = DateFormat().format(DateTime.parse(dater));
    print(x);
    String f = x.split(", ")[0];
    String datex = f.split(" ")[1];
    String l = x.split(", ")[1];

    // print(f.substring(0,4));
    // print(x.split(", ")[0].substring(0,3) + " " + datex + "," + l.substring(0,4));
    // print(l.substring(4,l.length));
    String timer = x.split(", ")[0].substring(0, 3) +
        " " +
        datex +
        "," +
        l.substring(0, 4) +
        "." +
        l.substring(4, l.length).trim();
    return timer;
  }
}

class SmileySelect {
  Icon icon;
  bool selected;
  int rating;

  SmileySelect(this.icon, this.selected, this.rating);
}
