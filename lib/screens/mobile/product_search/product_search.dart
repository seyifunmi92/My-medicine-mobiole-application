import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mymedicinemobile/constants.dart';
import 'package:mymedicinemobile/models/models.dart';
import 'package:mymedicinemobile/reusables/bars.dart';
import 'package:mymedicinemobile/screens/mobile/cart/cart.dart';
import 'package:mymedicinemobile/screens/mobile/product_search/similar_products.dart';
import 'package:mymedicinemobile/text_style.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ProductSearch1 extends StatefulWidget {
  const ProductSearch1({Key? key}) : super(key: key);
  @override
  _ProductSearch createState() => _ProductSearch();
}

class _ProductSearch extends State<ProductSearch1> {
  bool value = false;
  bool productShow = false;
  bool searchIsEmpty = false;
  TextEditingController searchC = TextEditingController();

  bool _hasSpeech = false;
  bool _logEvents = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = '';
  String lastError = '';
  String lastStatus = '';
  String _currentLocaleId = '';

  // List<LocaleName> _localeNames = [];
  // final SpeechToText speech = SpeechToText();

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

  List<CartModel> list2 = [
    CartModel(
        name: "Mushrooms Herb- Energy for men",
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
        name: "Mushrooms Herb- Energy for men",
        price: "10,500",
        quantity: 0,
        isChecked: false,
        image: "assets/images/product_search.png"),
  ];

  void initiateSpeech() async {
    bool available = await speech.initialize(
        onStatus: statusListener, onError: errorListener);
    if (available) {
      print("Speech is ready now for listening");
    } else {
      print("The user has denied the use of speech recognition.");
    }
  }

  @override
  void initState() {
    initiateSpeech();
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
          child: ListView(
            children: [
              navBarOnlyCart("", context, Cart(), false),
              const SizedBox(
                height: 10,
              ),
              Container(
                color: Color(0xFFF8F5FC),
                width: width,
                height: 45,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: kColorWhite,
                  border: Border.all(
                      color: kColorSmoke, width: 1, style: BorderStyle.solid),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        onChanged: (text) {
                          if (text.isNotEmpty) {
                            print(text);
                            bool exists = isDataExist(text);
                            if (exists) {
                              setState(() {
                                productShow = true;
                              });
                            } else {
                              setState(() {
                                searchIsEmpty = true;
                                productShow = false;
                                trackList.clear();
                              });
                            }
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
                    const SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {
                        print("Clicked now ");
                        speech.listen(onResult: resultListener);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/svg/mic_home.svg",
                            color: kColorSmoke,
                            width: 14,
                            height: 16,
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
              searchIsEmpty == true
                  ? Container(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Ooops! No results for ${searchC.text}",
                            style: kmediumText(kColorBlack),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text("Please check your spelling for typing errors",
                              style: ksmallTextBold(kColorBlack)),
                          Text(
                              "It’s possible that the product is not available",
                              style: ksmallTextBold(kColorBlack)),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              padding: const EdgeInsets.symmetric(
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
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Similar Products",
                                  style: ksmallMediumText(kColorBlack),
                                ),
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SimilarProducts()));
                                    },
                                    child: Text(
                                      "View all",
                                      style: ksmallTextBold(kPrimaryColor),
                                    ))
                              ],
                            ),
                          ),
                          ...list2.map((e) => cartCustom(e)),
                        ],
                      ),
                    )
                  : const Text(""),
              Visibility(
                  visible: productShow,
                  child: Column(
                    children: [...trackList.map((e) => cartCustom(e))],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  checkboxChanged(bool value) {}
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

  void resultListener(SpeechRecognitionResult result) {
    print(
        'Result listener final: ${result.finalResult}, words: ${result.recognizedWords}');
    setState(() {
      lastWords = '${result.recognizedWords} - ${result.finalResult}';
    });
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    // _logEvent('sound level $level: $minSoundLevel - $maxSoundLevel ');
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    print('Received error status: $error, listening: ${speech.isListening}');
    setState(() {
      lastError = '${error.errorMsg} - ${error.permanent}';
    });
  }

  void statusListener(String status) {
    print(
        'Received listener status: $status, listening: ${speech.isListening}');
    setState(() {
      lastStatus = '$status';
    });
  }

  Widget cartCustom(CartModel cartModel) => Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        //spadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                const SizedBox(
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
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cartModel.name,
                      style: ksmallTextBold(kColorBlack),
                    ),
                    Text(
                      " N " + cartModel.price,
                      style: kmediumTextBold(kPrimaryColor),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Row(
                      children: [
                        Text(
                          "Type",
                          style: ksmallTextBold(kColorSmoke2),
                        ),
                        Text(
                          " Capsule" + cartModel.price,
                          style: ksmallTextBold(kColorSmoke2),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          "Manufacturer",
                          style: ksmallTextBold(kColorSmoke2),
                        ),
                        Text(
                          ": Emzor",
                          style: ksmallTextBold(kColorSmoke2),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        width: 30,
                        height: 30,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(180),
                          color: kColorSmoke.withOpacity(.4),
                        ),
                        child: SvgPicture.asset(
                          "assets/svg/love.svg",
                          color: kColorWhite,
                          width: 20,
                          height: 20,
                        ),
                      ),
                    )
                  ],
                ))
              ],
            ),
            // Positioned(
            //   bottom: 10,
            //   right: 70,
            //   child: Container(
            //     width: 30,
            //     height: 30,
            //     padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(180),
            //       color: kColorSmoke.withOpacity(.4),
            //     ),
            //     child: SvgPicture.asset(
            //       "assets/svg/love.svg",
            //       color: kColorWhite,
            //       width: 20,
            //       height: 20,
            //     ),
            //   ),
            // ),
            Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 70,
                  height: 34,
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
                ))
          ],
        ),
      );
}
