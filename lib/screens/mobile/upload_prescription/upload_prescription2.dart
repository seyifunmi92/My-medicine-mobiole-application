import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mymedicinemobile/constants.dart';
import 'package:mymedicinemobile/models/models.dart';
import 'package:mymedicinemobile/reusables/bars.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class UploadPrescription2 extends StatefulWidget {
  _UploadPrescription2 createState() => new _UploadPrescription2();
}

class _UploadPrescription2 extends State<UploadPrescription2> {
  bool value = false;
  bool showList = false;
  TextEditingController searchC = new TextEditingController();
  List<File> imgList = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

  pickMultipleFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf', 'doc'],
    );
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      if (files != null) {
        print("***** picked now");
        for (var file in files) {
          imgList.add(file);
          print(file.path);
        }
        setState(() {
          imgList;
          showList = true;
        });
      }
    } else {
      // User canceled the picker
    }
  }

  snapPrescription() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      print("hello");
      print(photo.path);
      setState(() {
        imgList.add(new File(photo.path));
        showList = true;
      });
    }
  }

  // _displayDialog(BuildContext context) async {
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text('Refill Medicine!'),
  //           content: Text("Are you sure you want to schedule medicine refill order?"),
  //           actions: <Widget>[
  //             new FlatButton(
  //               child: new Text('Yes'),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //                 Navigator.push(context,MaterialPageRoute(builder: (context) => Refillorders()));
  //               },
  //             ),
  //             new FlatButton(
  //               child: new Text('No'),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             )
  //           ],
  //         );
  //       });
  // }

  Widget customMedias(File file) => Container(
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  file,
                  width: 100,
                  height: 100,
                )),
            Positioned(
                bottom: 10,
                left: 20,
                right: 20,
                child: Container(
                  decoration: BoxDecoration(
                      color: kColorWhite,
                      borderRadius: BorderRadius.circular(180)),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        print(imgList.length);
                        if (imgList.length == 1) {
                          imgList.remove(file);
                          showList = false;
                        } else {
                          imgList.remove(file);
                        }
                      });
                    },
                    child: Icon(
                      Icons.clear,
                      color: kPrimaryColor,
                    ),
                  ),
                ))
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                  navBarFAQ("Upload Prescription", context),
                  SizedBox(
                    height: 1,
                  ),
                  Container(
                    height: height * .84,
                    child: ListView(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: SvgPicture.asset(
                                "assets/svg/upload_icon.svg",
                                width: 20,
                                height: 20,
                              ),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              "Upload Prescription",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w400,
                                  color: kColorBlack.withOpacity(.6),
                                  fontSize: 12,
                                  decoration: TextDecoration.underline),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 25, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: kColorWhite,
                            boxShadow: [
                              BoxShadow(
                                color: kColorSmoke.withOpacity(.4),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      snapPrescription();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color(0xFFEBEFF5),
                                          borderRadius:
                                              BorderRadius.circular(160)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18, vertical: 24),
                                        child: SvgPicture.asset(
                                          "assets/svg/camera_snap.svg",
                                          width: 20,
                                          height: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Camera",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                      color: kColorBlack,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      pickMultipleFiles();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color(0xFFEBEFF5),
                                          borderRadius:
                                              BorderRadius.circular(160)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18, vertical: 24),
                                        child: SvgPicture.asset(
                                          "assets/svg/gallery.svg",
                                          width: 20,
                                          height: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "From gallery",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                      color: kColorBlack,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Color(0xFFEBEFF5),
                                        borderRadius:
                                            BorderRadius.circular(160)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 24),
                                      child: SvgPicture.asset(
                                        "assets/svg/report.svg",
                                        width: 20,
                                        height: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Past Report",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                      color: kColorBlack,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        showList
                            ? Container(
                                height: 200,
                                child: GridView(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisSpacing: 2,
                                            mainAxisSpacing: 4,
                                            crossAxisCount: 5),
                                    children: imgList
                                        .map((e) => customMedias(e))
                                        .toList()),
                              )
                            : Text(""),
                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Text(
                            "Attach up to 15 files at a time, Total file size may not \nexceed 25 MB. The document types can be \npdf, gif, jpg and png only.",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                              color: kColorBlack.withOpacity(.8),
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Prescription Guide",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: kColorBlack,
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "* Upload clear prescription images",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w400,
                                  color: kColorBlack.withOpacity(.5),
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                "* Check below for mentioned points that should   be a part of a valid prescription",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w400,
                                  color: kColorBlack.withOpacity(.5),
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Image.asset(
                              "assets/images/prescription.png",
                            )),
                        SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Positioned(
                bottom: 5,
                left: 10,
                right: 10,
                child: InkWell(
                  onTap: () {
                    if (imgList.isEmpty) {
                      showNullDialog(context);
                    } else {
                      showAlertDialog(context);
                      _uploadInfo(imgList);
                    }
                    // Navigator.pop(context);
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => Checkout(widget.salesOrderId,widget.uniqueSalesOrderId,widget.items,widget.total)));
                  },
                  child: Container(
                    color: kColorWhite,
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: kPrimaryColor),
                      child: Center(
                        child: Text(
                          "CONTINUE",
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text("Loading ..."),
      content: Container(
          padding: EdgeInsets.all(5),
          width: 150,
          height: 150,
          child: Center(child: CircularProgressIndicator())),
      actions: [],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showNullDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: Text("OK",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontFamily: "Poppins",
            fontSize: 14,
            color: Colors.black,
          )),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Upload a prescription",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontFamily: "Poppins",
            fontSize: 14,
            color: Colors.black,
          )),
      content: Text("Please, upload your prescription to continue",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontFamily: "Poppins",
            fontSize: 12,
            color: Colors.black.withOpacity(.8),
          )),
      actions: [
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
  }

  void _uploadInfo(List<File> _files) async {
    print("Entered my man");

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");

    String BaseUrl = "https://advantagerx.africa/";

    print("Length ---- ${_files.length}");
    try {
      FormData formData = new FormData.fromMap({
        "salesOrderId": "",
        "prescriptionId": "",
        "files": [
          await MultipartFile.fromFile(_files[0].path,
              filename: path.basename(_files[0].path)),
          if (_files.length == 2)
            {
              await MultipartFile.fromFile(_files[1].path,
                  filename: path.basename(_files[1].path)),
            }
          else if (_files.length == 3)
            {
              await MultipartFile.fromFile(_files[2].path,
                  filename: path.basename(_files[2].path)),
            }
          else if (_files.length == 4)
            {
              await MultipartFile.fromFile(_files[3].path,
                  filename: path.basename(_files[3].path)),
            }
          else if (_files.length == 5)
            {
              await MultipartFile.fromFile(_files[4].path,
                  filename: path.basename(_files[4].path)),
            }
          else if (_files.length == 6)
            {
              await MultipartFile.fromFile(_files[5].path,
                  filename: path.basename(_files[5].path)),
            }
          else if (_files.length == 7)
            {
              await MultipartFile.fromFile(_files[6].path,
                  filename: path.basename(_files[6].path)),
            }
        ]
      });

      Dio dio2 = new Dio();

      dio2.options.headers['content-Type'] = 'application/json';
      dio2.options.headers["Authorization"] = "Bearer $token";

      var response = await dio2.post(
          BaseUrl + "apigw/mymedicine/order/prescription",
          data: formData);
      //Hello people of the world, this is the show you have all been waiting for and it is here. The AProko comedy night out is the best dance of you will ever see, it will be breath taking and you will laugh your as to the core. We will be very grateful if you can donate to our cause this new year.
      print(response.toString());
      if (response.statusCode == 200) {
        print("Pres update ........... for long");
        print(response.toString());
        var data = jsonDecode(response.toString());
        print(data);
        _showMessage(data["message"], new Duration(seconds: 6));
        Navigator.pop(context);
        imgList.clear();
        setState(() {});
        // Navigator.push(context, MaterialPageRoute(builder: (context) => SUCCESS()));

      } else {
        //print(response.toString());
        Navigator.pop(context);
        var data = jsonDecode(response.toString());
        _showMessage(data["message"], new Duration(seconds: 6));
        print("This is the code of conduct");
        print("Code --- ${response.statusCode}");
      }
    } catch (e) {
      Navigator.pop(context);
      print("other errors occured now ........... cool");
      _showMessage("Network error encountered", new Duration(seconds: 6));
      print(e);
      // setState(() {
      //   isLoading = false;
      // });
    }
  }
}
