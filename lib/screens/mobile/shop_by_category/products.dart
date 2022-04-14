// ignore_for_file: unnecessary_new, prefer_const_constructors, sized_box_for_whitespace

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mymedicinemobile/constants.dart';
import 'package:mymedicinemobile/error_page.dart';
import 'package:mymedicinemobile/models/models.dart';
import 'package:mymedicinemobile/reusables/bars.dart';
import 'package:mymedicinemobile/screens/mobile/cart/cart.dart';
import 'package:mymedicinemobile/screens/mobile/product_details/product_details.dart';
import 'package:mymedicinemobile/screens/mobile/shop_by_category/filter.dart';
import 'package:mymedicinemobile/services/services.dart';
import 'package:mymedicinemobile/text_style.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class CatProducts extends StatefulWidget {
  _CatProducts createState() => new _CatProducts();
}

class _CatProducts extends State<CatProducts> with SingleTickerProviderStateMixin{
  bool value = false;
  bool productShow = false;
  TextEditingController searchC = new TextEditingController();
  stt.SpeechToText speech = stt.SpeechToText();
  List<ProductCategory> categoryList = [];
  List<ProductSubCategory> subCategoryList = [];
  List<ProductFromSubcategory> productsList = [];

  bool productLoaded = false;
  bool loading = true;
  bool productLoading = false;
  bool dataLoaded = false;
  bool errorOcurred = false;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 2),
    );
    _animationController.repeat();
    showProductCategory();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                width: width,
                //margin: EdgeInsets.only(left: 10,right: 1),
                height: height,
                child: Column(
                  children: [
                    navBarCustomCartBeforeFilter('Products',context,Cart(),true),
                    SizedBox(
                      height: 10,
                    ),

                    errorOcurred
                        ? errorPage(() {
                      showProductCategory();
                      showProductSubCategory(1);
                      print("Clicked");
                      setState(() {
                        loading = true;
                        errorOcurred = false;
                      });
                    }) : dataLoaded == false
                        ? Center() :
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      height: height * .83,
                      child: ListView(
                        children: [
                          Text(
                              "SHOP BY",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Poppins",
                                  fontSize: 12,
                                  color: kColorBlack.withOpacity(.6)
                              )
                          ),
                          SizedBox(height:5,),
                          Text(
                              "Category",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Poppins",
                                  fontSize: 13,
                                  color: kColorBlack
                              )
                          ),
                          SizedBox(height: 10,),
                          Container(
                            height: 130,
                            child: ListView.builder(
                                itemCount: categoryList.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, i) {
                                  return categoryCustom(categoryList[i]);
                                } ),
                          ),
                          SizedBox(height: 25,),
                          Container(
                            height: 40,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                ...subCategoryList.map((e) => categoryTile(e,context)),
                              ],),
                          ),
                          SizedBox(height: 25,),
                          productLoading ? Center(child: CircularProgressIndicator(strokeWidth: 20,color: kPrimaryColor,)) :
                          productLoaded ? Column(
                            children: [
                              ...productsList.map((e) => productCustom(e)),
                            ],
                          ) : Center(),
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



            ],
          ),
        ),
      ),
    );
  }


  Widget categoryCustom(ProductCategory productCategory) => InkWell(
    onTap: () {
      print("This is from p the ID ${productCategory.id}");
      for(var x in categoryList){
        x.clicked = false;
      }
      setState(() {
        categoryList[categoryList.indexOf(productCategory)].clicked = true;
        productShow = true;
      });

      showProductSubCategory(productCategory.id!);
      viewProductsByCategory(productCategory.id!);
    },
    child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        height: 130,
        width: 100,
        decoration: BoxDecoration(
            // boxShadow: [
            //   BoxShadow(
            //     color: kColorSmoke.withOpacity(.4),
            //     spreadRadius: 1,
            //     blurRadius: 7,
            //     offset: Offset(5, 3), // changes position of shadow
            //   ),
            // ],
            border: categoryList[categoryList.indexOf(productCategory)].clicked == true ?
            Border.all(color: kPrimaryColor,width: 1,style: BorderStyle.solid) : Border.all(color: Colors.grey,width: 1,style: BorderStyle.solid),
            color: Color(0xFFECECEE),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            //Image.asset(""),
            SizedBox(height: 5,),
            Text(
              productCategory.name.toString(),
              style: TextStyle(
                  fontSize: 11,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w400,
                  color: kColorBlack),
              textAlign: TextAlign.center,
            ),
          ],
        )),
  );

  Widget categoryTile(ProductSubCategory productSubCategory,BuildContext context) => InkWell(
    onTap: (){

      print("This is the ID ${productSubCategory.productCategoryId}");
      for(var x in subCategoryList){
        x.clicked = false;
      }
      setState(() {
        subCategoryList[subCategoryList.indexOf(productSubCategory)].clicked = true;
        productLoading = true;
      });
      if(subCategoryList.indexOf(productSubCategory) == 0){
        String proove = Provider.of<ServiceClass>(context,listen: false).Filter;
        print("Current text now ....");
        print(proove);
        if( proove != "Select"){
          viewProductsByBrands(proove);
        }else{
          viewProductsByCategory(productSubCategory.productCategoryId!);
        }

      }else{
        viewProductsFromSubCategory(productSubCategory.id!);
      }

    },
    child:  Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      padding: EdgeInsets.symmetric(vertical: 1, horizontal: 20),
      decoration: BoxDecoration(
          color: productSubCategory.clicked! ? kPrimaryColor : kColorWhite,
          border: subCategoryList[subCategoryList.indexOf(productSubCategory)].clicked == true ?
          Border.all(color: kPrimaryColor,width: 1,style: BorderStyle.solid) : Border.all(color: Colors.grey,width: 0.3,style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(5)),
      child: Center(
        child: Text(productSubCategory.name!,style: TextStyle(
            fontWeight: FontWeight.w400,
            fontFamily: "Poppins",
            fontSize: 12,
            color: productSubCategory.clicked! ? kColorWhite : kPrimaryColor
        ),),
      ),
    ),
  );



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

  void showProductCategory() {
    print("We are In product now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.viewProductCategory().then((value) => categoryOutput(value));
  }

  void showProductSubCategory(int productId){
    print("We are In product now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.viewProductSubCategory(productId).then((value) => subCategoryOutput(value,productId));

  }

  void viewProductsFromSubCategory(int subCategoryId) {
    print("We are In products from subcategory now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.viewProductsFromSubCategory(subCategoryId).then((value) => subCategoryProductsOutput(value));
  }

  void viewProductsByCategory(int categoryId) {
    print("We are In products from subcategory now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.viewProductsByCategory(categoryId).then((value) => subCategoryProductsOutput(value));
  }

  void viewProductsByBrands(String txt) {
    print("We are In products from subcategory now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.viewProductsByBrands(txt).then((value) => brandProductsOutput(value));
  }


  void categoryOutput(String body) {
    print("We are In category now...");
    print(body);
    if (body.contains("Network Error")) {
      _showMessage("Network Error");
      setState(() {
        loading = false;
      });
    } else {
      var bodyT = jsonDecode(body);
      if (bodyT["message"] == "Successful") {
        var data = json.decode(body);
        print(data);
        var value = data["data"]["value"];
        print(value);
        dynamic myValue = value;
        print(myValue);

        //dynamic value = data["data"]["value"];
        categoryList = myValue.map<ProductCategory>((element) => ProductCategory.fromJson(element)).toList();
        print(categoryList);

        if(categoryList.isNotEmpty){
          showProductSubCategory(categoryList[0].id!);
          viewProductsByCategory(categoryList[0].id!);
        }

        setState(() {
          loading = false;
          dataLoaded = true;
          categoryList[0].clicked = true;
          productLoading = true;
        });
      }
      else {
        _showMessage(bodyT["message"]);
        setState(() {
          loading = false;
        });
      }
    }
  }



  void subCategoryOutput(String body, int productId) {
    print("We are In sub category now...");
    print(body);
    if (body.contains("Network Error")) {
      _showMessage("Network Error");
      setState(() {
        loading = false;
        errorOcurred = true;
        dataLoaded = false;
      });
    } else {
      var bodyT = jsonDecode(body);
      if (bodyT["message"] == "Successful") {
        var data = json.decode(body);
        print(data);
        var value = data["data"]["value"];
        print(value);
        dynamic myValue = value;
        print(myValue);

        // dynamic value = data["data"]["value"];

        //print(list1);

        subCategoryList.clear();
        setState(() {
          subCategoryList = myValue.map<ProductSubCategory>((element) => ProductSubCategory.fromJson(element)).toList();
          subCategoryList.insert(0,new ProductSubCategory(id: 0,productCategoryId: productId,name: "All",clicked: true));
          loading = false;
          errorOcurred = false;
          dataLoaded = true;
        });
      }
      else {
        _showMessage(bodyT["message"]);
        setState(() {
          loading = false;
          errorOcurred = true;
          dataLoaded = false;
        });
      }
    }
  }


  void subCategoryProductsOutput(String body) {
    print("We are In products from subcategory output now...");
    print(body);
    if (body.contains("Network Error")) {
      _showMessage("Network Error");
      setState(() {
        productLoaded = false;
        productLoading = false;
      });
    } else {
      var bodyT = jsonDecode(body);
      if (bodyT["message"] == "Successful") {
        var data = json.decode(body);
        print(data);
        var value = data["data"]["value"];
        print(value);
        dynamic myValue = value;
        print(myValue);
        productsList.clear();
        //print(productsList[0]);
        setState(() {
          productLoaded = true;
          productLoading = false;
          productsList = myValue.map<ProductFromSubcategory>((element) => ProductFromSubcategory.fromJson(element)).toList();
        });
      }
      else {
        _showMessage(bodyT["message"]);
        setState(() {
          productLoaded = false;
          productLoading = false;
        });
      }
    }
  }


  void brandProductsOutput(String body) {
    print("We are In products from subcategory output now...");
    print(body);
    if (body.contains("Network Error")) {
      _showMessage("Network Error");
      setState(() {
        productLoaded = false;
        productLoading = false;
      });
    } else {
      var bodyT = jsonDecode(body);
      if (bodyT["message"] == "Successful") {
        var data = json.decode(body);
        print(data);
        var value = data["data"]["value"];
        print(value);
        dynamic myValue = value;
        print(myValue);
        productsList.clear();
        //print(productsList[0]);
        setState(() {
          productLoaded = true;
          productLoading = false;
          productsList = myValue.map<ProductFromSubcategory>((element) => ProductFromSubcategory.fromJson(element)).toList();
        });
      }
      else {
        _showMessage(bodyT["message"]);
        setState(() {
          productLoaded = false;
          productLoading = false;
        });
      }
    }
  }

  Widget productCustom(ProductFromSubcategory cartModel) => InkWell(
    onTap:(){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductID(cartModel.productId!)));
    },
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: kColorSmoke.withOpacity(.4),
          spreadRadius: 2,
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
              // SizedBox(
              //   width: 10,
              // ),
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width/3,
                  maxHeight: 150
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  color: Color(0xFFF0F2F5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.network(
                  cartModel.productImageUrl != null ? cartModel.productImageUrl! : "",
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
                        height: 10,
                      ),
                      Text(
                        cartModel.productName != null ? cartModel.productName!.trim() : "",
                        style: ksmallTextBold(kColorBlack),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset("assets/svg/naira.svg",width: 10,height: 10,color:kPrimaryColor ,),
                          Text(
                              cartModel.minPrice != null ? cartModel.minPrice!.toString() : "",
                            style: kmediumTextBold(kPrimaryColor),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Row(
                        children: [
                          Text(
                            "Type",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w400,
                                fontSize: 11,
                                color: kColorSmoke2
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              cartModel.productType != null ? cartModel.productType!.trim() : "",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11,
                                  color: kColorSmoke2
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Row(
                        children: [
                          Text(
                            "Manufacturer:",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                              color: kColorSmoke2
                            ),
                          ),
                          SizedBox(width: 5,),
                          Expanded(
                            flex: 1,
                            child: Text(
                              cartModel.manufacturer != null ? ": ${cartModel.manufacturer!.trim()}" : "",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11,
                                  fontStyle: FontStyle.italic,
                                  color: kColorSmoke2
                              ),
                              maxLines: 1,
                                overflow: TextOverflow.ellipsis
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),

                      InkWell(
                        onTap: (){
                          createWishlist(cartModel.productId!, productsList.indexOf(cartModel));
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(180),
                            color: Color(0xFFF0F2F5),
                          ),
                          child: SvgPicture.asset(
                            "assets/svg/love.svg",
                            color: cartModel.addedToWishList! == false ? kColorWhite : kErrorColor,
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 10,
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
                  if(cartModel.totalQuantityInStock! >0){
                    addToCart(cartModel.productId!);
                  }else{
                    _showMessage("Out of stock");
                  }

                },
                child: Container(
                  width: 60,
                  height: 44,
                  decoration: BoxDecoration(
                      color: cartModel.totalQuantityInStock! >0 ? kPrimaryColor : kColorSmoke2,
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


  void addToCart(int productId) {
    print("We are In Add to cart now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.addToCart(productId,1).then((value) => addCartOutput(value));
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


  void createWishlist(int productId,int currentIndex) {
    print("We are In now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.createWishList(2, productId).then((value) => output(value,currentIndex));
  }

  void output(String body,int currentIndex) {
    print("Added to wishlist now ...");
    var bodyT = jsonDecode(body);
    print(bodyT);
    _showMessage(bodyT["message"]);
    if (bodyT["status"] == true) {
      var data = json.decode(body);
      dynamic data2 = data;
      //print(data2);
     setState(() {
       productsList[currentIndex].addedToWishList = true;
     });
    }
  }


}









