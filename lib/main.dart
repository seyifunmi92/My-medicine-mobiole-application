import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mymedicinemobile/screen_decider.dart';
import 'package:mymedicinemobile/screens/mobile/cart/cart.dart';
import 'package:mymedicinemobile/screens/mobile/faqs/faqs.dart';
import 'package:mymedicinemobile/screens/mobile/home_page/homepager.dart';
import 'package:mymedicinemobile/screens/mobile/splash_screens/splash_screen_one.dart';
import 'package:mymedicinemobile/screens/mobile/termsandc/termsandc.dart';
import 'package:mymedicinemobile/services/services.dart';
import 'package:mymedicinemobile/theme.dart';
import 'package:provider/provider.dart';
// ignore: unused_import
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

// FirebaseOptions get firebaseOptions async => const FirebaseOptions(
//      appId: '1:515849272550:android:36a0a684a20ae2dc5ccf27',
//       apiKey:
//           'AAAAeBsDPOY:APA91bHuxzMtV2y38HZ5-yT5fRQ1-O_hCgG8lh39UfSBy5exQ_zXWo0276Cgw7K1_qK4PvbF6Lk_TUuC_pnF6BwzsTZmlt0yjtBRywGnGITVwVDZKjT1vNPnqV4G-sCMoyKEWmHHl-2L',
//       projectId: 'mymedicine-3de15',
//       messagingSenderId: '515849272550',
//
//
//  );

FirebaseOptions get firebaseOptions => const FirebaseOptions(
      appId: '1:515849272550:android:36a0a684a20ae2dc5ccf27',
      apiKey:
          'AAAAeBsDPOY:APA91bHuxzMtV2y38HZ5-yT5fRQ1-O_hCgG8lh39UfSBy5exQ_zXWo0276Cgw7K1_qK4PvbF6Lk_TUuC_pnF6BwzsTZmlt0yjtBRywGnGITVwVDZKjT1vNPnqV4G-sCMoyKEWmHHl-2L',
      projectId: 'mymedicine-3de15',
      messagingSenderId: '515849272550',
    );

String get name => 'Mymedicine';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(
    create: (context) => ServiceClass(),
    child: const MyApp(),
  ));
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightThemeData(context),
      //darkTheme: darkThemeData(context),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }
  @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ScreenDecider(),
//     );
//   }
// }
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ScreenDecider(),
    );
  }
}
// Future<void> main async{
//    await Firebase.initializeApp();
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     theme: ThemeData(),
//     home: Aha(),

//     routes: {
//       '/': (context) {Route(),}
//       '/se': (context){Second(),}
//     },
// ));}
// class Aha extends StatefulWidget {
//   bool isOkay = true;
//   bool isConnected = false;
//   bool isGood = true;
//   String seyi = "";
//   String passwordError = "";
//   bool remeberMe = true;
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   final TextEditingController textC = TextEditingController();
//   final TextEditingController passC = TextEditingController();
//   late AnimationController _animationController;
//   String passwordErrorTest = "";
//   String passText = "Show";
//   GlobalKey _emailget = GlobalKey<State<StatefulWidget>>();
//   void checkUser()async{
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
// if(sharedPreferences.getString("_emailget") != null){
//   textC.text = SharedPreferences.getInstance("_emailget")!;
//   passC.text = SharedPreferences.getInstance('_emailget')!;
//   setState((){
//     isOkay = false;
//     isConnected = true;
//     isGood = false;
//     remeberMe = true;
//   });
// }
//   }
//   final bool _obscureText = true;
//   void _obscure(){
//     setState((){
//       _obscure = ! _obscure;
//     });
//   }
//   @override
//   _State createState() => _State(
//   );
// }
// class _State extends State<> {
//   @override
//   void initState() {
//     _animationController = AnimationController(
//       vsync: 
//     );
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ,  
      
//     );
//   }
// }

