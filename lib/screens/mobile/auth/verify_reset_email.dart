import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mymedicinemobile/constants.dart';
import 'package:mymedicinemobile/models/models.dart';
import 'package:mymedicinemobile/screens/mobile/auth/login.dart';
import 'package:mymedicinemobile/screens/mobile/auth/password_reset.dart';
import 'package:mymedicinemobile/services/services.dart';
import 'package:mymedicinemobile/text_style.dart';

class ResetEmailVerify extends StatefulWidget {
   String email;
   int OTPID,ChannelID;
   ResetEmailVerify(this.email,this.OTPID,this.ChannelID);
  _ResetEmailVerify createState() => _ResetEmailVerify();
}

class _ResetEmailVerify extends State<ResetEmailVerify> with SingleTickerProviderStateMixin{
  TextEditingController emailC = new TextEditingController();
  bool value = false;
  bool passwordVisible = false;
  bool passwordObscure = true;
  Color swapColor = kPrimaryColor.withOpacity(.5);

  bool loading = false;
  bool errorOcurred = false;
  bool dataLoaded = false;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  late AnimationController _animationController;
  String resendMessage = "";

  List<Checker> otpList = [
    new Checker(current: true, text: ""),
    new Checker(current: false, text: ""),
    new Checker(current: false, text: ""),
    new Checker(current: false, text: ""),
    new Checker(current: false, text: ""),
    new Checker(current: false, text: ""),
  ];


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


  int currentIndex = 0;

  List<Object> list = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    ".",
    "0",
    Icon(Icons.arrow_back),
  ];
  int OTPID = 0;


  @override
  void initState() {
    // TODO: implement initState
    // TODO: implement initState
    _animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 2),
    );
    _animationController.repeat();
    super.initState();

    OTPID = widget.OTPID;
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //FocusScope.of(context).unfocus();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: height,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child:
                  Column(
                    children: [

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: SvgPicture.asset(
                                  "assets/svg/backward_arrow.svg",
                                  color: kColorSmoke2,
                                  width: 17,
                                  height: 17,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "OTP Verification",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: kColorBlack),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Please enter the 6 digit code sent \nto your email address",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: kColorBlack.withOpacity(.6)),
                            textAlign: TextAlign.center,
                          ),

                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     _textFieldOTP(first: true, last: false),
                      //     _textFieldOTP(first: true, last: false),
                      //     _textFieldOTP(first: true, last: false),
                      //     _textFieldOTP(first: false, last: false),
                      //     _textFieldOTP(first: false, last: false),
                      //     _textFieldOTP(first: false, last: true),
                      //   ],
                      // ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _textFieldOTP2(otpList[0]),
                          _textFieldOTP2(otpList[1]),
                          _textFieldOTP2(otpList[2]),
                          _textFieldOTP2(otpList[3]),
                          _textFieldOTP2(otpList[4]),
                          _textFieldOTP2(otpList[5]),
                        ],
                      ),

                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            resendMessage,
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: kColorBlack.withOpacity(.9)),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "If you didn't receive code",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: kColorBlack.withOpacity(.6)),
                          ),
                          SizedBox(width: 5,),
                          InkWell(
                            onTap: ()=> resendOTP(),
                            child: Text(
                              "Resend",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: kPrimaryColor),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        height: height * .4,
                        width: width,
                        child: GridView.builder(
                            itemCount: list.length,
                            physics: NeverScrollableScrollPhysics(), // to disable GridView's scrolling
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 70,
                              mainAxisSpacing: 0,
                              //childAspectRatio: (2 / 1),
                            ),
                            itemBuilder: (context, i) {
                              return categoryCustom(list[i]);
                            }),
                      ),

                      // GridView.count(
                      //   crossAxisCount: 3,
                      //   physics: NeverScrollableScrollPhysics(), // to disable GridView's scrolling
                      //   shrinkWrap: true, // You won't see infinite size error
                      //   children: <Widget>[
                      //     Container(
                      //       height: 24,
                      //       color: Colors.green,
                      //     ),
                      //     Container(
                      //       height: 24,
                      //       color: Colors.blue,
                      //     ),
                      //   ],
                      // ),


                      InkWell(
                        onTap: (){
                          if(getOTP(otpList) == "Wrong" || getOTP(otpList) == ""){
                            _showMessage("Invalid OTP");
                          }else{
                            setState(() {
                              loading = true;
                            });
                            validateOTP();
                          }
                        },
                        child: Container(
                          width: width,
                          height: 40,
                          color: swapColor,
                          child: Center(
                            child: Text(
                              "CONTINUE",
                              style: kmediumTextBold(kColorWhite),
                              textAlign: TextAlign.center,
                            ),
                          ),
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
    );
  }

  Widget categoryCustom(Object object) {
     if (object.runtimeType == String) {
      return Center(
        child: InkWell(
          onTap: (){
            setState(() {
              print(currentIndex);
              otpList[currentIndex].text = object.toString();
              if(currentIndex != 5){
                currentIndex = currentIndex + 1;
                swapColor = kPrimaryColor.withOpacity(.5);
              }
              else if(currentIndex == 5 && getOTP(otpList) != "Wrong"){
                swapColor = kPrimaryColor;
              }
            });
          },
          child: Container(
            width: 20,
            child: Text(object.toString(),style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 21,
                fontWeight: FontWeight.w500,
                color: kColorBlack.withOpacity(.7)),),
          ),
        ),
      );
    } else {
      return Center(
        child: InkWell(onTap: (){
          setState(() {
            otpList[currentIndex].text = "";
            if(currentIndex != 0){
              currentIndex = currentIndex - 1;
              swapColor = kPrimaryColor.withOpacity(.5);
            }
          });
        },child: Icon(Icons.arrow_back)),
      );
    }
  }

  Widget _textFieldOTP({required bool first, last}) {
    return Container(
      height: 65,
      width: 50,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
          autofocus: true,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.length == 0 && first == false) {
              FocusScope.of(context).previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.black12),
                borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.purple),
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }



  String getOTP(List<Checker> list){
    String text = "";
    for(int i=0;i<list.length;i++){
      if(list[i].text == ""){
        text = "Wrong";
      }else{
        text = text + list[i].text;
      }
    }
    return text;
  }


  Widget _textFieldOTP2(Checker checker) {
    return InkWell(
      onTap: (){
        setState(() {
          currentIndex = otpList.indexOf(checker);
        });
      },
      child: Container(
        height: 65,
        width: 50,
        decoration: BoxDecoration(
          color: kPrimaryColor,
            borderRadius: BorderRadius.circular(10),
        ),
        child: AspectRatio(
          aspectRatio: 1.0,
          child: Center(
            child: Text(checker.text,style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 21,
                fontWeight: FontWeight.w500,
                color: kColorWhite),),
          )
        ),
      ),
    );
  }


  void validateOTP() {
    print("We are In now...");
    print(getOTP(otpList));
    print(widget.OTPID);
    print(widget.ChannelID);
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.validateResetOTP(getOTP(otpList).trim(),OTPID).then((value) => output(value));
  }


  void output(String body) {
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
        print("Counter ....");
        print("List Course ....");
        setState(() {
          loading = false;
          errorOcurred = false;
          dataLoaded = true;
        });

        print(data);
        dynamic resetToken = data["data"]["result"];
        if(resetToken == null){
          _showMessage("Wrong OTP .... please check your mail.");
        }else{
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                  new PasswordReset(resetToken)));
        }


      } else {
        _showMessage(bodyT["message"]);
        setState(() {
          loading = false;
          errorOcurred = true;
        });
      }
    }
  }

  void resendOTP() {
    print("We are In now...");
    print(widget.OTPID);
    ServiceClass serviceClass = new ServiceClass();
    serviceClass.resendOTP(OTPID).then((value) => outputResend(value));
  }

  void outputResend(ResponseObject body) {
    print("We are In second haven now...");
    print(body);
    if (body.responseBody!.contains("Network Error")) {
      _showMessage("Please check your network connecton");
    } else {
      var bodyT = jsonDecode(body.responseBody!);
      if (body.responseCode == 200) {
        _showMessage(bodyT["responseMessage"]);
        var refId =  bodyT["data"]["referenceId"];
        setState(() {
          OTPID = refId;
          resendMessage = "OTP sent again to " + widget.email;
        });
      } else {
        _showMessage(bodyT["responseMessage"]);
      }
    }
  }

}

class Checker{
  String text;
  bool current;
  Checker({required this.current,required this.text});
}
