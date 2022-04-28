// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mymedicinemobile/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceClass extends ChangeNotifier {
  bool _loggedIn = false;
  //String BaseUrl = "http://51.104.186.105/";
  String BaseUrl = "https://advantagerx.africa/";
  int CurrentIndex = 0;
  String Country = "Select Country";
  String Filter = "Select";
  int CountryId = 0;
  String State = "Select State";
  int StateId = 0;
  String LGA = "Select LGA";
  int LGAID = 0;
  // ignore: avoid_init_to_null
  late RefillObj? refillObj = null;
  late MedUser MedUsers = MedUser(
      firstName: "",
      lastName: "",
      email: "",
      phoneNumber: "",
      userName: "",
      token: Object,
      role: Object);

  ///apigw/mymedicinecustomer/register/validate
  toggle() {
    _loggedIn = !_loggedIn;
    notifyListeners();
  }

  void notifyLogin(MedUser medUser) {
    MedUsers = medUser;
    notifyListeners();
  }

  void notifyRefill(RefillObj refillObj2) {
    refillObj = refillObj2;
    notifyListeners();
  }

  void makeRefillNull() {
    refillObj = null;
    notifyListeners();
  }

  void notifyCountry(String text, int id) {
    Country = text;
    CountryId = id;
    notifyListeners();
  }

  void filterBrand(String text) {
    Filter = text;
    notifyListeners();
  }

  void notifyStates(String text, int id) {
    State = text;
    StateId = id;
    notifyListeners();
  }

  void notifyLGAS(String text, int id) {
    LGA = text;
    LGAID = id;
    notifyListeners();
  }

  void increaseCart() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");

    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };
    try {
      String myurl = "apigw/cart/cartItems";
      var url = Uri.parse(BaseUrl + myurl);
      http.Response response = await http.get(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        //return response.body;
        var data = json.decode(response.body);
        dynamic data2 = data["responseBody"]["data"];
        if (data2 != null) {
          List<CartItems> dataList = data2
              .map<CartItems>((element) => CartItems.fromJson(element))
              .toList();
          CurrentIndex = dataList.length;
        } else {
          CurrentIndex = 0;
        }
        notifyListeners();
      } else {
        CurrentIndex = CurrentIndex + 1;
        notifyListeners();
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      CurrentIndex = CurrentIndex + 1;
      notifyListeners();
    }
  }

  Future<ResponseObject> loginUser(
      String Email, String Password, String DeviceId, int channelId) async {
    var headers = {
      HttpHeaders.authorizationHeader:
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJFbWFpbCI6ImNsZW1iYWJhaW5mb0BnbWFpbC5jb20iLCJQYXNzd29yZCI6ImNoZWxzZWF3cWUyMiIsImlhdCI6MTYyMTg0NzEzNCwiZXhwIjoxNjIxODQ3NzM0fQ.MCJ94nKO3RIOf-TgiEDDmne0o9J2HVEmwso-3MGPvIA',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };

    ResponseObject responseObject;
    try {
      var dataB = jsonEncode(<String, Object>{
        "channelId": channelId,
        "deviceId": DeviceId,
        "userName": Email,
        "password": Password
      });
      print("Inside the login quee");
      var url = Uri.parse(BaseUrl + "apigw/token/login");
      http.Response response =
          await http.post(url, body: dataB, headers: headers);
      print(response);
      responseObject = ResponseObject(
          responseBody: response.body, responseCode: response.statusCode);
      return responseObject;
    } on SocketException catch (e) {
      responseObject =
          ResponseObject(responseBody: "Network Error", responseCode: 700);
      return responseObject;
    }
  }

  Future<String> signUpUser() async {
    var headers = {
      HttpHeaders.authorizationHeader:
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJFbWFpbCI6ImNsZW1iYWJhaW5mb0BnbWFpbC5jb20iLCJQYXNzd29yZCI6ImNoZWxzZWF3cWUyMiIsImlhdCI6MTYyMTg0NzEzNCwiZXhwIjoxNjIxODQ3NzM0fQ.MCJ94nKO3RIOf-TgiEDDmne0o9J2HVEmwso-3MGPvIA',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };
    try {
      var dataB = jsonEncode(<String, Object>{
        "firstname": "Tonye",
        "middlename": "string",
        "lastname": "clem",
        "emailAddress": "tonclem@gmail.com",
        "phoneNumber": "08068040581",
        "username": "tonclem@gmail.com",
        "password": "testxxx",
        "gender": "Male",
        "birthday": "2021-09-16T14:48:52.707Z",
        "number": "string",
        "street": "string",
        "city": "string",
        "localGovtId": 1,
        "stateId": 2,
        "countryId": 2,
        "channelId": 1
      });
      print("Inside the queee");
      var url = Uri.parse(
          BaseUrl + "apigw/mymedicinecustomer/MymedicineCustomer/register");
      http.Response response =
          await http.post(url, body: dataB, headers: headers);
      print(response);
      //var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print("We are all goood ...... Response is 200");
        print(response.body);
        var body = jsonDecode(response.body);
      } else {
        print(response.body);
        print("Errrrrrrrror not 2000");
      }
    } on SocketException catch (_) {
      print("Error messages now ooooo");
    }
    return "";
  }

  Future<String> productCategoryList() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");
    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };
    try {
      // var dataB = jsonEncode(<String, Object>{
      //   "channelId": channelId,
      //   "deviceId": DeviceId,
      //   "userName": Email,
      //   "password": Password
      // });
      print("Getting product list");
      var url = Uri.parse(BaseUrl + "apigw/product/ProductCategory/list");
      http.Response response = await http.get(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        print("We are all goood ...... Response is 200");
        return response.body;
      } else {
        print(response.body);
        print("Errrrrrrrror not 2000");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      return e.message;
    }
  }

  Future<String> createWishList(int channellId, int productId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");
    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };
    try {
      var dataB = jsonEncode(<String, Object>{
        "productId": productId,
        "channelId": channellId,
      });
      print("Getting product list");
      var url = Uri.parse(BaseUrl + "apigw/wishlist/wishlist");
      http.Response response =
          await http.post(url, body: dataB, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        print("We are all goood ...... Response is 200");
        return response.body;
      } else {
        print(response.body);
        print("Errrrrrrrror not 2000");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      return e.message;
    }
  }

  Future<String> createBundleWishList(int channellId, int bundleId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");
    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };
    try {
      var dataB = jsonEncode(<String, Object>{
        "bundleId": bundleId,
        "channelId": channellId,
      });
      print("Getting product list");
      var url = Uri.parse(BaseUrl + "apigw/wishlist/wishlist/bundle");
      http.Response response =
          await http.post(url, body: dataB, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        print("We are all goood ...... Response is 200");
        return response.body;
      } else {
        print(response.body);
        print("Errrrrrrrror not 2000");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      return e.message;
    }
  }

  Future<String> viewWishList() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");
    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8'
    };
    try {
      print("Getting wish list");
      var url = Uri.parse(BaseUrl + "apigw/wishlist/wishlist");
      http.Response response = await http.get(url, headers: headers);
      print(response);
      print(response.body);
      if (response.statusCode == 200) {
        print("We are all goood ...... Response is 200");
        return response.body;
      } else {
        print(response.body);
        print("Errrrrrrrror not 2000");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      print(e.message);
      return "Network Error";
    }
  }

  Future<String> removeProductFromWishList(int productId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");
    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };
    try {
      var dataB = jsonEncode(<String, Object>{"id": productId, "channelId": 2});

      print("Deleting from wish list");
      var url = Uri.parse(BaseUrl + "apigw/wishlist/wishlist/product/delete");
      http.Response response =
          await http.delete(url, body: dataB, headers: headers);
      print(response);
      print(response.body);
      if (response.statusCode == 200) {
        print("We are all goood ...... Response is 200");
        return response.body;
      } else {
        print(response.body);
        print("Errrrrrrrror not 2000");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      print(e.message);
      return "Network Error";
    }
  }

  Future<String> removeBundleFromWishList(int bundleId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");
    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };
    try {
      var dataB = jsonEncode(<String, Object>{"id": bundleId, "channelId": 2});
      print("Deleting from wish list");
      var url = Uri.parse(BaseUrl + "apigw/wishlist/wishlist/bundle/delete");
      http.Response response =
          await http.delete(url, body: dataB, headers: headers);
      print(response);
      print(response.body);
      if (response.statusCode == 200) {
        print("We are all goood ...... Response is 200");
        return response.body;
      } else {
        print(response.body);
        print("Errrrrrrrror not 2000");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      print(e.message);
      return "Network Error";
    }
  }

  Future<String> viewAllBundles() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");
    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };
    try {
      var url = Uri.parse(BaseUrl + "apigw/catalog/products/bundle/all");
      http.Response response = await http.get(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        print("All Bundles");
        return response.body;
      } else {
        print(response.body);
        print("Errrrrrrrror not 2000");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      print(e.message);
      return "Network Error";
    }
  }

  Future<String> viewTermsAndCondition() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");
    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };
    try {
      print("Getting products now");
      var url = Uri.parse(
          BaseUrl + "apigw/info/Info/mymedicine/management/info/policy/TandC");
      http.Response response = await http.get(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        print("We are all goood ...... Response is 200");
        return response.body;
      } else {
        print(response.body);
        print("product not showing");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      print(e.message);
      return "Network Error";
    }
  }

  Future<String> viewFAQS() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");
    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };

    try {
      print("Getting FAQS");
      var url = Uri.parse(BaseUrl + "apigw/Support/faqs");
      http.Response response = await http.get(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        print("We are all goood ...... Response is 200");
        return response.body;
      } else {
        print(response.body);
        print("Errrrrrrrror not 2000");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      print(e.message);
      return "Network Error";
    }
  }

  Future<String> viewAllBlogs() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");
    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };

    try {
      print("Getting Blogs now");
      var url = Uri.parse(BaseUrl + "apigw/blog/blogPosts");
      http.Response response = await http.get(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        print("We are all goood ...... Response is 200");
        return response.body;
      } else {
        print(response.body);
        print("Errrrrrrrror not 2000");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      print(e.message);
      return "Network Error";
    }
  }

  Future<String> viewCountries() async {
    var headers = {
      HttpHeaders.authorizationHeader:
          'Bearer eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJtYXJ5LmphbmUiLCJqdGkiOiI3NTlhODY2ZS02NTk2LTQwMzUtYWVhNS1hYTdlZmI2ZjM4ODciLCJpYXQiOjE2MzM1OTk4MzQsInJvbGUiOiJNeU1lZGljaW5lQ3VzdG9tZXIiLCJ1c2VySWQiOiI4MyIsInVzZXJuYW1lIjoibWFyeS5qYW5lIiwiZmlyc3ROYW1lIjoiTWFyaWEiLCJsYXN0TmFtZSI6IkphbmUiLCJuYmYiOjE2MzM1OTk4MzQsImV4cCI6MTYzNDIwNDYzNCwiaXNzIjoiaHR0cDovLzUxLjEwNC4xODYuMTA1IiwiYXVkIjoiaHR0cDovLzUxLjEwNC4xODYuMTA1In0.75o4LSnZrdllDfuR_2hFHbA5A6m8VyVgHWsOWToY_js',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };

    try {
      print("Getting Blogs now");
      var url = Uri.parse(
          BaseUrl + "apigw/address/Address/v1/utilities/address/country");
      http.Response response = await http.get(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        print("We are all goood ...... Response is 200");
        return response.body;
      } else {
        print(response.body);
        print("Errrrrrrrror not 2000");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      print(e.message);
      return "Network Error";
    }
  }

  Future<String> viewStates(int countryID) async {
    print("This is the id $countryID");
    var headers = {
      HttpHeaders.authorizationHeader:
          'Bearer eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJtYXJ5LmphbmUiLCJqdGkiOiI1YjU0ZTNjZi0yOGFjLTRhM2MtOGVhMy00ZmFmMmYyNzBmNTgiLCJpYXQiOjE2MzMxNjc0NjksInJvbGUiOiJNeU1lZGljaW5lQ3VzdG9tZXIiLCJ1c2VySWQiOiI4MyIsInVzZXJuYW1lIjoibWFyeS5qYW5lIiwiZmlyc3ROYW1lIjoiTWFyeSIsImxhc3ROYW1lIjoiSmFuZSIsIm5iZiI6MTYzMzE2NzQ2OCwiZXhwIjoxNjMzNzcyMjY4LCJpc3MiOiJodHRwOi8vNTEuMTA0LjE4Ni4xMDUiLCJhdWQiOiJodHRwOi8vNTEuMTA0LjE4Ni4xMDUifQ.UvHwl8rqF5ePwnHWWcSH5ywtSdXFX6IJIWZ9_BiZL1Q',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };

    try {
      print("Getting Blogs now");
      var url = Uri.parse(BaseUrl +
          "apigw/address/Address/v1/utilities/address/country/${countryID}/state");
      http.Response response = await http.get(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        print("We are all goood ...... Response is 200");
        return response.body;
      } else {
        print(response.body);
        print("Errrrrrrrror not 2000");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      print(e.message);
      return "Network Error";
    }
  }

  Future<String> viewLGAS(int stateID) async {
    print("This is the id $stateID");
    var headers = {
      HttpHeaders.authorizationHeader:
          'Bearer eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJtYXJ5LmphbmUiLCJqdGkiOiI1YjU0ZTNjZi0yOGFjLTRhM2MtOGVhMy00ZmFmMmYyNzBmNTgiLCJpYXQiOjE2MzMxNjc0NjksInJvbGUiOiJNeU1lZGljaW5lQ3VzdG9tZXIiLCJ1c2VySWQiOiI4MyIsInVzZXJuYW1lIjoibWFyeS5qYW5lIiwiZmlyc3ROYW1lIjoiTWFyeSIsImxhc3ROYW1lIjoiSmFuZSIsIm5iZiI6MTYzMzE2NzQ2OCwiZXhwIjoxNjMzNzcyMjY4LCJpc3MiOiJodHRwOi8vNTEuMTA0LjE4Ni4xMDUiLCJhdWQiOiJodHRwOi8vNTEuMTA0LjE4Ni4xMDUifQ.UvHwl8rqF5ePwnHWWcSH5ywtSdXFX6IJIWZ9_BiZL1Q',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };

    try {
      print("Getting Blogs now");
      var url = Uri.parse(BaseUrl +
          "apigw/address/Address/v1/utilities/address/state/${stateID}/lga");
      http.Response response = await http.post(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        print("We are all goood ...... Response is 200");
        return response.body;
      } else {
        print(response.body);
        print("Errrrrrrrror not 2000");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      print(e.message);
      return "Network Error";
    }
  }

  Future<String> createShipmentAddress(
      int LGAID,
      int StateID,
      int CID,
      String Street,
      String city,
      String FName,
      String LName,
      bool isDefault,
      String Email,
      String Phone) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");

    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };
    try {
      var dataB = jsonEncode(<String, Object>{
        "number": Street,
        "street": Street,
        "city": city,
        "localGovtId": LGAID,
        "stateId": StateID,
        "countryId": CID,
        "latitude": "-3456.12",
        "longitude": "123123.2",
        "isDefault": false,
        "firstName": FName,
        "lastName": LName,
        "phoneNumber": Phone,
        "emailAddress": Email
      });
      //Text("Welcome ${Cart.Lname} to the application");
      var url = Uri.parse(
          BaseUrl + "apigw/mymedicinecustomer/MymedicineCustomer/address");
      http.Response response =
          await http.post(url, body: dataB, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print(response.statusCode);
        print(response.body);
        print("Errrrrrrrror not 2000");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      return "Network Error";
    }
  }

  Future<String> updateShipmentAddress(
    int LGAID,
    int StateID,
    int CID,
    String Street,
    String city,
    String FName,
    String LName,
    bool isDefault,
    String Email,
    String Phone,
    int customerShippingAddressId,
  ) async {
    print("REsponse is here now ...... we cool my man");
    print("${Street}");
    print("${city}");
    print("${isDefault}");
    print("${FName}");
    print("${LName}");
    print("${Phone}");
    print("${Email}");
    print("${LGAID}");
    print("${StateID}");
    print("${CID}");
    print("${customerShippingAddressId}");

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");

    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };
    try {
      var dataB = jsonEncode(<String, Object>{
        "number": Street,
        "street": Street,
        "city": city,
        "localGovtId": LGAID,
        "stateId": StateID,
        "countryId": CID,
        "latitude": "-3456.12",
        "longitude": "123123.2",
        "isDefault": isDefault,
        "firstName": FName,
        "lastName": LName,
        "phoneNumber": Phone,
        "emailAddress": Email
      });

      var url = Uri.parse(BaseUrl +
          "apigw/mymedicinecustomer/update/address/${customerShippingAddressId}");
      http.Response response =
          await http.put(url, body: dataB, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print(response.statusCode);
        print(response.body);
        print("Errrrrrrrror not 2000");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      return "Network Error";
    }
  }

  Future<String> viewShipmentAddresses() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");
    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };

    try {
      print("Getting Addresses now");
      var url = Uri.parse(BaseUrl + "apigw/mymedicinecustomer/view/address");
      http.Response response = await http.get(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        print("We are all goood ...... Response is 200");
        return response.body;
      } else {
        print(response.body);
        print("Errrrrrrrror not 2000");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      print(e.message);
      return "Network Error";
    }
  }

  Future<String> makeShipmentAddressDefault(
      int customerShippingAddressId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");
    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };

    try {
      print("Getting Addresses now");
      var url = Uri.parse(BaseUrl +
          "apigw/mymedicinecustomer/MymedicineCustomer/address/default/${customerShippingAddressId}");
      http.Response response = await http.put(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        print("We are all goood ...... Response is 200");
        return response.body;
      } else {
        print(response.body);
        print("Errrrrrrrror not 2000");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      print(e.message);
      return "Network Error";
    }
  }

  Future<String> deleteShipmentAddresses(int shipmentID) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");
    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };

    try {
      print("Getting Addresses now");
      var url = Uri.parse(BaseUrl +
          "apigw/mymedicinecustomer/MymedicineCustomer/delete/address/$shipmentID");
      http.Response response = await http.delete(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        print("We are all goood ...... Response is 200");
        return response.body;
      } else {
        print(response.body);
        print("Errrrrrrrror not 2000");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      print(e.message);
      return "Network Error";
    }
  }

  Future<String> searchRefillProducts(String text) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");

    print("indicated now ......");
    print(token);
    print("indicated now .....");

    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };

    try {
      print("Getting Addresses now");
      var url = Uri.parse(BaseUrl + "apigw/catalog/products/search");
      http.Response response = await http.get(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        print("We are all goood ...... Response is 200");
        return response.body;
      } else {
        print(response.body);
        print("Errrrrrrrror not 2000");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      print(e.message);
      return "Network Error";
    }
  }

  Future<String> viewProductByID(int id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");

    print("indicated now ......");
    print(token);
    print("indicated now .....");

    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };

    //3860004299
    try {
      print("Getting Addresses now");
      var url = Uri.parse(BaseUrl + "apigw/catalog/Catalog/products/${id}");
      http.Response response = await http.get(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        print("We are all goood ...... Response is 200");
        return response.body;
      } else {
        print(response.body);
        print("Errrrrrrrror not 2000");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      print(e.message);
      return "Network Error";
    }
  }

  Future<String> viewRefillProducts() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");
    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };

    try {
      print("Getting ViewRefillProducts now");
      var url = Uri.parse(
          BaseUrl + "apigw/mymedicinecustomer/MedicationRefilll/refill");
      http.Response response = await http.get(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        print("We are all goood ...... Response is 200");
        return response.body;
      } else {
        print(response.body);
        print("Errrrrrrrror not 2000");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      print(e.message);
      return "Network Error";
    }
  }

  Future<String> viewRefillCycle() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");
    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };

    try {
      print("Getting Refill cycle");
      var url = Uri.parse(
          BaseUrl + "apigw/mymedicinecustomer/MedicationRefilll/refill/cycle");
      http.Response response = await http.get(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        print("We are all goood ...... Response is 200");
        return response.body;
      } else {
        print(response.body);
        print("Errrrrrrrror not 2000");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      print(e.message);
      return "Network Error";
    }
  }

  Future<String> allRecentlyViewed() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");
    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };

    try {
      print("Getting Recently Viewed");
      var url = Uri.parse(BaseUrl + "apigw/mymedicinecustomer/product/recent");
      http.Response response = await http.get(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        print("We are all goood ...... Response is 200");
        return response.body;
      } else {
        print(response.body);
        print("Errrrrrrrror not 2000");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      print(e.message);
      return "Network Error";
    }
  }

  Future<String> deleteRefillProduct(int refillId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");
    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };

    try {
      print("Getting Refill cycle");
      var url = Uri.parse(BaseUrl +
          "apigw/mymedicinecustomer/MedicationRefilll/refill/$refillId");
      http.Response response = await http.delete(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        print("We are all goood ...... Response is 200");
        return response.body;
      } else {
        print(response.body);
        print("Errrrrrrrror not 2000");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      print(e.message);
      return "Network Error";
    }
  }

  Future<String> addRefillMedicine(
      int productId,
      String startDate,
      int refillCycleId,
      int channelId,
      bool remindBySMS,
      bool remindByEmail,
      bool remindByPushNotification,
      String endDate) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");

    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };
    try {
      //"startDate": "2021-10-17T19:31:39.505Z",
      //2021-10-17T19:31:39.505Z
      var dataB = jsonEncode(<String, Object>{
        "productId": productId,
        "startDate": startDate,
        "refillCycleId": refillCycleId,
        "channelId": channelId,
        "remindBySMS": remindBySMS,
        "remindByEmail": remindByEmail,
        "remindByPushNotification": remindByPushNotification,
        "endDate": endDate
      });

      var url = Uri.parse(
          BaseUrl + "apigw/mymedicinecustomer/MedicationRefilll/refill");
      http.Response response =
          await http.post(url, body: dataB, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      return "Network Error";
    }
  }

  Future<String> forgotPassword(String email) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");

    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };
    try {
      var dataB = jsonEncode(<String, Object>{
        "emailAddress": email,
      });

      var url = Uri.parse(BaseUrl + "apigw/mymedicinecustomer/reset");
      http.Response response =
          await http.post(url, body: dataB, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      return "Network Error";
    }
  }

  Future<String> validateRegOTP(
      String otpCode, int otpId, int channelId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");

    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };
    try {
      var dataB = jsonEncode(
          <String, Object>{"otpCode": otpCode, "channelId": 2, "otpId": otpId});

      var url =
          Uri.parse(BaseUrl + "apigw/mymedicinecustomer/register/validate");
      http.Response response =
          await http.post(url, body: dataB, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      return "Network Error";
    }
  }

  Future<String> validateResetOTP(String otpCode, int otpId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");

    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };
    try {
      var dataB =
          jsonEncode(<String, Object>{"otpCode": otpCode, "otpId": otpId});

      var url = Uri.parse(
          BaseUrl + "apigw/mymedicinecustomer/reset/validateResetToken");
      http.Response response =
          await http.post(url, body: dataB, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      return "Network Error";
    }
  }

  Future<String> resetPassword(String password, String resetToken) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");

    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };
    try {
      var dataB = jsonEncode(
          <String, Object>{"resetToken": resetToken, "password": password});

      var url = Uri.parse(BaseUrl + "apigw/mymedicinecustomer/reset/complete");
      http.Response response =
          await http.post(url, body: dataB, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      return "Network Error";
    }
  }

  Future<ResponseObject> viewCartItems() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");

    ResponseObject responseObject = new ResponseObject();

    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };
    try {
      var url = Uri.parse(BaseUrl + "apigw/cart/cartItems");
      http.Response response = await http.get(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        responseObject.responseCode = response.statusCode;
        responseObject.responseBody = response.body;
        return responseObject;
      } else {
        responseObject.responseCode = response.statusCode;
        responseObject.responseBody = response.body;
        return responseObject;
      }
    } on SocketException catch (e) {
      responseObject.responseCode = 0;
      responseObject.responseBody = "Network Error";
      return responseObject;
    }
  }

  Future<String> deleteCartItem(
      int shoppingCartOrderItemId, int productId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");

    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };

    try {
      List<dynamic> list = [
        {
          "sessionID": "string",
          "creatorUserId": 0,
          "shoppingCartOrderItemId": shoppingCartOrderItemId,
          "productId": productId,
          "channelId": 2,
          "bundleId": 0
        }
      ];
      var dataB = jsonEncode(list);

      var url = Uri.parse(BaseUrl + "apigw/cart/mymedicine/deletecartItem");
      http.Response response =
          await http.delete(url, body: dataB, headers: headers);
      print(response);
      print("We are in delete cart now ......");
      print(response.body);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      return "Network Error";
    }
  }

  Future<String> deleteMultipleCartItem(List<DeleteCartItems> items) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");

    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };

    try {
      List<dynamic> list = items;
      var dataB = jsonEncode(list);

      var url = Uri.parse(BaseUrl + "apigw/cart/mymedicine/deletecartItem");
      http.Response response =
          await http.delete(url, body: dataB, headers: headers);
      print(response);
      print("We are in delete cart now ......");
      print(response.body);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      return "Network Error";
    }
  }

  Future<String> addToCart(int productId, int qty) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");

    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };
    try {
      var dataB = jsonEncode(<String, Object>{
        "productId": productId,
        "channelId": 2,
        "sessionID": "string",
        "quantity": qty
      });

      var url = Uri.parse(BaseUrl + "apigw/cart/cartItem");
      http.Response response =
          await http.post(url, body: dataB, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      return "Network Error";
    }
  }

  Future<String> addBundleToCart(int bundleId, int qty) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");

    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };
    try {
      var dataB = jsonEncode(<String, Object>{
        "bundleId": bundleId,
        "channelId": 2,
        "sessionID": "string",
        "quantity": qty
      });

      var url = Uri.parse(BaseUrl + "apigw/cart/cartItems/bundle");
      http.Response response =
          await http.post(url, body: dataB, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      return "Network Error";
    }
  }

  Future<String> increaseCartQty(
      int productId, int shoppingCartOrderItemId, int quantity) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");

    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };
    try {
      List<dynamic> list = [
        {
          "sessionID": "string",
          "creatorUserId": 0,
          "shoppingCartOrderItemId": shoppingCartOrderItemId,
          "productId": productId,
          "channelId": 2,
          "bundleId": 0,
          "quantity": quantity,
          "minUnitPrice": 0,
          "maxUnitPrice": 0
        }
      ];
      var dataB = jsonEncode(list);

      var url = Uri.parse(BaseUrl + "apigw/cart/cartItems/update");
      http.Response response =
          await http.put(url, body: dataB, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      return "Network Error";
    }
  }

  Future<String> viewProductCategory() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");
    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };

    try {
      print("Getting products now");
      var url = Uri.parse(BaseUrl + "apigw/catalog/products/categories");
      http.Response response = await http.get(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        print("We are all goood ...... Response is 200");
        return response.body;
      } else {
        print(response.body);
        print("product not showing");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      print(e.message);
      return "Network Error";
    }
  }

  Future<String> searchProducts(String text) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");

    print("indicated now ......");
    print(token);
    print("indicated now .....");

    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };

    try {
      print("Getting Addresses now");
      var url = Uri.parse(BaseUrl + "apigw/product/list?search=${text}");
      http.Response response = await http.get(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        print("We are all goood ...... Response is 200");
        return response.body;
      } else {
        print(response.body);
        print("Errrrrrrrror not 2000");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      print(e.message);
      return "Network Error";
    }
  }

  Future<String> allOrderData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");

    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };
    try {
      var url = Uri.parse(BaseUrl + "apigw/mymedicine/order");
      http.Response response = await http.get(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      return "Network Error";
    }
  }

  Future<String> viewOrderDetails(int id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");

    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };
    try {
      var url = Uri.parse(BaseUrl + "apigw/mymedicine/order/$id");
      http.Response response = await http.get(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      return "Network Error";
    }
  }

  Future<String> viewReturnConditions() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");

    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };
    try {
      var url = Uri.parse(BaseUrl + "apigw/order/returnConditions");
      http.Response response = await http.get(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      return "Network Error";
    }
  }

  Future<String> postReturnCondition(
      int salesOrderId,
      int salesOrderItemId,
      int quantity,
      int returnConditionId,
      String comments,
      int returnReasonId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");

    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };

    try {
      var dataB = jsonEncode(<String, Object>{
        "salesOrderId": salesOrderId,
        "salesOrderItemId": salesOrderItemId,
        "quantity": quantity,
        "returnConditionId": returnConditionId,
        "comments": comments,
        "channelId": 2,
        "returnReasonId": returnReasonId
      });

      var url = Uri.parse(BaseUrl + "apigw/order/orderItem/return");
      http.Response response =
          await http.post(url, body: dataB, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      return "Network Error";
    }
  }

  Future<String> viewOrderHistory(int salesOrderId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");

    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };
    try {
      var url = Uri.parse(
          BaseUrl + "apigw/mymedicine/order/unique/${salesOrderId}/history");
      http.Response response = await http.get(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      return "Network Error";
    }
  }

  Future<String> startCheckout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");

    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token'
      //'Content-Type': 'application/problem+json; charset=utf-8 '
    };
    try {
      var dataB = {
        "channelId": "2",
      };

      var url =
          Uri.parse(BaseUrl + "apigw/mymedicine/order/checkout?channelId=2");
      http.Response response =
          await http.post(url, body: dataB, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      return "Network Error";
    }
  }

  Future<String> logisticsDeliveryGet(int stateId, int lgaID) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");
    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token'
      //'Content-Type': 'application/problem+json; charset=utf-8 '
    };
    try {
      var url = Uri.parse(BaseUrl +
          "apigw/mymedicine/order/logistics/state/$stateId/lga/$lgaID");
      http.Response response = await http.get(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      return "Network Error";
    }
  }

  Future<String> viewBanner() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");
    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };

    try {
      print("Getting banners now");
      var url = Uri.parse(BaseUrl + "apigw/banner/banner/slider");
      http.Response response = await http.get(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        print("We are all goood ...... Response is 200");
        return response.body;
      } else {
        print(response.body);
        print("product not showing");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      print(e.message);
      return "Network Error";
    }
  }

  Future<String> viewProductList() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");
    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };

    try {
      print("Getting recent viewed products now");
      var url =
          Uri.parse(BaseUrl + "apigw/catalog/Catalog/product/popular/100");
      http.Response response = await http.get(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        print("We are all goood ...... Response is 200");
        return response.body;
      } else {
        print(response.body);
        print("product not showing");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      print(e.message);
      return "Network Error";
    }
  }

  Future<String> viewBundleByID(int id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");
    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };

    try {
      print("Getting Addresses now");
      var url = Uri.parse(
          BaseUrl + "apigw/catalog/Catalog/products/bundle/detail/${id}");
      http.Response response = await http.get(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        print("We are all goood ...... Response is 200");
        return response.body;
      } else {
        print(response.body);
        print("Errrrrrrrror not 2000");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      print(e.message);
      return "Network Error";
    }
  }

  Future<String> viewMyWishList() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");
    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };

    try {
      print("Getting wishlist now");
      var url = Uri.parse(BaseUrl + "apigw/wishlist/wishlist");
      http.Response response = await http.get(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        print("We are all goood ...... Response is 200");
        return response.body;
      } else {
        print(response.body);
        print("product not showing");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      print(e.message);
      return "Network Error";
    }
  }

  Future<String> viewProductSubCategory(int productId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");
    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };

    try {
      print("Getting products now");
      var url = Uri.parse(BaseUrl +
          "apigw/catalog/products/subcategories?productCategoryId=${productId}");
      http.Response response = await http.get(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        print("We are all goood ...... Response is 200");
        return response.body;
      } else {
        print(response.body);
        print("product not showing");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      print(e.message);
      return "Network Error";
    }
  }

  Future<String> viewProductsFromSubCategory(int subCategoryId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");
    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };

    try {
      print("Getting products now");
      var url = Uri.parse(BaseUrl +
          "apigw/product/Product/list/subcategories/${subCategoryId}");
      http.Response response = await http.get(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        print("We are all goood ...... Response is 200");
        return response.body;
      } else {
        print(response.body);
        print("product not showing");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      print(e.message);
      return "Network Error";
    }
  }

  Future<String> viewProductsByCategory(int categoryId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");
    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };

    try {
      print("Getting products now");
      var url = Uri.parse(BaseUrl + "apigw/product/Product/list/${categoryId}");
      http.Response response = await http.get(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        print("We are all goood ...... Response is 200");
        return response.body;
      } else {
        print(response.body);
        print("product not showing");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      print(e.message);
      return "Network Error";
    }
  }

  Future<String> viewRecent() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");
    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };

    try {
      print("Getting recent viewed products now");
      var url = Uri.parse(BaseUrl + "apigw/product/list");
      http.Response response = await http.get(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        print("We are all goood ...... Response is 200");
        return response.body;
      } else {
        print(response.body);
        print("product not showing");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      print(e.message);
      return "Network Error";
    }
  }
  Future<String> completeOrder(
      String uniqueOrderId,
      String transactionReference,
      double amountCharged,
      int paymentProviderId,
      int logisticsDeliveryOptionId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");

    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };
    try {
      var dataB = jsonEncode(<String, Object>{
        "uniqueOrderId": uniqueOrderId,
        "transactionReference": transactionReference,
        "amountCharged": amountCharged,
        "fees": amountCharged,
        "channelId": 2,
        "paymentProviderId": paymentProviderId,
        "logisticsDeliveryOptionId": logisticsDeliveryOptionId
      });

      //apigw/mymedicine/order/completeCashOrder

      var url = Uri.parse(BaseUrl + "apigw/mymedicine/order/complete");
      http.Response response =
          await http.post(url, body: dataB, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      return "Network Error";
    }
  }

  Future<String> getRatings(int productId, bool isBundle) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");
    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };

    try {
      print("Getting recent viewed products now");
      var url =
          Uri.parse(BaseUrl + "apigw/Ratings/${productId}/review/${isBundle}");
      http.Response response = await http.get(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        print("We are all goood ...... Response is 200");
        return response.body;
      } else {
        print(response.body);
        print("product not showing");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      print(e.message);
      return "Network Error";
    }
  }

  Future<String> avgRatings(int productId, bool isBundle) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");
    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };

    try {
      print("Getting recent viewed products now");
      var url =
          Uri.parse(BaseUrl + "apigw/ratings/Ratings/${productId}/${isBundle}");
      http.Response response = await http.get(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        print("We are all goood ...... Response is 200");
        return response.body;
      } else {
        print(response.body);
        print("product not showing");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      print(e.message);
      return "Network Error";
    }
  }

  Future<String> selectShippingAddress(
      MedShipAddrees address, int salesOrderId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");

    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };
    try {
      var dataB = jsonEncode(<String, Object>{
        "customerShippingAddressId": address.customerShippingAddressId,
        "salesOrderId": salesOrderId,
        "latitude": "string",
        "longitude": "string",
        "houseNumber": address.houseNumber!,
        "street": address.street!,
        "city": address.city!,
        "lgaId": address.lgaId!,
        "stateId": address.stateId!,
        "countryId": address.countryId!
      });

      var url = Uri.parse(BaseUrl + "apigw/cart/address");
      http.Response response =
          await http.post(url, body: dataB, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      return "Network Error";
    }
  }

  // Future<String> selectsShippingAddress(
  //     MedShipAddrees address, int salesOrderId) async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   String? token = sharedPreferences.getString("Token");
  //
  //   var headers = {
  //     HttpHeaders.authorizationHeader: 'Bearer $token',
  //     'Content-Type': 'application/problem+json; charset=utf-8 '
  //   };
  //   try {
  //     var dataB = jsonEncode(<String, Object>{
  //       "customerId": 0,
  //       "mobilekey": "string",
  //       "fromaccount": "string",
  //       "fromacctname": "string",
  //       "fromaccountstatus": "string",
  //       "fromaccountemail": "string",
  //       "fromacctype": "string",
  //       "toaccount": "string",
  //       "toacctname": "string",
  //       "toacctype": "string",
  //       "tokenType": 0,
  //       "transactionreference": "string",
  //       "amount": 0,
  //       "dailylimit": 0,
  //       "currentbalance": 0,
  //       "trandate": "2022-04-27T22:35:04.813Z",
  //       "narration": "string",
  //       "channelId": 0,
  //       "loginuserid": "string",
  //       "tranToken": "string",
  //       "toacctnuban": "string",
  //       "toacctbvn": "string"
  //     });
  //
  //     var url = Uri.parse(BaseUrl + "apigw/cart/address");
  //     http.Response response =
  //     await http.post(url, body: dataB, headers: headers);
  //     print(response);
  //     if (response.statusCode == 200) {
  //       return response.body;
  //     } else {
  //       return response.body;
  //     }
  //   } on SocketException catch (e) {
  //     print("Error messages now ooooo");
  //     return "Network Error";
  //   }
  // }


  Future<String> fliterBrandsSearch(String txt) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");
    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };

    try {
      print("Getting recent viewed products now");
      var url = Uri.parse(BaseUrl + "apigw/product/Product/brand?search=$txt");
      http.Response response = await http.get(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        print("We are all goood ...... Response is 200");
        return response.body;
      } else {
        print(response.body);
        print("product not showing");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      print(e.message);
      return "Network Error";
    }
  }

  Future<String> viewProductsByBrands(String txt) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");
    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };

    try {
      print("Getting products now");
      var url = Uri.parse(BaseUrl + "apigw/product/brand/${txt}");
      http.Response response = await http.get(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        print("We are all goood ...... Response is 200");
        return response.body;
      } else {
        print(response.body);
        print("product not showing");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      print(e.message);
      return "Network Error";
    }
  }

  Future<String> getDeliveryType() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");
    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };

    try {
      print("Getting products now");
      var url = Uri.parse(BaseUrl + "apigw/logistics/types");
      http.Response response = await http.get(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        print("We are all goood ...... Response is 200");
        return response.body;
      } else {
        print(response.body);
        print("product not showing");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      print(e.message);
      return "Network Error";
    }
  }

  Future<String> getShipmentFee(
      int salesOrderId, int logisticsDeliveryTypeId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");

    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };
    try {
      var dataB = jsonEncode(<String, Object>{
        "salesOrderId": salesOrderId,
        "logisticsDeliveryTypeId": logisticsDeliveryTypeId
      });

      var url = Uri.parse(BaseUrl + "apigw/order/logistics/type/update");
      http.Response response =
          await http.post(url, body: dataB, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      return "Network Error";
    }
  }

  Future<String> applyPromoCode(int salesOrderId, String couponCode) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");

    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };
    try {
      var dataB = jsonEncode(<String, Object>{
        "salesOrderId": salesOrderId,
        "couponCode": couponCode
      });

      var url = Uri.parse(BaseUrl + "apigw/mymedicine/order/coupon");
      http.Response response =
          await http.post(url, body: dataB, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      return "Network Error";
    }
  }

  Future<String> completeCashOrder(int salesOrderId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");

    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };
    try {
      var dataB =
          jsonEncode(<String, Object>{"orderId": salesOrderId, "channelId": 2});

      var url = Uri.parse(BaseUrl + "apigw/mymedicine/order/completeCashOrder");
      http.Response response =
          await http.post(url, body: dataB, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      return "Network Error";
    }
  }

  Future<String> cancelRefillOrder(int refillId, bool active) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");

    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };
    try {
      var dataB = jsonEncode(<String, Object>{
        "refillId": refillId,
        "activate": active,
        "channelId": 2
      });

      var url = Uri.parse(BaseUrl +
          "apigw/mymedicinecustomer/MedicationRefilll/refill/activate");
      http.Response response =
          await http.post(url, body: dataB, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      return "Network Error";
    }
  }

  Future<String> postReview(int rating, String comment, int productId) async {
    print("REsponse is here now ...... we cool my man");
    print("${rating}");
    print("${comment}");
    print("${productId}");

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");
    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };
    try {
      var dataB = jsonEncode(<String, Object>{
        "comment": comment,
        "rating": rating,
        "productId": productId
      });

      var url = Uri.parse(BaseUrl + "apigw/Ratings/review");
      http.Response response =
          await http.post(url, body: dataB, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print(response.statusCode);
        print(response.body);
        print("Errrrrrrrror not 2000");
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      return "Network Error";
    }
  }
  Future<ResponseObject> resendOTP(int otpID) async {
    print("In OTP service now...... we cool my man");
    print("${otpID}");
    ResponseObject responseObject = new ResponseObject();

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");
    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };
    try {
      var dataB = jsonEncode(<String, Object>{"otpId": otpID});

      var url = Uri.parse(BaseUrl + "apigw/otp/resend");
      http.Response response =
          await http.post(url, body: dataB, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        responseObject.responseCode = response.statusCode;
        responseObject.responseBody = response.body;
        return responseObject;
      } else {
        responseObject.responseCode = response.statusCode;
        responseObject.responseBody = response.body;
        return responseObject;
      }
    } on SocketException catch (e) {
      responseObject.responseCode = 0;
      responseObject.responseBody = "Network Error";
      return responseObject;
    }
  }

  Future<String> cancelOrder(int salesOrderId, String reason) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("Token");

    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/problem+json; charset=utf-8 '
    };
    try {
      var dataB = jsonEncode(
          <String, Object>{"orderId": salesOrderId, "reason": reason});

      var url = Uri.parse(BaseUrl + "apigw/mymedicine/order/cancel");
      http.Response response =
          await http.post(url, body: dataB, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.body;
      }
    } on SocketException catch (e) {
      print("Error messages now ooooo");
      return "Network Error";
    }
  }
}
