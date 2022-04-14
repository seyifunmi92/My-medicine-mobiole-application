import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:mymedicinemobile/constants.dart';
import 'package:mymedicinemobile/models/models.dart';
import 'package:mymedicinemobile/reusables/bars.dart';
import 'package:mymedicinemobile/screens/mobile/cart/cart.dart';
import 'package:mymedicinemobile/screens/mobile/product_details/product_details.dart';
import 'package:mymedicinemobile/services/services.dart';
import 'package:mymedicinemobile/text_style.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../../error_page.dart';

class RecentlyViewed extends StatefulWidget {
  _RecentlyViewed createState() => new _RecentlyViewed();
}

class _RecentlyViewed extends State<RecentlyViewed> with SingleTickerProviderStateMixin{

  bool value = false;
  bool productShow = false;
  TextEditingController searchC = new TextEditingController();

  List<CartModel> trackList = [];
  stt.SpeechToText speech = stt.SpeechToText();
  var formatter = NumberFormat('#,###');
  bool loading = true;
  bool errorOcurred = false;
  bool dataLoaded = false;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  late AnimationController _animationController;
  late List<RecentlyViewedModel> dataList;


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
    _animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 2),
    );
    _animationController.repeat();
    recentlyViewed();

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
      backgroundColor: kColorWhite,
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
          width: width,
          height: height,
          child: Stack(
            children: [
              Column(
                children: [
                  navBarCustom("Recently Viewed",context,Cart(),true),
                  SizedBox(
                    height: 10,
                  ),

                  errorOcurred
                      ? errorPage(() {
                    recentlyViewed();
                    print("Clicked");
                    setState(() {
                      loading = true;
                      errorOcurred = false;
                    });
                  })
                      : dataLoaded == false ? Center()  :Container(
                    height: height * .84,
                    child: ListView(children: [
                      ...dataList.map((e) => cartCustom(e)),
                    ],),
                  ),
                ],
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



  Widget cartCustom(RecentlyViewedModel cartModel) => InkWell(
    onTap:(){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductID(cartModel.productId!)));
    },
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      //padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: kColorSmoke.withOpacity(.4),
          spreadRadius: 1,
          blurRadius: 7,
          offset: Offset(5, 3), // changes position of shadow
        ),
      ], color: kColorWhite, borderRadius: BorderRadius.circular(20)),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(
              //   width: 10,
              // ),
              Container(
                width: MediaQuery.of(context).size.width/3,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  color: Color(0xFFF0F2F5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.network(
                  cartModel.productImage != null ?  cartModel.productImage! : "",
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
                      // Row(
                      //   children: [
                      //
                      //
                      //     // Text(
                      //     //   cartModel.productName == null ? "null" : cartModel.productName!,
                      //     //   style: TextStyle(
                      //     //       fontFamily: "Poppins",
                      //     //       fontSize: 15,
                      //     //       fontWeight: FontWeight.w500,
                      //     //       color: kColorSmoke2
                      //     //   ),
                      //     // ),
                      //   ],
                      // ),

                      Text(
                        cartModel.productName == null ? "null" : cartModel.productName!.trim(),
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: kColorBlack
                        ),
                      ),

                      Text(
                        cartModel.productDescription!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: kColorSmoke2
                        ),
                      ),

                      SizedBox(height: 5,),
                      Row(
                        children: [

                          Row(
                            children: [
                              SvgPicture.asset("assets/svg/naira.svg",width: 10,height: 10,),
                              Text(
                                //formatter.format(cartModel.price).toString(),
                                "${cartModel.price}",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: kColorBlack.withOpacity(.8)
                                ),
                              ),
                            ],
                          ),

                          SizedBox(width: 20,),

                          Row(
                            children: [

                              Text(
                                cartModel.productRatings.toString(),
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: kColorBlack
                                ),
                              ),
                              SvgPicture.asset(
                                "assets/svg/star_rating.svg",
                              ),



                            ],
                          ),


                        ],
                      ),




                      SizedBox(
                        height: 70,
                      ),

                    ],
                  ))
            ],
          ),

          Positioned(
            bottom: 0,
            right: 0,
            child:  Container(
              width: 120,
              height: 40,
              decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomRight : Radius.circular(20))
              ),
              child: Center(
                child: Text("Buy Now",style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: kColorWhite
                ),),
              ),
            ),
          )
        ],
      ),
    ),
  );



  void recentlyViewed() {
    print("We are In now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.allRecentlyViewed().then((value) => output(value));
  }


  void output(String body) {
    print("We are In second haven now...");
    print(body);
    if (body.contains("Network Error")) {
      setState(() {
        loading = false;
        errorOcurred = true;
      });
    } else {
      var bodyT = jsonDecode(body);
      if (bodyT["status"] == "Successful") {
        var data = json.decode(body);
        dynamic data2 = data["data"]["value"];

        // ServerResponse serverResponse = ServerResponse.fromJson(data2);
        // AllData allData = AllData.fromJson(serverResponse.data);

        print("This is recently viewed now");
        print(data2);
        dataList = data2.map<RecentlyViewedModel>((element) => RecentlyViewedModel.fromJson(element)).toList();
        print("Recently Viewed");

        setState(() {
          loading = false;
          errorOcurred = false;
          dataLoaded = true;
        });
      } else {
        _showMessage(bodyT["message"]);
        setState(() {
          loading = false;
          errorOcurred = true;
        });
      }
    }
  }



}
