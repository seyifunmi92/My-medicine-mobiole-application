import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:freshchat_sdk/freshchat_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseOptions get firebaseOptions => const FirebaseOptions(
  appId: '1:515849272550:android:36a0a684a20ae2dc5ccf27',
  apiKey: 'AAAAeBsDPOY:APA91bHuxzMtV2y38HZ5-yT5fRQ1-O_hCgG8lh39UfSBy5exQ_zXWo0276Cgw7K1_qK4PvbF6Lk_TUuC_pnF6BwzsTZmlt0yjtBRywGnGITVwVDZKjT1vNPnqV4G-sCMoyKEWmHHl-2L',
  projectId: 'mymedicine-3de15',
  messagingSenderId: '515849272550',
);

String get name => 'Mymedicine';


class ChatApp extends StatefulWidget {

  void startUpServer() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  @override
  createState(){
    //startUpServer();
    return _ChatApp();
  }

}


void handleFreshchatNotification(Map<String, dynamic> message) async {
  if (await Freshchat.isFreshchatNotification(message)) {
    print("is Freshchat notification");
    Freshchat.handlePushNotification(message);
  }
}

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  print("Inside background handler");
  await Firebase.initializeApp();
  handleFreshchatNotification(message.data);
}



class _ChatApp extends State<ChatApp> {

  int _counter = 0;
  final GlobalKey<ScaffoldState>? _scaffoldKey = new GlobalKey<ScaffoldState>();

  void registerFcmToken() async{
    if(Platform.isAndroid) {
      await Firebase.initializeApp(name: name, options: firebaseOptions);
      String? token = await FirebaseMessaging.instance.getToken();
      print("FCM Token is generated $token");
      Freshchat.setPushRegistrationToken(token!);
    }
  }

  void restoreUser(BuildContext context) {
    var externalId, restoreId, obtainedRestoreId;
    var alert = AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: Text(
        "Identify/Restore User",
        textDirection: TextDirection.ltr,
        style: TextStyle(fontFamily: 'OpenSans-Regular'),
      ),
      content: Form(
        child: Column(
          children: [
            TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "External ID",
                ),
                onChanged: (val) {
                  setState(() {
                    externalId = val;
                  });
                }),
            TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Restore ID",
                ),
                onChanged: (val) {
                  setState(() {
                    restoreId = val;
                  });
                }),
          ],
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            MaterialButton(
              elevation: 10.0,
              child: Text(
                "Identify/Restore",
                textDirection: TextDirection.ltr,
              ),
              onPressed: () {
                setState(
                      () {
                    Freshchat.identifyUser(
                        externalId: externalId, restoreId: restoreId);
                    Navigator.of(context, rootNavigator: true).pop(context);
                  },
                );
              },
            ),
            MaterialButton(
              elevation: 10.0,
              child: Text(
                "Cancel",
                textDirection: TextDirection.ltr,
              ),
              onPressed: () {
                setState(() {
                  Navigator.of(context, rootNavigator: true).pop(context);
                });
              },
            ),
          ],
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (context) {
          return alert;
        });
  }

  void notifyRestoreId(var event) async{
    FreshchatUser user = await Freshchat.getUser;
    String? restoreId = user.getRestoreId();
    Clipboard.setData(new ClipboardData(text: restoreId));
    _scaffoldKey!.currentState!.showSnackBar(new SnackBar(content: new Text("Restore ID copied: $restoreId")));
  }

  void getUserProps(BuildContext context) {
    final _userInfoKey = new GlobalKey<FormState>();
    String? key,value;
    var alert = AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: Text(
        "Custom User Properties:",
        textDirection: TextDirection.ltr,
        style: TextStyle(fontFamily: 'OpenSans-Regular'),
      ),
      content: Form(
        key: _userInfoKey,
        child: Column(
          children: [
            TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Key",
                ),
                onChanged: (val) {
                  setState(() {
                    key = val;
                  });
                }),
            TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Value",
                ),
                onChanged: (val) {
                  setState(() {
                    value = val;
                  });
                }),
          ],
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            MaterialButton(
              elevation: 10.0,
              child: Text(
                "Add Properties",
                textDirection: TextDirection.ltr,
              ),
              onPressed: () {
                setState(() {
                  Map map = {key: value};
                  Freshchat.setUserProperties(map);
                });
              },
            ),
            MaterialButton(
              elevation: 10.0,
              child: Text(
                "Cancel",
                textDirection: TextDirection.ltr,
              ),
              onPressed: () {
                setState(() {
                  Navigator.of(context, rootNavigator: true).pop(context);
                });
              },
            ),
          ],
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (context) {
          return alert;
        });
  }

  void sendMessageApi(BuildContext context) {
    final _userInfoKey = new GlobalKey<FormState>();
    String? conversationTag,message;
    var alert = AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: Text(
        "Send Message API",
        textDirection: TextDirection.ltr,
        style: TextStyle(fontFamily: 'OpenSans-Regular'),
      ),
      content: Form(
        key: _userInfoKey,
        child: Column(
          children: [
            TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Conversation Tag",
                ),
                onChanged: (val) {
                  setState(() {
                    conversationTag = val;
                  });
                }),
            TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Message",
                ),
                onChanged: (val) {
                  setState(() {
                    message = val;
                  });
                }),
          ],
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            MaterialButton(
              elevation: 10.0,
              child: Text(
                "Send Message",
                textDirection: TextDirection.ltr,
              ),
              onPressed: () {
                setState(
                      () {
                    Freshchat.sendMessage(conversationTag!, message!);
                    Navigator.of(context, rootNavigator: true).pop(context);
                  },
                );
              },
            ),
            MaterialButton(
              elevation: 10.0,
              child: Text(
                "Cancel",
                textDirection: TextDirection.ltr,
              ),
              onPressed: () {
                setState(() {
                  Navigator.of(context, rootNavigator: true).pop(context);
                });
              },
            ),
          ],
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (context) {
          return alert;
        });
  }


  void startUpServer() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(name: name, options: firebaseOptions);
  }

  @override
  void initState() {
    // TODO: implement initState

    //startUpServer();

    // Firebase.initializeApp(name: name, options: firebaseOptions).whenComplete(() {
    //   print("Firebase app completed");
    //   setState(() {});
    // });

    // Freshchat.init("c794c32c-89e7-4015-9279-7c191c8ba0d6",
    //     "030354ff-d499-4c4d-b29b-5c06f5776937", "msdk.eu.freshchat.com",stringsBundle: "FCCustomLocalizable",themeName: "CustomTheme.plist");

    /**
     * This is the Firebase push notification server key for this sample app.
     * Please save this in your Freshchat account to test push notifications in Sample app.
     *
     * Server key: Please refer support documentation for the server key of this sample app.
     *
     * Note: This is the push notification server key for sample app. You need to use your own server key for testing in your application
     */
    var restoreStream = Freshchat.onRestoreIdGenerated;
    var restoreStreamSubsctiption = restoreStream.listen((event) {
      print("Restore ID Generated: $event");
      notifyRestoreId(event);
    });
    if (Platform.isAndroid) {
      registerFcmToken();
      FirebaseMessaging.instance.onTokenRefresh.listen(
          Freshchat.setPushRegistrationToken);
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        var data = message.data;
        handleFreshchatNotification(data);
        print("Notification Content: $data");
      });
      FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    }


    Navigator.pop(context);
    _incrementCounter();
    super.initState();
  }


  void setUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? Email = sharedPreferences.getString("Email");
    String? FirstName = sharedPreferences.getString("FirstName");
    String? LastName = sharedPreferences.getString("LastName");
    FreshchatUser user = await Freshchat.getUser;
    user.setEmail(Email!);
    user.setFirstName(FirstName!);
    user.setLastName(LastName!);

    print("Awarawa .......... ncnncc....");
    print(user.getEmail());
    print(user.getFirstName());
    print(user.getLastName());

  }


  void _incrementCounter() {
    setUser();
    setState(() {
      Freshchat.showConversations();
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('MyMedicine'),
        ),
        body: Builder(
          builder: (context) => GridView.count(
            crossAxisCount: 2,
            children: List.generate(6, (index) {
              switch (index) {
                case 0:
                  return GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(border: Border.all(width: 1)),
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 70, 0, 0),
                            child: Text(
                              "FAQs",
                              style: Theme.of(context).textTheme.headline5,
                              textAlign: TextAlign.center,
                            )),
                      ),
                      onTap: () {
                        Freshchat.showFAQ(
                            showContactUsOnFaqScreens: true,
                            showContactUsOnAppBar: true,
                            showFaqCategoriesAsGrid: true,
                            showContactUsOnFaqNotHelpful: true);
                      });
                  break;
                case 1:
                  return GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(border: Border.all(width: 1)),
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 70, 0, 0),
                            child: Text(
                              "Unread Count",
                              style: Theme.of(context).textTheme.headline5,
                              textAlign: TextAlign.center,
                            )),
                      ),
                      onTap: () async {
                        var unreadCountStatus =
                        await Freshchat.getUnreadCountAsync;
                        int count = unreadCountStatus['count'];
                        String status = unreadCountStatus['status'];
                        final snackBar = SnackBar(
                          content: Text(
                              "Unread Message Count: $count  Status: $status"),
                        );
                        Scaffold.of(context).showSnackBar(snackBar);
                      });
                  break;
                case 2:
                  return GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(border: Border.all(width: 1)),
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 70, 0, 0),
                            child: Text(
                              "Reset User",
                              style: Theme.of(context).textTheme.headline5,
                              textAlign: TextAlign.center,
                            )),
                      ),
                      onTap: () {
                        Freshchat.resetUser();
                      });
                  break;
                case 3:
                  return GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(border: Border.all(width: 1)),
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 70, 0, 0),
                            child: Text(
                              "Restore User",
                              style: Theme.of(context).textTheme.headline5,
                              textAlign: TextAlign.center,
                            )),
                      ),
                      onTap: () {
                        restoreUser(context);
                      });
                  break;
                case 4:
                  return GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(border: Border.all(width: 1)),
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 70, 0, 0),
                            child: Text(
                              "Set User Properties",
                              style: Theme.of(context).textTheme.headline5,
                              textAlign: TextAlign.center,
                            )),
                      ),
                      onTap: () {
                        getUserProps(context);
                      });
                  break;
                case 5:
                  return GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(border: Border.all(width: 1)),
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 70, 0, 0),
                            child: Text(
                              "Send Message",
                              style: Theme.of(context).textTheme.headline5,
                              textAlign: TextAlign.center,
                            )),
                      ),
                      onTap: () {
                        sendMessageApi(context);
                      });
                  break;
                default:
                  return Center(
                    child: Text(
                      'Item $index',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  );
                  break;
              }
            }),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Chat',
          child: Icon(Icons.chat),
        ),
      );
  }
}