import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mymedicinemobile/screens/mobile/auth/create_account.dart';
import 'package:mymedicinemobile/screens/mobile/auth/login.dart';
import 'package:mymedicinemobile/screens/mobile/auth/verify_email.dart';


import '../../../constants.dart';
import '../../../text_style.dart';

class ThirdScreen extends StatefulWidget {
  @override
  _ThirdScreen createState() => _ThirdScreen();
}

class _ThirdScreen extends State<ThirdScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: kColorWhite,
      body: SafeArea(
        child: Container(
          width: width,
          height: height,
          child:


            Stack(
              children: [
                Positioned(
                  top: height/4,
                    left: 20,
                    right: 20,
                    bottom: 0,
                    child: Container(
                      child: Column(
                        children: [

                          Row(
                            children: [
                              Container(
                                child: Image.asset(
                                  "assets/images/newlogo.png",
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                              SizedBox(width: 5,),
                              SvgPicture.asset("assets/svg/mymedicines.svg",
                                height: 20,
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),

                          SizedBox(height: 100,),
                          InkWell(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      new CreateAccount()));
                            },
                            child: Container(
                              width: width,
                              height: 40,
                              color: kPrimaryColor,
                              child: Center(
                                child: Text(
                                   "GET STARTED",
                                  style: kmediumTextBold(kColorWhite),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 25,),
                          InkWell(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      new Login()));
                            },
                            child: Container(
                              width: width,
                              height: 40,
                              decoration: BoxDecoration(
                                color: kColorWhite,
                                border: Border.all(
                                    width: .8,
                                    color: kPrimaryColor,
                                    style: BorderStyle.solid),
                              ),
                              child: Center(
                                child: Text(
                                  "LOG IN",
                                  style: kmediumTextBold(kPrimaryColor),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
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
}
