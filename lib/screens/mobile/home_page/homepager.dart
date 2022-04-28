// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unnecessary_new, prefer_const_declarations, invalid_required_positional_param, avoid_types_as_parameter_names, unnecessary_null_comparison
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mymedicinemobile/constants.dart';
import 'package:mymedicinemobile/models/models.dart';
import 'package:mymedicinemobile/screens/mobile/cart/emptycart.dart';
import 'package:mymedicinemobile/screens/mobile/auth/login.dart';
import 'package:mymedicinemobile/screens/mobile/bundles/all_bundles.dart';
import 'package:mymedicinemobile/screens/mobile/bundles/bundles_details.dart';
import 'package:mymedicinemobile/screens/mobile/cart/cart.dart';
import 'package:mymedicinemobile/screens/mobile/contact_us/contactus.dart';
import 'package:mymedicinemobile/screens/mobile/faqs/faqs.dart';
import 'package:mymedicinemobile/screens/mobile/freshchat/chat_app.dart';
import 'package:mymedicinemobile/screens/mobile/freshchat/freshchat.dart';
import 'package:mymedicinemobile/screens/mobile/inapp_call/inapp_call.dart';
import 'package:mymedicinemobile/screens/mobile/medicine_refill/medicine_refill.dart';
import 'package:mymedicinemobile/screens/mobile/medicine_refill/refill_orders.dart';
import 'package:mymedicinemobile/screens/mobile/my_account/myaccount.dart';
import 'package:mymedicinemobile/screens/mobile/notifications/notifications.dart';
import 'package:mymedicinemobile/screens/mobile/orders/myorders.dart';
import 'package:mymedicinemobile/screens/mobile/product_details/all_products.dart';
import 'package:mymedicinemobile/screens/mobile/product_details/product_details.dart';
import 'package:mymedicinemobile/screens/mobile/product_search/searchProduct.dart';
import 'package:mymedicinemobile/screens/mobile/recently_viewed/recentlyviewed.dart';
import 'package:mymedicinemobile/screens/mobile/shop_by_category/category.dart';
import 'package:mymedicinemobile/screens/mobile/shop_by_category/products.dart';
import 'package:mymedicinemobile/screens/mobile/splash_screens/third_screen.dart';
import 'package:mymedicinemobile/screens/mobile/subscription/subscription.dart';
import 'package:mymedicinemobile/screens/mobile/termsandc/termsandc.dart';
import 'package:mymedicinemobile/screens/mobile/upload_prescription/upload_prescription2.dart';
import 'package:mymedicinemobile/screens/mobile/wishlist/wishlist.dart';
import 'package:mymedicinemobile/services/services.dart';
import 'package:mymedicinemobile/text_style.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mymedicinemobile/screens/mobile/cart/emptycart.dart';

class HomePager extends StatefulWidget {

  // int ID;
  //
  // HomePager(this.ID);
  @override
  _HomePager createState() => _HomePager();
}
class _HomePager extends State<HomePager> {
  bool ishere = false;
  bool isnothere = false;
  TextEditingController searchC = TextEditingController();
  TextEditingController usernameC = TextEditingController();
  bool value = false;
  bool loading = true;
  bool dataLoaded = false;
  double padding = 15;
  int currentIndex = 0;
  int currentIndex2 = 0;
  bool noOrder = false;
  bool isloading = true;
  bool drawerClicked = false;
  bool loggedInUserClicked = false;
  Color selectedColor = kColorWhite;
  Color selectedTextColor = kPrimaryColor;
  List<BannerImages> bannerList = [];
  List<OrderItems>  myorder = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int closeCounter = 0;

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  PageController pageController2 = PageController(
    initialPage: 0,
    keepPage: true,
  );

  List<ProductList> productList = [];
  List<Bundles> bundleList = [];

  List<ShopByHealth> healthList = [
    new ShopByHealth(asset: "assets/svg/cardiac.svg", text: "CARDIAC CARE"),
    new ShopByHealth(asset: "assets/svg/diabetic.svg", text: "DIABETIC CARE"),
    new ShopByHealth(asset: "assets/svg/hair.svg", text: "HAIR CARE"),
    new ShopByHealth(asset: "assets/svg/ortho_care.svg", text: "ORTHO CARE"),
    new ShopByHealth(asset: "assets/svg/eye_care.svg", text: "EYE CARE"),
    new ShopByHealth(
        asset: "assets/svg/stomach_care.svg", text: "STOMACH CARE"),
  ];

  //List<mypopularProductsCustom> mypro = [];

  void launchWhatsApp({@required number, @required message}) async {
    String url = "whatsapp://send?phone=$number&text=$message";
    await canLaunch(url) ? launch(url) : print("Can't open whatsapp");
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
      );
    } else {
      throw "Could not launch $url";
    }
  }

  void getCurrentUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String Token = sharedPreferences.getString("Token")!;
    String Email = sharedPreferences.getString("Email")!;
    String LastName = sharedPreferences.getString("LastName")!;
    String FirstName = sharedPreferences.getString("FirstName")!;
    String Phone = sharedPreferences.getString("Phone")!;

    MedUser medUser = MedUser(
        firstName: FirstName,
        lastName: LastName,
        email: Email,
        phoneNumber: Phone,
        token: Token,
        role: "Well",
        userName: Email);
    Provider.of<ServiceClass>(context, listen: false).notifyLogin(medUser);
  }

  @override
  void initState() {
    //addRecentToCart();
    viewProductList();
    viewBanner();
    viewBundles();
    getCurrentUser();
    Timer(Duration(milliseconds: 4), onChange);
    super.initState();
  }

  void onChange() {
    setState(() {
      isloading = false;
    });
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
    print("Entered");
    final number = 'tel: +2349062386463';

    return WillPopScope(
      onWillPop: () async {
        if (closeCounter == 0) {
          _showMessage("Click again to close application");
          closeCounter++;
        } else {
          SystemNavigator.pop();
        }
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: kColorWhite,
        body: Container(
          width: width,
          height: height,
          child: isloading == true
              ? Container(
              width: 60,
              height: 60,
              child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: kPrimaryColor,
                    strokeWidth: 40,
                  )))
              : Stack(
            children: [

              ListView(
                children: [
                  SizedBox(
                    height: 85,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                        height: 160,
                        width: width * .8,
                        child: PageView(
                          onPageChanged: (var int) {
                            setState(() {
                              currentIndex = int;
                            });
                          },
                          controller: pageController,
                          scrollDirection: Axis.horizontal,
                          children: [
                            ...bannerList.map((e) => bannerCustom(e)),
                          ],
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 5,
                        width: 80,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            Container(
                              width: currentIndex == 0 ? 40 : 10,
                              height: 5,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                                color: currentIndex == 0
                                    ? kPrimaryColor
                                    : kColorSmoke,
                              ),
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Container(
                              width: currentIndex == 1 ? 40 : 10,
                              height: 5,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                                color: currentIndex == 1
                                    ? kPrimaryColor
                                    : kColorSmoke,
                              ),
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Container(
                              width: currentIndex == 2 ? 40 : 10,
                              height: 5,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                                color: currentIndex == 2
                                    ? kPrimaryColor
                                    : kColorSmoke,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: padding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/svg/quick_delivery.svg",
                              color: kpurpleColor,
                              width: 15,
                              height: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Quick Delivery",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Poppins",
                                  fontSize: 11,
                                  color: kColorBlack),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/svg/secure_payment.svg",
                              color: kpurpleColor,
                              width: 15,
                              height: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Secure Payment",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Poppins",
                                  fontSize: 11,
                                  color: kColorBlack),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/svg/best_quality.svg",
                              color: kpurpleColor,
                              width: 15,
                              height: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Best Quality",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Poppins",
                                  fontSize: 11,
                                  color: kColorBlack),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: width,
                    height: 100,
                    margin: EdgeInsets.symmetric(horizontal: padding),
                    // padding: EdgeInsets.symmetric(
                    //     horizontal: padding, vertical: 10),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: kBackgroundHome2,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SvgPicture.asset(
                          "assets/svg/med_refill.svg",
                          height: 60,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Medicine Refill",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Poppins",
                                  fontSize: 16,
                                  color: kColorBlack),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Text(
                              "Get automated refill with a\nmedicine refill subscription",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Poppins",
                                  fontSize: 11,
                                  color: kColorBlack.withOpacity(.5)),
                            ),
                          ],
                        ),
                        SizedBox(width: 5),
                        Center(
                          child: InkWell(
                            onTap: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             SubScription()));

                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             new SubScription()));
                            },
                            child: Container(
                              height: 40,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: kColorGreen,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Center(
                                child: Text(
                                  "Subscribe",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Poppins",
                                      fontSize: 13,
                                      color: kColorWhite),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AllProducts()));
                    },
                    child: Container(
                      width: width,
                      height: 400,
                      decoration: BoxDecoration(
                        color: kColorWhite,
                        borderRadius: BorderRadius.circular(10),
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
                      margin: EdgeInsets.symmetric(horizontal: padding),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Explore",
                            style:
                            ksmallTextBold(kColorBlack.withOpacity(1)),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            "Shop by health condition",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: "Poppins",
                                fontSize: 16,
                                color: kColorBlack),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              shopByHealth(
                                  healthList[0].asset, healthList[0].text),
                              shopByHealth(
                                  healthList[1].asset, healthList[1].text),
                              shopByHealth(
                                  healthList[2].asset, healthList[2].text)
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              shopByHealth(
                                  healthList[3].asset, healthList[3].text),
                              shopByHealth(
                                  healthList[4].asset, healthList[4].text),
                              shopByHealth(
                                  healthList[5].asset, healthList[5].text)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Container(
                    width: width,
                    height: 500,
                    decoration: BoxDecoration(
                      color: kColorWhite,
                      borderRadius: BorderRadius.circular(10),
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
                    margin: EdgeInsets.symmetric(horizontal: padding),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Explore",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Poppins",
                                      fontSize: 11,
                                      color: kColorBlack.withOpacity(.5)),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  "Sanitary Bundles",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Poppins",
                                      fontSize: 14,
                                      color: kColorBlack),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AllBundles()));
                              },
                              child: Row(
                                children: [
                                  Text(
                                    "View all",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Poppins",
                                        fontSize: 12,
                                        color: kPrimaryColor),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: kPrimaryColor,
                                    size: 11,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Shop for discounted bundle from",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Poppins",
                                  fontSize: 12,
                                  color: kColorSmoke2.withOpacity(.7)),
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (bundleList != null) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BundleID(
                                                      bundleList[0].id!)));
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(5),
                                      color: kPrimaryColor,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "View Bundle",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Poppins",
                                            fontSize: 11,
                                            color: kColorWhite),
                                      ),
                                    ),
                                    //height: 30,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                InkWell(
                                  onTap: () {
                                    if (bundleList != null) {
                                      createBundleWishList(
                                          bundleList[0].id!);
                                    }
                                  },
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(180),
                                      color: Color(0xFFCBD2DB),
                                    ),
                                    child: SvgPicture.asset(
                                      "assets/svg/love.svg",
                                      color: kColorWhite,
                                      width: 30,
                                      height: 30,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: 350,
                          child: ListView.builder(
                              itemCount: bundleList == null
                                  ? 0
                                  : (bundleList.length > 2
                                  ? 2
                                  : bundleList.length),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, i) {
                                return bundleCustom(bundleList[i]);
                              }),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Container(
                    width: width,
                    height: 450,
                    decoration: BoxDecoration(
                      color: kColorWhite,
                      borderRadius: BorderRadius.circular(10),
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
                    margin: EdgeInsets.symmetric(horizontal: padding),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Explore",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Poppins",
                                      fontSize: 11,
                                      color: kColorBlack.withOpacity(.5)),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  "Popular Products",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Poppins",
                                      fontSize: 14,
                                      color: kColorBlack),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  "Shop discounted products from ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Poppins",
                                      fontSize: 12,
                                      color: kColorSmoke2.withOpacity(.7)),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AllProducts()));
                              },
                              child: Row(
                                children: [
                                  Text(
                                    "View all",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Poppins",
                                        fontSize: 12,
                                        color: kPrimaryColor),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: kPrimaryColor,
                                    size: 11,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 300,
                          child: ListView.builder(
                              itemCount: productList == null
                                  ? 0
                                  : (productList.length > 2
                                  ? 2
                                  : productList.length),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, i) {
                                return productCustom(productList[i]);
                              }),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  InkWell(
                    onTap: () {
                      _makePhoneCall(number);
                    },
                    child: Container(
                      width: width,
                      height: 170,
                      decoration: BoxDecoration(
                        color: kColorWhite,
                        borderRadius: BorderRadius.circular(10),
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
                      margin: EdgeInsets.symmetric(horizontal: padding),
                      padding: EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Image.asset(
                                  "assets/images/self_med.png",
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 130,
                                ),
                              ),
                              Positioned(
                                  top: 15,
                                  //bottom: 10,
                                  left: 10,
                                  right: 10,
                                  child: SvgPicture.asset(
                                      "assets/svg/danger.svg",
                                      width: 40,
                                      height: 40))
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text("Don’t self-medicate",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Poppins",
                                      fontSize: 14,
                                      color: kColorBlack,
                                    )),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                    "Introduction to the consultation call center Do not self-medicate. Speak to our experts. call a pharmacist.",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Poppins",
                                      fontSize: 12,
                                      color: kColorSmoke2,
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(""),
                                    Container(
                                      width: 90,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF3CA455),
                                        borderRadius:
                                        BorderRadius.circular(30),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          //call_now
                                          SvgPicture.asset(
                                            "assets/svg/call_now.svg",
                                            color: kColorWhite,
                                            width: 20,
                                            height: 20,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "Call us",
                                            style:
                                            ksmallTextBold(kColorWhite),
                                          ),
                                        ],
                                      ),
//                                Center(child: Text("Call us",style: kminismall(kColorWhite),)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: width,
                    height: 170,
                    decoration: BoxDecoration(
                      color: kColorWhite,
                      borderRadius: BorderRadius.circular(10),
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
                    margin: EdgeInsets.symmetric(horizontal: padding),
                    padding: EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Image.asset(
                                "assets/images/emergency.png",
                                fit: BoxFit.cover,
                                width: 100,
                                height: 130,
                              ),
                            ),
                            Positioned(
                                top: 15,
                                //bottom: 10,
                                left: 10,
                                right: 10,
                                child: SvgPicture.asset(
                                  "assets/svg/delivery.svg",
                                  width: 40,
                                  height: 40,
                                ))
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text("Emergency Delivery",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Poppins",
                                    fontSize: 14,
                                    color: kColorBlack,
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Introduction to Fast delivery Tired of waiting in a queue? Too weak to go down and buy medicines? Home delivery in 2 hours",
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Poppins",
                                  fontSize: 12,
                                  color: kColorSmoke2,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(""),
                                  Container(
                                    //width: 100,
                                    height: 30,
                                    padding:
                                    EdgeInsets.only(left: 8, right: 8),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF3CA455),
                                      borderRadius:
                                      BorderRadius.circular(30),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Learn More",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Poppins",
                                            fontSize: 12,
                                            color: kColorWhite,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: kColorWhite,
                                          size: 20,
                                        )
                                      ],
                                    ),
//                                Center(child: Text("Call us",style: kminismall(kColorWhite),)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width: width,
                    height: 320,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            //background: linear-gradient(180deg, #9927AD 0%, #C826B3 100%);
                            Color(0xFF9927AD),
                            Color(0xFFC826B3),
                          ],
                        )),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15),
                          height: 290,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text("New Arrivals",
                                      style: kmediumTextBold(kColorSmoke)),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "BROWSE OUR \nNEW PRODUCTS",
                                    style: ksmallTextBold(kColorWhite),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    " 100% QUALITY*",
                                    style: ksmallTextBold(kColorWhite),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    width: 100,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(10),
                                      color: Color(0xFFFFD763),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Shop Now",
                                        style: ksmallTextBold(kColorBlack),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              productList.isEmpty && productList.length < 2
                                  ? Center()
                                  : newArrivalsCustom(productList[0]),
                              SizedBox(
                                width: 6,
                              ),
                              productList.isEmpty && productList.length < 2
                                  ? Center()
                                  : newArrivalsCustom(productList[1]),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 5,
                              width: 80,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  Container(
                                    width: currentIndex2 == 0 ? 40 : 10,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10)),
                                      color: currentIndex2 == 0
                                          ? kPrimaryColor
                                          : kColorSmoke,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Container(
                                    width: currentIndex2 == 1 ? 40 : 10,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10)),
                                      color: currentIndex2 == 1
                                          ? kPrimaryColor
                                          : kColorSmoke,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Container(
                                    width: currentIndex == 2 ? 40 : 10,
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
                                    width: currentIndex == 3 ? 40 : 10,
                                    height: 5,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () {
                      launchWhatsApp(
                          number: "+234 808 275 1466",
                          message: "Welcome To My Medicine");
                    },
                    child: Container(
                      width: width,
                      height: 90,
                      decoration: BoxDecoration(
                        color: kColorWhite,
                        borderRadius: BorderRadius.circular(10),
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
                      margin: EdgeInsets.symmetric(horizontal: padding),
                      padding: EdgeInsets.all(15),
                      // whatsApp redirect
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Chat with a Pharmacist",
                            style: klargeTextBold(kColorBlack),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          SvgPicture.asset(
                            "assets/svg/whatsapp.svg",
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddMedicine(0)));
                    },
                    child: Container(
                      width: width,
                      height: 90,
                      decoration: BoxDecoration(
                        color: kColorWhite,
                        borderRadius: BorderRadius.circular(10),
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
                      margin: EdgeInsets.symmetric(horizontal: padding),
                      padding: EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Schedule your Refills",
                            style: klargeTextBold(kColorBlack),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          SvgPicture.asset(
                            "assets/svg/refill.svg",
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () {
                      launchWhatsApp(
                          number: "+234 808 275 1466",
                          message: "Welcome To My Medicine");
                    },
                    child: Container(
                      width: width,
                      height: 90,
                      decoration: BoxDecoration(
                        color: kColorWhite,
                        borderRadius: BorderRadius.circular(10),
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
                      margin: EdgeInsets.symmetric(horizontal: padding),
                      padding: EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Need Help?",
                            style: klargeTextBold(kColorBlack),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          SvgPicture.asset(
                            "assets/svg/need_help.svg",
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    width: width,
                    height: 400,
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: kColorWhite,
                      borderRadius: BorderRadius.circular(10),
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
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Health Blog",
                              style: kmediumTextBold(kColorBlack),
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    final url =
                                        "http://dev.mymedicines.africa/blog";
                                    if (await canLaunch(url)) {
                                      print("This can launch $url");
                                      await launch(url,
                                          forceSafariVC: true,
                                          forceWebView: true,
                                          enableJavaScript: true);
                                    }
                                  },
                                  child: Text(
                                    "View all",
                                    style: kminismall(kPrimaryColor),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    final url =
                                        "http://dev.mymedicines.africa/blog";
                                    if (await canLaunch(url)) {
                                      await launch(url,
                                          forceSafariVC: true,
                                          forceWebView: true,
                                          enableJavaScript: true);
                                    }
                                  },
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: kPrimaryColor,
                                    size: 15,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(

                          height: 300,
                          child: FutureBuilder(
                              future: ServiceClass().viewAllBlogs(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data
                                      .toString()
                                      .contains("Network Error")) {} else {
                                    print("Well we are here");
                                    print(snapshot.data.toString());
                                    var data = json.decode(
                                        snapshot.data.toString());
                                    dynamic value = data["data"]["value"];
                                    List<MedBlog> list = value
                                        .map<MedBlog>((element) =>
                                        MedBlog.fromJson(element))
                                        .toList();
                                    print("WishList");

                                    return Container(
                                      color: Colors.white,
                                      height: 300,
                                      //padding: EdgeInsets.only(bottom: 20),
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          ...list.map((e) =>
                                              blogCustom(
                                                  e.mainImageUrl!,
                                                  e.title!,
                                                  e.datePublished!)),
                                          SizedBox(width: 5,),
                                          ...list.map((e) =>
                                              blogCustom(
                                                  e.mainImageUrl!,
                                                  e.title!,
                                                  e.datePublished!)),
                                        ],
                                      ),
                                    );
                                  }
                                }
                                return Center();
                              }),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
              Positioned(
                bottom: 15,
                right: 10,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ChatApp()));
                  },
                  child: Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: kColorWhite,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: kColorSmoke.withOpacity(.4),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset:
                          Offset(5, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/chat_prod.png",
                          // width: 70,
                          // height: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Chat!",
                            style: TextStyle(
                                fontSize: 12,
                                color: kPrimaryColor,
                                fontFamily: "Poppins")),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                child: Container(
                    width: width,
                    height: 110,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          child: Container(
                            width: width,
                            height: 90,
                            decoration: BoxDecoration(
                                color: kPrimaryColor,
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/home_bg.png"),
                                    fit: BoxFit.cover)),
                            child: Text(""),
                          ),
                        ),
                        Positioned(
                          top: 70,
                          left: padding,
                          right: padding,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SearchProducts()));
                            },
                            child: Container(
                              width: width,
                              height: 50,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: kColorWhite,
                                boxShadow: [
                                  BoxShadow(
                                    color: kColorSmoke.withOpacity(.4),
                                    spreadRadius: 2,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 6), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  SvgPicture.asset(
                                    "assets/svg/search_icon.svg",
                                    color: kPrimaryColor,
                                    width: 15,
                                    height: 15,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Search for medicines, health products, ailment',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        //Hamburger
                        Positioned(
                            top: 25,
                            left: padding,
                            right: padding,
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (drawerClicked) {
                                        drawerClicked = false;
                                      } else {
                                        loggedInUserClicked = false;
                                        drawerClicked = true;
                                      }
                                    });
                                  },
                                  child: SvgPicture.asset(
                                    "assets/svg/hamburger.svg",
                                    width: 14,
                                    height: 14,
                                    color: kPrimaryColor,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      child: Image.asset(
                                        "assets/images/newlogo.png",
                                        width: 35,
                                        height: 35,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 7,
                                    ),
                                    SvgPicture.asset(
                                      "assets/svg/mymedicines.svg",
                                      width: 70,
                                      height: 20,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [

                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (loggedInUserClicked) {
                                            loggedInUserClicked = false;
                                          } else {
                                            loggedInUserClicked = true;
                                            drawerClicked = false;
                                          }
                                        });
                                      },
                                      child: SvgPicture.asset(
                                        Provider
                                            .of<ServiceClass>(context)
                                            .MedUsers
                                            .email ==
                                            ""
                                            ? "assets/svg/home_person.svg"
                                            : "assets/svg/loggedin_person.svg",
                                        width: 20,
                                        color: kPrimaryColor,
                                        height: 20,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 40,
                                    ),
                                    Stack(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            var countlength = Provider.of<ServiceClass>(context, listen: false).CurrentIndex.toString();
                                            print(countlength);
                                            print("This is the value of $countlength");
                                            //print("This is ${myorder.length}");
                                            if(countlength == 0.toString()){
                                              setState(() {
                                                noOrder = true;
                                                // print(noOrder);
                                                // print("This is $myorder");
                                                // print("This is ${myorder.length}");
                                              });
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Emptycart()));
                                            }
                                            else {
                                              print("I am a boy");
                                              setState(() {
                                                print("I am a boy");
                                                print(countlength);
                                                print("This is $countlength");
                                              });
                                              Navigator.push(context, MaterialPageRoute(
                                                builder: (context) => Cart()
                                              ));
                                            }
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10,
                                                horizontal: 10),
                                            child: SvgPicture.asset(
                                              "assets/svg/show_cart.svg",
                                              color: kPrimaryColor,
                                              width: 20,
                                              height: 20,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                            top: 0,
                                            right: 0,
                                            child: Container(
                                              width: 18,
                                              height: 18,
                                              decoration: BoxDecoration(
                                                  color: Color(0xFFFF7685),
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      10)),
                                              child: Center(
                                                  child: Text(
                                                    Provider
                                                        .of<ServiceClass>(
                                                        context)
                                                        .CurrentIndex
                                                        .toString(),
                                                    style: ksmallMediumText(
                                                        kColorWhite),
                                                  )),
                                            )),
                                      ],
                                    ),

                                  ],
                                )
                              ],
                            ))
                      ],
                    )),
              ),
              drawerClicked
                  ? Positioned(
                top: 68,
                left: 0,
                right: 0,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (drawerClicked) {
                        drawerClicked = false;
                      } else {
                        drawerClicked = true;
                      }
                    });
                  },
                  child: Container(
                    width: width,
                    height: height * .9,
                    color: Color(0xFF000000).withOpacity(0.4),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                              width: width * .75,
                              height: height * .8,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      bottomRight:
                                      Radius.circular(25))),
                              child: Column(
                                children: [
                                  Image.asset(
                                    "assets/images/home_dropdown.png",
                                    fit: BoxFit.cover,
                                    width: width * .9,
                                  ),
                                  Container(
                                      height: height * .7,
                                      child: ListView(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                          UploadPrescription2()));
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 60),
                                              child: Text(
                                                "Upload Prescription",
                                                style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.w500,
                                                  fontSize: 16,
                                                  fontFamily:
                                                  "Poppins",
                                                  color:
                                                  kPrimaryColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Divider(
                                            height: 1,
                                            color: kColorSmoke,
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              // Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (context) =>
                                              //             SubScription()));
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 60),
                                              child: Text(
                                                "Consultation",
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight
                                                        .w500,
                                                    fontSize: 16,
                                                    fontFamily:
                                                    "Poppins",
                                                    color:
                                                    kPrimaryColor),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Divider(
                                            height: 1,
                                            color: kColorSmoke,
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                          Categories()));
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 60,
                                                  right: 16),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Shop by Category",
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .w500,
                                                        fontSize: 16,
                                                        fontFamily:
                                                        "Poppins",
                                                        color:
                                                        kPrimaryColor),
                                                  ),
                                                  Icon(
                                                    Icons
                                                        .arrow_forward_ios,
                                                    color:
                                                    kColorSmoke2,
                                                    size: 17,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Divider(
                                            height: 1,
                                            color: kColorSmoke,
                                          ),
                                          Container(
                                            color: selectedColor,
                                            child: ExpansionTile(
                                              textColor:
                                              kPrimaryColor,
                                              collapsedTextColor:
                                              kColorWhite,
                                              onExpansionChanged:
                                                  (bool expanded) {
                                                print(
                                                    "Clicked now..");
                                                print(expanded);
                                                if (expanded) {
                                                  setState(() {
                                                    selectedColor =
                                                        kPrimaryColor;
                                                    selectedTextColor =
                                                        kColorWhite;
                                                  });
                                                } else {
                                                  setState(() {
                                                    selectedColor =
                                                        kColorWhite;
                                                    selectedTextColor =
                                                        kPrimaryColor;
                                                  });
                                                }
                                              },
                                              title: Container(
                                                padding:
                                                EdgeInsets.only(
                                                    left: 40),
                                                child: new Text(
                                                  "Talk to a pharmacist",
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .w500,
                                                      fontSize: 16,
                                                      fontFamily:
                                                      "Poppins",
                                                      color:
                                                      selectedTextColor),
                                                ),
                                              ),
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    _makePhoneCall(
                                                        number);
                                                  },
                                                  child:
                                                  customInAppCall(
                                                    "In-app call",
                                                    "assets/svg/caller.svg",
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    launchWhatsApp(
                                                        number:
                                                        "+234 906 238 6463",
                                                        message:
                                                        "Hello Mymedicine");
                                                  },
                                                  child:
                                                  customInAppCall(
                                                    "+234 906 238 6463",
                                                    "assets/svg/watsapp.svg",
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    final url =
                                                        'https://www.facebook.com/ordermymedicines';
                                                    if (await canLaunch(
                                                        url)) {
                                                      await launch(
                                                          url,
                                                          forceSafariVC:
                                                          true,
                                                          forceWebView:
                                                          true,
                                                          enableJavaScript:
                                                          true);
                                                    }
                                                  },
                                                  child:
                                                  customInAppCall(
                                                    "Facebook",
                                                    "assets/svg/facebook.svg",
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    final url =
                                                        'https://twitter.com/my_medicines';
                                                    if (await canLaunch(
                                                        url)) {
                                                      await launch(
                                                          url,
                                                          forceSafariVC:
                                                          true,
                                                          forceWebView:
                                                          true,
                                                          enableJavaScript:
                                                          true);
                                                    }
                                                  },
                                                  child:
                                                  customInAppCall(
                                                    "Twitter",
                                                    "assets/svg/twittersvg.svg",
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    final url =
                                                        'https://www.instagram.com/my_medicines/';
                                                    if (await canLaunch(
                                                        url)) {
                                                      await launch(
                                                          url,
                                                          forceSafariVC:
                                                          true,
                                                          forceWebView:
                                                          true,
                                                          enableJavaScript:
                                                          true);
                                                    }
                                                  },
                                                  child:
                                                  customInAppCall(
                                                    "Instagram",
                                                    "assets/svg/instagram.svg",
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                ChatApp()));
                                                  },
                                                  child:
                                                  customInAppCall(
                                                    "Chat",
                                                    "assets/svg/chatter.svg",
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            height: 1,
                                            color: kColorSmoke,
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                          ContactUs()));
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 60),
                                              child: Text(
                                                "Contact Us",
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight
                                                        .w500,
                                                    fontSize: 16,
                                                    fontFamily:
                                                    "Poppins",
                                                    color:
                                                    kPrimaryColor),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Divider(
                                            height: 1,
                                            color: kColorSmoke,
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                          TermsAndC()));
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 60),
                                              child: Text(
                                                "Terms & Conditions",
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight
                                                        .w500,
                                                    fontSize: 16,
                                                    fontFamily:
                                                    "Poppins",
                                                    color:
                                                    kPrimaryColor),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Divider(
                                            height: 1,
                                            color: kColorSmoke,
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                          FAQS()));
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 60),
                                              child: Text(
                                                "FAQ",
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight
                                                        .w500,
                                                    fontSize: 16,
                                                    fontFamily:
                                                    "Poppins",
                                                    color:
                                                    kPrimaryColor),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Divider(
                                            height: 1,
                                            color: kColorSmoke,
                                          ),
                                          SizedBox(
                                            height: 25,
                                          ),
                                        ],
                                      )),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              )
                  : Center(),
              loggedInUserClicked
                  ? Positioned(
                top: 68,
                right: 0,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (loggedInUserClicked) {
                        loggedInUserClicked = false;
                      } else {
                        loggedInUserClicked = true;
                      }
                    });
                  },
                  child: Container(
                    width: width,
                    height: height * .98,
                    color: Color(0xFF000000).withOpacity(0.4),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 35),
                            width: width * .8,
                            height: height * .4,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/maskgroup.png"),
                                  fit: BoxFit.cover,
                                )),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  Provider
                                      .of<ServiceClass>(context)
                                      .MedUsers
                                      .firstName +
                                      " " +
                                      Provider
                                          .of<ServiceClass>(
                                          context)
                                          .MedUsers
                                          .lastName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      fontFamily: "Poppins",
                                      color: kColorWhite),
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      Provider
                                          .of<ServiceClass>(
                                          context)
                                          .MedUsers
                                          .email,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 11,
                                          fontFamily: "Poppins",
                                          color: kColorWhite
                                              .withOpacity(.7)),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Notifications()));
                                      },
                                      child: SvgPicture.asset(
                                        "assets/svg/notification.svg",
                                        width: 20,
                                        height: 20,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                Text(
                                  Provider
                                      .of<ServiceClass>(context)
                                      .MedUsers
                                      .phoneNumber,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 11,
                                      fontFamily: "Poppins",
                                      color: kColorWhite
                                          .withOpacity(.7)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                            top: height * .11,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 20),
                              height: height * .75,
                              width: width * .8,
                              decoration: BoxDecoration(
                                  color: Color(0xFFEBECEE),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                      kColorSmoke.withOpacity(.4),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0,
                                          3), // changes position of shadow
                                    ),
                                  ],
                                  borderRadius:
                                  BorderRadius.circular(30)),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "     Account Management",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        fontFamily: "Poppins",
                                        color: kColorSmoke2),
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Container(
                                    height: height * .66,
                                    width: width * .9,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                        BorderRadius.circular(
                                            10)),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 6,
                                        ),
                                        customMedium(
                                            "assets/svg/person_profile.svg",
                                            "My Account Details",
                                            MyAccount()),
                                        customMedium(
                                            "assets/svg/my_orders.svg",
                                            "My Orders",
                                            MyOrders(false)),
                                        customMedium(
                                            "assets/svg/refill_new.svg",
                                            "Refill Medicine",
                                            Refillorders()),
                                        // customMedium(
                                        //     "assets/svg/refill.svg",
                                        //     "My Transactions",
                                        //     MyAccount()),
                                        customMedium(
                                            "assets/svg/wallet_profile.svg",
                                            "My Wallet",
                                            MyAccount()),

                                        customMedium(
                                            "assets/svg/recently.svg",
                                            "Recently Viewed",
                                            RecentlyViewed()),
                                        customMedium(
                                            "assets/svg/wishlist.svg",
                                            "Wishlist",
                                            WishList2()),
                                        // customMedium(
                                        //     "assets/svg/logistics.svg",
                                        //     "Logistic Services",
                                        //     MyAccount()),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            showDialogWidget(context);
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            children: [
                                              Icon(
                                                Icons.logout,
                                                color: kPrimaryColor,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Logout",
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight
                                                        .w500,
                                                    fontSize: 14,
                                                    fontFamily:
                                                    "Poppins",
                                                    color:
                                                    kPrimaryColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Share.share(
                                                "Download app via https://play.google.com/store/apps/details?id=co.mymedicine.co.mymedicinemobile");
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            children: [
                                              SvgPicture.asset(
                                                "assets/svg/share_icon.svg",
                                                color: kPrimaryColor,
                                                width: 20,
                                                height: 20,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Share myMedicine app",
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.w400,
                                                    fontSize: 12,
                                                    fontFamily:
                                                    "Poppins",
                                                    color: kColorBlack),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            final url = 'https://play.google.com/store/apps/details?id=co.mymedicine.co.mymedicinemobile';
                                            if (await canLaunch(url)) {
                                              await launch(url,
                                                  forceSafariVC: true,
                                                  forceWebView: true,
                                                  enableJavaScript: true);
                                            }
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            children: [
                                              SvgPicture.asset(
                                                "assets/svg/rate_med.svg",
                                                width: 20,
                                                height: 20,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Rate myMedicine app",
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.w400,
                                                    fontSize: 12,
                                                    fontFamily:
                                                    "Poppins",
                                                    color: kColorBlack),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 25,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "   myMedicine V1.0",
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.w400,
                                                  fontSize: 11,
                                                  fontFamily:
                                                  "Poppins",
                                                  color:
                                                  kColorSmoke2),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              )
                  : Center(),
            ],
          ),
        ),
      ),
    );
  }

  customMedium(String asset, String name, Widget widget) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => widget));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  SvgPicture.asset(
                    asset,
                    color: kPrimaryColor,
                    width: 14,
                    height: 14,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    name,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        fontFamily: "Poppins",
                        color: kColorSmoke2),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => widget));
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 20.0),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: kColorSmoke,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Divider(
          height: .2,
          color: kColorSmoke.withOpacity(.4),
        ),
        SizedBox(
          height: 5,
        )
      ],
    );
  }

  Widget customInAppCall(String text,
      String asset,) {
    return Container(
        decoration: new BoxDecoration(
          color: Color(0xFFF6F6F9),
          border: Border(
            top: BorderSide(width: 1.0, color: Color(0xFFCCCED0)),
            bottom: BorderSide(width: 1.0, color: Color(0xFFCCCED0)),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                SvgPicture.asset(
                  asset,
                  color: kColorSmoke2,
                  width: 20,
                  height: 20,
                ),
                //SizedBox(width: 50,),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: text.contains("Facebook") ? 25 : 15),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400,
                      color: kColorBlack,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Widget shopByHealth(String asset, String text) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width / 3.7,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kBackgroundHome3,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              asset,
              width: 80,
              height: 70,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              text,
              style: ksmallTextBold(kPrimaryColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget sanitaryCustom(String asset, String text, String category) {
    double width = MediaQuery
        .of(context)
        .size
        .width / 2.5;
    return Container(
      width: width,
      height: 180,
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
            Container(
              color: kBackgroundHome4,
              width: width,
              height: 110,
              child: Image.asset(asset),
            ),
            Container(
              width: width,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: kColorWhite,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: kmediumText(kColorBlack),
                  ),
                  Text(
                    category,
                    style: ksmallTextBold(kColorSmoke),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget blogCustom(String asset, String text, String time) {
    String time2 = time.split("T")[0];
    double width = MediaQuery
        .of(context)
        .size
        .width / 2;
    return Container(
      width: width,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 280,
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
            Container(
              width: width,
              height: 170,
              child: Image.network(
                asset,
                fit: BoxFit.fill,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: width,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: kColorWhite,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    text,
                    style: kmediumText(kColorBlack),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        time2,
                        style: ksmallTextBold(kColorSmoke),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget newArrivalsCustom(ProductList product) {
    //String asset, String category, String name, price, int id,int stock
    double width = MediaQuery
        .of(context)
        .size
        .width / 2.4;
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductID(product.productId!)));
      },
      child: Container(
        width: width,
        margin: EdgeInsets.symmetric(horizontal: 1),
        height: 280,
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
                    height: 180,
                    child: Image.network(
                      product.productImageUrl!,
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
                          product.productName!,
                          style: kmediumText(kColorBlack),
                        ),
                        Text(
                          "Starting from",
                          style: kmediumText(kColorSmoke),
                        ),
                        Text(
                          "N" + product.minPrice!.toString(),
                          style: ksmallTextBold(kPrimaryColor),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          if (product.totalQuantityInStock! > 0) {
                            addRecentToCart(product.productId!);
                          } else {
                            _showMessage("Out of stock");
                          }
                        },
                        child: Container(
                          width: 60,
                          height: 30,
                          decoration: BoxDecoration(
                              color: product.totalQuantityInStock! > 0 ? Color(
                                  0xFF8D28AD) : kColorWhite,
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
            ],
          ),
        ),
      ),
    );
  }

  showDialogWidget(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text('Logout Confirmation'),
      content: Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
            onPressed: () async {
              Navigator.pop(context);
              Navigator.pop(context);

              SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
              sharedPreferences.remove("Token");
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ThirdScreen()));
            },
            child: Text('YES')),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'NO',
              style: TextStyle(color: Colors.black),
            )),
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  Widget bannerCustom(BannerImages myBanner) {
    print("banner Custom");
    print(myBanner.imageUrl);
    return Container(
        width: MediaQuery
            .of(context)
            .size
            .width * .8,
        height: 180,
        child: InkWell(
          onTap: () {
            int index = bannerList.indexOf(myBanner);
            if (index == 0) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AllProducts()));
            } else if (index == 1) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CatProducts()));
            } else {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AllBundles()));
            }
          },
          child: Image.network(
            "${myBanner.imageUrl!}",
            fit: BoxFit.contain,
          ),
        ));
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

  void viewBanner() {
    print("We are seeing banner now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.viewBanner().then((value) => output(value));
  }

  void output(String body) {
    print("We are In banner now...");
    print(body);
    if (body.contains("Network Error")) {
      _showMessage("Network Error");
    } else {
      var bodyT = jsonDecode(body);
      if (bodyT["status"] == "Successful") {
        var data = json.decode(body);
        dynamic value = data["data"];
        bannerList.clear();
        MyBanner banner = MyBanner.fromJson(value);
        bannerList = banner.bannerImages
            .map<BannerImages>((element) => BannerImages.fromJson(element))
            .toList();

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

  Widget productCustom(ProductList product) {
    var formatter = NumberFormat('#,###,000');
    int index = this.productList.indexOf(product);
    return InkWell(
      onTap: () {
        print("Pressed ........");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductID(product.productId!)));
      },
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width / 2,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
        child: Stack(
          children: [
            Column(

              children: [
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 20,),
                    Container(
                      height: 25,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.orange,

                      ),
                      child:
                      Center(
                        child: Center(
                          child: Text(
                            product.totalQuantityInStock! > 0 ? "Available"
                                : "Available on request"
                            , style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontFamily: "Poppins",

                          ),),
                        ),

                      ),
                    ),
                  ],
                ),
                Container(
                  //width: MediaQuery.of(context).size.width * .65,
                    height: 170,
                    child: Image.network(
                      product.productImageUrl!,
                      fit: BoxFit.contain,
                    )),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / 2,
                  //height: 50,
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
                        product.productName!,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: "Poppins",
                          fontSize: 12,
                          color: kColorBlack,
                        ),
                        maxLines: 1,
                      ),
                      Text(
                        product.productCategory!,
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
                          SvgPicture.asset(
                            "assets/svg/naira.svg",
                            width: 10,
                            height: 10,
                          ),
                          Text(
                            formatter.format(product.minPrice!),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: "Poppins",
                              fontSize: 12,
                              color: kColorBlack,
                            ),
                          ),
                        ],
                      ),
                      // Text(
                      //   "From N" + productList.modPrice!.toString(),
                      //   style: ksmallTextBold(kColorBlack),
                      // ),
                    ],
                  ),
                )
              ],
            ),
            Positioned(
              top: 10,
              right: 10,
              child: InkWell(
                onTap: () {
                  createWishlist(product.productId!, index);
                },
                child: Container(
                  width: 30,
                  height: 30,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(180),
                    color: Color(0xFFCBD2DB),
                  ),
                  child: SvgPicture.asset(
                    "assets/svg/love.svg",
                    color: product.addedToWishList ? kErrorColor : kColorWhite,
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
            ),
            Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: () {
                    if (product.totalQuantityInStock! > 0) {
                      addRecentToCart(product.productId!);
                    } else {
                      _showMessage("Out of stock");
                    }
                  },
                  child: Container(
                    width: 60,
                    height: 40,
                    decoration: BoxDecoration(
                        color: product.totalQuantityInStock! > 0
                            ? kPrimaryColor
                            : kColorSmoke2,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20))),
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/svg/cart_add.svg",
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
  }

  void viewProductList() {
    Provider.of<ServiceClass>(context, listen: false).increaseCart();
    print("gotten products.");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.viewProductList().then((value) => productOutput(value));
  }

  void productOutput(String body) {
    print("We are In search products now...");
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
        dynamic value = data["data"];
        productList.clear();
        productList = value
            .map<ProductList>((element) => ProductList.fromJson(element))
            .toList();
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

  void viewBundles() {
    print("gotten bundles");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.viewAllBundles().then((value) => bundleOutput(value));
  }

  void bundleOutput(String body) {
    print("We are In bundles now...");
    print(body);
    if (body.contains("Network Error")) {
      _showMessage("Network Error");
    } else {
      var bodyT = jsonDecode(body);
      if (bodyT["message"] == "Successful") {
        var data = json.decode(body);
        dynamic data2 = data;
        print(data2);
        dynamic value = data["data"]["value"];

        bundleList =
            value.map<Bundles>((element) => Bundles.fromJson(element)).toList();
        setState(() {
          loading = false;
        });
      } else {
        _showMessage(bodyT["message"]);
        setState(() {
          loading = false;
        });
      }
    }
  }

  Widget bundleCustom(Bundles bundles) =>
      InkWell(
        onTap: () {
          print("Pressed ........");
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => BundleID(bundles.id!)));
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          padding: EdgeInsets.only(bottom: 10, top: 10),
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 200,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * .65,
                  child: Image.network(
                    bundles.bundleImageUrl!,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  '${bundles.bundleName}',
                  style: ksmallTextBold(kColorBlack),
                ),
              ],
            ),
          ),
        ),
      );

  void addRecentToCart(int id) {
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

  void createWishlist(int id, int index) {
    print("We are In now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.createWishList(2, id).then((value) =>
        wishlistOutput(value, index));
  }

  void createBundleWishList(int id) {
    print("We are In now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass
        .createBundleWishList(2, id)
        .then((value) => wishlistBundleOutput(value));
  }

  void wishlistOutput(String body, int index) {
    print("We are In second  now...");
    var bodyT = jsonDecode(body);
    print(bodyT);
    _showMessage(bodyT["message"]);
    if (bodyT["status"]) {
      var data = json.decode(body);
      dynamic data2 = data;
      print("all man .........");
      print(data2);

      setState(() {
        productList[index].addedToWishList = true;
      });
    }
  }


  void wishlistBundleOutput(String body) {
    print("We are In second  now...");
    var bodyT = jsonDecode(body);
    print(bodyT);
    _showMessage(bodyT["message"]);
    if (bodyT["status"]) {
      var data = json.decode(body);
      dynamic data2 = data;
      print("all man .........");
      print(data2);
    }
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
