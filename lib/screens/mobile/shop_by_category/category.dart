// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, unnecessary_new, avoid_print

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mymedicinemobile/constants.dart';
import 'package:mymedicinemobile/models/models.dart';
import 'package:mymedicinemobile/reusables/bars.dart';
import 'package:mymedicinemobile/screens/mobile/cart/cart.dart';
import 'package:mymedicinemobile/screens/mobile/shop_by_category/products.dart';
import 'package:mymedicinemobile/services/services.dart';
import 'package:mymedicinemobile/text_style.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../../error_page.dart';

class Categories extends StatefulWidget {
  _Categories createState() => new _Categories();
}

class _Categories extends State<Categories> with SingleTickerProviderStateMixin{
  bool loading = true;
  bool dataLoaded = false;
  bool errorOcurred = false;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  late AnimationController _animationController;
  List<ProductCategory> list = [];

  @override
  void initState() {
    // TODO: implement initState
    _animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 2),
    );
    _animationController.repeat();

    showProductCategory();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
          child: Stack(children: [
            Container(
              width: width,
              height: height,
              child: Column(
                children: [
                  navBarCustomCartBeforePerson('Categories',context,Cart(),true),

                  SizedBox(
                    height: 10,
                  ),

                  errorOcurred
                      ? errorPage(() {
                    showProductCategory();
                    print("Clicked");
                    setState(() {
                      loading = true;
                      errorOcurred = false;
                    });
                  }) : dataLoaded == false
                      ? Center()
                  : Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    height: height * .83,
                    child: GridView.builder(
                        itemCount: list.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: MediaQuery.of(context).orientation ==
                              Orientation.landscape
                              ? 4
                              : 3,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                          //childAspectRatio: (2 / 1),
                        ),
                        itemBuilder: (context, i) {
                          return categoryCustom(list[i]);
                        }),
                  )
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


          ]),
        ),
      ),
    );
  }

  Widget categoryCustom(ProductCategory productCategory) => InkWell(

    onTap: () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CatProducts()));
    },
    child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        height: 170,
        width: 90,
        decoration: BoxDecoration(
            // boxShadow: [
            //   BoxShadow(
            //     color: kColorSmoke.withOpacity(.4),
            //     spreadRadius: 1,
            //     blurRadius: 7,
            //     offset: Offset(5, 3), // changes position of shadow
            //   ),
            // ],
            color: Color(0xFFECECEE),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            //Image.asset(""),
            SizedBox(height: 5,),
            Text(
              productCategory.name.toString(),
              style: TextStyle(
                  fontSize: 11,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w400,
                  color: kColorBlack),
              textAlign: TextAlign.center,
            ),
          ],
        )),
  );

  void showProductCategory() {
    print("We are In product now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.viewProductCategory().then((value) => categoryOutput(value));
  }

  void categoryOutput(String body) {
    print("We are In category now...");
    print(body);
    if (body.contains("Network Error")) {
      _showMessage("Network Error");
      setState(() {
        loading = false;
        errorOcurred = true;
        dataLoaded = false;
      });
    } else {
      var bodyT = jsonDecode(body);
      if (bodyT["status"]){
        var data = json.decode(body);
        print(data);
        var value = data["data"]["value"];
        print(value);
        dynamic myValue = value;
        print(myValue);
        // dynamic value = data["data"]["value"];
        list = myValue.map<ProductCategory>((element) => ProductCategory.fromJson(element)).toList();
        print(list);
        setState(() {
          loading = false;
          dataLoaded = true;
          errorOcurred = false;
          list[0].clicked = true;
        });
      }
      else {
        _showMessage(bodyT["message"]);
        setState(() {
          loading = false;
          errorOcurred = true;
        });
      }
    }
  }
}
