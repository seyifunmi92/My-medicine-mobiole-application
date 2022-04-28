
// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mymedicinemobile/constants.dart';
import 'package:mymedicinemobile/models/models.dart';
import 'package:mymedicinemobile/reusables/bars.dart';
import 'package:mymedicinemobile/screens/mobile/cart/cart.dart';
import 'package:mymedicinemobile/services/services.dart';
import 'package:provider/provider.dart';

import '../../../text_style.dart';
import 'bundles_details.dart';


class AllBundles extends StatefulWidget {
  @override
  _AllBundlesState createState() => _AllBundlesState();
}

class _AllBundlesState extends State<AllBundles>
    with SingleTickerProviderStateMixin{

  bool loading = true;
  bool dataLoaded = false;
  late AnimationController _animationController;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Bundles> list = [];

  @override
  void initState() {

    _animationController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 3));
    _animationController.repeat();

    viewBundles();
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kColorWhite,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: [


              Container(
                child: Column(
                  children: [
                    navBarCustomCartBeforeFilter('Bundle Products',context,Cart(),true),
                    Container(
                      height: height * .9,
                      child: ListView(
                        children: [
                          ...list.map((e) => bundleCustom(e)),
                        ],
                      ),
                    ),

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

              // Container(
              //   child: Column(
              //     children: [
              //       navBarCustomCartBeforePerson('Bundles',context,Cart(),true),
              //       SizedBox(
              //         height: 50,
              //       ),
              //       ...list.map((e) => bundleCustom(e)),
              //     ],
              //   ),
              // ),


            ],
          ),
        ),
      ),
    );
  }

  Widget bundleCustom (Bundles bundles) => InkWell(
    onTap: () {
      print("Pressed ........");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  BundleID(bundles.id!)));
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
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${bundles.bundleName}',style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins",
                    fontSize: 14,
                    color: kColorBlack),),
                InkWell(
                  onTap: (){
                    addToCart(bundles.id!);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: kPrimaryColor,width: 1)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Add to Cart',style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                          fontSize: 13,
                          color: kPrimaryColor),),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Text("Shop for discounted bundle from ",style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins",
                    fontSize: 12,
                    color: kColorSmoke2.withOpacity(.7)),),
                //Text(bundles.price.toString(),style: TextStyle(color: kPrimaryColor),)
              ],
            ),
            SizedBox(height: 10,),
            Image.network(
              bundles.bundleImageUrl!,
              fit: BoxFit.contain,
            ),
          ],
        ),
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

  void viewBundles() {
    print("We are In now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.viewAllBundles().then((value) => output(value));
  }

  void output(String body) {
    print("We are In bundles now...");
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
        list = value
            .map<Bundles>((element) => Bundles.fromJson(element)).toList();
        setState(() {
          loading = false;
          dataLoaded = true;
        });
      } else {
        _showMessage(bodyT["message"]);
        setState(() {
          loading = false;

        });
      }
    }
  }


  void addToCart(int id) {
    print("We are In Add to cart now...");
    print("Bundle ID --- $id");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.addBundleToCart(id,1).then((value) => addCartOutput(value));
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


}
