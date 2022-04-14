import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mymedicinemobile/constants.dart';
import 'package:mymedicinemobile/screens/mobile/medicine_refill/medicine_refill.dart';
import 'package:mymedicinemobile/screens/mobile/orders/myorders.dart';


class OrderComplete extends StatefulWidget{
    String uniqueOrder;
    OrderComplete(this.uniqueOrder);
  _OrderComplete createState()=> _OrderComplete();
}


class _OrderComplete extends State<OrderComplete>{

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

              Text(
                "Your Order AHA ${widget.uniqueOrder} is Completed.\nPlease Check the Delivery Status at \nOrder Tracking Pages.",
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



            SizedBox(height: 30,),

            Column(
              children: [

                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddMedicine(0)));
                  },
                  child: Container(
                    width: width * .7,
                    padding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kPrimaryColor),
                    child: Center(
                      child: Text(
                        "MEDICATION REFILL FORM",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          color: kColorWhite,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15,),
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