// ignore_for_file: file_names, prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable, non_constant_identifier_names, unnecessary_new, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

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
import 'package:mymedicinemobile/screens/mobile/product_details/product_details.dart';
import 'package:mymedicinemobile/screens/mobile/product_search/searchProduct.dart';
import 'package:mymedicinemobile/screens/mobile/rating_and_review/ratings.dart';
import 'package:mymedicinemobile/screens/mobile/recently_viewed/recentlyviewed.dart';
import 'package:mymedicinemobile/services/services.dart';
import 'package:mymedicinemobile/text_style.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
//import 'package:share_plus/share_plus.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class RefillProductDetails extends StatefulWidget {
  int ID,refillCycleId;
  bool remindBySMS,remindByEmail, remindByPushNotification;
  String startDate;
  RefillProductDetails(this.ID,this.refillCycleId,this.remindBySMS,this.remindByEmail,this.remindByPushNotification,this.startDate);

  _RefillProductDetails createState() => new _RefillProductDetails();
}
class _RefillProductDetails extends State<RefillProductDetails> with TickerProviderStateMixin {

  late TabController _tabController;
  bool value = false;
  bool productShow = false;
  int currentIndex = 0;
  bool addedToWishList = false;
  TextEditingController searchC = new TextEditingController();
  List<CartModel> trackList = [];
  stt.SpeechToText speech = stt.SpeechToText();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  late ProductDetails? product = null;
  bool loading = true;
  bool dataLoaded = false;
  bool showAdded = false;
  late AnimationController _animationController;
  int productQty = 1;

  int averageRatings = 0;
  int numberOfReviews = 0;

  List<RecentlyViewedModel> recentlyList = [];
  List<MedRating> dataList = [];

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

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );


  @override
  void initState() {
    // TODO: implement initState
    _tabController = new TabController(length: 4, vsync: this);
    _tabController.addListener(() {});

    _animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 2),
    );
    _animationController.repeat();
    print("ID");
    print(widget.ID);
    findProductByID(widget.ID);
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [

              Column(
                children: [

                  navBarSearchCustom('Details', context, Cart(), true),
                  SizedBox(
                    height: 20,
                  ),

                  dataLoaded == false ? Center() :  Container(
                    height: height * .85,
                    child: ListView(
                      children: [

                        Container(
                          width: width * .8,
                          height: 250,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: kColorWhite,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: kColorSmoke.withOpacity(.4),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Container(
                                height: 200,
                                child: PageView(
                                  onPageChanged: (var int) {
                                    setState(() {
                                      currentIndex = int;
                                    });
                                  },
                                  controller: pageController,
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    Image.network(product!.productImageUrl ?? ""),
                                    // Image.asset(
                                    //   "assets/images/details1.png",
                                    //   fit: BoxFit.contain,
                                    // ),
                                    // Image.asset(
                                    //   "assets/images/details2.png",
                                    //   fit: BoxFit.contain,
                                    // ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                left: 20,
                                right: 20,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 5,
                                      width: 80,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          Container(
                                            width: currentIndex == 0 ? 20 : 10,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              color: currentIndex == 0
                                                  ? kPrimaryColor
                                                  : kColorSmoke,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Container(
                                            width: currentIndex == 1 ? 20 : 10,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              color: currentIndex == 1
                                                  ? kPrimaryColor
                                                  : kColorSmoke,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Container(
                                            width: currentIndex == 2 ? 20 : 10,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              color: currentIndex == 2
                                                  ? kPrimaryColor
                                                  : kColorSmoke,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              color: currentIndex == 3
                                                  ? kPrimaryColor
                                                  : kColorSmoke,
                                            ),
                                            width: currentIndex == 3 ? 20 : 10,
                                            height: 5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                          decoration: BoxDecoration(
                            color: kColorWhite,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                color: kColorSmoke.withOpacity(.4),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(product!.name!,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Poppins",
                                          fontSize: 18,
                                          color: kColorBlack,
                                        ),maxLines: 1,overflow: TextOverflow.ellipsis,)
                                  ),
                                  InkWell(
                                    onTap: () {
                                      createWishlist();
                                    },
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(180),
                                        color: addedToWishList
                                            ? kPrimaryColor
                                            : kColorWhite,
                                        boxShadow: [
                                          BoxShadow(
                                            color: kColorSmoke.withOpacity(.4),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(
                                                0, 3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: SvgPicture.asset(
                                        "assets/svg/love_icon.svg",
                                        width: 20,
                                        height: 20,
                                        color: addedToWishList == true ? kColorWhite : kErrorColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text("Product code ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Poppins",
                                        fontSize: 12,
                                        color: kColorBlack.withOpacity(.4),
                                      )),
                                  Text(
                                    product!.universalProductCode ?? "",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Poppins",
                                      fontSize: 13,
                                      color: kColorBlack,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      RatingBar.builder(
                                        itemSize: 20,
                                        initialRating: double.parse("$averageRatings"),
                                        minRating: 0,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding:
                                            EdgeInsets.symmetric(horizontal: 4.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          print(rating);
                                        },
                                      ),
                                      Text(
                                        "( ${dataList.length} Ratings )",
                                        style: ksmallTextBold(kPrimaryColor),
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: (){
                                      Share.share('Check via http://dev.mymedicines.africa/bundle-details/${widget.ID}', subject: '${product!.name},\n ${product!.description}');
                                    },
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(180),
                                        color: kColorWhite,
                                        boxShadow: [
                                          BoxShadow(
                                            color: kColorSmoke.withOpacity(.4),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: SvgPicture.asset(
                                        "assets/svg/share_icon.svg",
                                        width: 20,
                                        height: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Item requires a valid prescription",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text("Package Size: ",
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                            color: kColorSmoke
                                          )),
                                      Text(" ${product!.packSize} bottle",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                              color: kColorBlack
                                          )),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "In Stock",
                                        style : TextStyle(
                                            fontFamily: "Poppins",
                                            color: Color(0xFF07CE29),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11),
                                        //style: ksmallTextBold(Color(0xFF07CE29)),
                                      ),
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: 70
                                        ),
                                        child: Text(
                                            "Mfg: ${product!.manufacturer!}",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                color: kColorSmoke2,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                                fontStyle: FontStyle.italic),
                                          ),
                                      ),

                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                          decoration: BoxDecoration(
                            color: kColorWhite,
                            boxShadow: [
                              BoxShadow(
                                color: kColorSmoke.withOpacity(.4),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "From ",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: kColorBlack.withOpacity(.7),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11),
                                  ),
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/svg/naira.svg",
                                        color: kPrimaryColor,
                                        width: 10,
                                        height: 12,
                                      ),
                                      Text(
                                        " ${product!.minimumPrice}",
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            color: kPrimaryColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Text(
                                    "Quantity",
                                    style:TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Poppins",
                                      fontSize: 11,
                                      color: kColorBlack,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    padding:
                                    EdgeInsets.symmetric(horizontal: .7, vertical: 2),
                                    decoration: BoxDecoration(
                                        color: Color(0xFFECECEC),
                                        borderRadius: BorderRadius.circular(4)),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap:(){
                                            if(productQty > 1){
                                              setState(() {
                                                productQty--;
                                              });
                                            }
                                          },
                                          child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 1),
                                              decoration: BoxDecoration(
                                                  color: kColorWhite,
                                                  borderRadius: BorderRadius.circular(5)),
                                              child: Icon(Icons.remove,size: 15,)),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          productQty.toString(),
                                          style: kmediumTextBold(kColorBlack),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        InkWell(
                                          onTap:(){
                                         setState(() {
                                           productQty++;
                                         });
                                          },
                                          child: Container(

                                              padding: EdgeInsets.symmetric(horizontal: 1),
                                              decoration: BoxDecoration(
                                                  color: kColorWhite,
                                                  borderRadius: BorderRadius.circular(5)),
                                              child: Icon(Icons.add,size: 15)),
                                        ),

                                      ],
                                    ),
                                  ),

                                  SizedBox(width: 20,),

                                ],
                              ),

                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                          decoration: BoxDecoration(
                            color: kColorWhite,
                            boxShadow: [
                              BoxShadow(
                                color: kColorSmoke.withOpacity(.4),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Text("Product Description",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    color: kColorBlack,
                                    fontSize: 14,
                                  )),
                              SizedBox(
                                height: 5,
                              ),
                              Text(product!.description!,
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w400,
                                    color: kColorBlack.withOpacity(.6),
                                    fontSize: 13,
                                  )),
                              SizedBox(
                                height: 5,
                              ),
                              product!.description!.length > 500 ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    child: Text("Read more ...",
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            color: kPrimaryColor)),
                                    onPressed: () {},
                                  )
                                ],
                              ) : Text("")
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          decoration: BoxDecoration(
                            color: kColorWhite,
                            boxShadow: [
                              BoxShadow(
                                color: kColorSmoke.withOpacity(.4),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                constraints: BoxConstraints.expand(height: 50),
                                child: TabBar(
                                  indicatorColor: kPrimaryColor,
                                  tabs: [
                                    Tab(
                                      child: Text(
                                        "Precautions",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w700,
                                          color: kColorBlack,
                                          fontSize: 10,
                                        ),
                                      ),
                                      //text: "Precaution,
                                    ),
                                    Tab(
                                      child: Text(
                                        "How to use",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w700,
                                          color: kColorBlack,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                    Tab(
                                      child: Text(
                                        "Warnings",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w700,
                                          color: kColorBlack,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                    Tab(
                                      child: Text(
                                        "Storage",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w700,
                                          color: kColorBlack,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                  controller: _tabController,
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 17,vertical: 10),
                                      child: TabBarView(
                                          controller: _tabController,
                                          children: [
                                            Container(
                                              child: ListView(
                                                children: [
                                                  Text(
                                                    product!.precautions!,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 12,
                                                        fontFamily: "Poppins",
                                                        color: kColorBlack
                                                            .withOpacity(.6)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              child: ListView(
                                                children: [
                                                  Text(
                                                    product!.howToUse!,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 12,
                                                        fontFamily: "Poppins",
                                                        color: kColorBlack
                                                            .withOpacity(.6)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              child: ListView(
                                                children: [
                                                  Text(
                                                    product!.warning != null ?  product!.warning! : "",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 12,
                                                        fontFamily: "Poppins",
                                                        color: kColorBlack
                                                            .withOpacity(.6)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              child: ListView(
                                                children: [
                                                  Text(
                                                    product!.storage!,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 12,
                                                        fontFamily: "Poppins",
                                                        color: kColorBlack
                                                            .withOpacity(.6)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ]))),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),


                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: kColorWhite,
                            boxShadow: [
                              BoxShadow(
                                color: kColorSmoke.withOpacity(.4),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text('Product Rating & Review',
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w600,
                                            color:kColorBlack,
                                            fontSize: 12,
                                          )),
                                    ],
                                  ),
                                  dataList.length >1 ? TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RatingsReview(widget.ID,false)));
                                      },
                                      child: Text('View more')):Text(""),

                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ...dataList.map((e) => ratingCustom(
                                  e.reviewer!,
                                  e.reviewDate!,
                                  e.comments!,
                                  e.comments!,
                                  e.reviewer!,
                                  e.rating!)),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                          decoration: BoxDecoration(
                            color: kColorWhite,
                            boxShadow: [
                              BoxShadow(
                                color: kColorSmoke.withOpacity(.4),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Shipping Policy",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: kPrimaryColor,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: SvgPicture.asset(
                                        "assets/svg/shipping_policy.svg",
                                        width: 10,
                                        height: 10),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                        "Shipping fee is calculated at checkout and orders fufilled by multiple pharmacies may attract \nadditional shipping fee",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          fontSize: 11,
                                        )),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                          decoration: BoxDecoration(
                            color: kColorWhite,
                            boxShadow: [
                              BoxShadow(
                                color: kColorSmoke.withOpacity(.4),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Return Policy",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: kPrimaryColor,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: SvgPicture.asset(
                                        "assets/svg/return_policy.svg",
                                        width: 10,
                                        height: 10),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                        "Items can only be returned or exchanged before 2 calendar days",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          fontSize: 11,
                                        )),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 360,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            color: kColorWhite,
                            boxShadow: [
                              BoxShadow(
                                color: kColorSmoke.withOpacity(.4),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Recently Viewed",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: kColorBlack,
                                    ),
                                  ),
                                  recentlyList.length > 1 ?   InkWell(
                                    onTap: (){
                                      Navigator.push(context,MaterialPageRoute(builder: (context) => RecentlyViewed()));
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          "View more",
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400,
                                            color: kPrimaryColor,
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: kPrimaryColor,
                                          size: 10,
                                        )
                                      ],
                                    ),
                                  ):Text(""),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: 270,
                                width: MediaQuery.of(context).size.width,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                    ),

                                    ...recentlyList.map((e) => popularProductsCustom(e.productId!,
                                        e.productImage!,
                                        e.productDescription!,
                                        e.productName!,
                                        e.price)),

                                    SizedBox(
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
                        SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: kColorWhite,
                  width: width,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: InkWell(
                      onTap: (){
                        //addRefill();

                        RefillObj refillObj = new RefillObj(
                          productId: product!.id,
                          productName: product!.name!,
                          productImage: product!.productImageUrl!,
                          price: double.parse(product!.minimumPrice.toString()),
                            quantity: productQty
                        );

                        Provider.of<ServiceClass>(context, listen: false).notifyRefill(refillObj);
                        setState(() {
                          showAdded = true;
                        });

                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(5)
                        ),
                        padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                          SizedBox(width: 20,),
                            // Row(
                            //   children: [
                            //     SizedBox(
                            //       width: 20,
                            //     ),
                            //     SvgPicture.asset(
                            //       "assets/svg/cart_add.svg",
                            //       color: kColorWhite,
                            //       width: 22,
                            //       height: 22,
                            //     ),
                            //   ],
                            // ),

                            Text('ADD TO REFILL',style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: kColorWhite,
                            ),),
                            SizedBox(
                              width: 30,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),



              Visibility(
                visible: showAdded,
                child: Positioned(
                  top: 40,
                  child: Container(
                    color: Color(0xFF4CD964),
                    height: 50,
                    width: width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Row(
                          children: [
                            SizedBox(
                              width: 40,
                            ),
                            Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(180),
                                    border: Border.all(
                                        color: kColorWhite,
                                        width: 1,
                                        style: BorderStyle.solid)),
                                child:
                                    SvgPicture.asset("assets/svg/checkmark.svg")),

                            SizedBox(
                              width: 10,
                            ),
                            Text(product != null ? product!.name! + " added to refill" : "" ,
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: kColorWhite,
                                )),

                          ],
                        ),


                        Row(
                          children: [
                            InkWell(onTap: (){setState(() {
                              showAdded = false;
                            });},child: Icon(Icons.clear,color: kColorWhite,)),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),




              Visibility(
                  visible: loading,
                  child: Container(
                    width: width,
                    height: height,
                    color: Color(0xFF000000).withOpacity(0.3),
                    child: Center(
                      child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            //color: kColorWhite,
                              borderRadius: BorderRadius.circular(5)),
                          child: AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: _animationController.value * 2 * pi,
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
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget popularProductsCustom(int id,
      String asset, String category, String name, price) {

    double width = MediaQuery.of(context).size.width / 2.4;
    var formatter = NumberFormat('#,###,000');
    return InkWell(
      onTap: () {

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductID(id)));

      },
      child: Container(
        width: width,
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: kColorWhite,
          boxShadow: [
            BoxShadow(
              color: kColorSmoke.withOpacity(.4),
              spreadRadius: 2,
              blurRadius: 12,
              offset: Offset(0, 3), // changes position of shadow
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
                    padding: EdgeInsets.symmetric(horizontal: 10),
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
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          name,
                          style: TextStyle(
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
                            Text(
                              "From ",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: "Poppins",
                                fontSize: 12,
                                color: kColorBlack,
                              ),
                            ),
                            SvgPicture.asset("assets/svg/naira.svg",width: 10,height: 10,),
                            Text(
                                price != null ? formatter.format(price) : "",
                              style: TextStyle(
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
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: (){
                          addRecentToCart(id);
                        },
                        child: Container(
                          width: 60,
                          height: 30,
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
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget ratingCustom(String initials, String date, String subject, String text,
          String poster, int rating) =>
      Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          color: Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(initials.substring(0, 2),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: "Poppins",
                        fontSize: 12,
                        color: kColorWhite,
                      )),
                ),
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    subject,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: "Poppins",
                      fontSize: 12,
                      color: kColorBlack,
                    ),
                  ),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //
                  //     // SizedBox(
                  //     //   width: 50,
                  //     // ),
                  //
                  //   ],
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  RatingBar.builder(
                    itemSize: 10,
                    initialRating: double.parse(rating.toString()),
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    text,
                    style: ksmallTextBold(kColorBlack),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        poster,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                          fontSize: 12,
                          color: kColorSmoke2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

             Text(
                date.split("T")[0],
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: "Poppins",
                  fontSize: 11,
                  color: kColorSmoke2,
                ),
              )

          ],
        ),
      );

  void findProductByID(int id) {
    print("We are In now...");
    print("This the ID .... $id");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.viewProductByID(id).then((value) => productOutput(value));
    serviceClass.getRatings(widget.ID, false).then((value) => outputRating(value));
    serviceClass.avgRatings(widget.ID,false).then((value) => avgRatingOutput(value));
    serviceClass.allRecentlyViewed().then((value) => outputRecenttlyViewed(value));
  }

  void addToCart() {
    print("We are In Add to cart now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.addToCart(widget.ID,productQty).then((value) => addCartOutput(value));
  }


  void addRecentToCart(int id) {
    print("We are In Add to cart now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.addToCart(id,1).then((value) => addCartOutput(value));
  }

  void outputRecenttlyViewed(String body) {
    print("We are In second haven now...");
    print(body);
    if (body.contains("Network Error")) {

    } else {
      var bodyT = jsonDecode(body);
      if (bodyT["status"] == "Successful") {
        var data = json.decode(body);
        dynamic data2 = data["data"]["value"];
        print("This is recently viewed now");
        print(data2);
        //print("Recently Viewed");
        setState(() {
          recentlyList = data2.map<RecentlyViewedModel>((element) => RecentlyViewedModel.fromJson(element)).toList();
        });
      } else {
      }
    }
  }


  void addCartOutput(String body) {
    print("Whats is wrong bruv");
    print(body);
    if (body.contains("Network Error")) {
      _showMessage("Network Error");
    } else {
      var bodyT = jsonDecode(body);
      _showMessage(bodyT["message"]);
      setState(() {
        showAdded = true;
      });
      Provider.of<ServiceClass>(context, listen: false).increaseCart();
    }
  }



  void outputRating(String body) {
    print("We are In second haven now...");
    print(body);
    if (body.contains("Network Error")) {
    } else {
      var bodyT = jsonDecode(body);
      if (bodyT["status"] == "Successful") {
        var data = json.decode(body);
        dynamic data2 = data["data"]["value"];
        print("We are in ratings and review");
        print(data);
        print("We are in ratings and review");
        print(data2);

        setState(() {
          dataList = data2
              .map<MedRating>((element) => MedRating.fromJson(element))
              .toList();
        });
      } else {}
    }
  }

  void productOutput(String body) {
    print("We are In products now...");
    print(body);
    if (body.contains("Network Error")) {
      _showMessage("Network Error");
      setState(() {
        loading = false;
      });
    } else {
      var bodyT = jsonDecode(body);
      if (bodyT["message"] == "Successful") {
        var data = json.decode(body);
        dynamic data2 = data;
        print("In now .........");
        print(data2);
        dynamic value = data["data"];
        setState(() {
          product = ProductDetails.fromJson(value);
          print(product!.brandName);
          loading = false;
          dataLoaded = true;
        });
      } else {
        _showMessage(bodyT["message"]);
      }
    }
  }

  void createWishlist() {
    print("We are In now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.createWishList(2, product!.id!).then((value) => output(value));
  }

  void output(String body) {
    print("We are In second  now...");
    var bodyT = jsonDecode(body);
    print(bodyT);
    _showMessage(bodyT["message"]);
    if (bodyT["status"]) {

      setState(() {
        addedToWishList = true;
      });
      print("Added to wishlist");
    }
  }



  void avgRatingOutput(String body) {
    print("We are In second haven now...");
    print(body);
    if (body.contains("Network Error")) {

    } else {
      var bodyT = jsonDecode(body);
      if (bodyT["status"] == "Successful") {
        var data = json.decode(body);
        dynamic data2 = data["data"];
        print("all man .........");
        print(data2);

        setState(() {
          if(data2 != null) {
            averageRatings = data2["averageRatings"];
            numberOfReviews = data2["numberOfReviews"];
          }
        });

      } else {

      }
    }
  }


  void addRefill() {
    print("We are In AddRefill now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.addRefillMedicine(widget.ID,widget.startDate, widget.refillCycleId, 2, widget.remindBySMS, widget.remindByEmail, widget.remindByPushNotification, "2021-10-17T19:31:39.505Z").then((value) => addRefillOutput(value));
  }

  void addRefillOutput(String body) {

    print("Whats is wrong bruv");
    print(body);
    if (body.contains("Network Error")) {
      _showMessage("Network Error");
    } else {
      var bodyT = jsonDecode(body);
      if (bodyT["status"] == "Successful") {
        _showMessage(bodyT["message"]);
        setState(() {
          showAdded = true;
        });

        print("Crase ...... Boy dey come .......(((((((((((((((((");
        Navigator.pop(context);

      } else {
        _showMessage(bodyT["message"]);
      }
    }
  }


}
