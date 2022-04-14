import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:mymedicinemobile/constants.dart';
import 'package:mymedicinemobile/models/models.dart';
import 'package:mymedicinemobile/reusables/bars.dart';
import 'package:mymedicinemobile/screens/mobile/cart/cart.dart';
import 'package:mymedicinemobile/screens/mobile/orders/order_details.dart';
import 'package:mymedicinemobile/services/services.dart';
import 'package:mymedicinemobile/text_style.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:timeline_tile/timeline_tile.dart';

class MyOrders extends StatefulWidget {
  bool fromRefillPage;
  MyOrders(this.fromRefillPage, {Key? key}) : super(key: key);
  @override
  _MyOrders createState() => _MyOrders();
}
class _MyOrders extends State<MyOrders> with TickerProviderStateMixin {
  bool value = false;
  bool passwordShow = false;
  bool showNewCard = false;
  bool showNewAddress = false;
  late TabController _tabController;
  TextEditingController nameC = TextEditingController();
  int currentIndex = 0;
  List<OrderHistory> history = [];
  late List<OrderData> dataList;
  List<OrderData> closedList = [];
  bool loading = true;
  bool errorOcurred = false;
  bool dataLoaded = false;
  final _scaffoldKey =  GlobalKey<ScaffoldState>();
  late AnimationController _animationController;
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
  bool toggleStatus = true;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      print("Hello people of country...");
      setState(() {
        currentIndex = _tabController.index;
      });
      print(currentIndex);
    });
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animationController.repeat();
    viewOrderList();
    super.initState();
  }
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Provider.of<ServiceClass>(context, listen: false).increaseCart();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kColorWhite,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: width,
              height: height,
              child: Column(
                children: [
                  navBarCustomCartBeforePerson("Orders", context, Cart(), true),
                  const SizedBox(
                    height: 3,
                  ),
                  Container(
                    height: height * .86,
                    width: MediaQuery.of(context).size.width,
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: kColorWhite,
                    ),
                    child: Column(
                      children: [
                        Container(
                          constraints: const BoxConstraints.expand(height: 50),
                          child: TabBar(
                            indicatorColor: kPrimaryColor,
                            tabs: [
                              Tab(
                                child: Container(
                                  child: Text(
                                    "New/delivered orders",
                                    style: currentIndex == 0
                                        ? ksmallTextBold(kPrimaryColor)
                                        : ksmallTextBold(kColorBlack),
                                  ),
                                ),
                              ),
                              Tab(
                                child: Container(
                                  child: Text(
                                    "Closed orders",
                                    style: currentIndex == 1
                                        ? ksmallTextBold(kPrimaryColor)
                                        : ksmallTextBold(kColorBlack),
                                  ),
                                ),
                              )
                            ],
                            controller: _tabController,
                          ),
                        ),
                        Expanded(
                            child: Container(
                                height: height * .6,
                                width: width,
                                padding: const EdgeInsets.all(1),
                                child: TabBarView(
                                    controller: _tabController,
                                    children: [
                                      /* All Tabs  */

                                      dataLoaded
                                          ? ListView(
                                              children: [
                                                ExpansionPanelList(
                                                  children: [
                                                    ...dataList.map((e) =>
                                                        customExtension(
                                                            e, width)),
                                                  ],
                                                  dividerColor: Colors.white,
                                                  expansionCallback:
                                                      (i, isOpen) {
                                                    setState(() {
                                                      dataList[i].isChecked =
                                                          !dataList[i]
                                                              .isChecked;
                                                    });
                                                  },
                                                ),
                                              ],
                                            )
                                          : const Center(),
                                      dataLoaded
                                          ? ListView(
                                              children: [
                                                ExpansionPanelList(
                                                  children: [
                                                    ...closedList.map((e) =>
                                                        customExtension(
                                                            e, width)),
                                                  ],
                                                  dividerColor: Colors.white,
                                                  expansionCallback:
                                                      (i, isOpen) {
                                                    setState(() {
                                                      closedList[i].isChecked =
                                                          !closedList[i]
                                                              .isChecked;
                                                    });
                                                  },
                                                ),
                                              ],
                                            )
                                          : const Center(),
                                    ]))),
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
                    color: const Color(0xFF000000).withOpacity(0.3),
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
                                    angle: _animationController.value * 2 * pi,
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
    );
  }
  Widget customMedia(OrderModel cartModel) {
    return InkWell(
      onTap: () {
        //Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetails()));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 5),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: kColorSmoke.withOpacity(.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ], color: kColorWhite, borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 10,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Color(0xFFF0F2F5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.asset(
                    cartModel.image,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Mushrooms -",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: kColorBlack),
                        ),
                        Text(
                          "Herbs",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: kColorSmoke2),
                        ),
                      ],
                    ),
                    Text(
                      "Order ",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: kColorSmoke2),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      decoration: BoxDecoration(
                          color: const Color(0xFF8E8E93),
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                        child: Text(
                          cartModel.orderStatus,
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: kColorWhite),
                        ),
                      ),
                    ),
                    Text(
                      cartModel.orderStatus.contains("CLOSED")
                          ? ""
                          : "On 10/12/2021",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: kColorSmoke2),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
  ExpansionPanel customExtension(OrderData cartModel, double width) {
    String date = "", activity = "";
    String timer = "";
    print("Kringe ..........");
    var now = DateTime.now();
    print(DateFormat().format(now));

    //November 4, 2021 6:36:42 AM
    if (history.isNotEmpty) {
      activity = history[0].activity;
      print("Lag");
      print(history.length);
      String x = DateFormat().format(DateTime.parse(history[0].activityDate));
      print(x);
      print(x.split(", ")[1]);
      String f = x.split(", ")[0];
      String datex = f.split(" ")[1];
      String l = x.split(", ")[1];
      print(f.substring(0, 4));
      print(x.split(", ")[0].substring(0, 3) +
          " " +
          datex +
          "," +
          l.substring(0, 4));
      print(l.substring(4, l.length));
      date = x.split(", ")[0].substring(0, 3) +
          " " +
          datex +
          "," +
          l.substring(0, 4);
      timer = l.substring(4, l.length).trim();
    }
    return ExpansionPanel(
      //canTapOnHeader: true,
      //hasIcon: false,
      isExpanded: cartModel.isChecked,
      headerBuilder: (context, isOpen) {
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OrderDetails(cartModel)));
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: kColorSmoke.withOpacity(.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ], color: kColorWhite, borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F2F5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Image.asset(
                        "assets/images/order_img.jpeg",
                        fit: BoxFit.contain,
                        width: 100,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "${cartModel.uniqueOrderId}",
                              style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: kColorBlack),
                            ),
                            // Text(
                            //   "Herbs",
                            //   style: TextStyle(
                            //       fontFamily: "Poppins",
                            //       fontSize: 13,
                            //       fontWeight: FontWeight.w500,
                            //       color: kColorSmoke2),
                            // ),
                          ],
                        ),
                        Text(
                          "Order #" + cartModel.salesOrderId.toString(),
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: kColorSmoke2),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        cartModel.orderStatus!.contains("Delivered")
                            ? const Center()
                            : Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/svg/status_track.svg",
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      int index = dataList.indexOf(cartModel);
                                      setState(() {
                                        loading = true;
                                        //dataList[index].isChecked = !dataList[index].isChecked;
                                      });
                                      viewHistory(
                                          cartModel.salesOrderId!, index);
                                    },
                                    child: const Text(
                                      "Track order",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFFAF1302)),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  cartModel.isChecked
                                      ? InkWell(
                                          onTap: () {
                                            int index =
                                                dataList.indexOf(cartModel);
                                            setState(() {
                                              dataList[index].isChecked =
                                                  !dataList[index].isChecked;
                                            });
                                          },
                                          child: const Icon(
                                            Icons.keyboard_arrow_up,
                                            color: Color(0xFFAF1302),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            int index =
                                                dataList.indexOf(cartModel);
                                            setState(() {
                                              loading = true;
                                              //dataList[index].isChecked = !dataList[index].isChecked;
                                            });
                                            viewHistory(
                                                cartModel.salesOrderId!, index);
                                          },
                                          child: const Icon(
                                            Icons.keyboard_arrow_down,
                                            color: Color(0xFFAF1302),
                                          ),
                                        )
                                ],
                              ),
                        const SizedBox(
                          height: 2,
                        ),
                        cartModel.orderStatus!.contains("Pending") ||
                                cartModel.orderStatus!.contains("New")
                            ? Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/svg/cancel_1.svg",
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      // set up the button
                                      Widget okButton = TextButton(
                                        child: const Text("Yes"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          setState(() {
                                            loading = true;
                                          });
                                          cancelOrder(cartModel.salesOrderId!);
                                        },
                                      );

                                      // set up the button
                                      Widget exitButton = TextButton(
                                        child: Text("No"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      );

                                      // set up the AlertDialog
                                      AlertDialog alert = AlertDialog(
                                        title: const Text("Cancel Order!"),
                                        content: const Text("Are you sure"),
                                        actions: [
                                          exitButton,
                                          okButton,
                                        ],
                                      );

                                      // show the dialog
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return alert;
                                        },
                                      );
                                    },
                                    child: const Text(
                                      "Cancel order",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFFAF1302)),
                                    ),
                                  ),
                                ],
                              )
                            : const Center(),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                              color: cartModel.orderStatus!
                                      .contains("Ready for delivery")
                                  ? const Color(0xFF48A7F8)
                                  : cartModel.orderStatus!.contains("Delivered")
                                      ? const Color(0xFF16C68B)
                                      : const Color(0xFFFFB323),
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                            child: Text(
                              cartModel.orderStatus!,
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: cartModel.orderStatus!
                                              .contains("Delivered") ||
                                          cartModel.orderStatus!
                                              .contains("Ready for delivery")
                                      ? kColorWhite
                                      : kColorBlack),
                            ),
                          ),
                        ),
                        // cartModel.orderStatus!.contains("Delivered")
                        //     ?
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          "On " + cartModel.orderDate!.split("T")[0],
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: kColorSmoke2),
                        )
                        //: Center(),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
      body: Container(
        width: width,
        height: 180,
        padding: const EdgeInsets.only(top: 20),
        decoration: const BoxDecoration(
            color: Color(0xFFF0F2F5),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFF0F2F5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TimelineTile(
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.manual,
              afterLineStyle: const LineStyle(
                color: kPrimaryColor,
                thickness: 2,
              ),
              lineXY: 0.3,
              isFirst: true,
              indicatorStyle: IndicatorStyle(
                indicator: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(180),
                    border: Border.all(
                        color: kPrimaryColor,
                        width: 1,
                        style: BorderStyle.solid),
                  ),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(180),
                        color: kPrimaryColor
                        //border: Border.all(color: kPrimaryColor,width: 1,style: BorderStyle.solid),
                        ),
                  ),
                ),
              ),
              startChild: Container(
                width: width / 6,
                child: Column(
                  children: [
                    Text(
                      activity,
                      style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                    const Text(
                      "Order",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                  ],
                ),
              ),
              endChild: Container(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      timer,
                      style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                    Text(
                      date,
                      style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                  ],
                ),
              ),
            ),
            TimelineTile(
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.manual,
              afterLineStyle: LineStyle(
                  color: history.length > 1 ? kPrimaryColor : kColorSmoke,
                  thickness: 2),
              beforeLineStyle: LineStyle(
                  color: history.length > 1 ? kPrimaryColor : kColorSmoke,
                  thickness: 2),
              lineXY: 0.3,
              isLast: false,
              indicatorStyle: IndicatorStyle(
                indicator: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(180),
                    border: Border.all(
                        color: history.length > 1 ? kPrimaryColor : kColorSmoke,
                        width: 1,
                        style: BorderStyle.solid),
                  ),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(180),
                        color: history.length > 1 ? kPrimaryColor : kColorSmoke
                        //border: Border.all(color: kPrimaryColor,width: 1,style: BorderStyle.solid),
                        ),
                  ),
                ),
              ),
              startChild: Container(
                width: width / 6,
                child: Column(
                  children: [
                    Text(
                      history.length > 1 ? history[1].activity : "",
                      style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                    Text(
                      history.length > 1 ? "Order" : "",
                      style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                  ],
                ),
              ),
              endChild: Container(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      history.length > 1
                          ? timerCustom(history[1].activityDate).split(".")[1]
                          : "",
                      style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                    Text(
                      history.length > 1
                          ? timerCustom(history[1].activityDate).split(".")[0]
                          : "",
                      style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                  ],
                ),
              ),
            ),
            TimelineTile(
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.manual,
              afterLineStyle: LineStyle(
                  color: history.length > 2 ? kPrimaryColor : kColorSmoke,
                  thickness: 2),
              beforeLineStyle: LineStyle(
                  color: history.length > 2 ? kPrimaryColor : kColorSmoke,
                  thickness: 2),
              lineXY: 0.3,
              isLast: false,
              indicatorStyle: IndicatorStyle(
                indicator: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(180),
                    border: Border.all(
                        color: history.length > 2 ? kPrimaryColor : kColorSmoke,
                        width: 1,
                        style: BorderStyle.solid),
                  ),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(180),
                        color: history.length > 2 ? kPrimaryColor : kColorSmoke
                        //border: Border.all(color: kPrimaryColor,width: 1,style: BorderStyle.solid),
                        ),
                  ),
                ),
              ),
              startChild: Container(
                width: width / 6,
                child: Column(
                  children: [
                    Text(
                      history.length > 2 ? history[2].activity : "",
                      style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                    Text(
                      history.length > 2 ? "Order" : "",
                      style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                  ],
                ),
              ),
              endChild: Container(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      history.length > 2
                          ? timerCustom(history[2].activityDate).split(".")[1]
                          : "",
                      style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                    Text(
                      history.length > 2
                          ? timerCustom(history[2].activityDate).split(".")[0]
                          : "",
                      style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                  ],
                ),
              ),
            ),
            TimelineTile(
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.manual,
              afterLineStyle: LineStyle(
                  color: history.length > 3 ? kPrimaryColor : kColorSmoke,
                  thickness: 2),
              beforeLineStyle: LineStyle(
                  color: history.length > 3 ? kPrimaryColor : kColorSmoke,
                  thickness: 2),
              lineXY: 0.3,
              isLast: false,
              indicatorStyle: IndicatorStyle(
                indicator: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(180),
                    border: Border.all(
                        color: history.length > 3 ? kPrimaryColor : kColorSmoke,
                        width: 1,
                        style: BorderStyle.solid),
                  ),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(180),
                        color: history.length > 3 ? kPrimaryColor : kColorSmoke
                        //border: Border.all(color: kPrimaryColor,width: 1,style: BorderStyle.solid),
                        ),
                  ),
                ),
              ),
              startChild: Container(
                width: width / 6,
                child: Column(
                  children: [
                    Text(
                      history.length > 3 ? history[3].activity : "",
                      style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                    Text(
                      history.length > 3 ? "Order" : "",
                      style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                  ],
                ),
              ),
              endChild: Container(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      history.length > 3
                          ? timerCustom(history[3].activityDate).split(".")[1]
                          : "",
                      style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                    Text(
                      history.length > 3
                          ? timerCustom(history[3].activityDate).split(".")[0]
                          : "",
                      style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                  ],
                ),
              ),
            ),
            TimelineTile(
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.manual,
              afterLineStyle: LineStyle(
                  color: history.length > 4 ? kPrimaryColor : kColorSmoke,
                  thickness: 2),
              beforeLineStyle: LineStyle(
                  color: history.length > 4 ? kPrimaryColor : kColorSmoke,
                  thickness: 2),
              lineXY: 0.3,
              isLast: true,
              indicatorStyle: IndicatorStyle(
                indicator: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(180),
                    border: Border.all(
                        color: history.length > 4 ? kPrimaryColor : kColorSmoke,
                        width: 1,
                        style: BorderStyle.solid),
                  ),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(180),
                        color: history.length > 4 ? kPrimaryColor : kColorSmoke
                        //border: Border.all(color: kPrimaryColor,width: 1,style: BorderStyle.solid),
                        ),
                  ),
                ),
              ),
              startChild: Container(
                width: width / 6,
                child: Column(
                  children: [
                    Text(
                      history.length > 4 ? history[4].activity : "",
                      style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                    Text(
                      history.length > 4 ? "Order" : "",
                      style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                  ],
                ),
              ),
              endChild: Container(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      history.length > 4
                          ? timerCustom(history[4].activityDate).split(".")[1]
                          : "",
                      style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                    Text(
                      history.length > 4
                          ? timerCustom(history[4].activityDate).split(".")[0]
                          : "",
                      style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void viewOrderList() {
    print("We are In now...");
    ServiceClass serviceClass = ServiceClass();
    serviceClass.allOrderData().then((value) => outputX(value));
  }

  void outputX(String body) {
    print("We are In second haven now...");
    print(body);
    if (body.contains("Network Error")) {
      setState(() {
        loading = false;
        errorOcurred = true;
      });
    } else {
      var bodyT = jsonDecode(body);
      if (bodyT["status"] == "Successful") {
        var data = json.decode(body);
        dynamic data2 = data["data"];
        print("all in man .........");
        print(data2);

        List<OrderData> dataList2 = data2
            .map<OrderData>((element) => OrderData.fromJson(element))
            .toList();
        dataList = [];
        if (widget.fromRefillPage) {
          for (int i = 0; i < dataList2.length; i++) {
            if (dataList2[i].orderStatus!.trim() == "Payment Complete") {
              dataList.add(dataList2[i]);
            }
          }
        } else {
          //dataList = dataList2;
          for (int i = 0; i < dataList2.length; i++) {
            if (dataList2[i].orderStatus!.trim() == "Cancelled") {
              closedList.add(dataList2[i]);
            } else {
              dataList.add(dataList2[i]);
            }
          }
        }
        //print("OrderList");
        setState(() {
          loading = false;
          errorOcurred = false;
          dataLoaded = true;
        });
      } else {
        _showMessage(bodyT["message"]);
        setState(() {
          loading = false;
          errorOcurred = true;
        });
      }
    }
  }

  void viewHistory(int id, int index) {
    print("We are In now...");
    print("This the ID .... $id");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass
        .viewOrderHistory(id)
        .then((value) => historyOutput(value, index));
  }

  void historyOutput(String body, index) {
    print("We are In History now...");
    print(body);
    if (body.contains("Network Error")) {
      setState(() {
        loading = false;
      });
    } else {
      var bodyT = jsonDecode(body);
      if (bodyT["status"] == "Successful") {
        var data = json.decode(body);
        dynamic value = data["data"];
        setState(() {
          loading = false;
          dataList[index].isChecked = !dataList[index].isChecked;
          history =
              value.map<OrderHistory>((e) => OrderHistory.fromJson(e)).toList();
        });
        print("We are in history");
        print(history[0].activity);
        print(history[0].comments);
      } else {
        setState(() {
          loading = false;
        });
        _showMessage(bodyT["message"]);
      }
    }
  }

  String timerCustom(String dater) {
    print("Lag");
    String x = DateFormat().format(DateTime.parse(dater));
    print(x);
    String f = x.split(", ")[0];
    String datex = f.split(" ")[1];
    String l = x.split(", ")[1];
    String timer = x.split(", ")[0].substring(0, 3) +
        " " +
        datex +
        "," +
        l.substring(0, 4) +
        "." +
        l.substring(4, l.length).trim();
    return timer;
  }

  void cancelOrder(int orderId) {
    print("We are In aancel order now ...");
    print("This the ID .... $orderId");
    ServiceClass serviceClass = new ServiceClass();
    serviceClass
        .cancelOrder(orderId, "")
        .then((value) => cancelOrderOutput(value));
  }

  void cancelOrderOutput(String body) {
    print("We are In History now...");
    print(body);
    if (body.contains("Network Error")) {
      setState(() {
        loading = false;
      });
    } else {
      var bodyT = jsonDecode(body);
      if (bodyT["status"] == "Successful") {
        _showMessage(bodyT["message"]);
        viewOrderList();
      } else {
        setState(() {
          loading = false;
        });
        _showMessage(bodyT["message"]);
      }
    }
  }
}
