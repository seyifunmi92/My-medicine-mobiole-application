// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, sized_box_for_whitespace, unnecessary_new

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mymedicinemobile/constants.dart';
import 'package:mymedicinemobile/models/models.dart';
import 'package:mymedicinemobile/reusables/bars.dart';
import 'package:mymedicinemobile/screens/mobile/cart/cart.dart';
import 'package:mymedicinemobile/screens/mobile/product_details/product_details.dart';
import 'package:mymedicinemobile/services/services.dart';
import 'package:mymedicinemobile/text_style.dart';
import 'package:provider/provider.dart';


class AllProducts extends StatefulWidget {
  @override
  _AllProductsState createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts>
    with SingleTickerProviderStateMixin{

  bool loading = true;
  bool dataLoaded = false;
  late AnimationController _animationController;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<ProductList> list = [];


  @override
  void initState() {

    print("XSSSSSS............");
    viewProductList();

    _animationController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 3));
    _animationController.repeat();
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kColorWhite,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: [

              Container(
                child: Column(
                  children: [
                    navBarCustomCartBeforeFilter('Popular Products',context,Cart(),true),
                    Container(
                      height: height * .9,
                      child: ListView(
                        children: [
                          ...list.map((e) => productCustom(e)),
                        ],
                      ),
                    ),

                  ],
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


            ]
          ),
        ),
      ),

    );
  }

  Widget productCustom (ProductList productList) {
    var formatter = NumberFormat('#,###,000');
    return InkWell(
      onTap: () {
        print("Pressed ........");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProductID(productList.productId!)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        //padding: EdgeInsets.only(bottom: 10,top: 10),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: kColorSmoke.withOpacity(.4),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ], color: kColorWhite, borderRadius: BorderRadius.circular(20)),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery
                          .of(context)
                          .size
                          .width / 2.5,
                      maxHeight: MediaQuery
                          .of(context)
                          .size
                          .width / 2.2),
                  padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                  decoration: BoxDecoration(
                    color: Color(0xFFF0F2F5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.network(
                    productList.productImageUrl!,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          productList.productName!.trim(),
                          style: ksmallTextBold(kColorBlack),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Row(
                          children: [
                            SvgPicture.asset("assets/svg/naira.svg",width: 11,height: 10,color: kPrimaryColor,),
                            Text(
                              formatter.format(productList.minPrice).toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Poppins",
                                  fontSize: 13,
                                  color: kPrimaryColor),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Row(
                          children: [
                            Text(
                              "Type: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Poppins",
                                  fontSize: 11,
                                  color: kColorSmoke2),
                            ),
                            Text(
                              productList.productCategory!,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Poppins",
                                  fontSize: 11,
                                  color: kColorSmoke2),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              "Manufacturer",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Poppins",
                                  fontSize: 11,
                                  fontStyle: FontStyle.italic,
                                  color: kColorSmoke2),
                            ),
                            Expanded(
                              child: Text(
                                ": " + productList.manufacturer!.trim(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Poppins",
                                    fontSize: 11,
                                    fontStyle: FontStyle.italic,
                                    color: kColorSmoke2),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        // InkWell(
                        //   onTap: () {},
                        //   child: Container(
                        //     width: 30,
                        //     height: 30,
                        //     padding: EdgeInsets.symmetric(
                        //         vertical: 10, horizontal: 10),
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(180),
                        //       color: kColorSmoke.withOpacity(.4),
                        //     ),
                        //     child: SvgPicture.asset(
                        //       "assets/svg/love.svg",
                        //       color: kColorWhite,
                        //       width: 20,
                        //       height: 20,
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ))
              ],
            ),
            Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: (){
                    if(productList.totalQuantityInStock! > 0){
                      addToCart(productList.productId!);
                    }else{
                      _showMessage("Product is out of stock");
                    }

                  },
                  child: Container(
                    width: 70,
                    height: 45,
                    decoration: BoxDecoration(
                        color: productList.totalQuantityInStock! > 0 ? kPrimaryColor : kColorSmoke2,
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
      ),
    );
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

  void viewProductList() {
    print("We are In now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.viewProductList().then((value) => output(value));
  }

  void output(String body) {
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
        list.clear();
        List<ProductList> list2 = value
            .map<ProductList>((element) => ProductList.fromJson(element)).toList();


        String proove = Provider.of<ServiceClass>(context,listen: false).Filter;
        print("Current text now ....");
        print(proove);
        if( proove != "Select"){
            print("Heyyyyyyyy ........yyyeyeyeyyeyeyeyyeyeyey");
            for(int i=0;i<list2.length;i++){

              String manu = list2[i].manufacturer!.toLowerCase();
              print("Manu name " + manu);
              if(manu.trim().contains(proove.toLowerCase())){
                list.add(list2[i]);
              }
            }
        }else{
          list = list2;
        }

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

  void addToCart(int id) {
      print("We are In Add to cart now...");
      ServiceClass serviceClass = new ServiceClass();
      serviceClass.addToCart(id,1).then((value) => addCartOutput(value));
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


}


