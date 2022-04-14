import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:mymedicinemobile/constants.dart';
import 'package:mymedicinemobile/models/models.dart';
import 'package:mymedicinemobile/reusables/bars.dart';
import 'package:mymedicinemobile/screens/mobile/cart/cart.dart';
import 'package:mymedicinemobile/screens/mobile/orders/refund_method.dart';
import 'package:mymedicinemobile/services/services.dart';
import 'package:mymedicinemobile/text_style.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:timeline_tile/timeline_tile.dart';

class RequestReturn extends StatefulWidget {
  late OrderDataDetails2 OrderDataDetails;
  late List<OrderItems> orderItems;

  RequestReturn(this.OrderDataDetails, this.orderItems);

  _RequestReturn createState() => new _RequestReturn();
}

class _RequestReturn extends State<RequestReturn>
    with SingleTickerProviderStateMixin {


  List<QtyPick> qtylist = [
    new QtyPick(num: 1, picked: false),
    new QtyPick(num: 2, picked: false),
    new QtyPick(num: 3, picked: false),
    new QtyPick(num: 4, picked: false),
    new QtyPick(num: 5, picked: false),
  ];

  int selectedSalesOrderId = 0;
  TextEditingController emailC = new TextEditingController();
  TextEditingController addC = new TextEditingController();
  bool toggleStatus = true;

  bool showQty = false;
  bool loading = false;
  bool loaded = false;
  bool showAdded = false;
  String selectedQty = "Select";
  late AnimationController _animationController;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<ReturnCondition> returnList = [];
  late ReturnCondition returnCondition;
  bool clicker = false;

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

  @override
  void initState() {
    // TODO: implement initState
    selectedSalesOrderId = widget.orderItems[0].salesOrderItemId!;
    _animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 2),
    );
    _animationController.repeat();

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
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: kColorWhite,
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                  width: width,
                  height: height,
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 70,
                      ),
                      Container(
                        //height: height * .84,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "SELECT PRODUCT FOR REFUND",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: kColorBlack),
                                ),
                              ],
                            ),

                           ...widget.orderItems.map((e) => returnTopContainer(e)),

                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 15),
                              padding: EdgeInsets.symmetric(
                                  vertical: 25, horizontal: 20),
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
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Please fill in details for your return",
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: kColorBlack.withOpacity(.9)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Divider(
                                    height: 1,
                                    color: kColorSmoke,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "QTY",
                                                style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: kColorBlack
                                                        .withOpacity(.8)),
                                              ),
                                              Text(
                                                "*",
                                                style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: kPrimaryColor),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Color(0xFFF6F6F9)),
                                            child: Row(
                                              children: [
                                                Text(
                                                  selectedQty,
                                                  style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: kColorSmoke2),
                                                ),
                                                InkWell(
                                                  onTap: (){
                                                    setState(() {
                                                      showQty = true;
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons
                                                        .keyboard_arrow_down_outlined,
                                                    color: kColorBlack,
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            //mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    loading = true;
                                                  });
                                                  viewConditions();
                                                },
                                                child: Text(
                                                  "Reasons",
                                                  style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: kColorBlack),
                                                ),
                                              ),
                                              Text(
                                                "*",
                                                style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                    color: kPrimaryColor),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            // mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    loading = true;
                                                  });
                                                  viewConditions();
                                                },
                                                child: Text(
                                                  "Select Reasons",
                                                  style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: kPrimaryColor),
                                                ),
                                              ),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                color: kPrimaryColor,
                                                size: 15,
                                              )
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Divider(
                                    height: 1,
                                    color: kColorSmoke,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Additional Information",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: kColorBlack),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    height: 120,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Color(0xFFF6F6F9)),
                                    child: TextField(
                                      controller: addC,
                                      cursorColor: kPrimaryColor,
                                      style: kmediumTextBold(kColorBlack),
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                        hintText: "Text",
                                        hintStyle: kmediumTextBold(kColorSmoke),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Email Address",
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: kColorBlack),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Color(0xFFF6F6F9)),
                                    child: TextField(
                                      controller: emailC,
                                      cursorColor: kPrimaryColor,
                                      style: kmediumTextBold(kColorBlack),
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                        hintText: "Enter email address",
                                        hintStyle: kmediumTextBold(kColorSmoke),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 45,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        loading = true;
                                      });
                                      postReturn();

                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(1),
                                          color: kPrimaryColor),
                                      child: Center(
                                        child: Text(
                                          "REQUEST RETURN",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: kColorWhite),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )),


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
                                      angle:
                                          _animationController.value * 2 * pi,
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
                visible: loaded,
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
                            top: height * .3,
                            left: 50,
                            right: 50,
                            child: Container(
                                width: width/2,
                                //color: kColorWhite,
                                height: height * .6,
                                decoration: BoxDecoration(
                                    color: kColorWhite,
                                    borderRadius: BorderRadius.circular(15)),
                                child: ListView(
                                  children: [
                                    SizedBox(height: 20,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("REQUEST RETURN REASON",style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: kColorBlack),),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    ...returnList.map((e) => mapConditions(e,width)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap :(){
                                            setState(() {
                                              loaded = false;
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: kPrimaryColor,
                                                borderRadius: BorderRadius.circular(10)),
                                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                            child: Text("Yes, Continue",style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                                color: kColorWhite),),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap :(){
                                            setState(() {
                                              loaded = false;
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Color(0xFFFFECFD),
                                                borderRadius: BorderRadius.circular(10)),
                                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                            child: Text("No, Cancel",style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                                color: kPrimaryColor),),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    )),
              ),

              showQty
                  ? Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: width,
                    height: height,
                    color: Color(0xFF000000).withOpacity(0.25),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 210,
                          left: 65,
                          child: Container(
                            width: 100,
                            decoration: BoxDecoration(
                                color: kColorWhite,
                                borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                ...qtylist.map((e) => customGender(e)),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
                  : Center(),

              Positioned(
                top:0,
              left: 0,
              right: 0,
              child: Container(
                //height: height * .08,
                child: navBarSearchCustom(
                    "Order Details", context, Cart(), true),
              ),)

            ],
          ),
        ));
  }

  Widget mapConditions(ReturnCondition condition,width) {
    return Container(
      //height: 20,
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: width/2,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(condition.name,style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: kColorSmoke2),),
              ),
              Checkbox(
                checkColor: Colors.white,
                fillColor: MaterialStateProperty.all(kPrimaryColor),
                value: condition.clicked,
                shape: CircleBorder(),
                onChanged: (bool? value) {
                  setState(() {
                    returnCondition = condition;
                    returnList[returnList.indexOf(condition)].clicked =
                    !returnList[returnList.indexOf(condition)].clicked;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 10,),
          Divider(height: 1,thickness: 1,color: kColorSmoke,)
        ],
      ),
    );
  }

  Widget returnTopContainer(OrderItems cartModel) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      padding: EdgeInsets.only(top: 15, bottom: 20,left: 10,right: 10),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order Item",
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: kColorBlack),
              ),
              // SvgPicture.asset(
              //   "assets/svg/radio_return.svg",
              // ),
              Checkbox(
                checkColor: Colors.white,
                fillColor: MaterialStateProperty.all(kPrimaryColor),
                value: cartModel.isChecked,
                shape: CircleBorder(),
                onChanged: (bool? value) {
                  for(int i=0;i<widget.orderItems.length;i++){
                    widget.orderItems[i].isChecked = false;
                  }
                  int index = widget.orderItems.indexOf(cartModel);
                  setState(() {
                    selectedSalesOrderId = cartModel.salesOrderItemId!;
                   widget.orderItems[index].isChecked  = !widget.orderItems[index].isChecked;
                  });
                },
              ),

            ],
          ),
          SizedBox(
            height: 3,
          ),
          Divider(color: kColorSmoke.withOpacity(.6),thickness: 1,),
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 3),
                decoration: BoxDecoration(
                  color: Color(0xFFF0F2F5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.network(
                  "${cartModel.productImageUrl}",
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
                  Row(
                    children: [
                      Text(
                        "${cartModel.productName!.trim()}",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: kColorBlack),
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
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Order #${cartModel.salesOrderItemId}",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: kColorSmoke2),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        "QTY: ${cartModel.quantity}   PACK: ",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: kColorSmoke2),
                      ),
                      Text(
                        "capsule",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: kColorBlack),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/svg/naira.svg",
                      ),
                      Text(
                        "${cartModel.unitprice}",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: kColorBlack),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  // cartModel.status.contains("PROCESSING")
                  //     ? Row(
                  //         children: [
                  //           SvgPicture.asset(
                  //             "assets/svg/cancel_1.svg",
                  //           ),
                  //           SizedBox(
                  //             width: 5,
                  //           ),
                  //           Text(
                  //             "Cancel order",
                  //             style: TextStyle(
                  //                 fontFamily: "Poppins",
                  //                 fontSize: 14,
                  //                 fontWeight: FontWeight.w500,
                  //                 color: Color(0xFFAF1302)),
                  //           ),
                  //         ],
                  //       )
                  //     : Center(),
                  SizedBox(
                    height: 5,
                  ),
                  // Container(
                  //   width: 100,
                  //   padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  //   decoration: BoxDecoration(
                  //       color: cartModel.status.contains("Ready for delivery")
                  //           ? Color(0xFF48A7F8)
                  //           : cartModel.status.contains("Delivered")
                  //               ? Color(0xFF16C68B)
                  //               : Color(0xFFFFB323),
                  //       borderRadius: BorderRadius.circular(5)),
                  //   child: Center(
                  //     child: Text(
                  //       cartModel.status,
                  //       style: TextStyle(
                  //           fontFamily: "Poppins",
                  //           fontSize: 13,
                  //           fontWeight: FontWeight.w500,
                  //           color: cartModel.status.contains("Delivered") ||
                  //                   cartModel.status
                  //                       .contains("Ready for delivery")
                  //               ? kColorWhite
                  //               : kColorBlack),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  // cartModel.status.contains("Delivered")
                  //     ? Text(
                  //         "On ${widget.OrderDataDetails.orderDate}",
                  //         style: TextStyle(
                  //             fontFamily: "Poppins",
                  //             fontSize: 12,
                  //             fontWeight: FontWeight.w400,
                  //             color: kColorSmoke2),
                  //       )
                  //     : Center(),
                ],
              ))
            ],
          ),
        ],
      ),
    );
  }


  void viewConditions() {
    print("We are In now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.viewReturnConditions().then((value) => output(value));
  }


  void postReturn() {
    print("We are In now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.postReturnCondition(widget.OrderDataDetails.salesOrderId!,selectedSalesOrderId,int.parse(selectedQty),returnCondition.id,addC.text,1).then((value) => outputPostRequest(value));
  }


  void output(String body) {
    print("We are In faq now...");
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
        print(data2);
        dynamic value = data["data"]["value"];
        setState(() {
          returnList = value
              .map<ReturnCondition>((e) => ReturnCondition.fromJson(e))
              .toList();
          loading = false;
          loaded = true;
        });
      } else {
        _showMessage(bodyT["message"]);
      }
    }
  }


  void outputPostRequest(String body) {
    print("We are In faq now...");
    print(body);
    if (body.contains("Network Error")) {
      _showMessage("Network Error");
      setState(() {
        loading = false;
      });
    } else {
      var bodyT = jsonDecode(body);
      if (bodyT["status"] == "Successful") {
        _showMessage(bodyT["data"]);
        setState(() {
          loading = false;
        });
        _showMessage(bodyT["message"]);
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) =>
        //             RefundMethod()));
      } else {
        _showMessage(bodyT["message"]);
      }
    }
  }

  Widget customGender(QtyPick pick) {
    return InkWell(
      onTap: () {
        int currentIndex = qtylist.indexOf(pick);
        for (var pick in qtylist) {
          pick.picked = false;
        }
        setState(() {
          qtylist[currentIndex].picked = !qtylist[currentIndex].picked;
          selectedQty = pick.num.toString();
          showQty = false;
        });
      },
      child: Container(
        width: 100,
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        margin: EdgeInsets.only(top: 15, left: 10, right: 10),
        decoration: BoxDecoration(
            color: pick.picked ? Color(0xFFFFDAFA) : kColorWhite,
            borderRadius: BorderRadius.circular(5)),
        child: Text(
          pick.num.toString(),
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w400,
            color: kColorBlack,
            fontSize: 14,
          ),
        ),
      ),
    );
  }


}


class QtyPick {
  int num;
  bool picked;

  QtyPick({required this.num, required this.picked});
}
