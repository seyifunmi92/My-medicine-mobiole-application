// ignore_for_file: prefer_const_constructors

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
import 'package:mymedicinemobile/screens/mobile/upload_prescription/upload_prescription.dart';
import 'package:mymedicinemobile/services/services.dart';
import 'package:mymedicinemobile/text_style.dart';
import 'package:provider/provider.dart';
import '../../../error_page.dart';

class Cart extends StatefulWidget {
  _Cart createState() => _Cart();
}

class _Cart extends State<Cart> with SingleTickerProviderStateMixin {

  bool value = false;
  late AnimationController _animationController;

  late List<CartItems> dataList = [];
  late List<CartItems> prescribedList = [];
  late List<CartItems> nonPrescribedList = [];
  late List<CartItems> sortedList = [];
  bool loading = true;
  bool errorOcurred = false;
  bool dataLoaded = false;
  bool loaded = false;
  bool deleteSelected = false;
  bool showdeleteConfirmation = false;
  bool showAddAddress = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool all = false;
  double total = 0;
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

    viewCartItems();
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
    Provider.of<ServiceClass>(context, listen: false).increaseCart();

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
                  navBarSearchCartCustom("Product Cart", context, Cart(), true),
                  errorOcurred
                      ?
                  Container(
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
                          onTap: (){
                            setState(() {
                              loading = true;
                              errorOcurred = false;
                            });
                          },
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
                  )
                      : dataLoaded == false
                          ? Center()
                          : Container(
                              height: height * .83,
                              child: ListView(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(width: 10,),
                                          Checkbox(
                                              activeColor: kPrimaryColor,
                                              value: all,
                                              onChanged: (value1) {
                                                  if (dataList.isNotEmpty) {
                                                    for (int x = 0; x <
                                                        dataList.length; x++) {
                                                      if(all){
                                                        dataList[x].isChecked = false;
                                                      }else{
                                                        dataList[x].isChecked = true;
                                                      }
                                                    }
                                                    setState(() {
                                                      all = !all;
                                                      all ? deleteSelected = true : deleteSelected = false;
                                                    });
                                                  }
                                              }),
                                          Text(
                                            "Select all items",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Poppins",
                                              fontSize: 14,
                                              color: kColorSmoke2,
                                            ),
                                          ),
                                        ],
                                      ),

                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: (){
                                              total = 0;
                                              for (int x = 0; x < dataList.length; x++) {
                                                if(dataList[x].isChecked!){
                                                  late double p;
                                                  late double price;
                                                  if(dataList[x].quantity == 0){
                                                    p = double.parse("1");
                                                    price = p * dataList[x].minUnitPrice!;
                                                  }else{
                                                    p = double.parse( dataList[x].quantity!.toString());
                                                    price = p * dataList[x].minUnitPrice!;
                                                  }
                                                  total = total + price;
                                                  sortedList.add(dataList[x]);
                                                }
                                              }
                                              if(sortedList.isEmpty){
                                                _showMessage("Select any cart item");
                                              }else{
                                                setState(() {
                                                  showdeleteConfirmation = true;
                                                });
                                              }
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                              margin: EdgeInsets.symmetric(horizontal: 25),
                                              decoration: BoxDecoration(
                                                color: deleteSelected ?Color(0xFFF9C0C1): Color(0xFFF2F2F2),
                                                borderRadius: BorderRadius.circular(10)
                                              ),
                                              child: Row(children: [
                                                SvgPicture.asset(
                                                  "assets/svg/cart_delete.svg",
                                                  color: deleteSelected ? Color(0xFFE57A62) :Color(0xFFBDBDBD),
                                                  width: 14,
                                                  height: 14,
                                                ),
                                                Text("  Delete",style:TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "Poppins",
                                                  fontSize: 12,
                                                  color:deleteSelected ? Color(0xFFE72345) :Color(0xFF828282),
                                                )),
                                              ],),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: kColorSmoke.withOpacity(.4),
                                          spreadRadius: 2,
                                          blurRadius: 7,
                                          offset: Offset(0,
                                              6), // changes position of shadow
                                        ),
                                      ],
                                      color: kColorWhite,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: Text(
                                      "Items Requiring Prescription",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Poppins",
                                        fontSize: 13,
                                        color: kColorBlack,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ...prescribedList.map((e) => cartCustom(e)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: kColorSmoke.withOpacity(.4),
                                          spreadRadius: 2,
                                          blurRadius: 7,
                                          offset: Offset(0,
                                              6), // changes position of shadow
                                        ),
                                      ],
                                      color: kColorWhite,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: Text(
                                      "Items not Requiring Prescription",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Poppins",
                                        fontSize: 13,
                                        color: kColorBlack,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ...nonPrescribedList.map((e) => cartCustom(e)),
                                  SizedBox(
                                    height: height / 2,
                                  ),
                                ],
                              ),
                            ),
                ],
              ),



              Positioned(
                bottom: 0,
                child: Container(
                  width: width,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  color: kColorWhite,
                  child: Column(
                    children: [
                      Divider(
                        height: 2,
                        color: kColorSmoke2,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Sub Total",
                            style: kmediumTextBold(kColorSmoke2),
                          ),
                          SvgPicture.asset(
                            "assets/svg/elipse.svg",
                            color: kColorSmoke2,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/svg/naira.svg",
                                color: kColorSmoke2,
                              ),
                              Text(
                                "${total}",
                                style: klargeText(kColorSmoke2),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Delivery charges",
                            style: kmediumTextBold(kColorSmoke2),
                          ),
                          SvgPicture.asset(
                            "assets/svg/elipse.svg",
                            color: kColorSmoke2,
                          ),
                          Text(
                            "Included at checkout",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: kColorSmoke2.withOpacity(.7)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Divider(
                        height: 2,
                        color: kColorSmoke2,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: kColorBlack),
                          ),
                          SvgPicture.asset(
                            "assets/svg/elipse.svg",
                            color: kColorSmoke2,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/svg/naira.svg",
                                color: kPrimaryColor,
                                width: 11,
                                height: 11,
                              ),
                              Text(
                                " ${total}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () {

                          viewShipmentAddress();

                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: kPrimaryColor),
                          child: Center(
                            child: Text(
                              "Checkout",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                                color: kColorWhite,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Text(
                            "Back to Shopping",
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
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



              Visibility(
                visible: loaded,
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
                            top: height * .3,
                            left: 50,
                            right: 50,
                            child: Container(
                                width: width/2,
                                //color: kColorWhite,
                                height: height * .3,
                                decoration: BoxDecoration(
                                    color: kColorWhite,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                    SizedBox(
                                      height: 10,
                                    ),

                                    SvgPicture.asset("assets/svg/alerter.svg"),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("Kindly upload your prescription",style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: kColorBlack),),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap :(){
                                        setState(() {
                                          loaded = false;
                                        });
                                        startCheckout(true);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: kPrimaryColor,
                                            borderRadius: BorderRadius.circular(5)),
                                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                        child: Text("Continue",style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: kColorWhite),),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 14,
                                    ),
                                    InkWell(
                                      onTap :(){
                                        setState(() {
                                          loaded = false;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: kColorWhite,
                                            borderRadius: BorderRadius.circular(10)),
                                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                        child: Text("Review cart",style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: kPrimaryColor),),
                                      ),
                                    ),

                                  ],
                                )),
                          ),
                        ],
                      ),
                    )),
              ),



              showdeleteConfirmation
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
                          top: 150,
                          left: 30,
                          right: 30,
                          child: Container(
                            width: 100,
                            padding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                            decoration: BoxDecoration(
                                color: kColorWhite,
                                borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("Remove Product?", style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Poppins",
                                      fontSize: 15,
                                      color: kColorBlack,
                                    ),textAlign: TextAlign.start,),
                                  ],
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text("Are you sure you want to remove product from cart", style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Poppins",
                                  fontSize: 14,
                                  color: kColorBlack.withOpacity(.6),
                                ),),
                                SizedBox(
                                  height: 5,
                                ),
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.end,
                                 children: [
                                   GestureDetector(
                                     onTap :(){
                                       List<DeleteCartItems> items= [];
                                       for(int i=0;i<dataList.length;i++){
                                         if(dataList[i].isChecked!){
                                           DeleteCartItems cartItem = new DeleteCartItems(sessionID: "string",creatorUserId: 0,shoppingCartOrderItemId: dataList[i].shoppingCartOrderItemId,productId: dataList[i].productId,channelId: 2,bundleId: 0);
                                           items.add(cartItem);
                                           print("ALl ids ---- "+ dataList[i].productId.toString());
                                         }
                                       }
                                       deleteMultipleFromCart(items);
                                       setState(() {
                                         showdeleteConfirmation = false;
                                       });
                                     },
                                     child: Text("Yes",style: TextStyle(
                                       fontWeight: FontWeight.w500,
                                       fontFamily: "Poppins",
                                       fontSize: 15,
                                       color: kPrimaryColor,
                                     )),
                                   ),
                                   SizedBox(
                                     width: 25,
                                   ),
                                   GestureDetector(
                                     onTap: (){
                                       setState(() {
                                         showdeleteConfirmation = false;
                                       });
                                     },
                                     child: Text("No",style: TextStyle(
                                       fontWeight: FontWeight.w500,
                                       fontFamily: "Poppins",
                                       fontSize: 15,
                                       color: kColorBlack,
                                     )),
                                   ),
                                 ],
                               ),
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




              showAddAddress
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
                          top: 150,
                          left: 30,
                          right: 30,
                          child: Container(
                            width: 100,
                            padding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                            decoration: BoxDecoration(
                                color: kColorWhite,
                                borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("Add Shipment Address", style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Poppins",
                                      fontSize: 15,
                                      color: kColorBlack,
                                    ),textAlign: TextAlign.start,),
                                  ],
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text("You don't have any shipment address, go to your profile and add address.", style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Poppins",
                                  fontSize: 14,
                                  color: kColorBlack.withOpacity(.6),
                                ),),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap :(){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => MyAccount(addAddress: true,)));
                                        setState(() {
                                          showAddAddress = false;
                                        });
                                      },
                                      child: Text("Okay",style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Poppins",
                                        fontSize: 15,
                                        color: kPrimaryColor,
                                      )),
                                    ),
                                    SizedBox(
                                      width: 25,
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          showAddAddress = false;
                                        });
                                      },
                                      child: Text("Cancel",style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Poppins",
                                        fontSize: 15,
                                        color: kColorBlack,
                                      )),
                                    ),
                                  ],
                                ),
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

            ],
          ),
        ),
      ),
    );
  }

  checkboxChanged(bool value) {}

  Widget cartCustom(CartItems cartModel) => Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.only(right: 10, left: 10, bottom: 10,top: 5),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: kColorSmoke.withOpacity(.4),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          color: kColorWhite,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                    activeColor: kPrimaryColor,
                    value: cartModel.isChecked,
                    onChanged: (value1) async {

                      dataList[dataList.indexOf(cartModel)].isChecked = !dataList[dataList.indexOf(cartModel)].isChecked!;
                      int counter = 0;
                      for(int i=0; i<dataList.length;i++){
                        if(dataList[i].isChecked == true){
                          counter ++;
                        }
                      }
                      setState(() {
                        if(counter != 0){
                          deleteSelected = true;
                        }else{
                          deleteSelected = false;
                        }
                      });
                    },
                )
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 4.5),
                child: Image.network(cartModel.imageUrl!)),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartModel.productName!.trim(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                    fontSize: 12,
                    color: kColorBlack,
                  ),
                ),
                SizedBox(height: 3,),
                Row(
                  children: [
                    Text(
                      "From",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: "Poppins",
                        fontSize: 11,
                        color: kColorBlack,
                      ),
                    ),
                    SizedBox(width: 10,),
                    Row(
                      children: [
                        SvgPicture.asset("assets/svg/naira.svg",width: 10,height: 10,color: kPrimaryColor,),
                        Text(
                           cartModel.minUnitPrice!.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: "Poppins",
                            fontSize: 11,
                            color: kPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
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
                          EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                          color: Color(0xFFECECEC),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          InkWell(
                            onTap:(){
                              late int qty;
                              if(cartModel.quantity != 0){
                                qty = cartModel.quantity! - 1;
                                updateCartQty(cartModel,qty);
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
                            cartModel.quantity.toString(),
                            style: kmediumTextBold(kColorSmoke2),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          InkWell(
                            onTap:(){
                              late int qty;
                              qty = cartModel.quantity! + 1;
                              updateCartQty(cartModel,qty);
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
                    InkWell(
                      onTap: () {
                        deleteFromCart(cartModel);
                      },
                      child: SvgPicture.asset(
                        "assets/svg/cart_delete.svg",
                        color: Color(0xFFAF1302),
                        width: 15,
                        height: 15,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                  ],
                ),
              ],
            ))
          ],
        ),
      );

  void viewCartItems() {
    print("We are In cart now...");
    ServiceClass serviceClass = ServiceClass();
    serviceClass.viewCartItems().then((value) => output(value));
  }

  void deleteFromCart(CartItems cartModel) {
    print("We are In now...");
    ServiceClass serviceClass = ServiceClass();
    serviceClass.deleteCartItem(cartModel.shoppingCartOrderItemId!,cartModel.productId!).then((value) => deleteOutput(value,cartModel));
  }


  void deleteMultipleFromCart(List<DeleteCartItems> items) {
    print("We are In delete multiple now now...");
    ServiceClass serviceClass = ServiceClass();
    serviceClass.deleteMultipleCartItem(items).then((value) => deleteOutput2(value,items));
  }


  void updateCartQty(CartItems cartModel,int qty) {
    //print("We are In now increase qty...");
    ServiceClass serviceClass = ServiceClass();
    serviceClass.increaseCartQty(cartModel.productId!,cartModel.shoppingCartOrderItemId!,qty).then((value) => increaseOutput(value,cartModel,qty));
  }


  void startCheckout(bool prescriptionNeeded) {
    //print("We are In now increase qty...");
    setState(() {
      loading = true;
    });
    ServiceClass serviceClass = ServiceClass();
    serviceClass.startCheckout().then((value) => startCheckoutOutput(value,prescriptionNeeded));
  }


  void output(ResponseObject obj) {
    print("We are cart output right now...");
    print(obj.responseBody!);
    print("Response code ${obj.responseCode}");
    if (obj.responseBody!.contains("Network Error")) {
      setState(() {
        dataLoaded = false;
        loading = false;
        errorOcurred = true;
      });
    } else {
      if (obj.responseCode != 200) {
        _showMessage("Unexpected Error ......");
        setState(() {
          loading = false;
          dataLoaded = false;
          errorOcurred = true;
        });
      } else {
        var data = json.decode(obj.responseBody!);
        if (data["responseBody"]["data"] == null) {
          _showMessage("Empty Cart");
          setState(() {
            loading = false;
            dataLoaded = true;
            //errorOcurred = true;
          });
          dataList = [];
        } else {
        dynamic data2 = data["responseBody"]["data"];
        dataList.clear();
        prescribedList.clear();
        nonPrescribedList.clear();
        dataList = data2
            .map<CartItems>((element) => CartItems.fromJson(element))
            .toList();

        if (dataList.isNotEmpty) {
          for (int x = 0; x < dataList.length; x++) {
            late double p;
            late double price;
            if (dataList[x].quantity == 0) {
              p = double.parse("1");
              price = p * dataList[x].minUnitPrice!;
            } else {
              p = double.parse(dataList[x].quantity!.toString());
              price = p * dataList[x].minUnitPrice!;
            }
            total = total + price;

            if(dataList[x].requiresPrescription!){
              prescribedList.add(dataList[x]);
            }else{
              nonPrescribedList.add(dataList[x]);
            }
          }
        }

        print("Cart total as of calculation --- $total");
        print("Cart Items");
        setState(() {
          loading = false;
          errorOcurred = false;
          dataLoaded = true;
        });

      }
      }
    }
  }



  void startCheckoutOutput(String body, bool prescriptionNeeded) {
    print("We are In second haven now...");
    print(body);
    if (body.contains("Network Error")) {
      setState(() {
        loading = false;
        errorOcurred = true;
      });
    } else {
      setState(() {
        loading = false;
      });
      var bodyT = jsonDecode(body);
      if (bodyT["status"] == "Successful") {
        var id = bodyT["data"]["salesOrderId"];
        var uniqueSalesOrderId = bodyT["data"]["uniqueSalesOrderId"];
        //_showMessage("Unexpected Error ......");


        print("Cart total as of now is ------------ $total");
        Navigator.pop(context);

        if(prescriptionNeeded){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      UploadPrescription(id,uniqueSalesOrderId,dataList,total)));
        }else{
          Navigator.push(context, MaterialPageRoute(builder: (context) => Checkout(id,uniqueSalesOrderId,dataList,total)));
        }

      } else {
        _showMessage("Unexpected Error ......");
      }
    }
  }

  void deleteOutput(String body,CartItems items) {
    print("delete wishlist");
    print(body);
    if (body.contains("Network Error")) {
      _showMessage("Network error occured, please try again.");
    } else {
      var bodyT = jsonDecode(body);
      print("Okay ooo my boy");
      print(bodyT);
      if (bodyT["message"] == "Deleted") {
        _showMessage(bodyT["message"]);
        Provider.of<ServiceClass>(context, listen: false).increaseCart();
        dataList.removeAt(dataList.indexOf(items));
        prescribedList.clear();
        nonPrescribedList.clear();

        setState(() {
        if(dataList.length != 0) {
          total = 0;
          for (int x = 0; x < dataList.length; x++) {
            late double p;
            late double price;
            if(dataList[x].quantity == 0){
              p = double.parse("1");
              price = p * dataList[x].minUnitPrice!;
            }else{
              p = double.parse( dataList[x].quantity!.toString());
              price = p * dataList[x].minUnitPrice!;
            }
            total = total + price;

            if(dataList[x].requiresPrescription!){
              prescribedList.add(dataList[x]);
            }else{
              nonPrescribedList.add(dataList[x]);
            }

          }
        }else{
        }
        });
      } else {
        print("Not successful....");
        _showMessage(bodyT["message"]);
        setState(() {
          loading = false;
        });
      }
    }
  }


  void deleteOutput2(String body,List<DeleteCartItems> items) {
    print("delete multiple cart items");
    print(body);
    if (body.contains("Network Error")) {
      _showMessage("Network error occured, please try again.");
    } else {
      var bodyT = jsonDecode(body);
      print("Okay ooo my boy");
      print(bodyT);
      if (bodyT["message"] == "Deleted") {
        _showMessage(bodyT["message"]);
        Provider.of<ServiceClass>(context, listen: false).increaseCart();
        for(int i=0;i<items.length;i++){
          int? id = items[i].productId;
          for(int x=0;x<dataList.length;x++){
            if(dataList[x].productId == id){
              dataList.removeAt(dataList.indexOf(dataList[x]));
            }
          }
        }
        setState(() {
          prescribedList.clear();
          nonPrescribedList.clear();
          if(dataList.length != 0) {
            total = 0;
            for (int x = 0; x < dataList.length; x++) {
              late double p;
              late double price;
              if(dataList[x].quantity == 0){
                p = double.parse("1");
                price = p * dataList[x].minUnitPrice!;
              }else{
                p = double.parse( dataList[x].quantity!.toString());
                price = p * dataList[x].minUnitPrice!;
              }
              total = total + price;
              if(dataList[x].requiresPrescription!){
                prescribedList.add(dataList[x]);
              }else{
                nonPrescribedList.add(dataList[x]);
              }
            }
          }else{
            // setState(() {
            //   total = 0;
            // });
          }
        });
      } else {
        print("Not successful....");
        _showMessage(bodyT["message"]);
        setState(() {
          loading = false;
        });
      }
    }
  }

  void increaseOutput(String body,CartItems items, int qty) {
    print("Increase cart item");
    print(body);
    if (body.contains("Network Error")) {
      _showMessage("Network error occured, please try again.");
    } else {
      var bodyT = jsonDecode(body);
      print("Okay ooo my boy");
      print(bodyT);
      if (bodyT["message"] == "Cart Updated") {
       // _showMessage(bodyT["message"]);
        dataList[dataList.indexOf(items)].quantity = qty;
        setState(() {
          if(dataList.length != 0) {
            total = 0;
            for (int x = 0; x < dataList.length; x++) {
              late double p;
              late double price;
              if(dataList[x].quantity == 0){
                p = double.parse("1");
                price = p * dataList[x].minUnitPrice!;
              }else{
                p = double.parse( dataList[x].quantity!.toString());
                price = p * dataList[x].minUnitPrice!;
              }
              total = total + price;
            }
          }
        });

      } else {
       // print("Not successful....");
        _showMessage(bodyT["message"]);
        setState(() {
          loading = false;
        });
      }
    }
  }



  void viewShipmentAddress() {
    print("We are In now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.viewShipmentAddresses().then((value) => shipmentOutput(value));
  }

  void shipmentOutput(String body) {
    print("We are In shipment output now...");
    print(body);
    if (body.contains("Network Error")) {
      _showMessage("Network Error");
    } else {
      var bodyT = jsonDecode(body);
      if (bodyT["status"] == "Successful") {
        print("This the body of get all address in the mirror my boy ..............");
        print(body);
        dynamic value = bodyT["data"]["value"];
        //addressList = [];
        List<MedShipAddrees> list2 = value
            .map<MedShipAddrees>((element) => MedShipAddrees.fromJson(element))
            .toList();

        if(list2.isNotEmpty){
          int counter = 0;
          for (int x = 0; x < dataList.length; x++) {
            if(dataList[x].requiresPrescription!){
              counter ++;
            }
          }

          if(counter != 0){
            setState(() {
              loaded = true;
            });
          }else{
            startCheckout(false);
          }
        }else{
          setState(() {
            showAddAddress = true;
          });
        }

      }
    }
  }

}
