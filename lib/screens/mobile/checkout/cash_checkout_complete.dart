import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mymedicinemobile/constants.dart';
import 'package:mymedicinemobile/screens/mobile/orders/myorders.dart';


class OrderComplete2 extends StatefulWidget{
    String uniqueOrder;
    OrderComplete2(this.uniqueOrder);
  _OrderComplete2 createState()=> _OrderComplete2();

}


class _OrderComplete2 extends State<OrderComplete2>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(child: Container(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
                Icon(Icons.clear,size: 30,),
                SizedBox(width: 30,)
          ],),

          Column(
            children: [

              SvgPicture.asset("assets/svg/checkbox.svg"),

              SizedBox(height: 10,),
              Text(
                "Thank you, Your order has been placed.",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                    fontSize: 15,
                    //decoration: TextDecoration.underline,
                    color: kPrimaryColor),
              ),


              SizedBox(height: 30,),

              Container(
                margin: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                padding: EdgeInsets.symmetric(
                    vertical: 15, horizontal: 10),
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
                    borderRadius:
                    BorderRadius.circular(20)),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.location_on_outlined),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          "Home Delivery",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: kColorBlack,
                          ),
                        ),

                        // SvgPicture.asset(
                        //   "assets/svg/tick3ple.svg",
                        // ),
                      ],
                    ),
                    SvgPicture.asset(
                      "assets/svg/tick3ple.svg",
                    ),
                  ],
                ),
              ),

              SizedBox(height: 15,),

              Text(
                "Your Order AHA ${widget.uniqueOrder} will be \n delivered to you very soon",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins",
                    fontSize: 15,
                    //decoration: TextDecoration.underline,
                    color: kColorBlack),
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Click ",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: "Poppins",
                        fontSize: 15,
                        //decoration: TextDecoration.underline,
                        color: kColorBlack),
                    textAlign: TextAlign.center,
                  ),

                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MyOrders(false)));
                    },
                    child: Text(
                      "Order Tracking ",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: "Poppins",
                          fontSize: 15,
                          //decoration: TextDecoration.underline,
                          color: kPrimaryColor),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  Text(
                    "to track order.",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: "Poppins",
                        fontSize: 15,
                        //decoration: TextDecoration.underline,
                        color: kColorBlack),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),


              SizedBox(height: 15,),

              Container(
                margin: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                padding: EdgeInsets.symmetric(
                    vertical: 15, horizontal: 10),
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
                    borderRadius:
                    BorderRadius.circular(20)),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        SvgPicture.asset(
                          "assets/svg/cashpayment.svg",
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          "Cash/Card on Delivery",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: kColorBlack,
                          ),
                        ),

                        // SvgPicture.asset(
                        //   "assets/svg/tick3ple.svg",
                        // ),
                      ],
                    ),
                    SvgPicture.asset(
                      "assets/svg/tick3ple.svg",
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10,),


            ],
          ),



            SizedBox(height: 30,),

            Column(
              children: [

                // Container(
                //   width: width * .7,
                //   padding:
                //   EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(10),
                //       color: kPrimaryColor),
                //   child: Center(
                //     child: Text(
                //       "MEDICATION REFILL FORM",
                //       style: TextStyle(
                //         fontFamily: "Poppins",
                //         fontWeight: FontWeight.w600,
                //         color: kColorWhite,
                //         fontSize: 15,
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(height: 15,),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MyOrders(false)));
                  },
                  child: Container(
                    width: width * .7,
                    padding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: kPrimaryColor,width: 1,style: BorderStyle.solid),
                        color: kColorWhite),
                    child: Center(
                      child: Text(
                        "VIEW ORDER",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          color: kPrimaryColor,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),







        ],),
      ),),
    );
  }
}