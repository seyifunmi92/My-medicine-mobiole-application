import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mymedicinemobile/constants.dart';
import 'package:mymedicinemobile/models/models.dart';
import 'package:mymedicinemobile/reusables/bars.dart';
import 'package:mymedicinemobile/screens/mobile/cart/cart.dart';
import 'package:mymedicinemobile/screens/mobile/medicine_refill/medicine_refill.dart';
import 'package:mymedicinemobile/screens/mobile/rating_and_review/ratings.dart';
import 'package:mymedicinemobile/services/services.dart';
import 'package:mymedicinemobile/text_style.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ProductDetails2 extends StatefulWidget {
  int ID;
  ProductDetails2(this.ID, {Key? key}) : super(key: key);
  @override
  _ProductDetails2 createState() => _ProductDetails2();
}

class _ProductDetails2 extends State<ProductDetails2>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool value = false;
  bool productShow = false;
  int currentIndex = 0;
  TextEditingController searchC = TextEditingController();
  List<CartModel> trackList = [];
  stt.SpeechToText speech = stt.SpeechToText();
  bool addedToWishList = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late ProductDetails product;
  String productName = "";
  bool loading = true;
  bool showAdded = false;
  late AnimationController _animationController;
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

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );
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
  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {});
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animationController.repeat();
    finfProductByID(widget.ID);
    super.initState();
  }

  @override
  void dispose() {
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
        child: Container(
          width: width,
          height: height,
          child: Stack(
            children: [
              Column(
                children: [
                  navBarSearchCustom("Details", context, Cart(), true),
                  if (loading == true)
                    Center()
                  else
                    Container(
                      height: height * .86,
                      child: ListView(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),

                          // Container(
                          //   width: width,
                          //   height: 60,
                          //   margin: EdgeInsets.symmetric(horizontal: 10),
                          //   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(5),
                          //     color: kColorWhite,
                          //     border: Border.all(
                          //         color: kColorSmoke, width: 1, style: BorderStyle.solid),
                          //   ),
                          //   child: PageView(
                          //     children: [
                          //
                          //     ],
                          //   ),
                          // ),
                          Container(
                            width: width * .6,
                            height: 250,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              color: kColorWhite,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: kColorSmoke.withOpacity(.4),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
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
                                      Image.asset(
                                        "assets/images/details3.png",
                                        fit: BoxFit.contain,
                                      ),
                                      Image.asset(
                                        "assets/images/details1.png",
                                        fit: BoxFit.contain,
                                      ),
                                      Image.asset(
                                        "assets/images/details2.png",
                                        fit: BoxFit.contain,
                                      ),
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
                                              width:
                                                  currentIndex == 0 ? 20 : 10,
                                              height: 5,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10)),
                                                color: currentIndex == 0
                                                    ? kPrimaryColor
                                                    : kColorSmoke,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            Container(
                                              width:
                                                  currentIndex == 1 ? 20 : 10,
                                              height: 5,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10)),
                                                color: currentIndex == 1
                                                    ? kPrimaryColor
                                                    : kColorSmoke,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            Container(
                                              width:
                                                  currentIndex == 2 ? 20 : 10,
                                              height: 5,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10)),
                                                color: currentIndex == 2
                                                    ? kPrimaryColor
                                                    : kColorSmoke,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10)),
                                                color: currentIndex == 3
                                                    ? kPrimaryColor
                                                    : kColorSmoke,
                                              ),
                                              width:
                                                  currentIndex == 3 ? 20 : 10,
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
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            decoration: BoxDecoration(
                              color: kColorWhite,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                  color: kColorSmoke.withOpacity(.4),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
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
                                      child: Text(product.name!,
                                          style: klargeText(kColorBlack)),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        createWishlist();
                                      },
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(180),
                                          color: addedToWishList
                                              ? kPrimaryColor
                                              : kColorWhite,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  kColorSmoke.withOpacity(.4),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: const Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: SvgPicture.asset(
                                          "assets/svg/love_icon.svg",
                                          width: 20,
                                          height: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text("Product code ",
                                        style: ksmallTextBold(kColorSmoke)),
                                    Text(
                                      product.universalProductCode ?? "",
                                      style: ksmallTextBold(kColorBlack),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        RatingBar.builder(
                                          itemSize: 20,
                                          initialRating: 4,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 4.0),
                                          itemBuilder: (context, _) =>
                                              const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {
                                            print(rating);
                                          },
                                        ),
                                        Text(
                                          "( 10 Ratings )",
                                          style: ksmallTextBold(kPrimaryColor),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: 30,
                                      height: 30,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(180),
                                        color: kColorWhite,
                                        boxShadow: [
                                          BoxShadow(
                                            color: kColorSmoke.withOpacity(.4),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: const Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: SvgPicture.asset(
                                        "assets/svg/share_icon.svg",
                                        width: 20,
                                        height: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text("Item requires a valid prescription",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text("PACKAGE SIZE: ",
                                            style: ksmallTextBold(kColorSmoke)),
                                        Text(" ${product.packSize} BOTTLE",
                                            style: ksmallTextBold(kColorBlack)),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "In Stock",
                                          style: ksmallTextBold(
                                              Colors.greenAccent),
                                        ),
                                        Text(
                                          "Mfg: ${product.manufacturer}",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              color: kColorSmoke2,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            decoration: BoxDecoration(
                              color: kColorWhite,
                              boxShadow: [
                                BoxShadow(
                                  color: kColorSmoke.withOpacity(.4),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
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
                                      style: kmediumTextBold(kColorBlack),
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
                                          "${product.modPrice}",
                                          style: kmediumTextBold(kPrimaryColor),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Quantity",
                                      style: kmediumTextBold(kColorBlack),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 2),
                                      decoration: BoxDecoration(
                                          color: const Color(0xFFECECEC),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        children: [
                                          Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 1),
                                              decoration: BoxDecoration(
                                                  color: kColorWhite,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: const Icon(Icons.remove)),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            "1",
                                            style:
                                                kmediumTextBold(kColorSmoke2),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 1),
                                              decoration: BoxDecoration(
                                                  color: kColorWhite,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: const Icon(Icons.add)),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            decoration: BoxDecoration(
                              color: kColorWhite,
                              boxShadow: [
                                BoxShadow(
                                  color: kColorSmoke.withOpacity(.4),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Product Description",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    )),
                                const SizedBox(
                                  height: 30,
                                ),
                                Text(product.description!,
                                    style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: const [
                                    Text(
                                      "Read more ...",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: kPrimaryColor),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          Container(
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            decoration: BoxDecoration(
                              color: kColorWhite,
                              boxShadow: [
                                BoxShadow(
                                  color: kColorSmoke.withOpacity(.4),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  constraints:
                                      const BoxConstraints.expand(height: 50),
                                  child: TabBar(
                                    indicatorColor: kPrimaryColor,
                                    tabs: [
                                      Tab(
                                        child: Container(
                                          child: Text(
                                            "Precautions",
                                            style: kminismall(kColorBlack),
                                          ),
                                        ),
                                      ),
                                      Tab(
                                        child: Container(
                                          child: Text(
                                            "How to use",
                                            style: kminismall(kColorBlack),
                                          ),
                                        ),
                                      ),
                                      Tab(
                                        child: Container(
                                          child: Text(
                                            "Warnings",
                                            style: kminismall(kColorBlack),
                                          ),
                                        ),
                                      ),
                                      Tab(
                                        child: Container(
                                          child: Text(
                                            "Storage",
                                            style: kminismall(kColorBlack),
                                          ),
                                        ),
                                      ),
                                    ],
                                    controller: _tabController,
                                  ),
                                ),
                                Expanded(
                                    child: Container(
                                        padding: const EdgeInsets.all(10),
                                        child: TabBarView(
                                            controller: _tabController,
                                            children: [
                                              /* All Tabs  */

                                              Container(
                                                child: ListView(
                                                  children: [
                                                    Text(
                                                      product.precautions!,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14,
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
                                                      product.howToUse!,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14,
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
                                                      product.warning!,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14,
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
                                                      product.storage!,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14,
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

                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              color: kColorWhite,
                              boxShadow: [
                                BoxShadow(
                                  color: kColorSmoke.withOpacity(.4),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: const [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text("Product Rating & Review",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                              fontFamily: "Poppins",
                                              color: kColorBlack,
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        RatingsReview(
                                                            widget.ID, false)));
                                          },
                                          child: const Text("View more",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                                fontFamily: "Poppins",
                                                color: kPrimaryColor,
                                              )),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          color: kPrimaryColor,
                                          size: 10,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ratingCustom(
                                    "PA",
                                    "22-04-2021",
                                    "The relief is unbelievable.",
                                    "This medication really helped boost my energy, I wonder why nobody gave me this prescription ealier on😂.",
                                    "by otonye clement"),
                                ratingCustom(
                                    "SA",
                                    "21-06-2021",
                                    "Cool Drug",
                                    "This medication really helped boost my energy, I wonder why nobody gave me this prescription ealier on😂.",
                                    "by Samuel"),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                              color: kColorWhite,
                              boxShadow: [
                                BoxShadow(
                                  color: kColorSmoke.withOpacity(.4),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Shipping Policy",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: kPrimaryColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: SvgPicture.asset(
                                          "assets/svg/shipping_policy.svg",
                                          width: 20,
                                          height: 20),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                          "Shipping fee is calculated at checkout and orders fufilled by multiple pharmacies may attract additional shipping fee",
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black.withOpacity(.5),
                                            fontSize: 13,
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                              color: kColorWhite,
                              boxShadow: [
                                BoxShadow(
                                  color: kColorSmoke.withOpacity(.4),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Return Policy",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: kPrimaryColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: SvgPicture.asset(
                                          "assets/svg/return_policy.svg",
                                          width: 20,
                                          height: 20),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                          "Items can only be returned or exchanged before 2 calendar days",
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black.withOpacity(.5),
                                            fontSize: 13,
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 40,
                          ),

                          Container(
                            height: 360,
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 10),
                            decoration: BoxDecoration(
                              color: kColorWhite,
                              boxShadow: [
                                BoxShadow(
                                  color: kColorSmoke.withOpacity(.4),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Recently Viewed",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: kColorBlack,
                                      ),
                                    ),
                                    Row(
                                      children: const [
                                        Text(
                                          "View more",
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 13,
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
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: 270,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      popularProductsCustom(
                                          "assets/images/product1.png",
                                          "Skin Glow",
                                          "Vitamin C serum",
                                          "6,500"),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      popularProductsCustom(
                                          "assets/images/product2.png",
                                          "Boost Immune",
                                          "Resorb Sport",
                                          "4,500"),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      popularProductsCustom(
                                          "assets/images/product1.png",
                                          "Skin Glow",
                                          "Vitamin C serum",
                                          "6,500"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 70,
                          ),
                          //...list.map((e) => cartCustom(e)),
                        ],
                      ),
                    ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 10,
                right: 10,
                child: InkWell(
                  onTap: () {
                    addToCart();
                  },
                  child: Container(
                    width: width * .8,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kPrimaryColor),
                    child: Center(
                      child: Text(
                        "ADD TO CART",
                        style: klargeTextBold(kColorWhite),
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
                    color: const Color(0xFF4CD964),
                    height: 50,
                    width: width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 40,
                        ),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(180),
                                border: Border.all(
                                    color: kColorWhite,
                                    width: 1,
                                    style: BorderStyle.solid)),
                            child:
                                SvgPicture.asset("assets/svg/checkmark.svg")),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(productName + " added to cart",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: kColorWhite,
                            )),
                      ],
                    ),
                  ),
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
                      color: const Color(0xFF000000).withOpacity(0.3),
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

  Widget popularProductsCustom(
      String asset, String category, String name, price) {
    double width = MediaQuery.of(context).size.width / 2.4;
    return InkWell(
      onTap: () {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => Productetails()));
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
                    child: Image.asset(
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
                          style: kmediumText(kColorBlack),
                        ),
                        Text(
                          category,
                          style: kmediumText(kColorSmoke),
                        ),
                        Text(
                          "From N" + price,
                          style: ksmallTextBold(kColorBlack),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 60,
                        height: 30,
                        decoration: const BoxDecoration(
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
          String poster) =>
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    initials,
                    style: klargeText(kColorWhite),
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        subject,
                        style: kmediumText(kColorBlack),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        date,
                        style: ksmallTextBold(kColorSmoke),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RatingBar.builder(
                    itemSize: 20,
                    initialRating: 4,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                  ),
                  const SizedBox(
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
                        style: ksmallTextBold(kColorSmoke),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      );

  void createWishlist() {
    print("We are In now...");
    ServiceClass serviceClass = ServiceClass();
    serviceClass.createWishList(2, 69).then((value) => output(value));
  }

  void output(String body) {
    print("We are In second  now...");
    var bodyT = jsonDecode(body);
    print(bodyT);
    _showMessage(bodyT["message"]);
    if (bodyT["status"]) {
      var data = json.decode(body);
      dynamic data2 = data;
      print("all man .........");
      print(data2);
      //var rest = data["rest"] as List;
      //print(rest);
      ServerResponse serverResponse = ServerResponse.fromJson(data2);
      AllData allData = AllData.fromJson(serverResponse.data);

      List<WishlistValue> list = allData.value
          .map<WishlistValue>((element) => WishlistValue.fromJson(element))
          .toList();

      //List<ServerResponse> list = rest.map<ServerResponse>((json) => ServerResponse.fromJson(json)).toList();
      print("WishList");

      print(serverResponse.message);
      print("Counter ....");
      print(serverResponse.data);
      print("List Course ....");
      //print(list[0].productName);

      setState(() {
        addedToWishList = true;
      });
      print("Added to wishlist");
    }
  }

  void finfProductByID(int id) {
    print("We are In now...");
    print("This the ID .... $id");
    ServiceClass serviceClass = ServiceClass();
    serviceClass.viewProductByID(id).then((value) => productOutput(value));
  }

  void productOutput(String body) {
    print("We are In faq now...");
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
          print(product.brandName);
          productName = product.name!;
          loading = false;
        });
      } else {
        _showMessage(bodyT["message"]);
      }
    }
  }

  void addToCart() {
    print("We are In Add to cart now...");
    ServiceClass serviceClass = ServiceClass();
    serviceClass.addToCart(widget.ID, 1).then((value) => addCartOutput(value));
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
}
