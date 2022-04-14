// // ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, unnecessary_null_comparison
//
// import 'dart:io';
// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:flutterwave_standard/flutterwave.dart';
// import 'package:mymedicinemobile/constants.dart';
//
// import 'package:flutterwave_standard/core/flutterwave.dart';
// import 'package:flutterwave_standard/models/responses/charge_response.dart';
//
//
//
// class PaymentScreen extends StatefulWidget {
//   @override
//   _PaymentScreenState createState() => _PaymentScreenState();
// }
//
// class _PaymentScreenState extends State<PaymentScreen> {
//   TextEditingController emailC = TextEditingController();
//   TextEditingController amountC = TextEditingController();
//
//   late String _ref;
//
//   void setRef(){
//     Random rand = Random();
//     int number = rand.nextInt(2000);
//     if(Platform.isAndroid) {
//       setState(() {
//         _ref = "AndroidRef1789$number";
//       });
//     }else{
//       setState(() {
//         _ref = "IOSRef1789$number";
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     setRef();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kColorWhite,
//       appBar: AppBar(
//         backgroundColor: kColorWhite,
//         leading: IconButton(
//           onPressed: (){
//             Navigator.pop(context);
//           },
//           icon: Icon(Icons.arrow_back,color: kPrimaryColor,),
//         ),
//       ),
//       body: SafeArea(
//         child: Container(
//           child: Column(
//             children: [
//               TextField(
//                 controller: emailC,
//                 decoration: InputDecoration(
//                   hintText: "Enter your Email"
//                 ),
//               ),
//               SizedBox(height: 10,),
//               TextField(
//                 controller: amountC,
//                 decoration: InputDecoration(
//                     hintText: "Amount"
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//       bottomSheet: Padding(
//         padding:
//         const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//         child: ElevatedButton(
//           onPressed: () {
//             final email = emailC.text;
//             final amount = amountC.text;
//             if (email.isEmpty || amount.isEmpty) {
//               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Field is Empty")));
//             } else {
//               _makePayment(context, email.trim(), amount.trim());
//             }
//           },
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.credit_card),
//                 SizedBox(
//                   width: 30,
//                 ),
//                 Text('Make Payment')
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _makePayment(BuildContext context, String email, String amount) async{
//     final style = FlutterwaveStyle(
//         appBarText: "My Medicine Paymennt",
//         buttonColor: kPrimaryColor,
//         appBarIcon: Icon(Icons.message, color: Colors.white),
//         buttonTextStyle: TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.bold,
//           fontSize: 18,
//         ),
//         appBarColor: kPrimaryColor,
//         appBarTitleTextStyle: TextStyle(
//           color: Colors.white,
//           fontSize: 18
//         ),
//         dialogCancelTextStyle: TextStyle(
//           color: Colors.redAccent,
//           fontSize: 18,
//         ),
//         dialogContinueTextStyle: TextStyle(
//           color: Colors.blue,
//           fontSize: 18,
//         )
//     );
//     final Customer customer = Customer(
//         name: "String Boy",
//         phoneNumber: "1234566677777",
//         email: "string.boy@qa.team");
//
//     final Flutterwave flutterwave = Flutterwave(
//         context: context,
//         style: style,
//         publicKey: "FLWPUBK_TEST-8e57d669e5764214ca984ead1c4a98a0-X",
//         currency: "NGN",
//         txRef: _ref,
//         amount: "$amount",
//         customer: customer,
//         paymentOptions: "ussd, card, barter, payattitude",
//         customization: Customization(title: "Test Payment"), isTestMode: true,
//         //isDebug: false,
//     );
//
//
//
//     final ChargeResponse response = await flutterwave.charge();
//     if (response == null) {
//       print(response.toJson());
//       print("Transaction failed");
//       if(response.status == "success") {
//         print(response.success);
//         print("successful payment");
//
//       } else {
//         // Transaction not successful
//         print("Transaction not successful");
//       }
//     }
//
//   }
//
// }
