import 'dart:convert';
import 'dart:math';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mymedicinemobile/constants.dart';
import 'package:mymedicinemobile/models/models.dart';
import 'package:mymedicinemobile/reusables/bars.dart';
import 'package:mymedicinemobile/screens/mobile/cart/cart.dart';
import 'package:mymedicinemobile/screens/mobile/medicine_refill/refill_product_detailsXX.dart';
import 'package:mymedicinemobile/screens/mobile/medicine_refill/refill_product_details2.dart';
import 'package:mymedicinemobile/screens/mobile/product_details/all_products.dart';
import 'package:mymedicinemobile/screens/mobile/product_search/similar_products.dart';
import 'package:mymedicinemobile/services/services.dart';
import 'package:mymedicinemobile/text_style.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ProductSearchRefill extends StatefulWidget {
  int refillCycleId;
  bool remindBySMS,remindByEmail, remindByPushNotification;
  String startDate;
  ProductSearchRefill(this.refillCycleId,this.remindBySMS,this.remindByEmail,this.remindByPushNotification,this.startDate);

  _ProductSearchRefill createState() => new _ProductSearchRefill();
}
//Delete refill product

class _ProductSearchRefill extends State<ProductSearchRefill> {
  bool value = false;
  bool productShow = false;
  bool searchIsEmpty = false;
  TextEditingController searchC = new TextEditingController();

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';
  double _confidence = 1.0;
  bool isLoading = false;

  List<CartModel> trackList = [];
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<ProductSearch> list = [];
  

  @override
  void initState() {
    // TODO: implement initState
    initiateSpeech();
    super.initState();
  }




  void initiateSpeech() async {
    _speech = stt.SpeechToText();
    bool available = await _speech.initialize(
        onStatus: statusListener, onError: errorListener);
    if (available) {
      print("Speech is ready now for listening");
    } else {
      print("The user has denied the use of speech recognition.");
    }
  }


  void errorListener(SpeechRecognitionError error) {
    print('Received error status: $error, listening: ${_speech.isListening}');
    // setState(() {
    //   //lastError = '${error.errorMsg} - ${error.permanent}';
    // });
  }

  void statusListener(String status) {
    print('Received listener status: $status, listening: ${_speech.isListening}');
    // setState(() {
    //   //lastStatus = '$status';
    // });
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
          child: ListView(
            children: [

              navBarCustom("Add Refill Medicine",context,Cart(),false),
              // SizedBox(
              //   height: 10,
              // ),

              //Text(_text,style: klargeTextBold(kColorBlack),),
              Container(
                color: Color(0xFFF8F5FC),
                child: Container(
                  width: width,
                  height: 45,
                  margin: EdgeInsets.only(left: 20,right: 20, bottom: 10),
                  padding: EdgeInsets.symmetric( horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: kColorWhite,
                    border: Border.all(
                        color: kColorSmoke, width: 1, style: BorderStyle.solid),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          onChanged: (text) {
                            if (text.isNotEmpty) {
                              setState(() {
                                isLoading = true;
                              });
                              _text = text;
                              print(_text);
                              searchProducts(_text);
                            }
                          },
                          controller: searchC,
                          cursorColor: kPrimaryColor,
                          style: ksmallTextBold(kColorBlack),
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            hintText: "Search for medicines ...",
                            hintStyle: kminismall(kColorSmoke2),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        onTap: () {
                          if(_isListening){
                            setState(() {
                              _isListening = false;
                            });
                          }else{
                            _listen();
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AvatarGlow(
                              animate: _isListening,
                              glowColor: kPrimaryColor,
                              endRadius: 6.0,
                              duration: Duration(milliseconds: 2000),
                              repeat: true,
                              showTwoGlows: true,
                              repeatPauseDuration: Duration(milliseconds: 100),
                              child: SvgPicture.asset(
                                "assets/svg/mic_home.svg",
                                color: kColorSmoke,
                                width: 14,
                                height: 16,
                              ),
                            ),
                            Text(
                              "Tap to speak",
                              style: kminismall(kColorSmoke),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AvatarGlow(
                    animate: _isListening,
                    glowColor: kPrimaryColor,
                    endRadius: 40,
                    duration: Duration(milliseconds: 2000),
                    repeat: true,
                    showTwoGlows: true,
                    repeatPauseDuration: Duration(milliseconds: 100),
                    child: _isListening ?Text(
                      "Listening ....",
                      style: kminismall(kColorSmoke),
                    ) : Text(
                      "",
                      style: kminismall(kColorSmoke),
                    ),
                  ),
                ],
              ),
              searchIsEmpty == true
                  ? Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),

                          Text(
                            "Ooops! No results for ${_text}",
                            style: kmediumText(kColorBlack),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text("Please check your spelling for typing errors",
                              style: ksmallTextBold(kColorBlack)),
                          Text(
                              "It’s possible that the product is not available",
                              style: ksmallTextBold(kColorBlack)),

                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: kPrimaryColor),
                              child: Center(
                                child: Text(
                                  "BACK TO HOME",
                                  style: kmediumTextBold(kColorWhite),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Popular Products",
                                  style: ksmallMediumText(kColorBlack),
                                ),
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AllProducts()));
                                    },
                                    child: Text(
                                      "View all",
                                      style: ksmallTextBold(kPrimaryColor),
                                    ))
                              ],
                            ),
                          ),

                          //...list2.map((e) => cartCustom(e)),
                        ],
                      ),
                    )
                  : isLoading ? Center(child: Container(width: 30,height: 30,child: CircularProgressIndicator(color: kPrimaryColor,strokeWidth: 10,))) : Column(
                      children: [
                        ...list.map((e) => searchCustom(e)),
                      ],
                    )

              // Visibility(
              //     visible: productShow,
              //     child: Column(
              //       children: [...trackList.map((e) => cartCustom(e))],
              //     )),
            ],
          ),
        ),
      ),
    );
  }


  Widget searchCustom(ProductSearch productSearch) => InkWell(
        onTap: () {
          print("Pressed ........");
          Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => RefillProductDetails(productSearch.productId!,widget.refillCycleId,widget.remindBySMS,widget.remindByEmail,widget.remindByPushNotification,widget.startDate)));
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          //padding: EdgeInsets.only(bottom: 10,top: 10),
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
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width / 3),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Color(0xFFF0F2F5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image.network(
                      productSearch.productImageUrl!,
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
                        productSearch.productName != null ? productSearch.productName! : "",
                        style: ksmallTextBold(kColorBlack),
                      ),
                      SizedBox(height: 5,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/svg/naira.svg",
                            color: kPrimaryColor,
                            width: 10,
                            height: 12,
                          ),
                          Text(
                            productSearch.minPrice.toString(),
                            style: kmediumTextBold(kPrimaryColor),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      Row(
                        children: [
                          Text(
                            "Type: ",
                            style: ksmallTextBold(kColorSmoke2),
                          ),
                          Text(
                            productSearch.genericName != null ? productSearch.genericName! : "",
                            style: ksmallTextBold(kColorSmoke2),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Row(
                        children: [
                          Text(
                            "Manufacturer",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 13,
                                color: kColorSmoke2,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w400),
                          ),
                          Expanded(
                            child: Text(
                              ": " + productSearch.manufacturer!,
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 13,
                                  color: kColorSmoke2,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () {
                          int index = list.indexOf(productSearch);
                          createWishlist(productSearch.productId!, index);
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(180),
                            color: kColorSmoke.withOpacity(.2),
                          ),
                          child: SvgPicture.asset(
                            "assets/svg/love.svg",
                            color: kColorWhite,
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ))
                ],
              ),
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap:(){
                      addToCart(productSearch.productId!);
                    },
                    child: Container(
                      width: 70,
                      height: 45,
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
                    ),
                  ))
            ],
          ),
        ),
      );

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

  void searchProducts(String txt) {
    print("We are In now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.searchProducts(txt).then((value) => output(value));
  }

  void output(String body) {
    print("We are In faq now...");
    print(body);
    if (body.contains("Network Error")) {
      _showMessage("Network Error");
    } else {
      var bodyT = jsonDecode(body);
      if (bodyT["message"] == "Successful") {
        var data = json.decode(body);
        dynamic data2 = data;
        print("In now .........");
        print(data2);
        dynamic value = data["data"]["value"];
        list.clear();
        setState(() {
          isLoading = false;
          list = value
              .map<ProductSearch>((element) => ProductSearch.fromJson(element))
              .toList();
        });
        if (list.isEmpty) {
          setState(() {
            isLoading = false;
            searchIsEmpty = true;
          });
        }
      } else {
        _showMessage(bodyT["message"]);
      }
    }
  }


  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            print("Okay now we are in speech territory");
            print(_text);
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
            setState(() {
              isLoading = true;
            });
            searchProducts(_text);
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }


  void addToCart(int productId) {
    print("We are In Add to cart now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.addToCart(productId,1).then((value) => addCartOutput(value));
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


  void createWishlist(int productId,int currentIndex) {
    print("We are In now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.createWishList(2, productId).then((value) => outputx(value,currentIndex));
  }

  void outputx(String body,int currentIndex) {
    print("Added to wishlist now ...");
    var bodyT = jsonDecode(body);
    print(bodyT);
    _showMessage(bodyT["message"]);
    if (bodyT["status"] == true) {
      var data = json.decode(body);
      dynamic data2 = data;
      //print(data2);
      setState(() {
        list[currentIndex].addedToWishList = true;
      });
    }
  }


}
