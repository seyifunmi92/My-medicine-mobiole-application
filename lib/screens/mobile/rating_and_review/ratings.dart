import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mymedicinemobile/constants.dart';
import 'package:mymedicinemobile/models/models.dart';
import 'package:mymedicinemobile/reusables/bars.dart';
import 'package:mymedicinemobile/screens/mobile/cart/cart.dart';
import 'package:mymedicinemobile/services/services.dart';
import 'package:mymedicinemobile/text_style.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../../error_page.dart';

class RatingsReview extends StatefulWidget {
  int id;
  bool isBundle;
  RatingsReview(this.id, this.isBundle);
  _RatingsReview createState() => new _RatingsReview();
}

class _RatingsReview extends State<RatingsReview>
    with SingleTickerProviderStateMixin {
  bool value = false;
  bool productShow = false;
  TextEditingController searchC = new TextEditingController();
  late AnimationController _animationController;
  RatingL rating = new RatingL();

  int averageRatings = 0;
  int numberOfReviews = 0;

  late List<MedRating> dataList = [];

  bool loading = true;
  bool errorOcurred = false;
  bool dataLoaded = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _showMessage(String message,
      [Duration duration = const Duration(seconds: 4)]) {
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
    // TODO: implement initState
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _animationController.repeat();

    viewRatings();
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
      body: SafeArea(
        child: Container(
          width: width,
          height: height,
          child: Stack(
            children: [
              errorOcurred
                  ? errorPage(() {
                      // viewWishlist();
                      // print("Clicked");
                      // setState(() {
                      //   loading = true;
                      //   errorOcurred = false;
                      // });
                    })
                  : dataLoaded == false
                      ? Center()
                      : Column(
                          children: [
                            navBarSearchCustom(
                                "Rating & Reviews", context, Cart(), true),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: kColorWhite,
                              ),
                              child: Column(
                                children: [],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: height * .83,
                              child: ListView(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 5),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 25, horizontal: 5),
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: kColorSmoke.withOpacity(.2),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                        color: kColorWhite,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                                "Product Rating( ${dataList.length} ratings )",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  fontFamily: "Poppins",
                                                  color: kColorBlack,
                                                )),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(""),
                                            Column(
                                              //mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 2,
                                                      horizontal: 20),
                                                  decoration: BoxDecoration(
                                                      color: kPrimaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "${averageRatings}",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Poppins",
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: kColorWhite),
                                                      ),
                                                      SvgPicture.asset(
                                                        "assets/svg/star_rating.svg",
                                                        color: kColorWhite,
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                // Text(
                                                //   "Rated by ${dataList.length} people",
                                                //   style: TextStyle(
                                                //       fontFamily: "Poppins",
                                                //       fontSize: 14,
                                                //       fontWeight: FontWeight.w400,
                                                //       color: kColorBlack.withOpacity(.6)),
                                                // ),
                                              ],
                                            ),
                                            Container(
                                              width: width / 2,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Text(
                                                        "5",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Poppins",
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: kColorBlack
                                                                .withOpacity(
                                                                    .6)),
                                                      ),
                                                      SizedBox(
                                                        width: 2,
                                                      ),
                                                      SvgPicture.asset(
                                                        "assets/svg/star_rating.svg",
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Container(
                                                        width: width / 3.2,
                                                        child:
                                                            LinearProgressIndicator(
                                                          backgroundColor:
                                                              Colors.white,
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                  Color>(
                                                            kPrimaryColor,
                                                          ),
                                                          value: double.parse(rating
                                                                  .star5
                                                                  .toString()) /
                                                              10.0,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "(${rating.star5!})",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Poppins",
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: kColorBlack
                                                                .withOpacity(
                                                                    .6)),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Text(
                                                        "4",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Poppins",
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: kColorBlack
                                                                .withOpacity(
                                                                    .6)),
                                                      ),
                                                      SizedBox(
                                                        width: 2,
                                                      ),
                                                      SvgPicture.asset(
                                                        "assets/svg/star_rating.svg",
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Container(
                                                        width: width / 3.2,
                                                        child:
                                                            LinearProgressIndicator(
                                                          backgroundColor:
                                                              Colors.white,
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                  Color>(
                                                            kPrimaryColor,
                                                          ),
                                                          value: double.parse(rating
                                                                  .star4
                                                                  .toString()) /
                                                              10.0,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "(${rating.star4})",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Poppins",
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: kColorBlack
                                                                .withOpacity(
                                                                    .6)),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Text(
                                                        "3",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Poppins",
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: kColorBlack
                                                                .withOpacity(
                                                                    .6)),
                                                      ),
                                                      SizedBox(
                                                        width: 2,
                                                      ),
                                                      SvgPicture.asset(
                                                        "assets/svg/star_rating.svg",
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Container(
                                                        width: width / 3.2,
                                                        child:
                                                            LinearProgressIndicator(
                                                          backgroundColor:
                                                              Colors.white,
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                  Color>(
                                                            kPrimaryColor,
                                                          ),
                                                          value: double.parse(rating
                                                                  .star3
                                                                  .toString()) /
                                                              10.0,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "(${rating.star3})",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Poppins",
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: kColorBlack
                                                                .withOpacity(
                                                                    .6)),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Text(
                                                        "2",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Poppins",
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: kColorBlack
                                                                .withOpacity(
                                                                    .6)),
                                                      ),
                                                      SizedBox(
                                                        width: 2,
                                                      ),
                                                      SvgPicture.asset(
                                                        "assets/svg/star_rating.svg",
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Container(
                                                        width: width / 3.2,
                                                        child:
                                                            LinearProgressIndicator(
                                                          backgroundColor:
                                                              Colors.white,
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                  Color>(
                                                            kPrimaryColor,
                                                          ),
                                                          value: double.parse(rating
                                                                  .star2
                                                                  .toString()) /
                                                              10.0,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "(${rating.star2})",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Poppins",
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: kColorBlack
                                                                .withOpacity(
                                                                    .6)),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Text(
                                                        "1",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Poppins",
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: kColorBlack
                                                                .withOpacity(
                                                                    .6)),
                                                      ),
                                                      SizedBox(
                                                        width: 2,
                                                      ),
                                                      SvgPicture.asset(
                                                        "assets/svg/star_rating.svg",
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Container(
                                                        width: width / 3.2,
                                                        child:
                                                            LinearProgressIndicator(
                                                          backgroundColor:
                                                              Colors.white,
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                  Color>(
                                                            kPrimaryColor,
                                                          ),
                                                          value: double.parse(rating
                                                                  .star1
                                                                  .toString()) /
                                                              10.0,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "(${rating.star1})",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Poppins",
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: kColorBlack
                                                                .withOpacity(
                                                                    .6)),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),

                                  ...dataList.map((e) => ratingCustom(
                                      e.reviewer!,
                                      e.reviewDate!,
                                      e.comments!,
                                      e.comments!,
                                      e.reviewer!,
                                      e.rating!)),

                                  //...list.map((e) => cartCustom(e)),
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

  void viewRatings() {
    print("We are In now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass
        .getRatings(widget.id, widget.isBundle)
        .then((value) => output(value));
    serviceClass
        .avgRatings(widget.id, widget.isBundle)
        .then((value) => output2(value));
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
        print("all man .........");
        print(data2);

        dataList = data2
            .map<MedRating>((element) => MedRating.fromJson(element))
            .toList();
        RatingL ratingx =
            new RatingL(star1: 0, star2: 0, star3: 0, star4: 0, star5: 0);
        if (dataList.isNotEmpty) {
          for (int x = 0; x < dataList.length; x++) {
            if (dataList[x].rating == 5) {
              ratingx.star5 = ratingx.star5! + 1;
            } else if (dataList[x].rating == 4) {
              ratingx.star4 = ratingx.star4! + 1;
            } else if (dataList[x].rating == 3) {
              ratingx.star3 = ratingx.star3! + 1;
            } else if (dataList[x].rating == 2) {
              ratingx.star2 = ratingx.star2! + 1;
            } else if (dataList[x].rating == 1) {
              ratingx.star1 = ratingx.star1! + 1;
            }
          }
        }

        setState(() {
          this.rating = ratingx;
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

  void output2(String body) {
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
          averageRatings = data2["averageRatings"];
          numberOfReviews = data2["numberOfReviews"];
        });
      } else {}
    }
  }
}

class RatingL {
  int? star1 = 0;
  int? star2 = 0;
  int? star3 = 0;
  int? star4 = 0;
  int? star5 = 0;

  RatingL({this.star1, this.star2, this.star3, this.star4, this.star5});
}
