import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mymedicinemobile/models/models.dart';
import 'package:mymedicinemobile/screens/mobile/my_account/myaccount.dart';
import 'package:mymedicinemobile/screens/mobile/product_search/searchProduct.dart';
import 'package:mymedicinemobile/screens/mobile/shop_by_category/filter.dart';
import 'package:mymedicinemobile/services/services.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../text_style.dart';

Widget navBarCustom(String pageName, BuildContext context, Widget widget,bool showPageName) =>
    Container(
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
              showPageName ? Text(
                pageName,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins",
                    fontSize: 16,
                    color: kColorBlack.withOpacity(.5)),
              ) : Text("")
            ],
          ),
          Row(
            children: [
              InkWell(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyAccount()));
                },
                child: SvgPicture.asset(
                  "assets/svg/loggedin_person.svg",
                  color: kPrimaryColor,
                  width: 22,
                  height: 22,
                ),
              ),
              SizedBox(
                width: 30,
              ),
              Stack(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => widget));
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => widget));
                        },
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                              color: Color(0xFFFF7685),
                              borderRadius: BorderRadius.circular(30)),
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
                        ),
                      )),
                ],
              ),
            ],
          ),
        ],
      ),
    );



Widget navBarSearchCustom(String pageName, BuildContext context, Widget widget,bool showPageName) =>
    Container(
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
              showPageName ? Text(
                pageName,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins",
                    fontSize: 16,
                    color: kColorBlack.withOpacity(.5)),
              ) : Text("")
            ],
          ),
          Row(
            children: [
              InkWell(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchProducts()));
                },
                child: SvgPicture.asset(
                  "assets/svg/search_icon3.svg",
                  color: kPrimaryColor,
                  width: 22,
                  height: 22,
                ),
              ),
              SizedBox(
                width: 30,
              ),
              Stack(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => widget));
                    },
                    child: Container(
                      margin:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => widget));
                        },
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                              color: Color(0xFFFF7685),
                              borderRadius: BorderRadius.circular(30)),
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
                        ),
                      )),
                ],
              ),
            ],
          ),
        ],
      ),
    );



Widget navBarOnlyCart(String pageName, BuildContext context, Widget widget,bool showPageName) =>
    Container(
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
              showPageName ? Text(
                pageName,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins",
                    fontSize: 16,
                    color: kColorBlack.withOpacity(.5)),
              ) : Text("")
            ],
          ),
          Row(
            children: [
              // SvgPicture.asset(
              //   "assets/svg/search_icon3.svg",
              //   color: kPrimaryColor,
              //   width: 22,
              //   height: 22,
              // ),
              SizedBox(
                width: 30,
              ),
              Stack(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => widget));
                    },
                    child: Container(
                      margin:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => widget));
                        },
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                              color: Color(0xFFFF7685),
                              borderRadius: BorderRadius.circular(30)),
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
                        ),
                      )),
                ],
              ),
            ],
          ),
        ],
      ),
    );



Widget navBarCustomCartBeforePerson(String pageName, BuildContext context, Widget widget,bool showPageName) =>
    Container(
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
              showPageName ? Text(
                pageName,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins",
                    fontSize: 16,
                    color: kColorBlack.withOpacity(.5)),
              ) : Text("")
            ],
          ),
          Row(
            children: [

              Stack(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => widget));
                    },
                    child: Container(
                      margin:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => widget));
                        },
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                              color: Color(0xFFFF7685),
                              borderRadius: BorderRadius.circular(30)),
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
                        ),
                      )),
                ],
              ),

              SizedBox(
                width: 30,
              ),

              InkWell(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyAccount()));
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
    );




Widget navBarCustomCartBeforeFilter(String pageName, BuildContext context, Widget widget,bool showPageName) =>
    Container(
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
              showPageName ? Text(
                pageName,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins",
                    fontSize: 16,
                    color: kColorBlack.withOpacity(.5)),
              ) : Text("")
            ],
          ),
          Row(
            children: [

              Stack(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => widget));
                    },
                    child: Container(
                      margin:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => widget));
                        },
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                              color: Color(0xFFFF7685),
                              borderRadius: BorderRadius.circular(30)),
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
                        ),
                      )),
                ],
              ),

              SizedBox(
                width: 30,
              ),

              InkWell(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Filters()));
                },
                child: SvgPicture.asset(
                  "assets/svg/filter.svg",
                  color: kPrimaryColor,
                  width: 22,
                  height: 22,
                ),
              ),

            ],
          ),
        ],
      ),
    );



Widget navBarFAQ(String pageName, BuildContext context) =>
    Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                pageName,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins",
                    fontSize: 16,
                    color: kColorBlack.withOpacity(.5)),
              )
            ],
          ),
        ],
      ),
    );



Widget navBarSearchCartCustom(String pageName, BuildContext context, Widget widget,bool showPageName) =>
    Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
              showPageName ? Text(
                pageName,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins",
                    fontSize: 16,
                    color: kColorBlack.withOpacity(.5)),
              ) : Text("")
            ],
          ),
          Row(
            children: [
              InkWell(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchProducts()));
                },
                child: SvgPicture.asset(
                  "assets/svg/search_icon3.svg",
                  color: kPrimaryColor,
                  width: 22,
                  height: 22,
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ],
      ),
    );



Widget navBarFilterCustom(String pageName, BuildContext context,bool showPageName) =>
    Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
              showPageName ? Text(
                pageName,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins",
                    fontSize: 16,
                    color: kColorBlack.withOpacity(.5)),
              ) : Text("")
            ],
          ),
          Row(
            children: [
              Text(
                "Reset",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins",
                    fontSize: 13,
                    color: kPrimaryColor),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ],
      ),
    );