import 'package:flutter/material.dart';
import 'package:mymedicinemobile/constants.dart';


Widget errorPage(Function clicked) => Container(
  margin: EdgeInsets.symmetric(horizontal: 20,vertical: 30),
  child: Center(
    child: Column(children: [
      //Spacer(flex: 2,),
      Icon(Icons.error,size: 200,color: kColorSmoke2,),
      SizedBox(height: 10,),
      Text("Network error ocurred..... Please check your network & try again.",style: TextStyle(
          color: kColorBlack.withOpacity(.6),
          fontSize: 12,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w500
      ),textAlign: TextAlign.center,),
      SizedBox(height: 20,),
      InkWell(
        onTap: clicked(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40,vertical: 10),
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text("Try Again",style: TextStyle(
            color: kColorWhite,
            fontSize: 16,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w400
          ),),
        ),
      )
    ],),
  ),
);
