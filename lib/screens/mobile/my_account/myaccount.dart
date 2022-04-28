
import 'dart:convert';
import 'package:mymedicinemobile/screens/mobile/cart/emptycart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:mymedicinemobile/constants.dart';
import 'package:mymedicinemobile/models/models.dart';
import 'package:mymedicinemobile/reusables/location_class.dart';
import 'package:mymedicinemobile/screens/mobile/cart/cart.dart';
import 'package:mymedicinemobile/services/services.dart';
import 'package:mymedicinemobile/text_style.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAccount extends StatefulWidget {
  bool? addAddress;
  MyAccount({this.addAddress});
  _MyAccount createState() => new _MyAccount();
}

class _MyAccount extends State<MyAccount> with SingleTickerProviderStateMixin {
  bool value = false;
  bool passwordShow = false;
  bool showNewCard = false;
  bool showNewAddress = false;
  bool showUpdateAddress = false;
  bool addressLoadding = true;
  late TabController _tabController;
  TextEditingController nameC = new TextEditingController();
  TextEditingController phoneC = new TextEditingController();
  TextEditingController emailC = new TextEditingController();
  TextEditingController genderC = new TextEditingController();
  TextEditingController bdayC = new TextEditingController();
  TextEditingController passwordC = new TextEditingController();

  TextEditingController cardType = new TextEditingController();
  TextEditingController cardName = new TextEditingController();
  TextEditingController cardNumber = new TextEditingController();

  TextEditingController currentP = new TextEditingController();
  TextEditingController newP = new TextEditingController();
  TextEditingController retypeP = new TextEditingController();
  TextEditingController cvv2 = new TextEditingController();
  TextEditingController expiry = new TextEditingController();

  TextEditingController streetC = new TextEditingController();
  TextEditingController regionC = new TextEditingController();
  TextEditingController phoneEditC = new TextEditingController();
  TextEditingController emailEditC = new TextEditingController();

  TextEditingController streetC2 = new TextEditingController();
  TextEditingController regionC2 = new TextEditingController();
  TextEditingController phoneEditC2 = new TextEditingController();
  TextEditingController emailEditC2 = new TextEditingController();

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool toggleStatus = true;
  bool createAddressLoading = false;
  int currentIndex = 0;
  int newlyloaded = 0;
  List<MedShipAddrees> addressList = [];
  late MedShipAddrees medShipAddrees;
  final _controller = ScrollController();


  void getCurrentUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String Token = sharedPreferences.getString("Token")!;
    String Email = sharedPreferences.getString("Email")!;
    String LastName = sharedPreferences.getString("LastName")!;
    String FirstName = sharedPreferences.getString("FirstName")!;
    String Phone = sharedPreferences.getString("Phone")!;

    MedUser medUser =  new MedUser(firstName: FirstName,lastName: LastName,email: Email,phoneNumber: Phone,token: Token, role: "Well", userName: Email);
    Provider.of<ServiceClass>(context, listen: false).notifyLogin(medUser);
  }


  @override
  void initState() {
    // TODO: implement initState
    _tabController = new TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      print("Hello people of country...");
      setState(() {
        currentIndex = _tabController.index;
      });
      print(currentIndex);
    });

    //If a user does not have any address, we animate straight to address
    if(widget.addAddress != null){
      print("Not Nuller ............");
      _tabController.animateTo((1));
    }else{
      print(" Nuller Boy............");
    }

    getCurrentUser();
    streetC.text = "";
    regionC.text = "";
    phoneEditC.text = "";
    emailEditC.text = "";

    viewAddress();
    super.initState();
  }

  bool validateAddressInput() {
    if (streetC.text.isEmpty) {
      _showMessage("Input Street");
      return false;
    }
    else if (phoneEditC.text.length != 11) {
      _showMessage("Input a valid phone");
      return false;
    } else if (!emailEditC.text.contains("@")) {
      _showMessage("Input a valid email");
      return false;
    } else if (!emailEditC.text.contains(".")) {
      _showMessage("Input a valid email");
      return false;
    }
    return true;
  }

  setUser() {
    nameC.text = Provider.of<ServiceClass>(context).MedUsers.firstName +
        " " +
        Provider.of<ServiceClass>(context).MedUsers.lastName;
    phoneC.text = Provider.of<ServiceClass>(context).MedUsers.phoneNumber;
    emailC.text = Provider.of<ServiceClass>(context).MedUsers.email;
    genderC.text = "";
    bdayC.text = "";
    passwordC.text = Provider.of<ServiceClass>(context).MedUsers.phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    setUser();

    print("We are in build again now oooo");

    return Scaffold(
      backgroundColor: kColorWhite,
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
          width: width,
          height: height,
          child: Stack(
            children: [
              ListView(
                children: [
                  //navBarCustomCartBeforePerson("My Account", context, Cart(), true),
                  SizedBox(
                    height: 60,
                  ),
                  Container(
                    height: height,
                    width: MediaQuery.of(context).size.width,
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
                        Container(
                          constraints: BoxConstraints.expand(height: 30),
                          child: TabBar(
                            indicatorColor: kPrimaryColor,
                            tabs: [
                              Tab(
                                child: Container(
                                  child: Text(
                                    "Profile",
                                    style: currentIndex == 0
                                        ? ksmallTextBold(kPrimaryColor)
                                        : ksmallTextBold(kColorBlack),
                                  ),
                                ),
                              ),
                              // Tab(
                              //   child: Container(
                              //     child: Text(
                              //       "My Cards",
                              //       style: currentIndex == 1
                              //           ? ksmallTextBold(kPrimaryColor)
                              //           : ksmallTextBold(kColorBlack),
                              //     ),
                              //   ),
                              // ),
                              Tab(
                                child: Container(
                                  child: Text(
                                    "My Address",
                                    style: currentIndex == 1
                                        ? ksmallTextBold(kPrimaryColor)
                                        : ksmallTextBold(kColorBlack),
                                  ),
                                ),
                              ),
                            ],
                            controller: _tabController,
                          ),
                        ),
                        Expanded(
                            child: Container(
                                padding: EdgeInsets.all(10),
                                child: TabBarView(
                                    controller: _tabController,
                                    children: [
                                      /* All Tabs  */

                                      passwordShow
                                          ? Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 10),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 15),
                                              decoration: BoxDecoration(
                                                color: kColorWhite,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: kColorSmoke
                                                        .withOpacity(.4),
                                                    spreadRadius: 5,
                                                    blurRadius: 7,
                                                    offset: Offset(0,
                                                        3), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: ListView(
                                                children: [
                                                  Text(
                                                    "CHANGE PASSWORD",
                                                    style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: kColorBlack
                                                          .withOpacity(.6),
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    "Current Password",
                                                    style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: kColorBlack
                                                          .withOpacity(.6),
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  TextField(
                                                    controller: currentP,
                                                    cursorColor: kPrimaryColor,
                                                    style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: kColorBlack,
                                                      fontSize: 17,
                                                    ),
                                                    keyboardType: TextInputType
                                                        .visiblePassword,
                                                    obscureText: true,
                                                    decoration: InputDecoration(
                                                      hintText: "Required",
                                                      hintStyle: TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: kColorBlack,
                                                        fontSize: 17,
                                                      ),
                                                      //border: InputBorder.none,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 50,
                                                  ),
                                                  Text(
                                                    "New Password",
                                                    style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: kColorBlack
                                                          .withOpacity(.6),
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  TextField(
                                                    controller: newP,
                                                    cursorColor: kPrimaryColor,
                                                    style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: kColorBlack,
                                                      fontSize: 17,
                                                    ),
                                                    keyboardType: TextInputType
                                                        .visiblePassword,
                                                    obscureText: true,
                                                    decoration: InputDecoration(
                                                      hintText: "Required",
                                                      hintStyle: TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: kColorBlack,
                                                        fontSize: 17,
                                                      ),
                                                      //border: InputBorder.none,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    "Retype Password",
                                                    style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: kColorBlack
                                                          .withOpacity(.6),
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  TextField(
                                                    controller: retypeP,
                                                    cursorColor: kPrimaryColor,
                                                    style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: kColorBlack,
                                                      fontSize: 17,
                                                    ),
                                                    keyboardType: TextInputType
                                                        .visiblePassword,
                                                    obscureText: true,
                                                    decoration: InputDecoration(
                                                      hintText: "Required",
                                                      hintStyle: TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: kColorBlack,
                                                        fontSize: 17,
                                                      ),
                                                      //border: InputBorder.none,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 40,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      //Navigator.push(context,new MaterialPageRoute(builder: (context) => AddMedicine()));
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 10),
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5,
                                                              vertical: 40),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(2),
                                                          color: kPrimaryColor),
                                                      child: Center(
                                                        child: Text(
                                                          "SAVE",
                                                          style: klargeTextBold(
                                                              kColorWhite),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(
                                              height: 100,
                                              margin: EdgeInsets.only(
                                                  top: 10,
                                                  left: 10,
                                                  right: 10,
                                                  bottom: 120),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 15),
                                              decoration: BoxDecoration(
                                                color: kColorWhite,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: kColorSmoke
                                                        .withOpacity(.4),
                                                    spreadRadius: 5,
                                                    blurRadius: 7,
                                                    offset: Offset(0,
                                                        3), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: ListView(
                                                children: [
                                                  Text(
                                                    "Name",
                                                    style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: kColorBlack
                                                          .withOpacity(.6),
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 12,
                                                  ),
                                                  Container(
                                                    height: 20,
                                                    child: TextField(
                                                      controller: nameC,
                                                      cursorColor:
                                                          kPrimaryColor,
                                                      style: TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: kColorBlack,
                                                        fontSize: 13,
                                                      ),
                                                      keyboardType:
                                                          TextInputType.name,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: "",
                                                        hintStyle:
                                                            ksmallTextBold(
                                                                kColorSmoke),
                                                        //border: InputBorder.none,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "Email",
                                                    style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: kColorBlack
                                                          .withOpacity(.6),
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 12,
                                                  ),
                                                  Container(
                                                    height: 20,
                                                    child: TextField(
                                                      controller: emailC,
                                                      cursorColor:
                                                          kPrimaryColor,
                                                      style: TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: kColorBlack,
                                                        fontSize: 13,
                                                      ),
                                                      keyboardType:
                                                          TextInputType
                                                              .emailAddress,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: "",
                                                        hintStyle:
                                                            ksmallTextBold(
                                                                kColorSmoke),
                                                        //border: InputBorder.none,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "Phone Number",
                                                    style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: kColorBlack
                                                          .withOpacity(.6),
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 12,
                                                  ),
                                                  Container(
                                                    height: 20,
                                                    child: TextField(
                                                      controller: phoneC,
                                                      cursorColor:
                                                          kPrimaryColor,
                                                      style: TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: kColorBlack,
                                                        fontSize: 13,
                                                      ),
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: "",
                                                        hintStyle:
                                                            ksmallTextBold(
                                                                kColorSmoke),
                                                        //border: InputBorder.none,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "Gender",
                                                    style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: kColorBlack
                                                          .withOpacity(.6),
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 12,
                                                  ),
                                                  Container(
                                                    height: 20,
                                                    child: TextField(
                                                      controller: genderC,
                                                      cursorColor:
                                                          kPrimaryColor,
                                                      style: TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: kColorBlack,
                                                        fontSize: 13,
                                                      ),
                                                      keyboardType:
                                                          TextInputType.name,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: "",
                                                        hintStyle:
                                                            ksmallTextBold(
                                                                kColorSmoke),
                                                        //border: InputBorder.none,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "Birthdate",
                                                    style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: kColorBlack
                                                          .withOpacity(.6),
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 12,
                                                  ),
                                                  Container(
                                                    height: 20,
                                                    child: TextField(
                                                      controller: bdayC,
                                                      cursorColor:
                                                          kPrimaryColor,
                                                      style: TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: kColorBlack,
                                                        fontSize: 13,
                                                      ),
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: "",
                                                        hintStyle:
                                                            ksmallTextBold(
                                                                kColorSmoke),
                                                        //border: InputBorder.none,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Change Password",
                                                        style: TextStyle(
                                                          fontFamily: "Poppins",
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: kColorBlack
                                                              .withOpacity(.6),
                                                          fontSize: 11,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              passwordShow =
                                                                  true;
                                                            });
                                                          },
                                                          child: Icon(
                                                            Icons
                                                                .arrow_forward_ios,
                                                            size: 15,
                                                          )),
                                                    ],
                                                  ),
                                                  TextField(
                                                    controller: passwordC,
                                                    cursorColor: kPrimaryColor,
                                                    style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: kColorBlack,
                                                      fontSize: 13,
                                                    ),
                                                    keyboardType: TextInputType
                                                        .visiblePassword,
                                                    obscureText: true,
                                                    decoration: InputDecoration(
                                                      hintText: "",
                                                      hintStyle: ksmallTextBold(
                                                          kColorSmoke),
                                                      //border: InputBorder.none,
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      //Navigator.push(context,new MaterialPageRoute(builder: (context) => AddMedicine()));
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 10),
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5,
                                                              vertical: 40),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(2),
                                                          color: kPrimaryColor),
                                                      child: Center(
                                                        child: Text(
                                                          "SAVE",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "Poppins",
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: kColorWhite,
                                                            fontSize: 17,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  // SizedBox(
                                                  //   height: 10,
                                                  // ),
                                                ],
                                              ),
                                            ),

                                      // Container(
                                      //   child: ListView(
                                      //     children: [
                                      //       SizedBox(
                                      //         height: 10,
                                      //       ),
                                      //       Container(
                                      //         child: Row(
                                      //           mainAxisAlignment:
                                      //               MainAxisAlignment.end,
                                      //           children: [
                                      //             SvgPicture.asset(
                                      //               "assets/svg/add_plus.svg",
                                      //               width: 20,
                                      //               height: 25,
                                      //             ),
                                      //             SizedBox(
                                      //               width: 5,
                                      //             ),
                                      //             InkWell(
                                      //               onTap: () {
                                      //                 setState(() {
                                      //                   showNewCard = true;
                                      //                 });
                                      //               },
                                      //               child: Text(
                                      //                 "ADD NEW CARD",
                                      //                 style: TextStyle(
                                      //                   fontFamily: "Poppins",
                                      //                   fontWeight: FontWeight.w400,
                                      //                   color: kColorBlack
                                      //                       .withOpacity(.6),
                                      //                   fontSize: 14,
                                      //                 ),
                                      //               ),
                                      //             ),
                                      //           ],
                                      //         ),
                                      //       ),
                                      //       SizedBox(
                                      //         height: 10,
                                      //       ),
                                      //       customCards(
                                      //           true, "assets/svg/visa.svg"),
                                      //       customCards(
                                      //           false, "assets/svg/mastercard.svg"),
                                      //       SizedBox(
                                      //         height: 20,
                                      //       ),
                                      //       showNewCard == false
                                      //           ? Center()
                                      //           : Container(
                                      //               margin: EdgeInsets.symmetric(
                                      //                   horizontal: 5,
                                      //                   vertical: 10),
                                      //               padding: EdgeInsets.symmetric(
                                      //                   horizontal: 10,
                                      //                   vertical: 20),
                                      //               decoration: BoxDecoration(
                                      //                 borderRadius:
                                      //                     BorderRadius.circular(30),
                                      //                 color: kColorWhite,
                                      //                 boxShadow: [
                                      //                   BoxShadow(
                                      //                     color: kColorSmoke
                                      //                         .withOpacity(.4),
                                      //                     spreadRadius: 5,
                                      //                     blurRadius: 7,
                                      //                     offset: Offset(0,
                                      //                         3), // changes position of shadow
                                      //                   ),
                                      //                 ],
                                      //               ),
                                      //               child: Column(
                                      //                 children: [
                                      //                   Row(
                                      //                     mainAxisAlignment:
                                      //                         MainAxisAlignment
                                      //                             .spaceBetween,
                                      //                     children: [
                                      //                       Row(
                                      //                         children: [
                                      //                           SvgPicture.asset(
                                      //                             "assets/svg/add_plus.svg",
                                      //                             width: 20,
                                      //                             height: 25,
                                      //                           ),
                                      //                           SizedBox(
                                      //                             width: 5,
                                      //                           ),
                                      //                           Text(
                                      //                             "ADD NEW CARD",
                                      //                             style: TextStyle(
                                      //                               fontFamily:
                                      //                                   "Poppins",
                                      //                               fontWeight:
                                      //                                   FontWeight
                                      //                                       .w400,
                                      //                               color: kColorBlack
                                      //                                   .withOpacity(
                                      //                                       .6),
                                      //                               fontSize: 14,
                                      //                             ),
                                      //                           ),
                                      //                         ],
                                      //                       ),
                                      //                       Row(
                                      //                         children: [
                                      //                           SvgPicture.asset(
                                      //                             "assets/svg/saver.svg",
                                      //                             width: 15,
                                      //                             height: 15,
                                      //                           ),
                                      //                           SizedBox(
                                      //                             width: 5,
                                      //                           ),
                                      //                           Text(
                                      //                             "SAVE",
                                      //                             style: TextStyle(
                                      //                               fontFamily:
                                      //                                   "Poppins",
                                      //                               fontWeight:
                                      //                                   FontWeight
                                      //                                       .w500,
                                      //                               color: kPrimaryColor
                                      //                                   .withOpacity(
                                      //                                       .6),
                                      //                               fontSize: 15,
                                      //                             ),
                                      //                           ),
                                      //                         ],
                                      //                       ),
                                      //                     ],
                                      //                   ),
                                      //                   SizedBox(
                                      //                     height: 30,
                                      //                   ),
                                      //                   Container(
                                      //                     padding:
                                      //                         EdgeInsets.symmetric(
                                      //                             horizontal: 12,
                                      //                             vertical: 5),
                                      //                     child: Row(
                                      //                       mainAxisAlignment:
                                      //                           MainAxisAlignment
                                      //                               .spaceBetween,
                                      //                       children: [
                                      //                         Expanded(
                                      //                           flex: 1,
                                      //                           child: TextField(
                                      //                             controller:
                                      //                                 cardType,
                                      //                             cursorColor:
                                      //                                 kPrimaryColor,
                                      //                             style: TextStyle(
                                      //                               fontFamily:
                                      //                                   "Poppins",
                                      //                               fontWeight:
                                      //                                   FontWeight
                                      //                                       .w400,
                                      //                               color:
                                      //                                   kColorBlack,
                                      //                               fontSize: 17,
                                      //                             ),
                                      //                             keyboardType:
                                      //                                 TextInputType
                                      //                                     .name,
                                      //                             decoration:
                                      //                                 InputDecoration(
                                      //                               hintText:
                                      //                                   "Card Type",
                                      //                               hintStyle:
                                      //                                   ksmallTextBold(
                                      //                                       kColorSmoke),
                                      //                               border:
                                      //                                   InputBorder
                                      //                                       .none,
                                      //                             ),
                                      //                           ),
                                      //                         ),
                                      //                         Text("Visa Express"),
                                      //                       ],
                                      //                     ),
                                      //                     decoration: BoxDecoration(
                                      //                         borderRadius:
                                      //                             BorderRadius
                                      //                                 .circular(10),
                                      //                         border: Border.all(
                                      //                             color:
                                      //                                 kColorSmoke,
                                      //                             width: 1,
                                      //                             style: BorderStyle
                                      //                                 .solid)),
                                      //                   ),
                                      //                   Container(
                                      //                     margin: EdgeInsets.only(
                                      //                         top: 20),
                                      //                     padding:
                                      //                         EdgeInsets.symmetric(
                                      //                             horizontal: 12,
                                      //                             vertical: 5),
                                      //                     child: Row(
                                      //                       mainAxisAlignment:
                                      //                           MainAxisAlignment
                                      //                               .spaceBetween,
                                      //                       children: [
                                      //                         Expanded(
                                      //                           flex: 1,
                                      //                           child: TextField(
                                      //                             controller:
                                      //                                 cardNumber,
                                      //                             cursorColor:
                                      //                                 kPrimaryColor,
                                      //                             style: TextStyle(
                                      //                               fontFamily:
                                      //                                   "Poppins",
                                      //                               fontWeight:
                                      //                                   FontWeight
                                      //                                       .w400,
                                      //                               color:
                                      //                                   kColorBlack,
                                      //                               fontSize: 17,
                                      //                             ),
                                      //                             keyboardType:
                                      //                                 TextInputType
                                      //                                     .name,
                                      //                             decoration:
                                      //                                 InputDecoration(
                                      //                               hintText:
                                      //                                   "Card Number",
                                      //                               hintStyle:
                                      //                                   ksmallTextBold(
                                      //                                       kColorSmoke),
                                      //                               border:
                                      //                                   InputBorder
                                      //                                       .none,
                                      //                             ),
                                      //                           ),
                                      //                         ),
                                      //                         Text(
                                      //                             "1234-1234-3456"),
                                      //                       ],
                                      //                     ),
                                      //                     decoration: BoxDecoration(
                                      //                         borderRadius:
                                      //                             BorderRadius
                                      //                                 .circular(10),
                                      //                         border: Border.all(
                                      //                             color:
                                      //                                 kColorSmoke,
                                      //                             width: 1,
                                      //                             style: BorderStyle
                                      //                                 .solid)),
                                      //                   ),
                                      //                   Container(
                                      //                     margin: EdgeInsets.only(
                                      //                         top: 20),
                                      //                     padding:
                                      //                         EdgeInsets.symmetric(
                                      //                             horizontal: 12,
                                      //                             vertical: 5),
                                      //                     child: Row(
                                      //                       mainAxisAlignment:
                                      //                           MainAxisAlignment
                                      //                               .spaceBetween,
                                      //                       children: [
                                      //                         Expanded(
                                      //                           flex: 1,
                                      //                           child: TextField(
                                      //                             controller:
                                      //                                 cardName,
                                      //                             cursorColor:
                                      //                                 kPrimaryColor,
                                      //                             style: TextStyle(
                                      //                               fontFamily:
                                      //                                   "Poppins",
                                      //                               fontWeight:
                                      //                                   FontWeight
                                      //                                       .w400,
                                      //                               color:
                                      //                                   kColorBlack,
                                      //                               fontSize: 17,
                                      //                             ),
                                      //                             keyboardType:
                                      //                                 TextInputType
                                      //                                     .name,
                                      //                             decoration:
                                      //                                 InputDecoration(
                                      //                               hintText:
                                      //                                   "Name on Card",
                                      //                               hintStyle:
                                      //                                   ksmallTextBold(
                                      //                                       kColorSmoke),
                                      //                               border:
                                      //                                   InputBorder
                                      //                                       .none,
                                      //                             ),
                                      //                           ),
                                      //                         ),
                                      //                         Text("Uche Chineke"),
                                      //                       ],
                                      //                     ),
                                      //                     decoration: BoxDecoration(
                                      //                         borderRadius:
                                      //                             BorderRadius
                                      //                                 .circular(10),
                                      //                         border: Border.all(
                                      //                             color:
                                      //                                 kColorSmoke,
                                      //                             width: 1,
                                      //                             style: BorderStyle
                                      //                                 .solid)),
                                      //                   ),
                                      //                   Row(
                                      //                     mainAxisAlignment:
                                      //                         MainAxisAlignment
                                      //                             .spaceBetween,
                                      //                     children: [
                                      //                       Container(
                                      //                         width: width / 2,
                                      //                         margin:
                                      //                             EdgeInsets.only(
                                      //                                 top: 20),
                                      //                         padding: EdgeInsets
                                      //                             .symmetric(
                                      //                                 horizontal:
                                      //                                     12,
                                      //                                 vertical: 5),
                                      //                         child: Row(
                                      //                           mainAxisAlignment:
                                      //                               MainAxisAlignment
                                      //                                   .spaceBetween,
                                      //                           children: [
                                      //                             Expanded(
                                      //                               flex: 1,
                                      //                               child:
                                      //                                   TextField(
                                      //                                 controller:
                                      //                                     expiry,
                                      //                                 cursorColor:
                                      //                                     kPrimaryColor,
                                      //                                 style:
                                      //                                     TextStyle(
                                      //                                   fontFamily:
                                      //                                       "Poppins",
                                      //                                   fontWeight:
                                      //                                       FontWeight
                                      //                                           .w400,
                                      //                                   color:
                                      //                                       kColorBlack,
                                      //                                   fontSize:
                                      //                                       17,
                                      //                                 ),
                                      //                                 keyboardType:
                                      //                                     TextInputType
                                      //                                         .name,
                                      //                                 decoration:
                                      //                                     InputDecoration(
                                      //                                   hintText:
                                      //                                       "Expiry Date",
                                      //                                   hintStyle:
                                      //                                       ksmallTextBold(
                                      //                                           kColorSmoke),
                                      //                                   border:
                                      //                                       InputBorder
                                      //                                           .none,
                                      //                                 ),
                                      //                               ),
                                      //                             ),
                                      //                             Text("10/23"),
                                      //                           ],
                                      //                         ),
                                      //                         decoration: BoxDecoration(
                                      //                             borderRadius:
                                      //                                 BorderRadius
                                      //                                     .circular(
                                      //                                         10),
                                      //                             border: Border.all(
                                      //                                 color:
                                      //                                     kColorSmoke,
                                      //                                 width: 1,
                                      //                                 style: BorderStyle
                                      //                                     .solid)),
                                      //                       ),
                                      //                       Container(
                                      //                         width: width / 4,
                                      //                         margin:
                                      //                             EdgeInsets.only(
                                      //                                 top: 20),
                                      //                         padding: EdgeInsets
                                      //                             .symmetric(
                                      //                                 horizontal:
                                      //                                     12,
                                      //                                 vertical: 5),
                                      //                         child: Row(
                                      //                           mainAxisAlignment:
                                      //                               MainAxisAlignment
                                      //                                   .spaceBetween,
                                      //                           children: [
                                      //                             Expanded(
                                      //                               flex: 1,
                                      //                               child:
                                      //                                   TextField(
                                      //                                 controller:
                                      //                                     cvv2,
                                      //                                 cursorColor:
                                      //                                     kPrimaryColor,
                                      //                                 style:
                                      //                                     TextStyle(
                                      //                                   fontFamily:
                                      //                                       "Poppins",
                                      //                                   fontWeight:
                                      //                                       FontWeight
                                      //                                           .w400,
                                      //                                   color:
                                      //                                       kColorBlack,
                                      //                                   fontSize:
                                      //                                       17,
                                      //                                 ),
                                      //                                 keyboardType:
                                      //                                     TextInputType
                                      //                                         .name,
                                      //                                 decoration:
                                      //                                     InputDecoration(
                                      //                                   hintText:
                                      //                                       "CVV",
                                      //                                   hintStyle:
                                      //                                       ksmallTextBold(
                                      //                                           kColorSmoke),
                                      //                                   border:
                                      //                                       InputBorder
                                      //                                           .none,
                                      //                                 ),
                                      //                               ),
                                      //                             ),
                                      //                             Text("2"),
                                      //                           ],
                                      //                         ),
                                      //                         decoration: BoxDecoration(
                                      //                             borderRadius:
                                      //                                 BorderRadius
                                      //                                     .circular(
                                      //                                         10),
                                      //                             border: Border.all(
                                      //                                 color:
                                      //                                     kColorSmoke,
                                      //                                 width: 1,
                                      //                                 style: BorderStyle
                                      //                                     .solid)),
                                      //                       ),
                                      //                     ],
                                      //                   ),
                                      //                   SizedBox(
                                      //                     height: 20,
                                      //                   ),
                                      //                   Row(
                                      //                     mainAxisAlignment:
                                      //                         MainAxisAlignment.end,
                                      //                     children: [
                                      //                       Text(
                                      //                           "Save my card details",
                                      //                           style: TextStyle(
                                      //                             fontFamily:
                                      //                                 "Poppins",
                                      //                             fontWeight:
                                      //                                 FontWeight
                                      //                                     .w400,
                                      //                             color:
                                      //                                 kColorSmoke,
                                      //                             fontSize: 14,
                                      //                           )),
                                      //                       SizedBox(
                                      //                         width: 5,
                                      //                       ),
                                      //                       Container(
                                      //                           child:
                                      //                               FlutterSwitch(
                                      //                         width: 70.0,
                                      //                         height: 30.0,
                                      //                         activeColor:
                                      //                             kPrimaryColor,
                                      //                         valueFontSize: 15.0,
                                      //                         toggleSize: 10.0,
                                      //                         value: toggleStatus,
                                      //                         borderRadius: 30.0,
                                      //                         padding: 8.0,
                                      //                         showOnOff: true,
                                      //                         onToggle: (val) {
                                      //                           setState(() {
                                      //                             if (toggleStatus) {
                                      //                               toggleStatus =
                                      //                                   false;
                                      //                             } else {
                                      //                               toggleStatus =
                                      //                                   true;
                                      //                             }
                                      //                           });
                                      //                         },
                                      //                       ))
                                      //                     ],
                                      //                   ),
                                      //                 ],
                                      //               ))
                                      //     ],
                                      //   ),
                                      // ),

                                      /*

                                       */
                                      Container(
                                        child: showUpdateAddress
                                            ? ListView(
                                                children: [
                                                  Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5,
                                                              vertical: 10),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 20),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        color: kColorWhite,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: kColorSmoke
                                                                .withOpacity(
                                                                    .4),
                                                            spreadRadius: 5,
                                                            blurRadius: 7,
                                                            offset: Offset(0,
                                                                3), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  SvgPicture
                                                                      .asset(
                                                                    "assets/svg/edit_address.svg",
                                                                    width: 20,
                                                                    height: 20,
                                                                    color:
                                                                        kColorSmoke,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Text(
                                                                    "EDIT ADDRESS",
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          "Poppins",
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: kColorBlack
                                                                          .withOpacity(
                                                                              .4),
                                                                      fontSize:
                                                                          12,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  SvgPicture
                                                                      .asset(
                                                                    "assets/svg/saver.svg",
                                                                    width: 10,
                                                                    height: 15,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        createAddressLoading =
                                                                            true;
                                                                      });
                                                                      updateAddress(medShipAddrees.customerShippingAddressId, toggleStatus);
                                                                    },
                                                                    child: createAddressLoading
                                                                        ? CircularProgressIndicator(
                                                                            color:
                                                                                kPrimaryColor,
                                                                          )
                                                                        : Text(
                                                                            "SAVE",
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: "Poppins",
                                                                              fontWeight: FontWeight.w500,
                                                                              color: kPrimaryColor.withOpacity(.6),
                                                                              fontSize: 12,
                                                                            ),
                                                                          ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 30,
                                                          ),

                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            "Street Address",
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                fontFamily:
                                                                "Poppins",
                                                                color:
                                                                kColorSmoke,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                            textAlign:
                                                            TextAlign.start,
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Container(
                                                            height: 45,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                12,
                                                                vertical:
                                                                5),
                                                            child: TextField(
                                                              controller:
                                                              streetC2,
                                                              cursorColor:
                                                              kPrimaryColor,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                "Poppins",
                                                                fontWeight:
                                                                FontWeight
                                                                    .w400,
                                                                color:
                                                                kColorBlack,
                                                                fontSize: 14,
                                                              ),
                                                              keyboardType:
                                                              TextInputType
                                                                  .name,
                                                              decoration:
                                                              InputDecoration(
                                                                hintText: "",
                                                                hintStyle:
                                                                ksmallTextBold(
                                                                    kColorSmoke),
                                                                border:
                                                                InputBorder
                                                                    .none,
                                                              ),
                                                            ),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    10),
                                                                border: Border.all(
                                                                    color:
                                                                    kColorSmoke,
                                                                    width: 1,
                                                                    style: BorderStyle
                                                                        .solid)),
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            "Country",
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                fontFamily:
                                                                    "Poppins",
                                                                color:
                                                                    kColorSmoke,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => LocationState(
                                                                          "Country",
                                                                          0)));
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      10),
                                                                  border: Border.all(
                                                                      color:
                                                                      kColorSmoke,
                                                                      width: 1,
                                                                      style: BorderStyle
                                                                          .solid)),
                                                              height: 45,
                                                              width: width,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                  12,
                                                                  vertical:
                                                                  10),
                                                              child: Text(
                                                                Provider.of<ServiceClass>(
                                                                        context)
                                                                    .Country
                                                                    .toString(),
                                                                style: ksmallTextBold(
                                                                    kColorBlack),
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                              ),
                                                            ),
                                                          ),
                                                          // Divider(
                                                          //   thickness: 1,
                                                          //   color: kColorSmoke2,
                                                          // ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            "State",
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                fontFamily:
                                                                    "Poppins",
                                                                color:
                                                                    kColorSmoke,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => LocationState(
                                                                          "State",
                                                                          Provider.of<ServiceClass>(context)
                                                                              .CountryId)));
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      10),
                                                                  border: Border.all(
                                                                      color:
                                                                      kColorSmoke,
                                                                      width: 1,
                                                                      style: BorderStyle
                                                                          .solid)),
                                                              height: 45,
                                                              width: width,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                  12,
                                                                  vertical:
                                                                  10),
                                                              child: Text(
                                                                Provider.of<ServiceClass>(
                                                                        context)
                                                                    .State
                                                                    .toString(),
                                                                style: ksmallTextBold(
                                                                    kColorBlack),
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                              ),
                                                            ),
                                                          ),
                                                          // Divider(
                                                          //   thickness: 1,
                                                          //   color: kColorSmoke2,
                                                          // ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            "City",
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                fontFamily:
                                                                    "Poppins",
                                                                color:
                                                                    kColorSmoke,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => LocationState(
                                                                          "LGA",
                                                                          Provider.of<ServiceClass>(context)
                                                                              .StateId)));
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  border: Border.all(
                                                                      color:
                                                                          kColorSmoke,
                                                                      width: 1,
                                                                      style: BorderStyle
                                                                          .solid)),
                                                              height: 45,
                                                              width: width,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          12,
                                                                      vertical:
                                                                          10),
                                                              child: Text(
                                                                Provider.of<ServiceClass>(
                                                                        context)
                                                                    .LGA
                                                                    .toString(),
                                                                style: ksmallTextBold(
                                                                    kColorBlack),
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                              ),
                                                            ),
                                                          ),
                                                          // Divider(
                                                          //   thickness: 1,
                                                          //   color: kColorSmoke2,
                                                          // ),

                                                          // SizedBox(
                                                          //   height: 15,
                                                          // ),
                                                          // Text(
                                                          //   "Region/State",
                                                          //   style: TextStyle(
                                                          //       fontSize: 11,
                                                          //       fontFamily:
                                                          //           "Poppins",
                                                          //       color:
                                                          //           kColorSmoke,
                                                          //       fontWeight:
                                                          //           FontWeight
                                                          //               .w400),
                                                          //   textAlign:
                                                          //       TextAlign.start,
                                                          // ),
                                                          // SizedBox(
                                                          //   height: 5,
                                                          // ),
                                                          // Container(
                                                          //   height: 45,
                                                          //   padding: EdgeInsets
                                                          //       .symmetric(
                                                          //           horizontal:
                                                          //               12,
                                                          //           vertical:
                                                          //               5),
                                                          //   child: TextField(
                                                          //     controller:
                                                          //         regionC2,
                                                          //     cursorColor:
                                                          //         kPrimaryColor,
                                                          //     style: TextStyle(
                                                          //       fontFamily:
                                                          //           "Poppins",
                                                          //       fontWeight:
                                                          //           FontWeight
                                                          //               .w400,
                                                          //       color:
                                                          //           kColorBlack,
                                                          //       fontSize: 14,
                                                          //     ),
                                                          //     keyboardType:
                                                          //         TextInputType
                                                          //             .name,
                                                          //     decoration:
                                                          //         InputDecoration(
                                                          //       hintText: "",
                                                          //       hintStyle:
                                                          //           ksmallTextBold(
                                                          //               kColorSmoke),
                                                          //       border:
                                                          //           InputBorder
                                                          //               .none,
                                                          //     ),
                                                          //   ),
                                                          //   decoration: BoxDecoration(
                                                          //       borderRadius:
                                                          //           BorderRadius
                                                          //               .circular(
                                                          //                   10),
                                                          //       border: Border.all(
                                                          //           color:
                                                          //               kColorSmoke,
                                                          //           width: 1,
                                                          //           style: BorderStyle
                                                          //               .solid)),
                                                          // ),
                                                          SizedBox(
                                                            height: 15,
                                                          ),
                                                          Text(
                                                            "Phone Number",
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                fontFamily:
                                                                    "Poppins",
                                                                color:
                                                                    kColorSmoke,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Container(
                                                            height: 45,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical:
                                                                        5),
                                                            child: TextField(
                                                              controller:
                                                                  phoneEditC2,
                                                              cursorColor:
                                                                  kPrimaryColor,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    "Poppins",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color:
                                                                    kColorBlack,
                                                                fontSize: 14,
                                                              ),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .name,
                                                              decoration:
                                                                  InputDecoration(
                                                                hintText: "",
                                                                hintStyle:
                                                                    ksmallTextBold(
                                                                        kColorSmoke),
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                              ),
                                                            ),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                border: Border.all(
                                                                    color:
                                                                        kColorSmoke,
                                                                    width: 1,
                                                                    style: BorderStyle
                                                                        .solid)),
                                                          ),
                                                          SizedBox(
                                                            height: 15,
                                                          ),
                                                          Text(
                                                            "Email Address",
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                fontFamily:
                                                                    "Poppins",
                                                                color:
                                                                    kColorSmoke,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Container(
                                                            height: 45,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical:
                                                                        5),
                                                            child: TextField(
                                                              controller:
                                                                  emailEditC2,
                                                              cursorColor:
                                                                  kPrimaryColor,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    "Poppins",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color:
                                                                    kColorBlack,
                                                                fontSize: 14,
                                                              ),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .name,
                                                              decoration:
                                                                  InputDecoration(
                                                                hintText: "",
                                                                hintStyle:
                                                                    ksmallTextBold(
                                                                        kColorSmoke),
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                              ),
                                                            ),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                border: Border.all(
                                                                    color:
                                                                        kColorSmoke,
                                                                    width: 1,
                                                                    style: BorderStyle
                                                                        .solid)),
                                                          ),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                  "Make this my default address",
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        "Poppins",
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color:
                                                                        kColorSmoke,
                                                                    fontSize:
                                                                        14,
                                                                  )),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Container(
                                                                  child:
                                                                      FlutterSwitch(
                                                                width: 70.0,
                                                                height: 30.0,
                                                                activeColor:
                                                                    kPrimaryColor,
                                                                valueFontSize:
                                                                    15.0,
                                                                toggleSize:
                                                                    10.0,
                                                                value:
                                                                    toggleStatus,
                                                                borderRadius:
                                                                    30.0,
                                                                padding: 8.0,
                                                                showOnOff: true,
                                                                onToggle:
                                                                    (val) {
                                                                  setState(() {
                                                                    setState(
                                                                        () {
                                                                      toggleStatus =
                                                                          !toggleStatus;
                                                                    });
                                                                  });
                                                                },
                                                              ))
                                                            ],
                                                          ),
                                                        ],
                                                      )),
                                                  SizedBox(
                                                    height: 150,
                                                  ),
                                                ],
                                              )
                                            : ListView(
                                                controller: _controller,
                                                children: [
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Container(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        SvgPicture.asset(
                                                          "assets/svg/add_plus.svg",
                                                          width: 20,
                                                          height: 25,
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              showNewAddress =
                                                                  true;
                                                            });
                                                            _controller
                                                                .animateTo(
                                                              _controller
                                                                      .position
                                                                      .maxScrollExtent +
                                                                  250,
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          1),
                                                              curve: Curves
                                                                  .fastOutSlowIn,
                                                            );
                                                          },
                                                          child: Text(
                                                            "ADD NEW ADDRESS",
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  "Poppins",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: kColorBlack
                                                                  .withOpacity(
                                                                      .6),
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),

                                                  addressLoadding
                                                      ? Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                          strokeWidth: 20,
                                                          color: kPrimaryColor,
                                                        ))
                                                      : Column(
                                                          children: [
                                                            ...addressList.map(
                                                                (e) =>
                                                                    customAddress(
                                                                        e)),
                                                          ],
                                                        ),

                                                  // FutureBuilder(
                                                  //     future: ServiceClass()
                                                  //         .viewShipmentAddresses(),
                                                  //     builder: (context, snapshot) {
                                                  //       if (snapshot.hasData) {
                                                  //         if (snapshot.data
                                                  //             .toString()
                                                  //             .contains(
                                                  //                 "Network Error")) {
                                                  //         } else {
                                                  //           print("Well we are here");
                                                  //           print(
                                                  //               snapshot.data.toString());
                                                  //           var data = json.decode(
                                                  //               snapshot.data.toString());
                                                  //           dynamic value =
                                                  //               data["data"]["value"];
                                                  //           addressList = value
                                                  //               .map<MedShipAddrees>(
                                                  //                   (element) =>
                                                  //                       MedShipAddrees
                                                  //                           .fromJson(
                                                  //                               element))
                                                  //               .toList();
                                                  //           print("Addresses");
                                                  //
                                                  //           return Column(
                                                  //             children: [
                                                  //               ...addressList.map((e) =>
                                                  //                   customAddress(e)),
                                                  //             ],
                                                  //           );
                                                  //         }
                                                  //       }
                                                  //       return Container(
                                                  //           child: Center(
                                                  //               child:
                                                  //                   CircularProgressIndicator(
                                                  //         color: kPrimaryColor,
                                                  //         strokeWidth: 10,
                                                  //       )));
                                                  //     }),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  showNewAddress == false
                                                      ? Center()
                                                      : Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal: 5,
                                                                  vertical: 10),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 20),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                            color: kColorWhite,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: kColorSmoke
                                                                    .withOpacity(
                                                                        .4),
                                                                spreadRadius: 5,
                                                                blurRadius: 7,
                                                                offset: Offset(
                                                                    0,
                                                                    3), // changes position of shadow
                                                              ),
                                                            ],
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      SvgPicture
                                                                          .asset(
                                                                        "assets/svg/add_plus.svg",
                                                                        width:
                                                                            20,
                                                                        height:
                                                                            25,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        "ADD NEW ADDRESS",
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              "Poppins",
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          color:
                                                                              kColorBlack.withOpacity(.6),
                                                                          fontSize:
                                                                              14,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      SvgPicture
                                                                          .asset(
                                                                        "assets/svg/saver.svg",
                                                                        width:
                                                                            15,
                                                                        height:
                                                                            15,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          if (validateAddressInput()) {
                                                                            setState(() {
                                                                              createAddressLoading = true;
                                                                            });
                                                                            createAddress();
                                                                          }
                                                                        },
                                                                        child: createAddressLoading
                                                                            ? CircularProgressIndicator(
                                                                                color: kPrimaryColor,
                                                                              )
                                                                            : Text(
                                                                                "SAVE",
                                                                                style: TextStyle(
                                                                                  fontFamily: "Poppins",
                                                                                  fontWeight: FontWeight.w500,
                                                                                  color: kPrimaryColor.withOpacity(.6),
                                                                                  fontSize: 15,
                                                                                ),
                                                                              ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 30,
                                                              ),

                                                              Text(
                                                                "Street Address",
                                                                style: ksmallTextBold(
                                                                    kColorSmoke),
                                                                textAlign:
                                                                TextAlign
                                                                    .start,
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Container(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                    12,
                                                                    vertical:
                                                                    5),
                                                                child:
                                                                TextField(
                                                                  controller:
                                                                  streetC,
                                                                  cursorColor:
                                                                  kPrimaryColor,
                                                                  style:
                                                                  TextStyle(
                                                                    fontFamily:
                                                                    "Poppins",
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                    color:
                                                                    kColorBlack,
                                                                    fontSize:
                                                                    14,
                                                                  ),
                                                                  keyboardType:
                                                                  TextInputType
                                                                      .name,
                                                                  decoration:
                                                                  InputDecoration(
                                                                    hintText:
                                                                    "",
                                                                    hintStyle:
                                                                    ksmallTextBold(
                                                                        kColorSmoke),
                                                                    border:
                                                                    InputBorder
                                                                        .none,
                                                                  ),
                                                                ),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius.circular(
                                                                        10),
                                                                    border: Border.all(
                                                                        color:
                                                                        kColorSmoke,
                                                                        width:
                                                                        1,
                                                                        style: BorderStyle
                                                                            .solid)),
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Text(
                                                                "Country",
                                                                style: ksmallTextBold(
                                                                    kColorSmoke),
                                                                textAlign:
                                                                TextAlign
                                                                    .start,
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => LocationState(
                                                                              "Country",
                                                                              0)));
                                                                },
                                                                child: Container(
                                                                    decoration: BoxDecoration(
                                                                      borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                          10),
                                                                      border: Border.all(
                                                                          color:
                                                                          kColorSmoke,
                                                                          width: 1,
                                                                          style: BorderStyle
                                                                              .solid)),
                                                                  height: 45,
                                                                  width: width,
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                      12,
                                                                      vertical:
                                                                      10),
                                                                  child: Text(
                                                                    Provider.of<ServiceClass>(
                                                                            context)
                                                                        .Country
                                                                        .toString(),
                                                                    style: ksmallTextBold(
                                                                        kColorBlack),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                  ),
                                                                ),
                                                              ),
                                                              // Divider(
                                                              //   thickness: 1,
                                                              //   color:
                                                              //       kColorSmoke2,
                                                              // ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Text(
                                                                "State",
                                                                style: ksmallTextBold(
                                                                    kColorSmoke),
                                                                textAlign:
                                                                TextAlign
                                                                    .start,
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => LocationState(
                                                                              "State",
                                                                              Provider.of<ServiceClass>(context).CountryId)));
                                                                },
                                                                child: Container(
                                                                    decoration: BoxDecoration(
                                                                      borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                          10),
                                                                      border: Border.all(
                                                                          color:
                                                                          kColorSmoke,
                                                                          width: 1,
                                                                          style: BorderStyle
                                                                              .solid)),
                                                                  height: 45,
                                                                  width: width,
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                      12,
                                                                      vertical:
                                                                      10),
                                                                  child: Text(
                                                                    Provider.of<ServiceClass>(
                                                                            context)
                                                                        .State
                                                                        .toString(),
                                                                    style: ksmallTextBold(
                                                                        kColorBlack),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                  ),
                                                                ),
                                                              ),
                                                              // Divider(
                                                              //   thickness: 1,
                                                              //   color:
                                                              //       kColorSmoke2,
                                                              // ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),

                                                              Text(
                                                                "City",
                                                                style: ksmallTextBold(
                                                                    kColorSmoke),
                                                                textAlign:
                                                                TextAlign
                                                                    .start,
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => LocationState(
                                                                              "LGA",
                                                                              Provider.of<ServiceClass>(context).StateId)));
                                                                },
                                                                child: Container(
                                                                    decoration: BoxDecoration(
                                                                      borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                          10),
                                                                      border: Border.all(
                                                                          color:
                                                                          kColorSmoke,
                                                                          width: 1,
                                                                          style: BorderStyle
                                                                              .solid)),
                                                                  height: 45,
                                                                  width: width,
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                      12,
                                                                      vertical:
                                                                      10),
                                                                  child: Text(
                                                                    Provider.of<ServiceClass>(
                                                                            context)
                                                                        .LGA
                                                                        .toString(),
                                                                    style: ksmallTextBold(
                                                                        kColorBlack),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                  ),
                                                                ),
                                                              ),
                                                              // Divider(
                                                              //   thickness: 1,
                                                              //   color:
                                                              //       kColorSmoke2,
                                                              // ),
                                                              //
                                                              // SizedBox(
                                                              //   height: 15,
                                                              // ),
                                                              // Text(
                                                              //   "Region/State",
                                                              //   style: ksmallTextBold(
                                                              //       kColorSmoke),
                                                              //   textAlign:
                                                              //       TextAlign
                                                              //           .start,
                                                              // ),
                                                              // SizedBox(
                                                              //   height: 5,
                                                              // ),
                                                              // Container(
                                                              //   padding: EdgeInsets
                                                              //       .symmetric(
                                                              //           horizontal:
                                                              //               12,
                                                              //           vertical:
                                                              //               5),
                                                              //   child:
                                                              //       TextField(
                                                              //     controller:
                                                              //         regionC,
                                                              //     cursorColor:
                                                              //         kPrimaryColor,
                                                              //     style:
                                                              //         TextStyle(
                                                              //       fontFamily:
                                                              //           "Poppins",
                                                              //       fontWeight:
                                                              //           FontWeight
                                                              //               .w400,
                                                              //       color:
                                                              //           kColorBlack,
                                                              //       fontSize:
                                                              //           14,
                                                              //     ),
                                                              //     keyboardType:
                                                              //         TextInputType
                                                              //             .name,
                                                              //     decoration:
                                                              //         InputDecoration(
                                                              //       hintText:
                                                              //           "",
                                                              //       hintStyle:
                                                              //           ksmallTextBold(
                                                              //               kColorSmoke),
                                                              //       border:
                                                              //           InputBorder
                                                              //               .none,
                                                              //     ),
                                                              //   ),
                                                              //   decoration: BoxDecoration(
                                                              //       borderRadius:
                                                              //           BorderRadius.circular(
                                                              //               10),
                                                              //       border: Border.all(
                                                              //           color:
                                                              //               kColorSmoke,
                                                              //           width:
                                                              //               1,
                                                              //           style: BorderStyle
                                                              //               .solid)),
                                                              // ),
                                                              SizedBox(
                                                                height: 15,
                                                              ),
                                                              Text(
                                                                "Phone Number",
                                                                style: ksmallTextBold(
                                                                    kColorSmoke),
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Container(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            12,
                                                                        vertical:
                                                                            5),
                                                                child:
                                                                    TextField(
                                                                  controller:
                                                                      phoneEditC,
                                                                  cursorColor:
                                                                      kPrimaryColor,
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        "Poppins",
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color:
                                                                        kColorBlack,
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .name,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    hintText:
                                                                        "",
                                                                    hintStyle:
                                                                        ksmallTextBold(
                                                                            kColorSmoke),
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                  ),
                                                                ),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    border: Border.all(
                                                                        color:
                                                                            kColorSmoke,
                                                                        width:
                                                                            1,
                                                                        style: BorderStyle
                                                                            .solid)),
                                                              ),
                                                              SizedBox(
                                                                height: 15,
                                                              ),
                                                              Text(
                                                                "Email Address",
                                                                style: ksmallTextBold(
                                                                    kColorSmoke),
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Container(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            12,
                                                                        vertical:
                                                                            5),
                                                                child:
                                                                    TextField(
                                                                  controller:
                                                                      emailEditC,
                                                                  cursorColor:
                                                                      kPrimaryColor,
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        "Poppins",
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color:
                                                                        kColorBlack,
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .name,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    hintText:
                                                                        "",
                                                                    hintStyle:
                                                                        ksmallTextBold(
                                                                            kColorSmoke),
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                  ),
                                                                ),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    border: Border.all(
                                                                        color:
                                                                            kColorSmoke,
                                                                        width:
                                                                            1,
                                                                        style: BorderStyle
                                                                            .solid)),
                                                              ),
                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Text(
                                                                      "Make this my default address",
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            "Poppins",
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        color:
                                                                            kColorSmoke,
                                                                        fontSize:
                                                                            14,
                                                                      )),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Container(
                                                                      child:
                                                                          FlutterSwitch(
                                                                    width: 70.0,
                                                                    height:
                                                                        30.0,
                                                                    activeColor:
                                                                        kPrimaryColor,
                                                                    valueFontSize:
                                                                        15.0,
                                                                    toggleSize:
                                                                        10.0,
                                                                    value:
                                                                        toggleStatus,
                                                                    borderRadius:
                                                                        30.0,
                                                                    padding:
                                                                        8.0,
                                                                    showOnOff:
                                                                        true,
                                                                    onToggle:
                                                                        (val) {
                                                                      setState(
                                                                          () {
                                                                        if (toggleStatus) {
                                                                          toggleStatus =
                                                                              false;
                                                                        } else {
                                                                          toggleStatus =
                                                                              true;
                                                                        }
                                                                      });
                                                                    },
                                                                  ))
                                                                ],
                                                              ),
                                                            ],
                                                          )),
                                                  SizedBox(
                                                    height: 120,
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ]))),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 0,
                child: Container(
                  width: width,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  color: Color(0xFFF8F5FC),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: SvgPicture.asset(
                              "assets/svg/backward_arrow.svg",
                              color: kPrimaryColor,
                              width: 20,
                              height: 20,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "My Account",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: "Poppins",
                                fontSize: 16,
                                color: kColorBlack.withOpacity(.5)),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Stack(
                            children: [
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
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: SvgPicture.asset(
                                    "assets/svg/show_cart.svg",
                                    color: kPrimaryColor,
                                    width: 22,
                                    height: 22,
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
                                            BorderRadius.circular(30)),
                                    child: Center(
                                        child: Text(
                                      Provider.of<ServiceClass>(context)
                                          .CurrentIndex
                                          .toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Poppins",
                                          fontSize: 11,
                                          color: kColorWhite),
                                    )),
                                  )),
                            ],
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          InkWell(
                            onTap: () {
                              // Navigator.push(context,
                              //     MaterialPageRoute(builder: (context) => MyAccount()));
                            },
                            child: SvgPicture.asset(
                              "assets/svg/loggedin_person.svg",
                              color: kPrimaryColor,
                              width: 22,
                              height: 22,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customCards(bool defaulter, String asset) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  margin: EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F6F5),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: SvgPicture.asset(
                    asset,
                    width: 15,
                    height: 15,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text("******** ***** **** 2867",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                        color: kColorBlack,
                        fontSize: 14,
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SvgPicture.asset(
                      "assets/svg/cart_delete.svg",
                      width: 15,
                      height: 15,
                    ),
                  ],
                ),
              ],
            ),
            defaulter
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Default card",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                          color: kPrimaryColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  )
                : Center()
          ],
        ));
  }

  Widget customAddress(MedShipAddrees medShipAddress) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: kColorWhite,
          boxShadow: [
            BoxShadow(
              color: kColorSmoke.withOpacity(.4),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    streetC2.text = "";
                    regionC2.text = "";
                    phoneEditC2.text = "";
                    emailEditC2.text = "";

                    streetC2.text = medShipAddress.street!;
                    regionC2.text = medShipAddress.city!;
                    phoneEditC2.text = medShipAddress.phoneNumber!;
                    emailEditC2.text = medShipAddress.emailAddress!;

                    Provider.of<ServiceClass>(context, listen: false)
                        .notifyCountry(
                            medShipAddress.country!, medShipAddress.countryId!);
                    Provider.of<ServiceClass>(context, listen: false)
                        .notifyStates(
                            medShipAddress.state!, medShipAddress.stateId!);
                    Provider.of<ServiceClass>(context, listen: false)
                        .notifyLGAS(medShipAddress.lga!, medShipAddress.lgaId!);

                    setState(() {
                      showUpdateAddress = true;
                      this.medShipAddrees = medShipAddress;
                    });
                  },
                  child: Text("Edit Address",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                        color: kPrimaryColor,
                        fontSize: 13,
                      )),
                ),
                SizedBox(
                  width: 5,
                ),
                SvgPicture.asset(
                  "assets/svg/edit_address.svg",
                  width: 10,
                  height: 15,
                ),
              ],
            ),
            Row(
              children: [
                SvgPicture.asset(
                  "assets/svg/location.svg",
                  width: 20,
                  height: 25,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                    medShipAddress.firstName != null &&
                            medShipAddress.lastName != null
                        ? medShipAddress.firstName! +
                            " " +
                            medShipAddress.lastName!
                        : "",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400,
                      color: kColorBlack,
                      fontSize: 15,
                    )),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: Text(
                    medShipAddress.street!,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400,
                      color: kColorSmoke2,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                        medShipAddress.lga != null
                            ? medShipAddress.lga! + ", "
                            : "",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                          color: kColorSmoke2,
                          fontSize: 13,
                        )),
                  ],
                ),
                InkWell(
                  onTap: () {
                    deleteAddress(medShipAddress);
                  },
                  child: SvgPicture.asset(
                    "assets/svg/cart_delete.svg",
                    width: 7,
                    height: 15,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 30,
                ),
                Text(
                    medShipAddress.phoneNumber != null
                        ? medShipAddress.phoneNumber!
                        : "",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400,
                      color: kColorSmoke2,
                      fontSize: 13,
                    )),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                SizedBox(
                  width: 30,
                ),
                Text(
                    medShipAddress.emailAddress != null
                        ? medShipAddress.emailAddress!
                        : "",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400,
                      color: kColorSmoke2,
                      fontSize: 13,
                    )),
              ],
            ),
            medShipAddress.isDefault!
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Default address",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                          color: kPrimaryColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  )
                : Center()
          ],
        ));
  }

  void createAddress() async {
    print("We are In now...");
    ServiceClass serviceClass = new ServiceClass();

    int CID = Provider.of<ServiceClass>(context, listen: false).CountryId;
    int StateID = Provider.of<ServiceClass>(context, listen: false).StateId;
    int LGaID = Provider.of<ServiceClass>(context, listen: false).LGAID;
    String city = Provider.of<ServiceClass>(context, listen: false).LGA;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();


    String? firstName = sharedPreferences.getString("FirstName");
    String? lastName = sharedPreferences.getString("LastName");

    serviceClass
        .createShipmentAddress(
            LGaID,
            StateID,
            CID,
            streetC.text,
            city,
            firstName!,
            lastName!,
            toggleStatus,
            emailEditC.text,
            phoneEditC.text)
        .then((value) => output(value, toggleStatus));
  }


  void updateAddress(int id, bool defaultAdd) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String? firstName = sharedPreferences.getString("FirstName");
    String? lastName = sharedPreferences.getString("LastName");

    ServiceClass serviceClass = new ServiceClass();
    int CID = Provider.of<ServiceClass>(context, listen: false).CountryId;
    int StateID = Provider.of<ServiceClass>(context, listen: false).StateId;
    int LGaID = Provider.of<ServiceClass>(context, listen: false).LGAID;
    String city = Provider.of<ServiceClass>(context, listen: false).LGA;

    print("ID == " + id.toString());
    print("CID == " + CID.toString());
    print("State ID == " + StateID.toString());
    print("LID == " + LGaID.toString());
    print("FN == " + firstName!);
    print("LN == " + lastName!);

    serviceClass
        .updateShipmentAddress(
            LGaID,
            StateID,
            CID,
            streetC2.text,
            city,
            firstName,
            lastName,
            toggleStatus,
            emailEditC2.text,
            phoneEditC2.text,
            id)
        .then((value) => outputUpdate(value,defaultAdd,id));

    // if (defaultAdd) {
    //   print("We are in now transit.......");
    //   serviceClass.makeShipmentAddressDefault(id).then((value) => defaultaddressOutput(value));
    // }


  }

  void output(String body, bool stat) {
    setState(() {
      createAddressLoading = false;
    });

    print("We are classy right now...");
    print(body);
    if (body.contains("Network Error")) {
      _showMessage("Network Error");
    } else {
      var bodyT = jsonDecode(body);
      if (bodyT["status"] == "Successful") {
        print("This the body");
        print(body);
        _showMessage(bodyT["message"]);
        streetC.text = "";
        regionC.text = "";
        emailEditC.text = "";
        phoneEditC.text = "";

        addressList.clear();

        int addId = bodyT["data"];

        setState(() {
          addressLoadding = true;
          showNewAddress = false;
        });
        if (toggleStatus) {
          print("We are in now transit.......");
          ServiceClass serviceClass = new ServiceClass();
          serviceClass
              .makeShipmentAddressDefault(addId)
              .then((value) => defaultaddressOutput(value));
        } else {
          viewAddress();
        }
      }
    }
  }

  void outputUpdate(String body,bool defaultAdd,int id) {
    setState(() {
      createAddressLoading = false;
    });
    print("We are In second haven now...");
    print(body);
    if (body.contains("Network Error")) {
      _showMessage("Network Error");
    } else {
      print("This the body");
      print(body);
      var bodyT = jsonDecode(body);

      print("GGGGGGGGGG ********");
      if(bodyT["status"] == "Successful"){
        print("GGGGGGGGGG ******** 756a");
        streetC2.text = "";
        regionC2.text = "";
        emailEditC2.text = "";
        phoneEditC2.text = "";
        viewAddress();
        setState(() {
          addressLoadding = true;
          showUpdateAddress = false;
        });
        _showMessage(bodyT["message"]);

        if (defaultAdd) {
          print("We are in now transit.......");
          ServiceClass serviceClass = new ServiceClass();
          serviceClass
              .makeShipmentAddressDefault(id)
              .then((value) => defaultaddressOutput(value));
        } else {
          viewAddress();
        }

      }else{
        _showMessage(bodyT["message"]);
      }

    }
  }


  void deleteAddress(MedShipAddrees medShipAddrees) {
    print("We are In now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass
        .deleteShipmentAddresses(medShipAddrees.customerShippingAddressId)
        .then((value) => deleteOutput(value, medShipAddrees));
  }

  void viewAddress() {
    print("We are In now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.viewShipmentAddresses().then((value) => shipmentOutput(value));
  }

  void shipmentOutput(String body) {
    print("We are In second haven now...");
    print(body);
    if (body.contains("Network Error")) {
      _showMessage("Network Error");
    } else {
      var bodyT = jsonDecode(body);
      if (bodyT["status"] == "Successful") {
        print("This the body of get all address in the mirror my boy ..............");
        print(body);
        //_showMessage(bodyT["message"]);
        dynamic value = bodyT["data"]["value"];
        addressList = [];
        List<MedShipAddrees> list2 = value
            .map<MedShipAddrees>((element) => MedShipAddrees.fromJson(element))
            .toList();

        setState(() {
          addressLoadding = false;
          addressList = list2;
        });
      }
    }
  }

  void defaultaddressOutput(String body) {
    print("Workman no dy carry last ......");
    print(body);
    if (body.contains("Network Error")) {
      _showMessage("Network Error");
    } else {
      var bodyT = jsonDecode(body);
      print("We are in default address now ....");
      print(bodyT);
      viewAddress();
      //viewAddress();
    }
  }

  // void defaultaddressOutput2(String body) {
  //   print("Workman no dy carry last ......");
  //   print(body);
  //   if (body.contains("Network Error")) {
  //     _showMessage("Network Error");
  //   } else {
  //     var bodyT = jsonDecode(body);
  //     print("We are in default address now ....");
  //     print(bodyT);
  //     viewAddress();
  //   }
  // }

  void deleteOutput(String body, MedShipAddrees medShipAddrees) {
    print("We are In second haven now...");
    print(body);
    if (body.contains("Network Error")) {
      _showMessage("Network Error");
    } else {
      print("This the body");
      print(body);
      var bodyT = jsonDecode(body);
      //_showMessage(bodyT["status"]);
      if (bodyT["status"] == "Successful") {
        print("We are in delete now ............");

        //addressList.clear();
        //viewAddress();
        setState(() {
          //addressLoadding = true;
          addressList.removeAt(addressList.indexOf(medShipAddrees));
        });
      }
    }
  }

  _showMessage(String message,
      [Duration duration = const Duration(seconds: 10)]) {
    _scaffoldKey.currentState!.showSnackBar(new SnackBar(
      content: new Text(message),
      duration: duration,
      action: new SnackBarAction(
          label: 'CLOSE',
          onPressed: () => _scaffoldKey.currentState!.removeCurrentSnackBar()),
    ));
  }
}
