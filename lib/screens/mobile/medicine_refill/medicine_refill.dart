// ignore_for_file: unused_element, deprecated_member_use
import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mymedicinemobile/constants.dart';
import 'package:mymedicinemobile/models/models.dart';
import 'package:mymedicinemobile/reusables/bars.dart';
import 'package:mymedicinemobile/screens/mobile/cart/cart.dart';
import 'package:mymedicinemobile/screens/mobile/medicine_refill/product_search_refill.dart';
import 'package:mymedicinemobile/screens/mobile/medicine_refill/refill_orders.dart';
import 'package:mymedicinemobile/screens/mobile/medicine_refill/refill_product_details2.dart';
import 'package:mymedicinemobile/screens/mobile/orders/myorders.dart';
import 'package:mymedicinemobile/screens/mobile/product_search/similar_products.dart';
import 'package:mymedicinemobile/services/services.dart';
import 'package:mymedicinemobile/text_style.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

// ignore: must_be_immutable
class AddMedicine extends StatefulWidget {
  int productId;
  AddMedicine(this.productId, {Key? key}) : super(key: key);
  @override
  _AddMedicine createState() => _AddMedicine();
}

class _AddMedicine extends State<AddMedicine>
    with SingleTickerProviderStateMixin {
  bool noOrders = true;
  bool productShow = false;
  bool searchIsEmpty = false;
  TextEditingController searchC = TextEditingController();
  TextEditingController dateC = TextEditingController();
  int cycleGroupVal = 0;
  int smsValue = 1;
  int emailvalue = 2;
  int inAppVal = 3;
  late AnimationController _animationController;
  List<CartModel> trackList = [];
  bool loading = true;
  bool deleteLoading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool remindMeBySMS = false;
  bool remindMeByEmail = false;
  bool remindMeByInAPP = false;
  String dateTime = "Start date";
  late DateTime _chosenDateTime;
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

  List<RefillProduct> list = [];
  List<RefillCycle> list2 = [];
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animationController.repeat();
    fetchRefillProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
                  //Add Refill Medicine
                  navBarCustom("Add Refill Medicine", context, Cart(), true),

                  Container(
                    height: height * .86,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),

                        InkWell(
                          onTap: () {
                            String dater = dateTime.split(" ")[0] +
                                "T" +
                                dateTime.split(" ")[1];
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductSearchRefill(
                                        0,
                                        remindMeBySMS,
                                        remindMeByEmail,
                                        remindMeByInAPP,
                                        "2021-01-12T23:45")));

                            // if(dateTime.contains("Start date")){
                            //   _showMessage("Select a start date");
                            // }else{
                            //   String dater = dateTime.split(" ")[0] + "T" + dateTime.split(" ")[1];
                            //   Navigator.push(context, MaterialPageRoute(builder: (context) => ProductSearchRefill(list2[cycleGroupVal].id,remindMeBySMS,remindMeByEmail,remindMeByInAPP,dater)));
                            // }
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: kColorSmoke.withOpacity(.4),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                              borderRadius: BorderRadius.circular(10),
                              color: kColorWhite,
                            ),
                            child: const Text(
                              "Search medicine",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyOrders(true)));
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: kColorSmoke.withOpacity(.4),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                              borderRadius: BorderRadius.circular(10),
                              color: kColorWhite,
                            ),
                            child: const Text(
                              "View Completed orders",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        Provider.of<ServiceClass>(context).refillObj != null
                            ? productCustom(
                                Provider.of<ServiceClass>(context).refillObj!)
                            : Text(""),

                        // Column(children: [
                        //   ...list.map((e) => productCustom(Provider.of<ServiceClass>(context).refillObj!)),
                        // ],)

                        const SizedBox(
                          height: 40,
                        ),

                        Container(
                          margin: const EdgeInsets.only(left: 15),
                          child: const Text(
                            "Start date for your medical refill",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),

                        const SizedBox(
                          height: 40,
                        ),

                        InkWell(
                          onTap: () {
                            _showDatePicker(context);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 15),
                            child: Text(
                              dateTime,
                              style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        Divider(
                          height: 2,
                          color: kColorSmoke2,
                        ),
                        const SizedBox(
                          height: 30,
                        ),

                        Container(
                          margin: const EdgeInsets.only(left: 15),
                          child: const Text(
                            " Medicine Refill Cycle",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),

                        const SizedBox(
                          height: 5,
                        ),
                        ...list2.map((e) => cycleCustom(e)),

                        const SizedBox(
                          height: 10,
                        ),

                        Container(
                          margin: const EdgeInsets.only(left: 15),
                          child: const Text(
                            " Remind me by",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),

                        Container(
                          margin: const EdgeInsets.only(left: 15),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    checkColor: Colors.white,
                                    fillColor: MaterialStateProperty.all(
                                        kPrimaryColor),
                                    value: remindMeBySMS,
                                    shape: const CircleBorder(),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        remindMeBySMS = value!;
                                        print(remindMeBySMS);
                                      });
                                    },
                                  ),
                                  const Text(
                                    'SMS',
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    checkColor: Colors.white,
                                    fillColor: MaterialStateProperty.all(
                                        kPrimaryColor),
                                    value: remindMeByEmail,
                                    shape: const CircleBorder(),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        remindMeByEmail = value!;
                                        print(remindMeByEmail);
                                      });
                                    },
                                  ),
                                  const Text(
                                    'Email',
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    checkColor: Colors.white,
                                    fillColor: MaterialStateProperty.all(
                                        kPrimaryColor),
                                    value: remindMeByInAPP,
                                    shape: const CircleBorder(),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        remindMeByInAPP = value!;
                                        print(remindMeByInAPP);
                                      });
                                    },
                                  ),
                                  const Text(
                                    'App Notification',
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 70,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 5,
                left: 10,
                right: 10,
                child: InkWell(
                  onTap: () {
                    // _displayDialog(context);
                    RefillObj refillObj =
                        Provider.of<ServiceClass>(context, listen: false)
                            .refillObj!;
                    if (refillObj == null) {
                      _showMessage("Click on search medicine");
                    } else {
                      if (dateTime.contains("Start date")) {
                        _showMessage("Select a start date");
                      } else {
                        String dater = dateTime.split(" ")[0] +
                            "T" +
                            dateTime.split(" ")[1];

                        // Navigator.push(context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             RefillProductetails(
                        //                 widget.productId,
                        //                 list2[cycleGroupVal].id,
                        //                 remindMeBySMS, remindMeByEmail,
                        //                 remindMeByInAPP, dater)));
                        setState(() {
                          loading = true;
                        });
                        addRefill(
                            refillObj.productId!,
                            list2[cycleGroupVal].id,
                            remindMeBySMS,
                            remindMeByEmail,
                            remindMeByInAPP,
                            dater);
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kPrimaryColor),
                    child: Center(
                      child: Text(
                        "SCHEDULE MEDICINE REFILL",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 14,
                            color: kColorWhite,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget cycleCustom(RefillCycle refillCycle) => Container(
        margin: const EdgeInsets.only(left: 15, top: 1),
        child: Row(
          children: [
            Radio(
              value: list2.indexOf(refillCycle),
              activeColor: kPrimaryColor,
              groupValue: cycleGroupVal,
              onChanged: (value) {
                print("This is clicked");
                print(value);
                setState(() {
                  cycleGroupVal = value as int;
                });
              },
            ),
            Text(
              '${refillCycle.name}',
              style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
      );
  void _showDatePicker(ctx) {
    // showCupertinoModalPopup is a built-in function of the cupertino library
    dateTime = DateTime.now().add(const Duration(days: 1)).toString();
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: 500,
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  Container(
                    height: 400,
                    child: CupertinoDatePicker(
                        minimumDate: DateTime.now().add(new Duration(days: 1)),
                        initialDateTime:
                            DateTime.now().add(new Duration(days: 1)),
                        //maximumDate : DateTime.now().add(new Duration(days: 14)),
                        onDateTimeChanged: (val) {
                          setState(() {
                            _chosenDateTime = val;
                            dateTime = _chosenDateTime.toString();
                            print("This the date");
                            print(val);
                          });
                        }),
                  ),
                  // Close the modal
                  CupertinoButton(
                    child: const Text('OK'),
                    onPressed: () => Navigator.of(ctx).pop(),
                  )
                ],
              ),
            ));
  }

  Widget productCustom(RefillObj cartModel) => Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: kColorSmoke.withOpacity(.4),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(10),
          color: kColorWhite,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: 10,
            ),
            Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 3),
                child: Image.network(cartModel.productImage!)),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartModel.productName!,
                  style: ksmallTextBold(kColorBlack),
                ),
                Text(
                  cartModel.productId.toString(),
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      color: kColorSmoke2,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/svg/naira.svg",
                      color: kPrimaryColor,
                      width: 10,
                      height: 12,
                    ),
                    Text(
                      cartModel.price.toString(),
                      style: kmediumTextBold(kPrimaryColor),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                          color: const Color(0xFFECECEC),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              if (cartModel.quantity! > 1) {
                                setState(() {
                                  cartModel.quantity = cartModel.quantity! - 1;
                                });
                              }
                            },
                            child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 1),
                                decoration: BoxDecoration(
                                    color: kColorWhite,
                                    borderRadius: BorderRadius.circular(5)),
                                child: const Icon(
                                  Icons.remove,
                                  size: 15,
                                )),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            "${cartModel.quantity}",
                            style: kmediumTextBold(kColorSmoke2),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                cartModel.quantity = cartModel.quantity! + 1;
                              });
                            },
                            child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 1),
                                decoration: BoxDecoration(
                                    color: kColorWhite,
                                    borderRadius: BorderRadius.circular(5)),
                                child: const Icon(
                                  Icons.add,
                                  size: 15,
                                )),
                          ),
                        ],
                      ),
                    ),
                    // cartModel.isLoading! ?CircularProgressIndicator(strokeWidth: 5) :InkWell(
                    //   onTap: (){
                    //     setState(() {
                    //       list[list.indexOf(cartModel)].isLoading = true;
                    //     });
                    //     deleteRefillProduct(cartModel.refillId!,list.indexOf(cartModel));
                    //   },
                    //   child: SvgPicture.asset(
                    //     "assets/svg/cart_delete.svg",
                    //     color: Color(0xFFAF1302),
                    //     width: 17,
                    //     height: 20,
                    //   ),
                    // )
                  ],
                ),
              ],
            ))
          ],
        ),
      );
  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Refill Medicine!'),
            content: const Text(
                "Are you sure you want to schedule medicine refill order?"),
            actions: <Widget>[
              FlatButton(
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Refillorders()));
                },
              ),
              FlatButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void deleteRefillProduct(int refillID, int index) {
    print("We are In now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass
        .deleteRefillProduct(refillID)
        .then((value) => deleteOutput(value, index));
    //serviceClass.viewRefillCycle().then((value) => output2(value));
  }

  void fetchRefillProducts() {
    print("We are In now...");
    ServiceClass serviceClass = new ServiceClass();
    //serviceClass.viewRefillProducts().then((value) => output(value));
    serviceClass.viewRefillCycle().then((value) => output2(value));
  }

  // void output(String body) {
  //   print("We are In faq now...");
  //   print(body);
  //   setState(() {
  //     loading = false;
  //   });
  //   if (body.contains("Network Error")) {
  //     _showMessage("Network Error");
  //   } else {
  //     var bodyT = jsonDecode(body);
  //     if (bodyT["status"] == "Successful") {
  //       var data = json.decode(body);
  //       dynamic data2 = data;
  //       print("In now .........");
  //       print(data2);
  //       dynamic value = data["data"]["value"];
  //       list.clear();
  //       list = value
  //           .map<RefillProduct>((element) => RefillProduct.fromJson(element))
  //           .toList();
  //       setState(() {
  //         loading = false;
  //       });
  //     } else {
  //       _showMessage(bodyT["message"]);
  //     }
  //   }
  // }
  void output2(String body) {
    print("We are In faq now...");
    print(body);
    setState(() {
      loading = false;
    });
    if (body.contains("Network Error")) {
      _showMessage("Network Error");
    } else {
      var bodyT = jsonDecode(body);
      if (bodyT["status"] == "Successful") {
        var data = json.decode(body);
        dynamic data2 = data;
        print("In now .........");
        print(data2);
        dynamic value = data["data"];
        list2.clear();
        list2 = value
            .map<RefillCycle>((element) => RefillCycle.fromJson(element))
            .toList();
        // setState(() {
        //   loading = false;
        // });
      } else {
        _showMessage(bodyT["message"]);
      }
    }
  }

  void deleteOutput(String body, int index) {
    print("We are In delete now...");
    print(body);
    setState(() {
      list[index].isLoading = false;
    });
    if (body.contains("Network Error")) {
      _showMessage("Network Error");
    } else {
      var bodyT = jsonDecode(body);
      if (bodyT["status"] == "Successful") {
        var data = json.decode(body);
        dynamic data2 = data;
        print("Response is 200 now ..... we are cool");
        setState(() {
          loading = false;
        });
      } else {
        _showMessage(bodyT["message"]);
      }
    }
  }

  void addRefill(productId, cycleId, remindMeBySMS, remindMeByEmail,
      remindMeByInAPP, dater) {
    print("We are In AddRefill now...");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass
        .addRefillMedicine(productId, dater, cycleId, 2, remindMeBySMS,
            remindMeByEmail, remindMeByInAPP, "2021-10-17T19:31:39.505Z")
        .then((value) => addRefillOutput(value));
  }

  void addRefillOutput(String body) {
    print("Whats is wrong bruv");
    print(body);
    if (body.contains("Network Error")) {
      _showMessage("Network Error");
    } else {
      var bodyT = jsonDecode(body);
      if (bodyT["status"] == "Successful") {
        _showMessage(bodyT["message"]);
        setState(() {
          loading = false;
        });

        Provider.of<ServiceClass>(context, listen: false).makeRefillNull();
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Refillorders()));
      } else {
        _showMessage(bodyT["message"]);
      }
    }
  }
}
