import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mymedicinemobile/models/models.dart';
import 'package:mymedicinemobile/services/services.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../text_style.dart';

class LocationState extends StatefulWidget {
  String category;
  int id;

  LocationState(this.category, this.id);

  _LocationState createState() => _LocationState();
}

class _LocationState extends State<LocationState>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  List<MedCountry> countrylist = [];
  List<MedSates> statelist = [];
  List<MedLGAS> LGalist = [];
  bool loading = true;
  bool dataLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    _animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 2),
    );
    _animationController.repeat();

    viewLocations();
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

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            dataLoaded
                ? widget.category == "Country"
                    ? ListView(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ...countrylist.map(
                              (e) => countryCustom(e.name, e.countryCode, e.id))
                        ],
                      )
                    : widget.category == "State"
                        ? ListView(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                      icon: Icon(
                                        Icons.close,
                                        color: Colors.black,
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      }),
                                  SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ...statelist.map((e) =>
                                  statesCustom(e.name!, e.id!))
                            ],
                          )
                        : ListView(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                      icon: Icon(
                                        Icons.close,
                                        color: Colors.black,
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      }),
                                  SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ...LGalist.map((e) =>
                                  lgaCustom(e.name, e.id))
                            ],
                          )
                : Center(),
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

  Widget countryCustom(String name, String code, int id) {
    return InkWell(
      onTap: () {
        Provider.of<ServiceClass>(context, listen: false)
            .notifyCountry(name, id);
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                //SvgPicture.asset(flag),
                SizedBox(
                  width: 15,
                ),
                Text(
                  name,
                  style: kmediumText(kColorBlack),
                ),
                SizedBox(
                  width: 5,
                ),
                Text("+($code)", style: kmediumText(kColorBlack)),
              ],
            ),
            Divider(
              color: kColorSmoke,
            )
          ],
        ),
      ),
    );
  }


  Widget statesCustom(String name, int id) {
    return InkWell(
      onTap: () {
        Provider.of<ServiceClass>(context, listen: false)
            .notifyStates(name, id);
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                //SvgPicture.asset(flag),
                SizedBox(
                  width: 15,
                ),
                Text(
                  name,
                  style: kmediumText(kColorBlack),
                ),
                SizedBox(
                  width: 5,
                ),
                //Text("+($code)", style: kmediumText(kColorBlack)),
              ],
            ),
            Divider(
              color: kColorSmoke,
            )
          ],
        ),
      ),
    );
  }

  Widget lgaCustom(String name, int id) {
    return InkWell(
      onTap: () {
        Provider.of<ServiceClass>(context, listen: false)
            .notifyLGAS(name, id);
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                //SvgPicture.asset(flag),
                SizedBox(
                  width: 15,
                ),
                Text(
                  name,
                  style: kmediumText(kColorBlack),
                ),
                SizedBox(
                  width: 5,
                ),
                //Text("+($code)", style: kmediumText(kColorBlack)),
              ],
            ),
            Divider(
              color: kColorSmoke,
            )
          ],
        ),
      ),
    );
  }

  void viewLocations() {
    print("We are In now...");
    ServiceClass serviceClass = new ServiceClass();
    if (widget.category.contains("Country")) {
      serviceClass.viewCountries().then((value) => output(value));
    } else if (widget.category.contains("State")) {
      serviceClass.viewStates(widget.id).then((value) => output(value));
    } else {
      serviceClass.viewLGAS(widget.id).then((value) => output(value));
    }
  }

  void output(String body) {
    print("We are In second haven now...");
    print(body);
    if (body.contains("Network Error")) {
      setState(() {
        loading = false;
        // errorOcurred = true;
      });
    } else {
      var bodyT = jsonDecode(body);
      if (bodyT["status"] == "Successful") {
        dynamic data2 = bodyT["data"];
        print("all man .........");
        print(data2);

        // ServerResponse serverResponse = ServerResponse.fromJson(data2);
        // AllData allData = AllData.fromJson(serverResponse.data);

        if (widget.category.contains("Country")) {
          countrylist = data2
              .map<MedCountry>((element) => MedCountry.fromJson(element))
              .toList();
        }
        else if (widget.category.contains("State")) {
          statelist = data2
              .map<MedSates>((element) => MedSates.fromJson(element))
              .toList();
        }else{
          LGalist = data2
              .map<MedLGAS>((element) => MedLGAS.fromJson(element))
              .toList();
        }

        setState(() {
          loading = false;
          dataLoaded = true;
        });
      } else {
        //_showMessage(bodyT["message"]);
        setState(() {
          loading = false;
        });
      }
    }
  }


}
