import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mymedicinemobile/constants.dart';
import 'package:mymedicinemobile/models/models.dart';
import 'package:mymedicinemobile/reusables/bars.dart';
import 'package:mymedicinemobile/screens/mobile/bundles/bundles_details.dart';
import 'package:mymedicinemobile/screens/mobile/cart/cart.dart';
import 'package:mymedicinemobile/screens/mobile/product_details/all_products.dart';
import 'package:mymedicinemobile/screens/mobile/product_details/product_details.dart';
import 'package:mymedicinemobile/services/services.dart';
import 'package:mymedicinemobile/text_style.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../../error_page.dart';

class WishList2 extends StatefulWidget {
  _WishList createState() => _WishList();
}

class _WishList extends State<WishList2> with SingleTickerProviderStateMixin {
  bool value = false;
  bool productShow = false;
  TextEditingController searchC = TextEditingController();
  late AnimationController _animationController;

  List<CartModel> trackList = [];
  stt.SpeechToText speech = stt.SpeechToText();

  late List<WishlistValue> dataList;

  bool loading = true;
  bool errorOcurred = false;
  bool dataLoaded = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _showMessage(String message, [Duration duration = const Duration(seconds: 4)]) {
    _scaffoldKey.currentState!.showSnackBar(SnackBar(
      content: Text(message),
      duration: duration,
      action: SnackBarAction(
          label: 'CLOSE',
          onPressed: () => _scaffoldKey.currentState!.removeCurrentSnackBar()),
    ));
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _animationController.repeat();

    viewWishlist();
    super.initState();
  }

  @override
  void dispose() {
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
        child: Container(
          width: width,
          height: height,
          child: Stack(
            children: [
              errorOcurred
                  ? errorPage(() {
                      //viewWishlist();
                      print("Clicked");
                      setState(() {
                        loading = true;
                        errorOcurred = false;
                      });
                    })
                  : dataLoaded == false
                      ? Center()
                      : Column(
                          children: [
                            navBarCustom("Wishlist", context, Cart(), true),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: height * .83,
                              child: ListView(
                                children: [
                                  dataList.isEmpty
                                      ? Column(
                                          children: [
                                            Text(
                                                "You have no items in wishlist yet."),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.pop(context);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AllProducts()));
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: kPrimaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5),
                                                child: Text(
                                                  "Add to Wishlist",
                                                  style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: kColorWhite),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Center(),
                                  ...dataList.map((e) => cartCustom(e)),
                                ],
                              ),
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

  // bool isDataExist(String value) {
  //   var data = list.where((row) => (row.name.contains(value)));
  //   print("All we needdddd ..........");
  //   print(data);
  //   if (data.length >= 1) {
  //     trackList.clear();
  //     for (int i = 0; i < data.length; i++) {
  //       trackList.add(data.elementAt(i));
  //     }
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  Widget cartCustom(WishlistValue cartModel) => InkWell(
        onTap: () {
          if (cartModel.bundlePrice != null) {
            print("Bundle Bundle Bundle ........");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BundleID(cartModel.bundleId!)));
          } else {
            print("Bundle Bundle Bundle Null........");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProductID(cartModel.productId!)));
          }
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
                  Container(
                    width: MediaQuery.of(context).size.width / 3,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Color(0xFFF0F2F5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image.network(
                      cartModel.bundlePrice == null
                          ? cartModel.productImageUrl!
                          : cartModel.bundleImageUrl!,
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
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              cartModel.bundlePrice == null
                                  ? "${cartModel.productName!.trim()}"
                                  : "${cartModel.bundleName!.trim()}",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: kColorBlack),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Row(
                        children: [
                          cartModel.minPrice != null
                              ? SvgPicture.asset(
                                  "assets/svg/naira.svg",
                                  height: 10,
                                  width: 10,
                                )
                              : SizedBox(),
                          Text(
                            cartModel.bundlePrice == null
                                ? "${cartModel.minPrice!}"
                                : "${cartModel.bundlePrice!}",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: kColorBlack),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SvgPicture.asset(
                        "assets/svg/love_cart.svg",
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            loading = true;
                            errorOcurred = false;
                          });

                          if (cartModel.productId == null) {
                            print("Bundle Bundle");
                            deleteBundleFromWishlist(
                                dataList.indexOf(cartModel),
                                cartModel.bundleId!);
                          } else {
                            deleteFromWishlist(dataList.indexOf(cartModel),
                                cartModel.productId!);
                          }
                        },
                        child: Text(
                          "Remove",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFAF1302),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ))
                ],
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: () {
                    if (cartModel.quantity != 0) {
                      if (cartModel.bundlePrice != null) {
                        addBundleToCart(cartModel.bundleId!);
                      } else {
                        addWishToCart(cartModel.productId!);
                      }
                    } else {
                      _showMessage("Out of stock");
                    }
                  },
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/svg/cart_plus.svg",
                      //color: cartModel.quantity != 0 ? null : kPrimaryColor ,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );

  void viewWishlist() {
    print("We are In now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.viewWishList().then((value) => output(value));
  }

  void deleteFromWishlist(int pos, int prodId) {
    print("We are In now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass
        .removeProductFromWishList(prodId)
        .then((value) => deleteOutput(value, pos));
  }

  void deleteBundleFromWishlist(int pos, int bundleId) {
    print("We are In now delete bundle...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass
        .removeBundleFromWishList(bundleId)
        .then((value) => deleteOutput(value, pos));
  }

  void output(String body) {
    print("We are In Wishlist now...");
    print(body);
    if (body.contains("Network Error")) {
      setState(() {
        loading = false;
        errorOcurred = true;
      });
    } else {
      var bodyT = jsonDecode(body);
      if (bodyT["message"] == "Successful") {
        var data = json.decode(body);
        dynamic data2 = data;
        print("all man .........");
        print(data2);

        ServerResponse serverResponse = ServerResponse.fromJson(data2);
        AllData allData = AllData.fromJson(serverResponse.data);

        dataList = allData.value
            .map<WishlistValue>((element) => WishlistValue.fromJson(element))
            .toList();
        print("WishList");

        print(serverResponse.message);
        print("Counter ....");
        print(serverResponse.data);
        print("List Course ....");
        //print(dataList[0].productName);
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

  void deleteOutput(String body, int pos) {
    print("delete wishlist");
    print(body);
    if (body.contains("Network Error")) {
      _showMessage("Network error occured, please try again.");
    } else {
      var bodyT = jsonDecode(body);
      print("Okay ooo my boy");
      print(bodyT);
      if (bodyT["status"] == true) {
        var data = json.decode(body);
        dynamic data2 = data;
        print("all man .........");
        print(data2);
        setState(() {
          loading = false;
          dataList.removeAt(pos);
        });
      } else {
        print("Not successful....");
        _showMessage(bodyT["message"]);
        setState(() {
          loading = false;
        });
      }
    }
  }

  void addWishToCart(int id) {
    print("We are In Add to cart now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.addToCart(id, 1).then((value) => addCartOutput(value));
  }

  void addCartOutput(String body) {
    print("Whats is wrong bruv");
    print(body);
    if (body.contains("Network Error")) {
      _showMessage("Network Error");
    } else {
      var bodyT = jsonDecode(body);
      _showMessage(bodyT["message"]);
      Provider.of<ServiceClass>(context, listen: false).increaseCart();
    }
  }

  void addBundleToCart(int bundleId) {
    print("We are In Add to cart now...");
    print("Bundle ID --- $bundleId");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass
        .addBundleToCart(bundleId, 1)
        .then((value) => addCartOutput(value));
  }
}
