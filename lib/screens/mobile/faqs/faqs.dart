// ignore_for_file: prefer_const_constructors, unnecessary_new, avoid_print, use_key_in_widget_constructors, annotate_overrides

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mymedicinemobile/constants.dart';
import 'package:mymedicinemobile/models/models.dart';
import 'package:mymedicinemobile/reusables/bars.dart';
import 'package:mymedicinemobile/screens/mobile/cart/cart.dart';
import 'package:mymedicinemobile/services/services.dart';
import 'package:mymedicinemobile/text_style.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class FAQS extends StatefulWidget {
  _FAQS createState() => new _FAQS();
}

class _FAQS extends State<FAQS> with SingleTickerProviderStateMixin{
  bool value = false;
  bool productShow = false;
  TextEditingController searchC = new TextEditingController();

  List<CartModel> trackList = [];
  stt.SpeechToText speech = stt.SpeechToText();
  bool loading = true;
  bool dataLoaded = false;
  late AnimationController _animationController;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<MedFaq> list = [

  ];
  // List<Tiles> list = [
  //   new Tiles(
  //     header: "How do i schedule medicine refill?",
  //     content:
  //         "Sed purus egestas at mauris ullamcorper risus. Nisi non pharetra nisi, nullam nec adipiscing congue volutpat.",
  //   ),
  //   new Tiles(
  //     header: "Can I cancel my refill orders?",
  //     content:
  //         "Sed purus egestas at mauris ullamcorper risus. Nisi non pharetra nisi, nullam nec adipiscing congue volutpat.",
  //   ),
  //   new Tiles(
  //     header: "Can I cancel my refill orders?",
  //     content:
  //         "Sed purus egestas at mauris ullamcorper risus. Nisi non pharetra nisi, nullam nec adipiscing congue volutpat.",
  //   ),
  //   new Tiles(
  //     header: "Can I cancel my refill orders?",
  //     content:
  //         "Sed purus egestas at mauris ullamcorper risus. Nisi non pharetra nisi, nullam nec adipiscing congue volutpat.",
  //   ),
  // ];

  @override
  void initState() {
    // TODO: implement initState

    // TODO: implement initState
    viewFAQs();
    // ignore: unnecessary_new
    _animationController = new AnimationController(
      vsync: this,
      // ignore: unnecessary_new, prefer_const_constructors
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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: [
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
              // ignore: sized_box_for_whitespace
              Container(
                width: width,
                height: height,
                child: Column(
                  children: [

                    navBarFAQ("FAQs",context),
                    SizedBox(
                      height: 10,
                    ),
                    dataLoaded ?  Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        height: height * .83,
                        child: ListView(children: [
                          Container(
                            margin:
                                EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                            child: Text(
                              "Get all the answers to the most frequently asked questions regarding our product",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w400,
                                color: kColorSmoke2,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          ...list.map((e) => expanded(e)),
                        ])) : Center()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget expanded(MedFaq faq) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 1, vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
              width: .4, style: BorderStyle.solid, color: kColorBlack)),
      child: ExpansionTile(
        title: new Text(
          faq.question.toString(),
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
        children: <Widget>[
          Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              // child: Text(
              //   faq.answer.toString(),
              //   style: TextStyle(
              //     fontFamily: "Poppins",
              //     fontWeight: FontWeight.w400,
              //     color: kColorSmoke2,
              //     fontSize: 16,
              //   ),
              // )
            child:Html(data: faq.answer.toString(),)
          ),
        ],
      ),
    );
  }



  void viewFAQs() {
    print("We are In now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.viewFAQS().then((value) => output(value));
  }




  void output(String body) {
    print("We are In faq now...");
    print(body);
    if (body.contains("Network Error")) {
      setState(() {
        loading = false;
        //errorOcurred = true;
      });
    } else {
      var bodyT = jsonDecode(body);
      if (bodyT["status"] == "Successful") {
        var data = json.decode(body);
        dynamic data2 = data;
        print("all man .........");
        print(data2);

        dynamic value = data["data"]["value"];
        //MedFaq medFaq = MedFaq.fromJson(value);
        list= value.map<MedFaq>((element) => MedFaq.fromJson(element)).toList();
        print("WishList");

        setState(() {
          loading = false;
          //errorOcurred = false;
          dataLoaded = true;
        });
      } else {
        _showMessage(bodyT["message"]);
        setState(() {
          loading = false;
          //errorOcurred = true;
        });
      }
    }
  }


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



}

class Tiles {
  String header;
  String content;

  Tiles({required this.header, required this.content});
}
