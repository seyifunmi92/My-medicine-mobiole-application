import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mymedicinemobile/constants.dart';
import 'package:mymedicinemobile/models/models.dart';
import 'package:mymedicinemobile/reusables/bars.dart';
import 'package:mymedicinemobile/screens/mobile/checkout/checkout.dart';
import 'package:mymedicinemobile/screens/mobile/my_account/myaccount.dart';
import 'package:mymedicinemobile/screens/mobile/product_details/all_products.dart';
import 'package:mymedicinemobile/screens/mobile/upload_prescription/upload_prescription.dart';
import 'package:mymedicinemobile/services/services.dart';
import 'package:mymedicinemobile/screens/mobile/home_page/homepager.dart';
import 'package:mymedicinemobile/text_style.dart';
import 'package:provider/provider.dart';
import '../../../error_page.dart';
import 'package:mymedicinemobile/screens/mobile/cart/emptycart.dart';
import 'package:mymedicinemobile/screens/mobile/home_page/homepager.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mymedicinemobile/constants.dart';
import 'package:mymedicinemobile/models/models.dart';
import 'package:mymedicinemobile/reusables/bars.dart';
import 'package:mymedicinemobile/screens/mobile/cart/cart.dart';
import 'package:mymedicinemobile/screens/mobile/payment/payment_screen.dart';
import 'package:mymedicinemobile/screens/mobile/product_search/searchProduct.dart';
import 'package:mymedicinemobile/screens/mobile/rating_and_review/ratings.dart';
import 'package:mymedicinemobile/screens/mobile/recently_viewed/recentlyviewed.dart';
import 'package:mymedicinemobile/services/services.dart';
import 'package:mymedicinemobile/text_style.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
//import 'package:share_plus/share_plus.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class Emptycart extends StatefulWidget {
  // int? ID;
  // Emptycart(this.ID);
  // @override
  _EmptycartState createState() => _EmptycartState();
}
class Data{
  String name;
  String _class;
  String level;
  int number = 10;
  int _double = 11;
  double value = 1.9;
  Data(this._class, this.name, this.level, this.number, this._double, this.value);

  // factory.fromJson(){
  //   return json["name "] as String,
@override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }
  }
Future getData()async{}
class _EmptycartState extends State<Emptycart> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<RecentlyViewedModel> recent = [];
  String input = "";
  List data = [];
  bool isConnected = true;
  String errorText = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kBackgroundHome3,
      body:
      // SingleChildScrollView(
      //   scrollDirection: Axis.vertical,
       // child:
        Column(
          children: [
            const SizedBox(height: 40,),
            Container(
              color: Colors.black12,
              height: 50,
              width: 400,
              child: Row(
                children: [
                  const SizedBox(width: 20,),

                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePager()));
                    },
                    child: SvgPicture.asset(
                      "assets/svg/back_arrow.svg",
                      height: 23,
                      color: kPrimaryColor,
                    ),
                  ),
                  const SizedBox(width: 20,),
                  const Text("Cart",
                    style: TextStyle(
                        fontSize: 14,
                        color: kPrimaryColor,
                        fontFamily: "Poppins"),
                  ),
                  const SizedBox(width: 210,),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SearchProducts()));
                    },

                    child: SvgPicture.asset(
                      "assets/svg/search_icon3.svg",
                      height: 20,
                      color: kPrimaryColor,

                    ),

                  ),
                  const SizedBox(width: 20,),
                  InkWell(
                    onTap: () {
                      var countlength = Provider.of<ServiceClass>(context, listen: false).CurrentIndex.toString();
                      print(countlength);
                      print("This is the value of $countlength");
                      //print("This is ${myorder.length}");
                      if(countlength == 0.toString()){
                        //setState(() {
                        //noOrder = true;
                        // print(noOrder);
                        // print("This is $myorder");
                        // print("This is ${myorder.length}");
                        //});
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Emptycart()));
                      }
                      else {
                        print("I am a boy");
                        // setState(() {
                        //   print("I am a boy");
                        //   print(countlength);
                        //   print("This is $countlength");
                        // });
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => Cart()
                        ));
                      }
                    },

                    child: Stack(
                      children: [

                        SvgPicture.asset(
                          "assets/svg/show_cart.svg",
                          height: 28,
                          color: kPrimaryColor,

                        ),
                        const Positioned(
                          right: 0,
                          top: 0,
                          bottom: 15,
                          left: 15,

                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.red,
                            child: Text("O",
                              style: TextStyle(fontSize: 7,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                          ),
                        ),
                        // Positioned(
                        //     top: 0,
                        //     right: 0,
                        //     bottom: 15,
                        //     left: 15,
                        //     child: Container(
                        //       width: 18,
                        //       height: 18,
                        //       decoration: BoxDecoration(
                        //           color: Color(0xFFFF7685),
                        //           borderRadius:
                        //           BorderRadius.circular(
                        //               10)),
                        //       child: Center(
                        //           child: Text(
                        //             Provider
                        //                 .of<ServiceClass>(
                        //                 context)
                        //                 .CurrentIndex
                        //                 .toString(),
                        //             style: ksmallMediumText(
                        //                 kColorWhite,
                        //             ),
                        //           )),
                        //     )),
                      ],
                    ),

                  ),
                ],
              ),
            ),
            const SizedBox(height: 150,),

            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(

                borderRadius: BorderRadius.circular(50),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  // 10% of the width, so there are ten blinds.
                  // ignore: prefer_const_literals_to_create_immutables
                  colors: <Color>[
                    Color(0Xffedf0f5),
                    Color(0xff85a3d4),
                  ], // red to yellow
                  tileMode:
                  TileMode.repeated, // repeats the gradient over the canvas
                ),
              ),
              child: Center(
                child: Stack(
                  children: [
                    SvgPicture.asset(
                      "assets/svg/show_cart.svg",
                      height: 26,
                      color: kPrimaryColor,
                    ),
                    const Positioned(
                      right: 0,
                      top: 0,
                      bottom: 15,
                      left: 15,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.red,
                        child: Text("O",
                          style: TextStyle(fontSize: 7,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      ),
                    ),
                  ],
                ),
              ),
            ),
            // CircleAvatar(
            //   backgroundColor: kCupertinoModalBarrierColor,
            //   radius: 30,
            //  child: InkWell(
            //    onTap: (){},
            //
            //    child: Stack(
            //      children: [
            //
            //
            //        SvgPicture.asset(
            //          "assets/svg/show_cart.svg",
            //          height: 26,
            //          color: kPrimaryColor,
            //
            //        ),
            //        const Positioned(
            //          right: 0,
            //          top: 0,
            //          bottom: 15,
            //          left: 15,
            //
            //          child: CircleAvatar(
            //            radius: 15,
            //            backgroundColor: Colors.red,
            //            child: Text("O",
            //              style: TextStyle(fontSize: 7,
            //                fontWeight: FontWeight.bold,
            //              ),
            //            ),
            //
            //          ),
            //        ),
            //      ],
            //    ),
            //  ),
            // ),

            const SizedBox(height: 20,),

            const Text("Oops!",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.blueGrey,

                  fontFamily: "Poppins"),
            ),
            const SizedBox(height: 5,),
            const Text("No Items in cart",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.blueGrey,
                  fontFamily: "Poppins"),
            ),

            const SizedBox(height: 40,),

            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder :(context)=> AllProducts()));
              },
              child: Container(
                height: 50,
                width: 330,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: kPrimaryColor,
                ),
                child: Center(
                  child: Text("CONTINUE SHOPPING",
                    style: TextStyle(
                        fontSize: 16,
                        color: kColorWhite,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins"),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50,),

            Container(
              color: Colors.white,
              height: 290,
              width: 500,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,

            child:  Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: [],),
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 20,),
                      const Text(
                        "Recently viewed",
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: kColorBlack,
                            fontFamily: "Poppins"),
                      ),
                      const SizedBox(width: 175,),

                      recent.length == 0 ?
                      InkWell(
                        onTap: () {},

                        child: Row(
                          children: const [
                            Text("View more",
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryColor,
                                  fontFamily: "Poppins"),
                            ),
                            Icon(Icons.arrow_forward_ios,
                              size: 10, color: kPrimaryColor,

                            ),
                          ],
                        ),
                      )
                          :
                      const Text("")

                    ],
                  ),

                  const SizedBox(height: 20,),
                  Container(
                    height: 270,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        const SizedBox(
                          width: 20,
                        ),

                        ...recent.map((e) =>
                            mypopularProductsCustom(e.productId!,
                                e.productImage!,
                                e.productDescription!,
                                e.productName!,
                                e.price)),

                        const SizedBox(
                          width: 10,
                        ),
                        // popularProductsCustom(
                        //     "assets/images/product2.png",
                        //     "Boost Immune",
                        //     "Resorb Sport",
                        //     "4,500"),
                        // SizedBox(
                        //   width: 10,
                        // ),
                        // popularProductsCustom(
                        //     "assets/images/product1.png",
                        //     "Skin Glow",
                        //     "Vitamin C serum",
                        //     "6,500"),
                      ],
                    ),
                  ),

                ],
              ),
            ),
            ),
      ],
        ),


      //),
    );
  }


  Widget mypopularProductsCustom(int id,
      String asset, String category, String name, price) {
    double width = MediaQuery
        .of(context)
        .size
        .width / 2.4;
    var formatter = NumberFormat('#,###,000');
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Emptycart()));
      },
      child: Container(
        width: width,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: kColorWhite,
          boxShadow: [
            BoxShadow(
              color: kColorSmoke.withOpacity(.4),
              spreadRadius: 2,
              blurRadius: 12,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: width,
                      height: 150,
                      child: Image.network(
                        asset,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: width,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: kColorWhite,
                      ),
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: "Poppins",
                              fontSize: 12,
                              color: kColorBlack,
                            ),
                            maxLines: 1,
                          ),
                          Text(
                            category,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: "Poppins",
                              fontSize: 12,
                              color: kColorSmoke,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              const Text(
                                "From ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Poppins",
                                  fontSize: 12,
                                  color: kColorBlack,
                                ),
                              ),
                              SvgPicture.asset(
                                "assets/svg/naira.svg", width: 10, height: 10,),
                              Text(
                                price != null ? formatter.format(price) : "",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Poppins",
                                  fontSize: 12,
                                  color: kColorBlack,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                    ),
                  ],
                ),
              ],
            )
        ),
      ),
    );
  }
}
