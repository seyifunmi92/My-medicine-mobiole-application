import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mymedicinemobile/constants.dart';
import 'package:mymedicinemobile/models/models.dart';
import 'package:mymedicinemobile/reusables/bars.dart';
import 'package:mymedicinemobile/screens/mobile/cart/cart.dart';
import 'package:mymedicinemobile/screens/mobile/home_page/homepager.dart';
import 'package:mymedicinemobile/screens/mobile/product_search/similar_products.dart';
import 'package:mymedicinemobile/services/services.dart';
import 'package:mymedicinemobile/text_style.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'medicine_refill.dart';

class Refillorders extends StatefulWidget {
  _Refillorders createState() => new _Refillorders();
}

class _Refillorders extends State<Refillorders> with SingleTickerProviderStateMixin{

  bool noOrders = true;
  bool productShow = false;
  bool searchIsEmpty = false;
  TextEditingController searchC = new TextEditingController();
  TextEditingController dateC = new TextEditingController();
  late AnimationController _animationController;
  bool loading = true;
  bool cancelLoading = false;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<RefillOrders> trackList = [];
  stt.SpeechToText speech = stt.SpeechToText();
  List<RefillProduct> list = [];


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
    _animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 2),
    );
    _animationController.repeat();
    fetchRefillProducts();
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
              ListView(
                children: [

                  SizedBox(
                    height: 70,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.add,color: kPrimaryColor,),

                      GestureDetector(
                        onTap: (){
                          //Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AddMedicine(0)));
                          //Navigator.pop(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Text(
                            "Add new",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 13,
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w400),

                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  ...list.map((e) => orderCustom(e)),

                  SizedBox(height: 80,),
                ],
              ),


              Positioned(
                bottom: 0,
                left: 10,
                right: 10,
                child:   InkWell(
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePager()));
                  },
                  child: Container(
                    width: width,
                    padding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    color: kColorWhite,
                    child: Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      margin:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: kPrimaryColor),
                      child: Center(
                        child: Text(
                          "CONTINUE SHOPPING",
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

              Positioned(
                top:0,
                child:Container(width: width,child: navBarCustom("Your Refill Order",context,Cart(),true)),
              ),


            ],
          ),
        ),
      ),
    );
  }





  Widget orderCustom(RefillProduct orders) => Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 10,
            ),

            SizedBox(
              width: 10,
            ),
            Row(children: [
              Text(
                orders.productName!,
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),

              // Text(
              //     orders.name,
              //   style: TextStyle(
              //       fontFamily: "Poppins",
              //       fontSize: 16,
              //       fontWeight: FontWeight.w400),
              // ),

            ],),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Row(
                children: [
                  Text(
                    'Quantity: ',
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        color: kColorSmoke2,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    orders.quantity != null ? "${orders.quantity}" : "0",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        color: kColorBlack,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),

              Text(
                orders.medicationRefillStatus!,
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 16,
                    color: Colors.green,
                    fontWeight: FontWeight.w400),
              ),

            ],),

            SizedBox(height: 10,),
            Text(
              "Order No.",
              style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16,
                  color: kColorSmoke2,
                  fontWeight: FontWeight.w400),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text(
                orders.productId.toString(),
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),

              InkWell(
                onTap: (){
                  late bool status;
                  if(orders.medicationRefillStatus == "Active"){
                    status = false;
                  }else{
                    status = true;
                  }
                  _displayDialog(context,orders.refillId!,status);
                },
                child: Text(
                  orders.medicationRefillStatus == "Active" ? "cancel orders" :"activate",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 11,
                      color: Colors.red,
                      fontWeight: FontWeight.w400),
                ),
              ),

            ],),

            SizedBox(height: 5,),
            Divider(height: 2,color: kColorSmoke,),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Start Date",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      color: kColorSmoke2,
                      fontWeight: FontWeight.w400),
                ),

                Text(
                  "Refill Cycle",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      color: kColorSmoke2,
                      fontWeight: FontWeight.w400),
                ),

              ],),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  orders.startDate!.split("T")[0],
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 13,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w400),
                ),

                Text(
                  orders.refillCycle!,
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 13,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w400),
                ),

              ],),


          ],
        ),
      );



  _displayDialog(BuildContext context,int id, bool status) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(status == false ? 'Cancel Refill Order!' : "Activate Refill Order" ,style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 15,
                color: kColorBlack,
                fontWeight: FontWeight.w400),),
            content: Text(status == false ? "Are you sure you want to cancel your refill order?":"Are you sure you want to activate your refill order?", style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 13,
                color: kColorBlack,
                fontWeight: FontWeight.w400),),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop();
                  cancelRefillOrder(id,status);
                  //Navigator.push(context,MaterialPageRoute(builder: (context) => Refillorders()));
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


  void fetchRefillProducts() {
    print("We are In now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.viewRefillProducts().then((value) => output(value));
  }

  void output(String body) {
    print("We are In faq now...");
    print(body);
    setState(() {
      loading = false;
    });
    if (body.contains("Network Error")) {
      _showMessage("Network Error");
    } else {
      var bodyT = jsonDecode(body);
      if (bodyT["status"] == "Successful") {
        var data = json.decode(body);
        dynamic data2 = data;
        print("In now .........");
        print(data2);
        dynamic value = data["data"]["value"];
        list.clear();
        list = value
            .map<RefillProduct>((element) => RefillProduct.fromJson(element))
            .toList();
        setState(() {
          loading = false;
        });
      } else {
        _showMessage(bodyT["message"]);
      }
    }
  }


  void cancelRefillOrder(int refillId, bool active) {
    print("We are In now cancel...");
    setState(() {
      loading = true;
    });
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.cancelRefillOrder(refillId,active).then((value) => outputCancel(value));
  }

  void outputCancel(String body) {
    print("We are In delete now...");
    print(body);
    if (body.contains("Network Error")) {
      _showMessage("Network Error");
      setState(() {
        loading = false;
      });
    } else {
      var bodyT = jsonDecode(body);
      if (bodyT["status"] == "Successful") {
        fetchRefillProducts();
        _showMessage(bodyT["message"]);
      } else {
        _showMessage(bodyT["message"]);
        setState(() {
          loading = false;
        });
      }
    }
  }


}
