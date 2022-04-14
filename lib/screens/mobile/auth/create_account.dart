import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mymedicinemobile/models/models.dart';
import 'package:mymedicinemobile/screens/mobile/auth/verify_email.dart';
import 'package:mymedicinemobile/screens/mobile/home_page/homepager.dart';
import 'package:mymedicinemobile/services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../constants.dart';
import '../../../text_style.dart';

class CreateAccount extends StatefulWidget {
  _CreateAccount createState() => new _CreateAccount();
}

class _CreateAccount extends State<CreateAccount>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  TextEditingController emailC = new TextEditingController();
  TextEditingController fName = new TextEditingController();
  TextEditingController lName = new TextEditingController();
  TextEditingController genderC = new TextEditingController();
  TextEditingController passC = new TextEditingController();
  TextEditingController phoneC = new TextEditingController();
  TextEditingController countryN = new TextEditingController();

  String selectedCode = "+234",
      selectedFlag = "assets/svg/ninja_flag.svg",
      selectedCountry = "Nigeria";
  bool countrySelectorVisible = false;
  bool passwordVisible = false;
  bool passwordObscure = true;
  bool phoneCancelVisible = false;
  bool phoneCorrectVisible = false;
  bool showGenderDrop = false;
  String _chosenValue = "Male";
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  String slectedGender = "Gender";
  bool loading = false;
  bool errorOcurred = false;
  bool dataLoaded = false;
  late AnimationController _animationController;
  List<MedCountry> countrylist = [];
  bool loadingCountry = false;
  bool countryLoaded = false;
  String emailIcon ="email_icon",fNameIcon = "person_img",lNameIcon = "person_img",genderIcon = "gender_icon",passIcon = "lock_icon";

  List<GenderPick> list = [
    new GenderPick(name: "Male", picked: false),
    new GenderPick(name: "Female", picked: false),
    new GenderPick(name: "Others", picked: false),
  ];

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  void onAddButtonTapped(int index) {
    // use this to animate to the page
    //pageController.animateToPage(index);
    // or this to jump to it without animating
    pageController.jumpToPage(index);
  }

  _showMessage(String message, Duration duration) {
    _scaffoldKey.currentState!.showSnackBar(new SnackBar(
      content: new Text(message),
      duration: duration,
      action: new SnackBarAction(
          label: 'CLOSE',
          onPressed: () => _scaffoldKey.currentState!.removeCurrentSnackBar()),
    ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    _animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 2),
    );
    _animationController.repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        //SystemNavigator.pop();
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        backgroundColor: kColorWhite,
        key: _scaffoldKey,
        body: SafeArea(
          child: Container(
              child: Stack(
            children: [
              PageView(
                controller: pageController,
                physics: new NeverScrollableScrollPhysics(),
                onPageChanged: (var int) {
                  setState(() {
                    currentIndex = int;
                  });
                },
                children: [
                  emailView(),
                  nameView(),
                  genderView(),
                  passwordView(),
                  phoneView()
                ],
              ),
              Positioned(
                  bottom: 0,
                  left: 25,
                  right: 25,
                  top: 280,
                  child: Container(
                    width: width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 10,
                          width: 80,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              Container(
                                width: 10,
                                height: 3,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(180)),
                                  color: currentIndex == 0
                                      ? kPrimaryColor
                                      : kColorWhite,
                                  border: Border.all(
                                      width: 1,
                                      color: kPrimaryColor,
                                      style: BorderStyle.solid),
                                ),
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Container(
                                width: 10,
                                height: 3,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(180)),
                                  color: currentIndex == 1
                                      ? kPrimaryColor
                                      : kColorWhite,
                                  border: Border.all(
                                      width: 1,
                                      color: kPrimaryColor,
                                      style: BorderStyle.solid),
                                ),
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Container(
                                width: 10,
                                height: 3,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(180)),
                                  color: currentIndex == 2
                                      ? kPrimaryColor
                                      : kColorWhite,
                                  border: Border.all(
                                      width: 1,
                                      color: kPrimaryColor,
                                      style: BorderStyle.solid),
                                ),
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(180)),
                                  color: currentIndex == 3
                                      ? kPrimaryColor
                                      : kColorWhite,
                                  border: Border.all(
                                      width: 1,
                                      color: kPrimaryColor,
                                      style: BorderStyle.solid),
                                ),
                                width: 10,
                                height: 3,
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(180)),
                                  color: currentIndex == 4
                                      ? kPrimaryColor
                                      : kColorWhite,
                                  border: Border.all(
                                      width: 1,
                                      color: kPrimaryColor,
                                      style: BorderStyle.solid),
                                ),
                                width: 10,
                                height: 3,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        InkWell(
                          onTap: () {
                            print("This $currentIndex");
                            if (currentIndex == 4) {
                              if (validatePhone(phoneC.text)) {
                                setState(() {
                                  loading = true;
                                });
                                createCustomer(
                                    fName.text,
                                    lName.text,
                                    emailC.text,
                                    selectedCode + phoneC.text,
                                    slectedGender,
                                    passC.text);
                              }
                            } else {
                              switch (currentIndex) {
                                case 0:
                                  if (validateEmail(emailC.text)) {
                                    onAddButtonTapped(currentIndex + 1);
                                  }
                                  break;
                                case 1:
                                  if (validateNames(fName.text, lName.text)) {
                                    SystemChannels.textInput
                                        .invokeMethod('TextInput.hide');
                                    onAddButtonTapped(currentIndex + 1);
                                  }
                                  break;
                                case 2:
                                  if (validateGender()) {
                                    onAddButtonTapped(currentIndex + 1);
                                  }
                                  break;
                                case 3:
                                  if (validatePassword(passC.text)) {
                                    onAddButtonTapped(currentIndex + 1);
                                  }
                                  break;
                              }
                            }
                          },
                          child: Container(
                            width: width,
                            height: 40,
                            color: kPrimaryColor,
                            child: Center(
                              child: Text(
                                "NEXT",
                                style: kmediumTextBold(kColorWhite),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  )),

              Visibility(
                  visible: countrySelectorVisible,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    width: width,
                    height: height,
                    color: kColorWhite,
                    child: ListView(
                      children: [
                        Row(
                          children: [
                            IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  setState(() {
                                    countrySelectorVisible = false;
                                  });
                                }),
                            SizedBox(
                              width: 5,
                            ),
                            // Expanded(
                            //   flex: 1,
                            //   child: TextField(
                            //     controller: countryN,
                            //     cursorColor: kPrimaryColor,
                            //     style: kmediumTextBold(kColorBlack),
                            //     keyboardType: TextInputType.name,
                            //     decoration: InputDecoration(
                            //       hintText: "Enter country name",
                            //       hintStyle: kmediumTextBold(kColorSmoke),
                            //       border: InputBorder.none,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        ...countrylist.map((e) => countryCustom(
                            "assets/svg/ninja_flag.svg",
                            e.name,
                            e.dialingCode)),

                        // countryCustom(
                        //     "assets/svg/ninja_flag.svg", "Nigeria", "+234"),
                        // countryCustom(
                        //     "assets/svg/ninja_flag.svg", "Ghana", "+233"),
                        // countryCustom(
                        //     "assets/svg/ninja_flag.svg", "Lesotho", "+212"),
                        // countryCustom(
                        //     "assets/svg/ninja_flag.svg", "Kenya", "+222"),
                      ],
                    ),
                  )),
              showGenderDrop
                  ? Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: width,
                        height: height,
                        color: Color(0xFF000000).withOpacity(0.25),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 210,
                              left: 65,
                              child: Container(
                                width: 100,
                                decoration: BoxDecoration(
                                    color: kColorWhite,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    ...list.map((e) => customGender(e)),
                                    SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                  : Center(),
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
          )),
        ),
      ),
    );
  }

  Widget countryCustom(String flag, String name, String code) {
    return InkWell(
      onTap: () {
        setState(() {
          countrySelectorVisible = false;
          selectedCode = code;
          selectedFlag = flag;
          selectedCountry = name;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                //SvgPicture.asset(flag),
                SizedBox(
                  width: 15,
                ),

                Text(
                  name,
                  style: kmediumText(kColorBlack),
                ),

                SizedBox(
                  width: 5,
                ),
                Expanded(
                    child: Text("($code)", style: kmediumText(kColorBlack))),
              ],
            ),
            Divider(
              color: kColorSmoke,
            )
          ],
        ),
      ),
    );
  }

  bool validateEmail(String email) {
    if (!email.contains("@")) {
      _showMessage("Please enter a valid email.", new Duration(seconds: 4));
      return false;
    } else if (!email.split("@")[1].contains(".")) {
      _showMessage("Please enter a valid email.", new Duration(seconds: 4));
      return false;
    }
    return true;
  }

  bool validateNames(String fName, String lName) {
    if (fName.isEmpty) {
      _showMessage("Please enter your First name.", new Duration(seconds: 4));
      return false;
    } else if (lName.isEmpty) {
      _showMessage("Please enter your Last name.", new Duration(seconds: 4));
      return false;
    }
    return true;
  }

  bool validateGender() {
    if (slectedGender == "Gender") {
      _showMessage("Please select your gender.", new Duration(seconds: 4));
      return false;
    }
    return true;
  }

  bool validatePassword(String password) {
    if (password.length < 7) {
      _showMessage("Password is too weak.", new Duration(seconds: 4));
      return false;
    }
    return true;
  }

  bool validatePhone(String phone) {
    if (phone.length != 10) {
      _showMessage("Please enter only 10 digits of your phone number",
          new Duration(seconds: 4));
      return false;
    }
    return true;
  }

  Widget emailView() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.only(top: 20, bottom: 40),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                    onTap: () {
                      if (currentIndex == 0) {
                        print("Tapped 3 time");
                        Navigator.pop(context);
                      } else {
                        print("Tapped at $currentIndex");
                        int moveTo = currentIndex - 1;
                        onAddButtonTapped(moveTo);
                      }
                    },
                    child: Container(
                        child: SvgPicture.asset("assets/svg/back_arrow.svg"))),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "What’s your email?",
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                      color: kColorBlack),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                    "We need your email to look up your account or create a new one",
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                        color: kColorBlack.withOpacity(.5)),
                    textAlign: TextAlign.start),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: kColorWhite),
                  child: Row(
                    children: [
                      SvgPicture.asset("assets/svg/${emailIcon}.svg"),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: emailC,
                          cursorColor: kPrimaryColor,
                          style: kmediumTextBold(kColorBlack),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (text){
                            if (text.contains("@")) {
                              if (text.split("@")[1].contains(".")){
                                setState(() {
                                  emailIcon = "email_icon2";
                                });
                              }else{
                                setState(() {
                                  emailIcon = "email_icon";
                                });
                              }
                            }else{
                              setState(() {
                                emailIcon = "email_icon";
                              });
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(
                                fontSize: 12,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w400,
                                color: kColorBlack.withOpacity(.3)),
                            border: InputBorder.none,
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
                  height: 1,
                  color: kColorSmoke,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget nameView() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.only(top: 20, bottom: 40),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                    onTap: () {
                      if (currentIndex == 0) {
                        print("Tapped 3 time");
                        Navigator.pop(context);
                      } else {
                        print("Tapped at $currentIndex");
                        int moveTo = currentIndex - 1;
                        onAddButtonTapped(moveTo);
                      }
                    },
                    child: Container(
                        child: SvgPicture.asset("assets/svg/back_arrow.svg"))),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "What’s your name?",
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                      color: kColorBlack),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 5,
                ),
                Text("Please provide your first and last name to continue",
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                        color: kColorBlack.withOpacity(.5)),
                    textAlign: TextAlign.start),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: kColorWhite),
                  child: Row(
                    children: [
                      SvgPicture.asset("assets/svg/${fNameIcon}.svg"),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: fName,
                          cursorColor: kPrimaryColor,
                          onChanged: (text){
                            if (text.length > 2) {
                              setState(() {
                                fNameIcon = "person_img2";
                              });
                            }else{
                              setState(() {
                                fNameIcon = "person_img";
                              });
                            }
                          },
                          style: kmediumTextBold(kColorBlack),
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            hintText: "First Name",
                            hintStyle: TextStyle(
                                fontSize: 12,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w400,
                                color: kColorBlack.withOpacity(.3)),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SvgPicture.asset("assets/svg/${lNameIcon}.svg"),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: lName,
                          cursorColor: kPrimaryColor,
                          style: kmediumTextBold(kColorBlack),
                          onChanged: (text){
                            if (text.length > 2) {
                              setState(() {
                                lNameIcon = "person_img2";
                              });
                            }else{
                              setState(() {
                                lNameIcon = "person_img";
                              });
                            }
                          },
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            hintText: "Last Name",
                            hintStyle: TextStyle(
                                fontSize: 12,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w400,
                                color: kColorBlack.withOpacity(.3)),
                            border: InputBorder.none,
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
                  height: 1,
                  color: kColorSmoke,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget genderView() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.only(top: 20, bottom: 40),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                    onTap: () {
                      if (currentIndex == 0) {
                        print("Tapped 3 time");
                        Navigator.pop(context);
                      } else {
                        print("Tapped at $currentIndex");
                        int moveTo = currentIndex - 1;
                        onAddButtonTapped(moveTo);
                      }
                    },
                    child: Container(
                        child: SvgPicture.asset("assets/svg/back_arrow.svg"))),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "What’s your gender?",
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                      color: kColorBlack),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 5,
                ),
                Text("We need your gender for your personalisation",
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                        color: kColorBlack.withOpacity(.5)),
                    textAlign: TextAlign.start),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: kColorWhite),
                  child: Row(
                    children: [
                      SvgPicture.asset("assets/svg/${genderIcon}.svg"),
                      SizedBox(
                        width: 30,
                      ),

                      InkWell(
                        onTap: () {
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide');
                          setState(() {
                            showGenderDrop = true;
                          });
                        },
                        child: Text(
                          slectedGender,
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                              color: kColorBlack),
                        ),
                      ),

                      SizedBox(
                        width: 10,
                      ),

                      InkWell(
                          onTap: () {
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                            setState(() {
                              showGenderDrop = true;
                            });
                          },
                          child: Icon(
                            Icons.arrow_drop_down,
                            size: 14,
                          ))

                      // Expanded(
                      //   flex: 1,
                      //   child: DropdownButton<String>(
                      //     focusColor:Colors.white,
                      //     value: _chosenValue,
                      //     elevation: 2,
                      //     style: TextStyle(color: Colors.white),
                      //     iconEnabledColor:Colors.black,
                      //     items: <String>[
                      //       'Male',
                      //       'Female',
                      //       'Others',
                      //     ].map<DropdownMenuItem<String>>((String value) {
                      //       return DropdownMenuItem<String>(
                      //         value: value,
                      //         child: Text(value,style:TextStyle(color:Colors.black),),
                      //       );
                      //     }).toList(),
                      //     hint:Text(
                      //       "Select Gender",
                      //       style: TextStyle(
                      //           color: Colors.black,
                      //           fontSize: 14,
                      //           fontWeight: FontWeight.w500),
                      //     ),
                      //     onChanged: (String? value) {
                      //       setState(() {
                      //         _chosenValue = value!;
                      //       });
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(
                  height: 1,
                  color: kColorSmoke,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget passwordView() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.only(top: 20, bottom: 40),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                    onTap: () {
                      if (currentIndex == 0) {
                        print("Tapped 3 time");
                        Navigator.pop(context);
                      } else {
                        print("Tapped at $currentIndex");
                        int moveTo = currentIndex - 1;
                        onAddButtonTapped(moveTo);
                      }
                    },
                    child: Container(
                        child: SvgPicture.asset("assets/svg/back_arrow.svg"))),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Choose a password",
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                      color: kColorBlack),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                    "Use atleast 8 characters, including a number, an uppercase and a lowercase",
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                        color: kColorBlack.withOpacity(.5)),
                    textAlign: TextAlign.start),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: kColorWhite),
                  child: Row(
                    children: [
                      SvgPicture.asset("assets/svg/$passIcon.svg"),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          onChanged: (text) {
                            if (text.isNotEmpty) {
                              if (text.length > 7) {
                                setState(() {
                                  passwordVisible = true;
                                  passIcon = "lock_icon2";
                                });
                              }else{
                                setState(() {
                                  passIcon = "lock_icon";
                                });
                              }
                            }
                          },
                          controller: passC,
                          cursorColor: kPrimaryColor,
                          style: kmediumTextBold(kColorBlack),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: passwordObscure,
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyle(
                                fontSize: 12,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w400,
                                color: kColorBlack.withOpacity(.3)),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Visibility(
                          visible: passwordVisible,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                if(passwordObscure){
                                  passwordObscure = false;
                                }else{
                                  passwordObscure = true;
                                }
                              });
                            },
                            child: Text(
                              passwordObscure ? "show" : "hide",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w400,
                                  color: kPrimaryColor),
                            ),
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(
                  height: 1,
                  color: kColorSmoke,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget phoneView() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.only(top: 20, bottom: 40),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                    onTap: () {
                      if (currentIndex == 0) {
                        print("Tapped 3 time");
                        Navigator.pop(context);
                      } else {
                        print("Tapped at $currentIndex");
                        int moveTo = currentIndex - 1;
                        onAddButtonTapped(moveTo);
                      }
                    },
                    child: Container(
                        child: SvgPicture.asset("assets/svg/back_arrow.svg"))),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "What’s your phone no?",
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                      color: kColorBlack),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                    "We sometimes share updates on your account, our new features, announcements and more",
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                        color: kColorBlack.withOpacity(.5)),
                    textAlign: TextAlign.start),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: kColorWhite),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      loadingCountry
                          ? Container(
                            width:20,
                            height:20,
                            child: CircularProgressIndicator(
                                //strokeWidth: 3,
                                color: kPrimaryColor,
                              ),
                          )
                          : Center(),
                      SizedBox(
                        width: 5,
                      ),
                      SvgPicture.asset(selectedFlag),
                      SizedBox(
                        width: 5,
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            // setState(() {
                            //   loadingCountry = true;
                            // });
                            // viewLocations();
                          }),
                      Text(
                        selectedCode,
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400,
                            color: kColorBlack),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 20,),
                            TextField(
                              onChanged: (text) {
                                if (text.isNotEmpty) {
                                  if (text.length == 10) {
                                    if(text.substring(0,1).contains("9") || text.substring(0,1).contains("8") || text.substring(0,1).contains("7")){
                                      setState(() {
                                        phoneCancelVisible = false;
                                        phoneCorrectVisible = true;
                                      });
                                    }
                                  } else if (text.length > 5 && text.length != 10) {
                                    setState(() {
                                      phoneCancelVisible = true;
                                      phoneCorrectVisible = false;
                                    });
                                  }
                                }
                              },
                              controller: phoneC,
                              maxLength: 10,
                              cursorColor: kPrimaryColor,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w400,
                                  color: kColorBlack),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "Phone Number",
                                hintStyle: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w400,
                                    color: kColorBlack.withOpacity(.3)),
                                border: InputBorder.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: phoneCancelVisible,
                        child: InkWell(
                            onTap: () {
                              phoneC.text = "";
                            },
                            child: SvgPicture.asset(
                                "assets/svg/close_vector.svg")),
                      ),
                      Visibility(
                        visible: phoneCorrectVisible,
                        child: InkWell(
                            onTap: () {},
                            child:
                                SvgPicture.asset("assets/svg/checkmark2.svg")),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(
                  height: 1,
                  color: kColorSmoke,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void viewLocations() {
    print("We are In now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.viewCountries().then((value) => output(value));
  }

  void output(String body) {
    print("We are In second haven now...");
    print(body);
    if (body.contains("Network Error")) {
      setState(() {
        loadingCountry = false;
      });
    } else {
      var bodyT = jsonDecode(body);
      if (bodyT["status"] == "Successful") {
        dynamic data2 = bodyT["data"];
        print("all man .........");
        print(data2);
        countrylist = data2
            .map<MedCountry>((element) => MedCountry.fromJson(element))
            .toList();
        setState(() {
          loadingCountry = false;
          countrySelectorVisible = true;
        });
      } else {
        //_showMessage(bodyT["message"]);
        setState(() {
          loadingCountry = false;
        });
      }
    }
  }

  void createCustomer(String fName, String lName, String email, String phone,
      String gender, String password) async {
    var headers = {
      HttpHeaders.authorizationHeader:
          'Bearer ',
      'Content-Type': 'application/problem+json; charset=utf-8 '
      //HttpHeaders.contentTypeHeader : 'application/json; charset=UTF-8',
    };

    try {

      var dataB = jsonEncode(<String, Object>{
        "channelId": 2,
        "firstName": fName,
        "lastName": lName,
        "phoneNumber": phone,
        "emailAddress": email,
        "birthDay": "2021-11-20T18:37:08.460Z",
        "password": password,
        "gender": gender
      });

      print("Inside the queee");
      var url = Uri.parse(
          "https://advantagerx.africa/apigw/Account/mobile/myMedicineCustomer");
      http.Response response =
          await http.post(url, body: dataB, headers: headers);
      print(response);
      //var data = jsonDecode(response.body);
      var body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print("We are all goood ...... Response is 200");
        print(response.body);


        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => HomePager()));
        //if (body["status"]["result"] == null) {
          if (body["status"] != "Successful") {
          setState(() {
            loading = false;
            errorOcurred = true;
          });
          //_showMessage("Email already exists..", new Duration(seconds: 4));
          _showMessage(body["message"], new Duration(seconds: 4));
        } else {
          setState(() {
            loading = false;
          });
          // int codeID = int.parse(body["data"]["result"]);
          // int channelID = body["data"]["id"];

          int otpID = int.parse(body["data"]);
          int channelID = 2;

          SignUpUser signUpUser = new SignUpUser(fName: fName,lName: lName,email: email, phone: phone,gender: gender,password: password);

          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      EmailVerify(signUpUser,emailC.text, otpID, channelID)));
        }
      } else {
        _showMessage(body["message"], new Duration(seconds: 4));
        setState(() {
          loading = false;
          errorOcurred = true;
        });
        print(response.body);
        print("Errrrrrrrror not 2000");
      }
    } on SocketException catch (_) {
      _showMessage("Network error....", new Duration(seconds: 4));
      setState(() {
        loading = false;
        errorOcurred = true;
      });
      print("Error messages now ooooo");
    }
  }

  Widget customGender(GenderPick pick) {
    return InkWell(
      onTap: () {
        int currentIndex = list.indexOf(pick);
        for (var pick in list) {
          pick.picked = false;
        }
        setState(() {
          list[currentIndex].picked = !list[currentIndex].picked;
          slectedGender = pick.name;
          showGenderDrop = false;
          genderIcon = "gender_icon2";
        });
      },
      child: Container(
        width: 100,
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        margin: EdgeInsets.only(top: 15, left: 10, right: 10),
        decoration: BoxDecoration(
            color: pick.picked ? Color(0xFFFFDAFA) : kColorWhite,
            borderRadius: BorderRadius.circular(5)),
        child: Text(
          pick.name,
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w400,
            color: kColorBlack,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class GenderPick {
  String name;
  bool picked;
  GenderPick({required this.name, required this.picked});
}
