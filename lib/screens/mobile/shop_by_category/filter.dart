import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mymedicinemobile/constants.dart';
import 'package:mymedicinemobile/models/models.dart';
import 'package:mymedicinemobile/reusables/bars.dart';
import 'package:mymedicinemobile/screens/mobile/cart/cart.dart';
import 'package:mymedicinemobile/screens/mobile/shop_by_category/filterbyBrand.dart';
import 'package:mymedicinemobile/services/services.dart';
import 'package:mymedicinemobile/text_style.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class Filters extends StatefulWidget {
  _Filters createState() => _Filters();
}

class _Filters extends State<Filters> {
  bool value = false;
  bool productShow = false;
  TextEditingController searchC = TextEditingController();
  List<CartModel> trackList = [];
  List<SortBy> sortList = [
    SortBy(name: "Popular product", clicked: false),
    SortBy(name: "New product", clicked: false),
    SortBy(name: " Best rating", clicked: false),
    SortBy(name: "Price(Low to High)", clicked: false),
    SortBy(name: "Price(High to Low)", clicked: false),
  ];
  bool showSorting = false;
  String filter = "";
  stt.SpeechToText speech = stt.SpeechToText();
  String sorted = "Popular product";
  List<CatTiles> list = [
    CatTiles(
        name: "Prescription medicines",
        img: "assets/images/cat1.png",
        clicked: true),
    CatTiles(
        name: "Non-Prescription medicines",
        img: "assets/images/cat2.png",
        clicked: true),
    CatTiles(name: "Cosmetics", img: "assets/images/cat3.png", clicked: true),
  ];

  List<BrandNames> brandList = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  // List<SelectorCat> list3 = [
  //   new SelectorCat(name: "Emzor", clicked: false),
  //   new SelectorCat(name: "M&B", clicked: false),
  //   new SelectorCat(name: "Tylenol", clicked: false),
  //   new SelectorCat(name: "Tylenol", clicked: false),
  //   //new SelectorCat(name: "Cosmetics", clicked: false),
  // ];

  // List<CartModel> list2 = [
  //   new CartModel(
  //       name: "Alfonso",
  //       price: "10,500",
  //       quantity: 0,
  //       isChecked: false,
  //       image: "assets/images/product_search.png"),
  //   new CartModel(
  //       name: "Mushrooms Herb- Energy for men",
  //       price: "10,500",
  //       quantity: 0,
  //       isChecked: false,
  //       image: "assets/images/product_search.png"),
  //   new CartModel(
  //       name: "Alfonso X",
  //       price: "10,500",
  //       quantity: 0,
  //       isChecked: false,
  //       image: "assets/images/product_search.png"),
  //   new CartModel(
  //       name: "Paracetamol",
  //       price: "10,500",
  //       quantity: 0,
  //       isChecked: false,
  //       image: "assets/images/product_search.png"),
  //   new CartModel(
  //       name: "Prolactin",
  //       price: "4,500",
  //       quantity: 10,
  //       isChecked: false,
  //       image: "assets/images/product_search.png"),
  // ];

  @override
  void initState() {
    super.initState();
    filterBrandsSearch("");
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
                  Container(
                      height: height * .07,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Filter",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Poppins",
                                      fontSize: 16,
                                      color: kColorBlack.withOpacity(.5)),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    print("tapped");
                                    for (var pick in brandList) {
                                      pick.clicked = false;
                                    }
                                    setState(() {
                                      filter = "";
                                      Provider.of<ServiceClass>(context,
                                              listen: false)
                                          .filterBrand("Select");
                                    });
                                  },
                                  child: const Text(
                                    "Reset",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Poppins",
                                        fontSize: 13,
                                        color: kPrimaryColor),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),

                  // SizedBox(
                  //   height: 10,
                  // ),

                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    width: width,
                    height: height * .45,
                    child: ListView(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              showSorting = true;
                            });
                          },
                          child: Row(
                            children: const [
                              Text(
                                "Sort by",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Poppins",
                                    fontSize: 18,
                                    color: kColorBlack),
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                size: 45,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          sorted,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: "Poppins",
                              fontSize: 14,
                              color: kColorBlack.withOpacity(.7)),
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Brand",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: "Poppins",
                              fontSize: 17,
                              color: kColorBlack),
                        ),

                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: width,
                          height: 40,
                          padding: const EdgeInsets.only(left: 10, top: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: kColorWhite,
                            border: Border.all(
                                color: kColorSmoke2,
                                width: .6,
                                style: BorderStyle.solid),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FilterByBrand()));
                                  },
                                  child: InkWell(
                                    onTap: () {
                                      if (searchC.text.isNotEmpty) {
                                        filterBrandsSearch(searchC.text);
                                      } else {
                                        filterBrandsSearch(searchC.text);
                                      }
                                      setState(() {
                                        loading = true;
                                      });
                                    },
                                    child: loading
                                        ? Container(
                                            width: 10,
                                            height: 10,
                                            child: CircularProgressIndicator(
                                                color: kPrimaryColor))
                                        : SvgPicture.asset(
                                            "assets/svg/search_icon.svg",
                                            width: 20,
                                            height: 15,
                                            color: kColorSmoke,
                                          ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: TextField(
                                    onChanged: (text) {},
                                    controller: searchC,
                                    cursorColor: kPrimaryColor,
                                    style: ksmallTextBold(kColorBlack),
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                      hintText: "Search Brand",
                                      hintStyle: kmediumText(kColorSmoke2),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Container(
                        //   height: 60,
                        //   child: GridView.builder(
                        //       itemCount: list3.length,
                        //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //         crossAxisCount: 3,
                        //         // crossAxisSpacing: 2,
                        //         // mainAxisSpacing: 2,
                        //         //childAspectRatio: (2 / 1),
                        //       ),
                        //       itemBuilder: (context, i) {
                        //         return categoryTile(list3[i]);
                        //       }),
                        // ),

                        const SizedBox(
                          height: 20,
                        ),

                        Container(
                          height: 35,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              ...brandList.map((e) => categoryTile(e)),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 40,
                        ),

                        InkWell(
                          onTap: () {
                            if (filter.isEmpty) {
                              _showMessage(
                                  "Search and click on a brand to apply filter");
                            } else {
                              _showMessage("Filter is successfully applied.");
                              Provider.of<ServiceClass>(context, listen: false)
                                  .filterBrand(filter);
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                                color: kPrimaryColor,
                                border: Border.all(
                                    color: kPrimaryColor,
                                    width: .6,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                              child: Text(
                                "APPLY",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Poppins",
                                    fontSize: 17,
                                    color: kColorWhite),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            showSorting
                ? Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          showSorting = false;
                        });
                      },
                      child: Container(
                        width: width,
                        height: height,
                        color: const Color(0xFF000000).withOpacity(0.25),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 115,
                              left: 25,
                              child: Container(
                                width: 200,
                                decoration: BoxDecoration(
                                    color: kColorWhite,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    ...sortList.map((e) => customSort(e)),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
                : const Center(),
          ],
        ),
      ),
    );
  }

  Widget customSort(SortBy pick) {
    return InkWell(
      onTap: () {
        int currentIndex = sortList.indexOf(pick);
        for (var pick in sortList) {
          pick.clicked = false;
        }
        setState(() {
          sortList[currentIndex].clicked = !sortList[currentIndex].clicked;
          sorted = pick.name;
          showSorting = false;
        });
      },
      child: Container(
        //width: 100,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 1),
        margin: EdgeInsets.only(top: 15, left: 5, right: 5),
        decoration: BoxDecoration(
            color: kColorWhite, borderRadius: BorderRadius.circular(5)),
        child: Text(
          pick.name,
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w400,
            color: pick.clicked ? const Color(0xFFFFDAFA) : kColorBlack,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget categoryTile(BrandNames tiles) => Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
        decoration: BoxDecoration(
            color: tiles.clicked! ? kPrimaryColor : kColorWhite,
            border: Border.all(
                color: kPrimaryColor, width: .6, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(5)),
        child: InkWell(
          onTap: () {
            int i = brandList.indexOf(tiles);
            setState(() {
              for (var x in brandList) {
                x.clicked = false;
              }
              brandList[i].clicked = !brandList[i].clicked!;
              filter = tiles.name!;
              searchC.text = tiles.name!;
            });
          },
          child: Center(
            child: Text(
              tiles.name!,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: "Poppins",
                  fontSize: 14,
                  color: tiles.clicked! ? kColorWhite : kPrimaryColor),
            ),
          ),
        ),
      );

  Widget categoryCustom(CatTiles tiles) => Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        height: 200,
        width: 100,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: kColorSmoke.withOpacity(.4),
                spreadRadius: 1,
                blurRadius: 7,
                offset: const Offset(5, 3), // changes position of shadow
              ),
            ],
            color: const Color(0xFFECECEE),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(tiles.img),
            Text(
              tiles.name,
              style: const TextStyle(
                  fontSize: 11,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w400,
                  color: kColorBlack),
              textAlign: TextAlign.center,
            )
          ],
        ),
      );

  Widget cartCustom(CartModel cartModel) => Container(
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        //padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: kColorSmoke.withOpacity(.4),
            spreadRadius: 1,
            blurRadius: 7,
            offset: Offset(5, 3), // changes position of shadow
          ),
        ], color: kColorWhite, borderRadius: BorderRadius.circular(20)),
        child: Stack(
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
                Expanded(
                    child: Column(
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
                      "Energy for men",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: kColorSmoke2),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      " N " + cartModel.price,
                      style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: kColorBlack),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SvgPicture.asset(
                      "assets/svg/love_cart.svg",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Remove",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFAF1302),
                      ),
                    ),
                  ],
                ))
              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Center(
                child: SvgPicture.asset(
                  "assets/svg/cart_plus.svg",
                ),
              ),
            )
          ],
        ),
      );
  void filterBrandsSearch(String text) {
    print("We are In now...");
    ServiceClass serviceClass = ServiceClass();
    serviceClass.fliterBrandsSearch(text).then((value) => output(value));
  }

  void output(String body) {
    print("In filter by brands now ...");
    var bodyT = jsonDecode(body);
    print(bodyT);
    //_showMessage(bodyT["message"]);
    if (bodyT["message"] == "Successful") {
      var data = json.decode(body);
      dynamic data2 = data["data"]["value"];
      List<BrandNames> list = data2
          .map<BrandNames>((element) => BrandNames.fromJson(element))
          .toList();
      ;
      if (list.isNotEmpty) {
        setState(() {
          loading = false;
          brandList = list;
        });
      } else {
        _showMessage("No brand found ..");
        setState(() {
          loading = false;
        });
      }
    }
  }

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
}

class CatTiles {
  String name;
  String img;
  bool clicked;

  CatTiles({required this.name, required this.img, required this.clicked});
}

class SelectorCat {
  String name;
  bool clicked;

  SelectorCat({required this.name, required this.clicked});
}

class SortBy {
  String name;
  bool clicked;
  SortBy({required this.name, required this.clicked});
}

class BrandNames {
  String? name;
  bool? clicked = false;
  int? numOfProducts;

  BrandNames({required this.name, required this.numOfProducts});

  factory BrandNames.fromJson(Map<String, dynamic> json) {
    return BrandNames(
      name: json['brandName'],
      numOfProducts: json['numOfProducts'],
    );
  }
}
