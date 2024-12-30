// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names, use_build_context_synchronously, unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mrap_v03/Pages/homePage.dart';
import 'package:mrap_v03/Pages/splash_screen.dart';
import 'package:mrap_v03/chat_feature/user_info_model.dart';
import 'package:mrap_v03/core/utils/app_colors.dart';
import 'package:mrap_v03/core/utils/image_constant.dart';

import 'package:mrap_v03/local_storage/boxes.dart';
import 'package:mrap_v03/local_storage/hive_data_model.dart';
import 'package:mrap_v03/screens.dart';
import 'package:mrap_v03/service/all_service.dart';
import 'package:mrap_v03/service/auth_services.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:geocoding/geocoding.dart' as geocoding;
import '../service/network_connectivity.dart';

export 'package:flutter_background_service/flutter_background_service.dart';
export 'package:flutter_background_service_android/flutter_background_service_android.dart';

List<String> dcr_visitedWithList = [];
List<String> rxTypeList = [];
List<String> exp_reject_reasonList = [];
List<String> user_basis_level_list = [];
// List<String> ff_user_list = [];
List<String> cause_for_non_execution_list = [];

bool offer_flag = false;
bool? note_flag;
bool? client_edit_flag;
bool? os_show_flag;
bool? os_details_flag;
bool? ord_history_flag;
bool? inv_histroy_flag;
// bool? timer_flag;
bool? rx_doc_must;
bool? rx_type_must;
bool? rx_gallery_allow;
int? notice_reload_duration;

final mydatabox = Boxes.allData();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _companyIdController = TextEditingController();
  final _userIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  double screenHeight = 0;
  double screenWidth = 0;
  Color initialColor = Colors.white;
  bool _obscureText = true;
  List<String> visitedWith = [];
  List<String> rxType = [];
  String deviceId = '';
  String? deviceBrand = '';
  String? deviceModel = '';
  String? savedUserId = '';
  bool isLoading = false;
  bool timer_flag = false;
  bool background_service = false;
  final box = Boxes.allData();

  String address = "";

  String version = "test";

  bool? serviceEnabled;
  // PermissionStatus? permissionGranted;

  // Location location = Location();

  @override
  initState() {
    super.initState();
    if (mounted) {
      AllServices().getPermission();

      getLatLong();
      _getDeviceInfo();

      if (box.get("CID") != null) {
        var a = box.get("CID");
        savedUserId = box.get('user_id');
        setState(() {
          _companyIdController.text = a.toString();
        });
      }

      debugPrint("offer flag result $offer_flag");
    }
  }

  Future _getDeviceInfo() async {
    var deviceInfo = DeviceInfoPlugin();

    var androidDeviceInfo = await deviceInfo.androidInfo;
    deviceId = androidDeviceInfo.id!;
    deviceBrand = androidDeviceInfo.brand!;
    deviceModel = androidDeviceInfo.model!;

    // try {
    //   deviceId = (await PlatformDeviceId.getDeviceId)!;
    //   // debugPrint(deviceId);
    // } on PlatformException {
    //   deviceId = 'Failed to get deviceId.';
    // }
    // All_SharePreference().setDeviceInfo(deviceId, deviceBrand, deviceModel);
    //!Share preference
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setString('deviceId', deviceId);
    // await prefs.setString('deviceBrand', deviceBrand!);
    // await prefs.setString('deviceModel', deviceModel!);

    //todo!   add Hive
    box.put('deviceId', deviceId);
    box.put('deviceBrand', deviceBrand!);
    box.put('deviceModel', deviceModel!);

    debugPrint("Device Id -----------------$deviceId");
  }

  getLatLong() {
    Future<Position> data = AllServices().determinePosition();
    data.then((value) {
      debugPrint("value $value");
      setState(() {
        double latitude = value.latitude;
        double longitude = value.longitude;

        debugPrint(
            "Splass Screen Lat Long :::::::::::::  $latitude : $longitude");

        box.put("latitude", latitude);
        box.put("longitude", longitude);
      });
    }).catchError((error) {
      // debugPrint("Error $error");
    });
  }

  ///******************************************************Function to Store button Names**********************************************************///

  Future<void> putButtonNames(Map<String, dynamic> buttonNames) async {
    Box box = Hive.box('buttonNames');

    try {
      await box.clear(); // Clear the box before adding new data

      buttonNames.forEach((key, value) {
        box.put(key, value); // Store each key-value pair in Hive
      });

      debugPrint("Successfully stored buttonNames in Hive: ${box.toMap()}");
    } catch (e) {
      debugPrint("Error storing buttonNames in Hive: $e");
    }
  }

  ///******************************************************Function to Store button Names**********************************************************///

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    final double safeAreaTop = MediaQuery.of(context).padding.top;
    final double safeAreaBotttom = MediaQuery.of(context).padding.bottom;

    return isLoading
        ? Container(
            padding: const EdgeInsets.all(50),
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            backgroundColor: kPrimaryColor,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: screenHeight - 30,
                    width: screenWidth,
                    child: Form(
                      key: _formKey,
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(12.0),
                        child: SingleChildScrollView(
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 240,
                                height: 120,
                                child: Image.asset(
                                  ImageConstant.mRep7WLogoImage,
                                  fit: BoxFit.cover,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    // Company ID Field
                                    TextFormField(
                                      autofocus: false,
                                      controller: _companyIdController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        labelText: 'company_id'.tr(),
                                        labelStyle: TextStyle(
                                          color: Colors.black,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.domain_outlined,
                                          color:
                                              Color.fromARGB(255, 98, 126, 112),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'please_provide_your_company_id'
                                              .tr();
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),

                                    SizedBox(
                                      height: 20.0,
                                    ),

                                    // User Id field
                                    TextFormField(
                                      autofocus: false,
                                      controller: _userIdController,
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        labelText: 'user_id'.tr(),
                                        labelStyle: TextStyle(
                                          color: Colors.black,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color:
                                              Color.fromARGB(255, 98, 126, 112),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'please_provide_your_user_id'
                                              .tr();
                                        }
                                        if (value.contains("@")) {
                                          return 'please_provide_your_user_id'
                                              .tr();
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),

                                    // Password Field
                                    TextFormField(
                                      obscureText: _obscureText,
                                      controller: _passwordController,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        labelText: 'password'.tr(),
                                        labelStyle: const TextStyle(
                                          color: Colors.black,
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.vpn_key,
                                          color:
                                              Color.fromARGB(255, 98, 126, 112),
                                        ),
                                        suffixIcon: _obscureText == true
                                            ? IconButton(
                                                onPressed: () {
                                                  setState(
                                                    () {
                                                      _obscureText = false;
                                                    },
                                                  );
                                                },
                                                icon: const Icon(
                                                  Icons.visibility_off,
                                                  size: 20,
                                                  color: Colors.grey,
                                                ))
                                            : IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _obscureText = true;
                                                  });
                                                },
                                                icon: const Icon(
                                                  Icons.remove_red_eye,
                                                  size: 20,
                                                  color: Colors.black,
                                                ),
                                              ),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.done,
                                      validator: (value) {
                                        // RegExp regexp = RegExp(r'^.{6,}$');
                                        if (value!.isEmpty) {
                                          return 'please_enter_your_password'
                                              .tr();
                                        }
                                        // if (value.length >= 6) {
                                        //   return 'Password is too short ,please expand';
                                        // }
                                        return null;
                                      },
                                    ),
                                    // SizedBox(height: screenHeight / 60),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 40.0,
                              ),
                              SizedBox(
                                height: 50,
                                width: 180,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: kSecondaryColor),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      // setState(() {
                                      //   isLoading = true;
                                      // });
                                      ///***this part for add user in firebase with tree structure practice***///
                                   //    print("clicked login ");
                                   //    final FirebaseFirestore _firestore =
                                   //        FirebaseFirestore.instance;
                                   //    Map<String,dynamic>? targetUser;
                                   //    bool hasData=false;
                                   //
                                   //
                                   //    //var userRef = _firestore.collection('depotList').doc(mobile_no).collection("users").doc(user_id);
                                   //    //base entry point _firestore.collection('chat_feature').doc(cid.toLowerCase()).collection("region")
                                   //  print('searching user');
                                   //  print("user id ${_userIdController.text.toString()}");
                                   // String userIdEditText = _userIdController.text.toString();
                                   //  for(int i = 0;i<userList.length;i++)
                                   //    {
                                   //      if(userList[i]["id"].toString()==_userIdController.text.toString())
                                   //        {
                                   //          targetUser=userList[i];
                                   //                  hasData=true;
                                   //                  print("data found");
                                   //                  print(targetUser);
                                   //                  break;
                                   //
                                   //        }
                                   //    }
                                   //    if(hasData)
                                   //    {
                                   //      var userRef;
                                   //       String userType = targetUser!['user_type'].toString();
                                   //       var base = _firestore
                                   //           .collection('companies')
                                   //           .doc(_companyIdController.text.toLowerCase())
                                   //           .collection("region");
                                   //       if(userType.toLowerCase()=="rm")
                                   //         {
                                   //         userRef = base.doc(targetUser['id'].toString());
                                   //
                                   //         }
                                   //      else if(userType.toLowerCase()=="zm")
                                   //       {
                                   //         userRef = base.doc(targetUser['RM'].toString()).collection("zone").doc(targetUser['id'].toString());
                                   //
                                   //       }
                                   //      else if(userType.toLowerCase()=="am")
                                   //       {
                                   //         userRef = base.doc(targetUser['RM'].toString()).collection("zone").doc(targetUser['ZM'].toString()).collection("area").doc(targetUser['id'].toString());
                                   //
                                   //       }
                                   //       else
                                   //         {
                                   //           userRef = base.doc(targetUser['RM'].toString()).collection("zone").doc(targetUser['ZM'].toString()).collection("area").doc(targetUser['AM'].toString()).collection("rep_list").doc(targetUser['id'].toString());
                                   //
                                   //         }
                                   //
                                   //
                                   //       // Check if the user with the given user_id already exists
                                   //       bool isExist =
                                   //           (await userRef.get()).exists;
                                   //
                                   //       if (!isExist) {
                                   //         print('user creating');
                                   //
                                   //         // userInfoModel.lastMsgSent =
                                   //         //     DateTime.now();
                                   //         await userRef
                                   //             .set(targetUser);
                                   //         ///try adding user list RM///
                                   //         if(userType.toLowerCase()=="rm")
                                   //         {
                                   //           try {
                                   //             // Step 1: Get all users in the ZM collection
                                   //             print("trying to add user");
                                   //             print(_companyIdController.text.toLowerCase());
                                   //             print(targetUser["id"].toString());
                                   //             print("zone");
                                   //             print("trying to add user");
                                   //             QuerySnapshot zmList =
                                   //             await _firestore
                                   //                 .collection('companies')
                                   //                 .doc(_companyIdController.text.toLowerCase().toString())
                                   //                 .collection("region").
                                   //             doc(targetUser["id"].toString()).
                                   //             collection("zone").get();
                                   //
                                   //             print("*****************");
                                   //
                                   //             print(zmList);
                                   //
                                   //             print(zmList.docs.toString());
                                   //
                                   //             // Step 2: Loop through each user document
                                   //             for (QueryDocumentSnapshot userDoc in zmList.docs) {
                                   //         print("for loop entered");
                                   //         String userId = userDoc.id;
                                   //         print("user id is $userId");
                                   //         print("user text id is $userIdEditText");
                                   //         //  Map<String, dynamic> existingUserData = userDoc.data() as Map<String, dynamic>;
                                   //
                                   //         // Step 3: Add all user to the "my_users" subcollection of new user
                                   //         print("*******************");
                                   //         await _firestore
                                   //             .collection('companies')
                                   //             .doc(_companyIdController.text.toLowerCase())
                                   //             .collection("region").doc(targetUser["id"].toString()).collection("my_chat_user")
                                   //             .doc(userId)
                                   //             .set({'id':userId.toString()});
                                   //         // Step 3: Add the new user to the "my_users" subcollection of each user
                                   //         await _firestore
                                   //             .collection('companies')
                                   //             .doc(_companyIdController.text.toLowerCase())
                                   //             .collection("region").doc(targetUser["id"].toString()).collection("zone")
                                   //             .doc(userId)
                                   //             .collection('my_chat_user')
                                   //             .doc(targetUser["id"].toString())
                                   //             .set({'id':targetUser["id"].toString()});
                                   //
                                   //         print("one user added");
                                   //             }
                                   //         QuerySnapshot myLevelUser =
                                   //         await _firestore
                                   //             .collection('companies')
                                   //             .doc(_companyIdController.text.toLowerCase().toString())
                                   //             .collection("region").get();
                                   //
                                   //         print("*****************");
                                   //
                                   //         print(myLevelUser);
                                   //
                                   //         print(myLevelUser.docs.toString());
                                   //
                                   //         // Step 2: Loop through each user document
                                   //         for (QueryDocumentSnapshot userDoc in myLevelUser.docs) {
                                   //         print("for loop entered");
                                   //         String userId = userDoc.id;
                                   //         print("user id is $userId");
                                   //         print("user text id is $userIdEditText");
                                   //         //  Map<String, dynamic> existingUserData = userDoc.data() as Map<String, dynamic>;
                                   //
                                   //         if (targetUser["id"].toString() != userId) {
                                   //         // Step 3: Add all user to the "my_users" subcollection of new user
                                   //         print("*******************");
                                   //         await _firestore
                                   //             .collection('companies')
                                   //             .doc(_companyIdController.text.toLowerCase())
                                   //             .collection("region").doc(targetUser["id"].toString()).collection("my_chat_user")
                                   //             .doc(userId)
                                   //             .set({'id':userId.toString()});
                                   //         // Step 3: Add the new user to the "my_users" subcollection of each user
                                   //         await _firestore
                                   //             .collection('companies')
                                   //             .doc(_companyIdController.text.toLowerCase())
                                   //             .collection("region").doc(userId)
                                   //             .collection('my_chat_user')
                                   //             .doc(targetUser["id"].toString())
                                   //             .set({'id':targetUser["id"].toString()});
                                   //
                                   //         print("one user addedd");
                                   //         }
                                   //         }
                                   //
                                   //             print('User added to all my_users collections successfully.');
                                   //           } catch (e) {
                                   //             print('Error adding user: $e');
                                   //           }}
                                   //
                                   //
                                   //         ///
                                   //         /// ZM
                                   //         ///try adding user list
                                   //         if(userType.toLowerCase()=="zm")
                                   //         {
                                   //           try {
                                   //             //first add this user to his superior chat list and add your superior to your chat List
                                   //             await _firestore
                                   //                 .collection('companies')
                                   //                 .doc(_companyIdController.text.toLowerCase())
                                   //                 .collection("region").doc(targetUser["RM"].toString()).collection("my_chat_user").doc(targetUser["id"].toString())
                                   //                 .set({'id':targetUser["id"].toString()});
                                   //             //
                                   //             await _firestore
                                   //                 .collection('companies')
                                   //                 .doc(_companyIdController.text.toLowerCase())
                                   //                 .collection("region").doc(targetUser["RM"].toString()).collection("zone").doc(targetUser["id"].toString())
                                   //             .collection("my_chat_user").doc(targetUser["RM"].toString())
                                   //                 .set({'id':targetUser["RM"].toString()});
                                   //             // Step 1: Get all users in the "user" collection
                                   //             print("trying to add user");
                                   //             print(_companyIdController.text.toLowerCase());
                                   //             print(targetUser["id"].toString());
                                   //             print("zone");
                                   //             print("trying to add user");
                                   //             QuerySnapshot areaManagerList =
                                   //             await _firestore
                                   //                 .collection('companies')
                                   //                 .doc(_companyIdController.text.toLowerCase().toString())
                                   //                 .collection("region").
                                   //             doc(targetUser["RM"].toString()).
                                   //             collection("zone").doc(targetUser["id"].toString()).collection("area").get();
                                   //
                                   //             print("*****************");
                                   //
                                   //             print(areaManagerList);
                                   //
                                   //             print(areaManagerList.docs.toString());
                                   //
                                   //             // Step 2: Loop through each user document
                                   //             for (QueryDocumentSnapshot userDoc in areaManagerList.docs) {
                                   //               print("for loop entered");
                                   //               String userId = userDoc.id;
                                   //               print("user id is $userId");
                                   //               print("user text id is $userIdEditText");
                                   //               //  Map<String, dynamic> existingUserData = userDoc.data() as Map<String, dynamic>;
                                   //
                                   //                 // Step 3: Add all user to the "my_users" sub-collection of new user
                                   //                 print("*******************");
                                   //                 await _firestore
                                   //                     .collection('companies')
                                   //                     .doc(_companyIdController.text.toLowerCase())
                                   //                     .collection("region").doc(targetUser["RM"].toString())
                                   //                     .collection("zone").doc(targetUser["id"].toString())
                                   //                     .collection("my_chat_user")
                                   //                     .doc(userId)
                                   //                     .set({'id':userId.toString()});
                                   //                 // Step 3: Add the new user to the "my_users" subcollection of each user
                                   //                 await _firestore
                                   //                     .collection('companies')
                                   //                     .doc(_companyIdController.text.toLowerCase())
                                   //                     .collection("region").doc(targetUser["RM"].toString())
                                   //                     .collection("zone").doc(targetUser["id"].toString())
                                   //                     .collection("area")
                                   //                     .doc(userId)
                                   //                     .collection('my_chat_user')
                                   //                     .doc(targetUser["id"].toString())
                                   //                     .set({'id':targetUser["id"].toString()});
                                   //
                                   //                 print("one user addedd");
                                   //             }
                                   //
                                   //             QuerySnapshot myLevelUser =
                                   //             await _firestore
                                   //                 .collection('companies')
                                   //                 .doc(_companyIdController.text.toLowerCase().toString())
                                   //                 .collection("region").doc(targetUser["RM"].toString()).collection("zone").get();
                                   //
                                   //             print("*****************");
                                   //
                                   //             print(myLevelUser);
                                   //
                                   //             print(myLevelUser.docs.toString());
                                   //
                                   //             // Step 2: Loop through each user document
                                   //             for (QueryDocumentSnapshot userDoc in myLevelUser.docs) {
                                   //               print("for loop entered");
                                   //               String userId = userDoc.id;
                                   //               print("user id is $userId");
                                   //               print("user text id is $userIdEditText");
                                   //               //  Map<String, dynamic> existingUserData = userDoc.data() as Map<String, dynamic>;
                                   //
                                   //               if (targetUser["id"].toString() != userId) {
                                   //                 // Step 3: Add all user to the "my_users" subcollection of new user
                                   //                 print("*******************");
                                   //                 await _firestore
                                   //                     .collection('companies')
                                   //                     .doc(_companyIdController.text.toLowerCase())
                                   //                     .collection("region").doc(targetUser["RM"].toString()).collection("zone")
                                   //                     .doc(targetUser["id"].toString())
                                   //                     .collection("my_chat_user")
                                   //                     .doc(userId)
                                   //                     .set({'id':userId.toString()});
                                   //                 // Step 3: Add the new user to the "my_users" subcollection of each user
                                   //                 await _firestore
                                   //                     .collection('companies')
                                   //                     .doc(_companyIdController.text.toLowerCase())
                                   //                     .collection("region").doc(targetUser["RM"].toString())
                                   //                     .collection("zone").doc(userId)
                                   //                     .collection('my_chat_user')
                                   //                     .doc(targetUser["id"].toString())
                                   //                     .set({'id':targetUser["id"].toString()});
                                   //
                                   //                 print("one user added");
                                   //               }
                                   //             }
                                   //
                                   //             print('User added to all my_users collections successfully.');
                                   //           } catch (e) {
                                   //             print('Error adding user: $e');
                                   //           }
                                   //
                                   //         }
                                   //         ///
                                   //         /// AM
                                   //         ///try adding user list
                                   //         if(userType.toLowerCase()=="am")
                                   //         {
                                   //           try {
                                   //             //first add this user to his superior chat list and add your superior to your chat List
                                   //             await _firestore
                                   //                 .collection('companies')
                                   //                 .doc(_companyIdController.text.toLowerCase())
                                   //                 .collection("region").doc(targetUser["RM"].toString())
                                   //                 .collection("zone").doc(targetUser["ZM"].toString())
                                   //                 .collection("my_chat_user").doc(targetUser["id"].toString())
                                   //                 .set({'id':targetUser["id"].toString()});
                                   //             //
                                   //             await _firestore
                                   //                 .collection('companies')
                                   //                 .doc(_companyIdController.text.toLowerCase())
                                   //                 .collection("region").doc(targetUser["RM"].toString()).collection("zone")
                                   //                 .doc(targetUser["ZM"].toString()).collection("area")
                                   //                 .doc(targetUser["id"].toString())
                                   //                 .collection("my_chat_user").doc(targetUser["ZM"].toString())
                                   //                 .set({'id':targetUser["ZM"].toString()});
                                   //             // Step 1: Get all users in the "user" collection
                                   //             print("trying to add user");
                                   //             print(_companyIdController.text.toLowerCase());
                                   //             print(targetUser["id"].toString());
                                   //             print("zone");
                                   //             print("trying to add user");
                                   //             QuerySnapshot repList =
                                   //             await _firestore
                                   //                 .collection('companies')
                                   //                 .doc(_companyIdController.text.toLowerCase().toString())
                                   //                 .collection("region").
                                   //             doc(targetUser["RM"].toString()).
                                   //             collection("zone").doc(targetUser["ZM"].toString()).collection("area")
                                   //                 .doc(targetUser["id"].toString()).
                                   //             collection("rep_list").get();
                                   //
                                   //             print("*****************");
                                   //
                                   //             print(repList);
                                   //
                                   //             print(repList.docs.toString());
                                   //
                                   //             // Step 2: Loop through each user document
                                   //             for (QueryDocumentSnapshot userDoc in repList.docs) {
                                   //               print("for loop entered");
                                   //               String userId = userDoc.id;
                                   //               print("user id is $userId");
                                   //               print("user text id is $userIdEditText");
                                   //               //  Map<String, dynamic> existingUserData = userDoc.data() as Map<String, dynamic>;
                                   //
                                   //               // Step 3: Add all user to the "my_users" sub-collection of new user
                                   //               print("*******************");
                                   //               await _firestore
                                   //                   .collection('companies')
                                   //                   .doc(_companyIdController.text.toLowerCase())
                                   //                   .collection("region").doc(targetUser["RM"].toString())
                                   //                   .collection("zone").doc(targetUser["ZM"].toString())
                                   //                   .collection("area").doc(targetUser["id"].toString())
                                   //                   .collection("my_chat_user")
                                   //                   .doc(userId)
                                   //                   .set({'id':userId.toString()});
                                   //               // Step 3: Add the new user to the "my_users" subcollection of each user
                                   //               await _firestore
                                   //                   .collection('companies')
                                   //                   .doc(_companyIdController.text.toLowerCase())
                                   //                   .collection("region").doc(targetUser["RM"].toString())
                                   //                   .collection("zone").doc(targetUser["ZM"].toString())
                                   //                   .collection("area").doc(targetUser["id"].toString())
                                   //                   .collection("rep_list")
                                   //                   .doc(userId)
                                   //                   .collection('my_chat_user')
                                   //                   .doc(targetUser["id"].toString())
                                   //                   .set({'id':targetUser["id"].toString()});
                                   //
                                   //               print("one user added");
                                   //             }
                                   //
                                   //             QuerySnapshot myLevelUser =
                                   //             await _firestore
                                   //                 .collection('companies')
                                   //                 .doc(_companyIdController.text.toLowerCase().toString())
                                   //                 .collection("region").doc(targetUser["RM"].toString())
                                   //                 .collection("zone").doc(targetUser["ZM"].toString())
                                   //             .collection("area").get();
                                   //
                                   //             print("*****************");
                                   //
                                   //             print(myLevelUser);
                                   //
                                   //             print(myLevelUser.docs.toString());
                                   //
                                   //             // Step 2: Loop through each user document
                                   //             for (QueryDocumentSnapshot userDoc in myLevelUser.docs) {
                                   //               print("for loop entered");
                                   //               String userId = userDoc.id;
                                   //               print("user id is $userId");
                                   //               print("user text id is $userIdEditText");
                                   //               //  Map<String, dynamic> existingUserData = userDoc.data() as Map<String, dynamic>;
                                   //
                                   //               if (targetUser["id"].toString() != userId) {
                                   //                 // Step 3: Add all user to the "my_users" subcollection of new user
                                   //                 print("*******************");
                                   //                 await _firestore
                                   //                     .collection('companies')
                                   //                     .doc(_companyIdController.text.toLowerCase())
                                   //                     .collection("region").doc(targetUser["RM"].toString())
                                   //                     .collection("zone").doc(targetUser["ZM"].toString()).collection("area")
                                   //                     .doc(targetUser["id"].toString()).collection("my_chat_user")
                                   //                     .doc(userId)
                                   //                     .set({'id':userId.toString()});
                                   //                 // Step 3: Add the new user to the "my_users" subcollection of each user
                                   //                 await _firestore
                                   //                     .collection('companies')
                                   //                     .doc(_companyIdController.text.toLowerCase())
                                   //                     .collection("region").doc(targetUser["RM"].toString())
                                   //                     .collection("zone").doc(targetUser["ZM"].toString())
                                   //                     .collection("area").doc(userId)
                                   //                     .collection('my_chat_user')
                                   //                     .doc(targetUser["id"].toString())
                                   //                     .set({'id':targetUser["id"].toString()});
                                   //
                                   //                 print("one user addedd");
                                   //               }
                                   //             }
                                   //
                                   //             print('User added to all my_users collections successfully.');
                                   //           } catch (e) {
                                   //             print('Error adding user: $e');
                                   //           }
                                   //
                                   //         }
                                   //         ///
                                   //         ///
                                   //         ///
                                   //         /// REP section
                                   //         ///try adding user list
                                   //         if(userType.toLowerCase()=="rep")
                                   //         {
                                   //           try {
                                   //             //first add this user to his superior chat list and add your superior to your chat List
                                   //             await _firestore
                                   //                 .collection('companies')
                                   //                 .doc(_companyIdController.text.toLowerCase())
                                   //                 .collection("region").doc(targetUser["RM"].toString())
                                   //                 .collection("zone").doc(targetUser["ZM"].toString())
                                   //                  .collection("area").doc(targetUser["AM"].toString())
                                   //                 .collection("my_chat_user").doc(targetUser["id"].toString())
                                   //                 .set({'id':targetUser["id"].toString()});
                                   //             //
                                   //             await _firestore
                                   //                 .collection('companies')
                                   //                 .doc(_companyIdController.text.toLowerCase())
                                   //                 .collection("region").doc(targetUser["RM"].toString()).collection("zone")
                                   //                 .doc(targetUser["ZM"].toString()).collection("area").doc(targetUser["AM"].toString())
                                   //                 .collection("rep_list")
                                   //                 .doc(targetUser["id"].toString())
                                   //                 .collection("my_chat_user").doc(targetUser["AM"].toString())
                                   //                 .set({'id':targetUser["AM"].toString()});
                                   //             // // Step 1: Get all users in the "user" collection
                                   //             // print("trying to add user");
                                   //             // print(_companyIdController.text.toLowerCase());
                                   //             // print(targetUser["id"].toString());
                                   //             // print("zone");
                                   //             // print("trying to add user");
                                   //             // QuerySnapshot repList =
                                   //             // await _firestore
                                   //             //     .collection('companies')
                                   //             //     .doc(_companyIdController.text.toLowerCase().toString())
                                   //             //     .collection("region").
                                   //             // doc(targetUser["RM"].toString()).
                                   //             // collection("zone").doc(targetUser["ZM"].toString()).collection("area")
                                   //             //     .doc(targetUser["id"].toString()).
                                   //             // collection("rep_list").get();
                                   //             //
                                   //             // print("*****************");
                                   //             //
                                   //             // print(repList);
                                   //             //
                                   //             // print(repList.docs.toString());
                                   //             //
                                   //             // // Step 2: Loop through each user document
                                   //             // for (QueryDocumentSnapshot userDoc in repList.docs) {
                                   //             //   print("for loop entered");
                                   //             //   String userId = userDoc.id;
                                   //             //   print("user id is $userId");
                                   //             //   print("user text id is $userIdEditText");
                                   //             //   //  Map<String, dynamic> existingUserData = userDoc.data() as Map<String, dynamic>;
                                   //             //
                                   //             //   // Step 3: Add all user to the "my_users" sub-collection of new user
                                   //             //   print("*******************");
                                   //             //   await _firestore
                                   //             //       .collection('companies')
                                   //             //       .doc(_companyIdController.text.toLowerCase())
                                   //             //       .collection("region").doc(targetUser["RM"])
                                   //             //       .collection("zone").doc(targetUser["ZM"].toString())
                                   //             //       .collection("area").doc(targetUser["id"].toString())
                                   //             //       .collection("my_chat_user")
                                   //             //       .doc(userId)
                                   //             //       .set({'id':userId.toString()});
                                   //             //   // Step 3: Add the new user to the "my_users" subcollection of each user
                                   //             //   await _firestore
                                   //             //       .collection('companies')
                                   //             //       .doc(_companyIdController.text.toLowerCase())
                                   //             //       .collection("region").doc(targetUser["RM"].toString())
                                   //             //       .collection("zone").doc(targetUser["ZM"].toString())
                                   //             //       .collection("area").doc(targetUser["id"].toString())
                                   //             //       .collection("rep_list")
                                   //             //       .doc(userId)
                                   //             //       .collection('my_chat_user')
                                   //             //       .doc(targetUser["id"].toString())
                                   //             //       .set({'id':targetUser["id"].toString()});
                                   //             //
                                   //             //   print("one user added");
                                   //             // }
                                   //
                                   //             QuerySnapshot myLevelUser =
                                   //             await _firestore
                                   //                 .collection('companies')
                                   //                 .doc(_companyIdController.text.toLowerCase().toString())
                                   //                 .collection("region").doc(targetUser["RM"].toString())
                                   //                 .collection("zone").doc(targetUser["ZM"].toString())
                                   //                 .collection("area").doc(targetUser["AM"].toString())
                                   //                 .collection("rep_list").get();
                                   //
                                   //             print("*****************");
                                   //
                                   //             print(myLevelUser);
                                   //
                                   //             print(myLevelUser.docs.toString());
                                   //
                                   //             // Step 2: Loop through each user document
                                   //             for (QueryDocumentSnapshot userDoc in myLevelUser.docs) {
                                   //               print("for loop entered");
                                   //               String userId = userDoc.id;
                                   //               print("user id is $userId");
                                   //               print("user text id is $userIdEditText");
                                   //               //  Map<String, dynamic> existingUserData = userDoc.data() as Map<String, dynamic>;
                                   //
                                   //               if (targetUser["id"].toString() != userId) {
                                   //                 // Step 3: Add all user to the "my_users" subcollection of new user
                                   //                 print("*******************");
                                   //                 await _firestore
                                   //                     .collection('companies')
                                   //                     .doc(_companyIdController.text.toLowerCase())
                                   //                     .collection("region").doc(targetUser["RM"].toString())
                                   //                     .collection("zone").doc(targetUser["ZM"].toString())
                                   //                     .collection("area").doc(targetUser["AM"].toString()).collection("rep_list")
                                   //                     .doc(targetUser["id"].toString()).collection("my_chat_user")
                                   //                     .doc(userId)
                                   //                     .set({'id':userId.toString()});
                                   //                 // Step 3: Add the new user to the "my_users" subcollection of each user
                                   //                 await _firestore
                                   //                     .collection('companies')
                                   //                     .doc(_companyIdController.text.toLowerCase())
                                   //                     .collection("region").doc(targetUser["RM"].toString())
                                   //                     .collection("zone").doc(targetUser["ZM"].toString())
                                   //                     .collection("area").doc(targetUser["AM"].toString())
                                   //                     .collection("rep_list").doc(userId)
                                   //                     .collection('my_chat_user').doc(targetUser["id"].toString())
                                   //                     .set({'id':targetUser["id"].toString()});
                                   //                 print("one user addedd");
                                   //               }
                                   //             }
                                   //
                                   //             print('User added to all my_users collections successfully.');
                                   //           } catch (e) {
                                   //             print('Error adding user: $e');
                                   //           }
                                   //
                                   //         }
                                   //         ///
                                   //         ///
                                   //
                                   //
                                   //
                                   //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Done")));
                                   //       }
                                   //       else
                                   //         {
                                   //           print('user already has');
                                   //         }
                                   //
                                   //
                                   //    }
                                      ///*******end******//

                                      bool result = await NetworkConnecticity.checkConnectivity();

                                      if (result == true) {
                                        final userid = box.get("USER_ID");
                                        // debugPrint(
                                        //     "User Iddddddddddadssdfs:$userid");

                                        dmPath(deviceId, deviceBrand, deviceModel, _companyIdController.text.trim().toUpperCase(), _userIdController.text.trim(), _passwordController.text.trim(), context);
                                      } else {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        AllServices().messageForUser('no_internet_connection'.tr());

                                        // debugPrint(InternetConnectionChecker()
                                        //     .lastTryResults);
                                      }
                                    } else {}
                                  },
                                  child: Text(
                                    'login'.tr(),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 30,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.0,
                    ),
                    decoration: BoxDecoration(color: Colors.green.shade300),
                    child: Text(
                      "$appVersion",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  // buildShowDialog(BuildContext context) {
  //   return showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: const [
  //             CircularProgressIndicator(
  //               color: Colors.white,
  //             ),
  //             SizedBox(
  //               height: 10,
  //             ),
  //           ],
  //         );
  //       });
  // }

  ///********************************** Dm Path and Login function***********************************************************

  Future dmPath(String? deviceId, String? deviceBrand, String? deviceModel,
      String cid, String userId, String password, BuildContext context) async {
    // debugPrint("DM::patht **************: $userId");

    try {
      debugPrint(
          // "http://192.168.0.102:8000/apx_pharma_api/dmpath_v07/get_dmpath?cid=$cid");
          "https://w05.yeapps.com/dmpath/dmpath_v07/get_dmpath?cid=$cid");
      final http.Response response = await http.get(
        Uri.parse(
            // 'http://192.168.0.102:8000/apx_pharma_api/dmpath_v07/get_dmpath?cid=$cid'),
            'https://w05.yeapps.com/dmpath/dmpath_v07/get_dmpath?cid=$cid'),
      );

      var userInfo = json.decode(response.body);

      var status = userInfo['res_data'];
      if (status['ret_res'] == 'Welcome to mReporting.') {
        AllServices().messageForUser("Wrong CID");

        setState(() {
          isLoading = false;
        });
      } else {
        print(status);
        var login_url = status['login_url'];
        String sync_url = status['sync_url'] ?? '';
        String submit_url = status['submit_url'];
        String report_sales_url = status['report_sales_url'];
        String report_dcr_url = status['report_dcr_url'];
        String report_rx_url = status['report_rx_url'];
        String photo_submit_url = status['photo_submit_url'];
        String photo_url = status['photo_url'];
        String leave_request_url = status['leave_request_url'];
        String leave_report_url = status['leave_report_url'];
        String plugin_url = status['plugin_url'];
        String tour_plan_url = status['tour_plan_url'];
        String tour_compliance_url = status['tour_compliance_url'];
        String client_url = status['client_url'];
        String doctor_url = status['doctor_url'];
        String doctor_edit_url = status['doctor_edit_url'];
        String microunion_url = status['microunion_url'];
        String activity_log_url = status['activity_log_url'];
        String user_sales_coll_ach_url = status['user_sales_coll_ach_url'];
        String client_outst_url = status['client_outst_url'];
        String user_area_url = status['user_area_url'];
        String os_details_url = status['os_details_url'];
        String ord_history_url = status['ord_history_url'];
        String inv_history_url = status['inv_history_url'];
        String client_edit_url = status['client_edit_url'];
        String timer_track_url = status['timer_track_url'];
        String exp_type_url = status['exp_type_url'];
        String exp_submit_url = status['exp_submit_url'];
        String report_exp_url = status['report_exp_url'];
        String report_exp_log = status['report_exp_log'];
        String report_outst_url = status['report_outst_url'];
        String report_last_ord_url = status['report_last_ord_url'];
        String report_last_inv_url = status['report_last_inv_url'];
        String exp_approval_url = status['exp_approval_url'];
        String sync_notice_url = status['sync_notice_url'];
        String report_atten_url = status['report_atten_url'];
        String approval_url = status['approval_url'];
        String late_attendance_url = status['late_attendance_url'] ?? "";
        String order_approval_url = status['order_approval_url'] ?? "";
        String order_list_url = status['order_list_url'] ?? "";

        // //todo Add HIVe,

        //todo! Start Hive

        await box.put('sync_url', sync_url);
        await box.put('report_sales_url', report_sales_url);
        await box.put('report_dcr_url', report_dcr_url);
        await box.put('report_rx_url', report_rx_url);
        await box.put('submit_url', submit_url);
        await box.put('photo_submit_url', photo_submit_url);
        await box.put('activity_log_url', activity_log_url);
        await box.put('client_outst_url', client_outst_url);
        await box.put('user_area_url', user_area_url);
        await box.put('photo_url', photo_url);
        await box.put('leave_request_url', leave_request_url);
        await box.put('leave_report_url', leave_report_url);
        await box.put('plugin_url', plugin_url);
        await box.put('tour_plan_url', tour_plan_url);
        await box.put('tour_compliance_url', tour_compliance_url);
        await box.put('client_url', client_url);
        await box.put('doctor_url', doctor_url);
        await box.put('doctor_edit_url', doctor_edit_url);
        await box.put('microunion_url', microunion_url);
        await box.put('user_sales_coll_ach_url', user_sales_coll_ach_url);
        await box.put('os_details_url', os_details_url);
        await box.put('ord_history_url', ord_history_url);
        await box.put('inv_history_url', inv_history_url);
        await box.put('client_edit_url', client_edit_url);
        await box.put('timer_track_url', timer_track_url);
        await box.put('exp_type_url', exp_type_url);
        await box.put('exp_submit_url', exp_submit_url);
        await box.put('report_exp_url', report_exp_url);
        await box.put('report_exp_log', report_exp_log);
        await box.put('report_outst_url', report_outst_url);
        await box.put('report_last_ord_url', report_last_ord_url);
        await box.put('report_last_inv_url', report_last_inv_url);
        await box.put('exp_approval_url', exp_approval_url);
        await box.put('sync_notice_url', sync_notice_url);
        await box.put('report_atten_url', report_atten_url);
        await box.put('approval_url', approval_url);
        await box.put('late_attendance_url', late_attendance_url);
        await box.put('order_approval_url', order_approval_url);
        await box.put('order_list_url', order_list_url);
        // await box.put('late_attendance_report_url',late_attendance_report_url);
        await secureStorage.write(
            key: 'timer_track_url', value: timer_track_url.toString());

        await login(deviceId, deviceBrand, deviceModel, cid, userId, password,
            login_url, context);
      }

      // return isLoading;
    } on Exception catch (e) {
      // throw Exception(e);
      debugPrint("$e");
    }
  }

  Future login(
      String? deviceId,
      String? deviceBrand,
      String? deviceModel,
      String cid,
      String userId,
      String password,
      String loginUrl,
      BuildContext context) async {
    version = 'v03';
    String _url =
        // 'http://192.168.0.102:8000/apx_pharma_api/api_login/check_user?cid=APEX&user_id=9657&user_pass=1234&device_id=UP1A.231005.007&device_brand=samsung&device_model=SM-A055F_v03&app_version=v-20240612___test';
        '$loginUrl?cid=$cid&user_id=$userId&user_pass=$password&device_id=$deviceId&device_brand=$deviceBrand&device_model=${deviceModel}_${version}&app_version=${appVersion}';
    // '$loginUrl?cid=APEX&user_id=9657&user_pass=1234&device_id=UP1A.231005.007&device_brand=samsung&device_model=SM-A055F_v03&app_version=v-20240612___test';
    print(_url);
    debugPrint(_url);
    try {
      final http.Response response = await http.get(
        Uri.parse(_url),
      );

      // final Map<String, dynamic> jsonresponse = json.decode(response.body);

      var userInfo = json.decode(response.body);
      var status = userInfo['status'];

      if (status == 'Success') {

        setState(() {
          isLoading = true;
        });
        print(userInfo);

        String userName = userInfo['user_name'];
        String user_id = userInfo['user_id'];
        String mobile_no = userInfo['mobile_no'];
        String? logo_url_1 = userInfo['logo_url_1'] ?? null;
        String? logo_url_2 = userInfo['logo_url_2'] ?? null;
        // Map<String, dynamic> buttonNames = {
        //   "new_order": "",
        //   "draft_order": "Draft Order",
        //   "order_report": "Report",
        //   // "new_dcr": "New DCR Button",
        //   // "draft_dcr": "Draft DCR Button",
        //   "dcr_report": "DCR Report",
        //   "seen_rx_capture": "RX Sent",
        //   "draft_seen_rx": "Draft Seen Rx",
        //   "seen_rx_report": "Seen RX Report",
        //   "attendance": "Attendance",
        //   "expense": "Expense",
        //   "tour_plan": "Tour Plan",
        //   "approval": "Approval",
        //   "plug_in_reports": "Plug-in & Reports",
        //   "activity_log": "Activity Log",
        //   "notice": "Notice",
        //   "sync_data": "Sync Data",
        //   "leave_request": "Leave Request",
        //   "leave_report":	"Leave Report"
        // };
        Map<String, dynamic>? buttonNames = userInfo['button_names'] ?? {};
        offer_flag = userInfo['offer_flag'];
        note_flag = userInfo['note_flag'];
        client_edit_flag = userInfo['client_edit_flag'];
        os_show_flag = userInfo['os_show_flag'];
        os_details_flag = userInfo['os_details_flag'];
        ord_history_flag = userInfo['ord_history_flag'];
        inv_histroy_flag = userInfo['inv_histroy_flag'];
        background_service = userInfo['background_service'];
        notice_reload_duration = userInfo['notice_reload_duration'] ?? 60;
        // notice_reload_duration = 1;
        timer_flag = userInfo['timer_flag'];
        rx_doc_must = userInfo['rx_doc_must'];
        rx_type_must = userInfo['rx_type_must'];
        rx_gallery_allow = userInfo['rx_gallery_allow'];

        List dcr_visit_with_list = userInfo['dcr_visit_with_list'];

        List rx_type_list = userInfo['rx_type_list'];
        bool order_flag = userInfo['order_flag'];
        bool dcr_flag = userInfo['dcr_flag'];
        bool rx_flag = userInfo['rx_flag'];
        bool others_flag = userInfo['others_flag'];
        bool client_flag = userInfo['client_flag'];
        bool visit_plan_flag = userInfo['visit_plan_flag'];
        bool plagin_flag = userInfo['plagin_flag'];
        bool dcr_discussion = userInfo['dcr_discussion'];
        bool promo_flag = userInfo['promo_flag'];
        bool leave_flag = userInfo['leave_flag'];
        bool notice_flag = userInfo['notice_flag'];
        bool doc_flag = userInfo['doc_flag'];
        bool doc_edit_flag = userInfo['doc_edit_flag'];
        // bool notice_auto_scroll_flag = userInfo['notice_auto_scroll_flag'] ?? false;
        bool notice_auto_scroll_flag =
            userInfo['notice_auto_scroll_flag'] ?? false;
        bool attendance_approval_flag =
            userInfo['attendance_approval_flag'] ?? false;
        bool order_approval_fkag = userInfo['order_approval_flag'] ?? false;
        String meter_reading_last = userInfo['meter_reading_last'] ?? '0';
        List exp_reject_reason = userInfo['exp_reject_reason'];
        bool exp_approval_flag = userInfo['exp_approval_flag'];
        List cause_for_non_execution = userInfo['cause_for_non_execution'];
        List expense_category_list = userInfo['expense_category_list'] ?? [];
        List areaList = userInfo['area'] ?? [];
        bool transport_mode = userInfo['transport_mode'] ?? true;
        bool auto_day_end = userInfo['auto_day_end'] ?? false;
        String startTime = userInfo['start_time'] ?? '';
        String endTime = userInfo['end_time'] ?? '';
        bool target_sales_achievement_flag =
            userInfo['target_sales_achievement_flag'] ?? false;
        //Check existing users Save data Delete if user does not match
        await AuthServices.checkExistingUser(user_id);

        //todo User basis lavel ar jonnno
//
        // List ff_list = userInfo['ff_list'];
        // ff_user_list.clear();
        // for (var element in ff_list) {
        //   ff_user_list.add(element);
        // }
        // box.put('ff_list', ff_user_list);
//
        user_basis_level_list.clear();
        box.put('user_basis_level_list', user_basis_level_list);
        if (userInfo['exp_approval_flag'] == true) {
          List user_basis_level = userInfo['user_basis_level'];
          for (var element in user_basis_level) {
            user_basis_level_list.add(element);
          }
          box.put('user_basis_level_list', user_basis_level_list);
        }
        //todo User basis lavel ar jonnno

        debugPrint("Rejected Reson is::::::$exp_reject_reason");

        debugPrint(
            'Last Metter Reading ${meter_reading_last.isNotEmpty ? meter_reading_last : '0'}');

        dcr_visitedWithList.clear();
        for (int i = 0; i < dcr_visit_with_list.length; i++) {
          dcr_visitedWithList.add(dcr_visit_with_list[i]);
        }
        rxTypeList.clear();
        for (var element in rx_type_list) {
          rxTypeList.add(element);
        }
        exp_reject_reasonList.clear();
        for (var element in exp_reject_reason) {
          exp_reject_reasonList.add(element);
        }
        cause_for_non_execution_list.clear();
        for (var element in cause_for_non_execution) {
          cause_for_non_execution_list.add(element);
        }

        debugPrint("NNNEWWW LISt is :::::::$exp_reject_reasonList");

        //todo Add data HIVe......

        // box.put('PASSWORD', user_pass);

        if (buttonNames != null) {
          await putButtonNames(buttonNames);
        }
        await box.put('CID', cid);
        await box.put("USER_ID", user_id);
        await box.put('areaPage', userInfo['area_page']);
        await box.put('userName', userName);
        await box.put('logo_url_1', logo_url_1);
        await box.put('logo_url_2', logo_url_2);
        await box.put('notice_reload_duration', notice_reload_duration);
        await box.put('user_id', user_id);
        await box.put('PASSWORD', password);
        await box.put('mobile_no', mobile_no);
        await box.put('offer_flag', offer_flag);
        await box.put('note_flag', note_flag!);
        await box.put('client_edit_flag', client_edit_flag!);
        await box.put('os_show_flag', os_show_flag!);
        await box.put('os_details_flag', os_details_flag!);
        await box.put('ord_history_flag', ord_history_flag!);
        await box.put('inv_histroy_flag', inv_histroy_flag!);
        await box.put('client_flag', client_flag);
        await box.put('rx_doc_must', rx_doc_must!);
        await box.put('rx_type_must', rx_type_must!);
        await box.put('rx_gallery_allow', rx_gallery_allow!);
        await box.put('order_flag', order_flag);
        await box.put('dcr_flag', dcr_flag);
        await box.put('timer_flag', timer_flag);
        await box.put('background_service', background_service);
        await box.put('auto_day_end', auto_day_end);
        await box.put('rx_flag', rx_flag);
        await box.put('others_flag', others_flag);
        await box.put('visit_plan_flag', visit_plan_flag);
        await box.put('plagin_flag', plagin_flag);
        await box.put('dcr_discussion', dcr_discussion);
        await box.put('promo_flag', promo_flag);
        await box.put('leave_flag', leave_flag);
        await box.put('notice_flag', notice_flag);
        await box.put('notice_auto_scroll_flag', notice_auto_scroll_flag);
        await box.put('doc_flag', doc_flag);
        await box.put('doc_edit_flag', doc_edit_flag);
        await box.put(
            'target_sales_achievement_flag', target_sales_achievement_flag);
        await box.put('attendance_approval_flag', attendance_approval_flag);
        await box.put('order_approval_flag', order_approval_fkag);
        await box.put('dcr_visit_with_list', dcr_visitedWithList);
        await box.put('meter_reading_last',
            meter_reading_last.isNotEmpty ? meter_reading_last : '0');
        await box.put('exp_approval_flag', exp_approval_flag);
        await box.put('rx_type_list', rxTypeList);
        await box.put('exp_reject_reason', exp_reject_reasonList);
        await box.put(
            'cause_for_non_execution_list', cause_for_non_execution_list);
        await box.put('expense_category_list', expense_category_list);
        await box.put('area_list', areaList);
        await box.put('transport_mode', transport_mode);
        await Boxes.allData().put('withoutMReading', false);
        print("---------------------------- bg: ${background_service}");
        await secureStorage.write(key: 'cid', value: cid.toString().trim());
        await secureStorage.write(
            key: 'userId', value: userId.toString().trim());
        await secureStorage.write(
            key: 'password', value: password.toString().trim());
        await secureStorage.write(
            key: 'background_service', value: background_service.toString());
        await secureStorage.write(
            key: 'device_mac', value: deviceId.toString());

        ///already attendance
        if (startTime != '') {
          box.put(
              'attendance', DateFormat('yyyy-MM-dd').format(DateTime.now()));
          box.put('attendanceUserId', user_id.toString());
        }
        if (startTime != '' && endTime != '') {
          box.put('attendance', '');
        }
        await box.put('startTime', startTime);
        await box.put('endTime', endTime);

        //todo! Add New  bg Service
        if (SameDeviceId == false) {
          debugPrint(SameDeviceId);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const SplashScreen()),
              (route) => false);
          setState(() {});
        }

        //!Hive.openBox('data').then(
        //!  (value) {
        // var mymap = value.toMap().values.toList();
        //! List clientToken = value.toMap().values.toList();
        ///code for firebase chat. for now make it comment out
        // UserInfoModel userInfoModel = new UserInfoModel();
        // userInfoModel.name = userName;
        // userInfoModel.userId = userId;
        // userInfoModel.depotName = mobile_no;
        // print("user depot is $mobile_no");
        // // deleteChace();
        // await Boxes.userData().put('user', json.encode(userInfoModel.toJson()));
        // print("this is the value of users:");
        // print(Boxes.userData().get("user").toString());
        // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
        // //var userRef = _firestore.collection('depotList').doc(mobile_no).collection("users").doc(user_id);
        // //base entry point _firestore.collection('chat_feature').doc(cid.toLowerCase()).collection("region")
        // var userRef = _firestore
        //     .collection('chat_feature')
        //     .doc(cid.toLowerCase())
        //     .collection("region")
        //     .doc(user_id);
        //
        // // Check if the user with the given user_id already exists
        // bool isExist = (await userRef.get()).exists;
        //
        // if (!isExist) {
        //   userInfoModel.lastMsgSent = DateTime.now();
        //   await userRef.set(userInfoModel.toJson());
        //   try {
        //     // Step 1: Get all users in the "user" collection
        //     QuerySnapshot userSnapshot = await _firestore
        //         .collection('depotList')
        //         .doc(mobile_no)
        //         .collection("users")
        //         .get();
        //
        //     // Step 2: Loop through each user document
        //     for (QueryDocumentSnapshot userDoc in userSnapshot.docs) {
        //       String userId = userDoc.id;
        //       //  Map<String, dynamic> existingUserData = userDoc.data() as Map<String, dynamic>;
        //
        //       if (user_id != userId) {
        //         // Step 3: Add the new user to the "my_users" subcollection of each user
        //         await _firestore
        //             .collection("depotList")
        //             .doc(mobile_no)
        //             .collection('users')
        //             .doc(userId)
        //             .collection('my_users')
        //             .doc(userInfoModel.userId)
        //             .set(userInfoModel.toJson());
        //         await _firestore
        //             .collection("depotList")
        //             .doc(mobile_no)
        //             .collection('users')
        //             .doc(user_id)
        //             .collection('my_users')
        //             .doc(userId)
        //             .set(userDoc.data() as Map<String, dynamic>);
        //       }
        //     }
        //
        //     print('User added to all my_users collections successfully.');
        //   } catch (e) {
        //     print('Error adding user: $e');
        //   }
        //   // userInfoModel.userType=user;
        //
        //   // User does not exist, add a new user entry
        //
        //   print("User information updated for user_id: $user_id");
        // }
        List clientToken = Hive.box("dcrListData").values.toList();

        if (clientToken.isNotEmpty && savedUserId == userId) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MyHomePage(
                userName: userName,
                user_id: user_id,
                userPassword: password,
              ),
            ),
          );
        } else {
          // if (background_service == true) {
          //   restartBackgroundService();
          // } else {
          //   stopBackgroundService();
          // }
          // Hive.openBox('data').then((value) => value.clear());
          // Hive.openBox('syncItemData').then((value) => value.clear());
          // Hive.openBox('dcrListData').then((value) => value.clear());
          // Hive.openBox('dcrGiftListData').then((value) => value.clear());
          // Hive.openBox('dcrSampleListData').then((value) => value.clear());
          // Hive.openBox('dcrPpmListData').then((value) => value.clear());
          // Hive.openBox('medicineList').then((value) => value.clear());

          await Hive.box('draftForExpense').clear();
          await Hive.box('VisitedWithNotes').clear();
          await Hive.box<MedicineListModel>('draftMdicinList').clear();
          await Hive.box<RxDcrDataModel>('RxdDoctor').clear();
          await Hive.box<DcrGSPDataModel>('selectedDcrGSP').clear();
          await Hive.box<DcrDataModel>('selectedDcr').clear();
          await Hive.box<CustomerDataModel>('customerHive').clear();
          await Hive.box<AddItemModel>('orderedItem').clear();
          await Hive.box("syncItemData").clear();
          // Hive.box("dcrListData").clear();//todo Old
          await Hive.box("mpoForDoctor").clear(); //todo New
          await Hive.box("dcrGiftListData").clear();
          await Hive.box("dcrSampleListData").clear();
          await Hive.box("dcrPpmListData").clear();
          // Hive.box("data").clear();//todo Old
          await Hive.box("mpoForClaient").clear(); //todo new
          await Hive.box("medicineList").clear();
          // var alldata = Hive.box("alldata");
          // alldata.put("startTime", "");
          // alldata.put("endTime", "");
          // alldata.put("present", "");

          await Hive.box("dcrDiscussionListData").clear();

          // await _firestore.collection('users').add({"user_id": user_id, "name": userName});
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => SyncDataTabScreen(
                cid: cid,
                userId: user_id,
                userPassword: password,
              ),
            ),
          );
        }
      } else {
        AllServices().messageForUser(userInfo['ret_str'].toString());
      }
    } on Exception catch (_) {
      throw Exception("Error on server");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Future deleteChace() async {
  //   await getTemporaryDirectory().then(
  //     (value) {
  //       Directory(value.path).delete(recursive: true);
  //     },
  //   );
  // }

  // getPermission() async {
  //   serviceEnabled = await location.serviceEnabled();
  //   if (!serviceEnabled!) {
  //     serviceEnabled = await location.requestService();
  //     if (!serviceEnabled!) {
  //       return;
  //     }
  //   }

  //   permissionGranted = await location.hasPermission();
  //   if (permissionGranted == PermissionStatus.denied) {
  //     permissionGranted = await location.requestPermission();
  //     if (permissionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }
  // }
  // code write by monir for test
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,
      // auto start service
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
  service.startService();
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
      service.setAsBackgroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
      service.setAsForegroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  var location_string = '';
  var location_count = 0;
  await checkLocationPermision();

  Timer.periodic(Duration(minutes: 5), (timer) async {
    service.on('stopService').listen((event) {
      service.stopSelf();
      timer.cancel();
    });
    String? storedCID = await _secureStorage.read(key: 'cid');
    String? storedUserId = await _secureStorage.read(key: 'userId');
    String? storedPassword = await _secureStorage.read(key: 'password');
    String? storedDeviceMac = await _secureStorage.read(key: 'device_mac');

    String? location_tracking_url =
        await _secureStorage.read(key: 'timer_track_url');
    String? location_tracking_service =
        await _secureStorage.read(key: 'background_service') ?? 'false';

    if (storedCID == null ||
        storedCID.isEmpty ||
        storedUserId == null ||
        storedUserId.isEmpty ||
        storedPassword == null ||
        storedPassword.isEmpty ||
        location_tracking_service == "false") {
      timer.cancel();
      await stopBackgroundService();
    } else {
      bool network = await NetworkConnecticity.checkConnectivity();
      if (network == true) {
        print("1");
        LocationPermission checkPermission = await Geolocator.checkPermission();
        if (await Geolocator.isLocationServiceEnabled()) {
          print("2");
          if (checkPermission == LocationPermission.always) {
            print("3");
            Position position = await Geolocator.getCurrentPosition();
            List<geocoding.Placemark> placemarks =
                await geocoding.placemarkFromCoordinates(
                    position.latitude, position.longitude);
            String address =
                "${placemarks[0].street!} ${placemarks[0].country!}";
            String nowDateTime =
                DateFormat('yyyy-MM-dd h.m.s').format(DateTime.now());

            if ((20.0 <= position.latitude && position.latitude <= 27.0) &&
                (88.0 <= position.longitude && position.longitude <= 93.0)) {
              print("4");
              if (position.latitude != 0 && position.longitude != 0) {
                if (location_string.isEmpty) {
                  print("5");
                  location_string =
                      "${position.latitude}|${position.longitude}|$address|$nowDateTime";
                } else {
                  print("6");
                  location_string = location_string +
                      "||" +
                      "${position.latitude}|${position.longitude}|$address|$nowDateTime";
                }
                print("7");
                location_count++;
              }
            }

            if (location_count >= 3) {
              print("8");
              try {
                print("9");
                // print(
                //     "::::::::::::::::::::::::::::::::::::::::::::::: $location_string");
                await http
                    .post(Uri.parse(location_tracking_url.toString()), body: {
                  "cid": storedCID.toString(),
                  "user_id": storedUserId.toString(),
                  "user_pass": storedPassword.toString(),
                  "device_id": storedDeviceMac.toString(),
                  "locations": location_string.toString(),
                }).then((response) async {
                  print("10");
                  print(
                      "Location Tracking url :::::::: $location_tracking_url");
                  print(
                      "body---------------------------cid: ${storedCID.toString()},user_id: ${storedUserId.toString()},user_pass: ${storedPassword.toString()},device_id: ${storedDeviceMac.toString()},locations: ${location_string.toString()}");
                  var data = jsonDecode(response.body);
                  if (data['status'] == "Success") {
                    // Fluttertoast.showToast(msg: "Background---${data['status']}");
                    print("11");
                    print("---------------------------------${data['status']}");
                    location_string = '';
                    location_count = 0;
                  } else {
                    print("12");
                    await _secureStorage.write(
                        key: 'background_service', value: "false");
                    timer.cancel();
                    await stopBackgroundService();
                  }
                });
              } catch (e) {
                print("13");
                debugPrint(e.toString());
              }
            }
          } else {
            print("14");
            Fluttertoast.showToast(
                msg: "Please Allow Location Permision",
                backgroundColor: Colors.red);
            await Geolocator.openLocationSettings();
          }
        } else {
          print("15");
          Fluttertoast.showToast(
              msg: "Please Allow Location Permision",
              backgroundColor: Colors.red);
          await Geolocator.openLocationSettings();
        }
      } else {
        print("16");
        Fluttertoast.showToast(
          msg: "Please Turn On Internet Connection",
          backgroundColor: Colors.red,
        );
      }
    }
  });

  // //********************Loop start********************//
  // await Hive.initFlutter();
  // await Hive.openBox("alldata");
  // final _boxdata = Hive.box("alldata");
  // final _userId = _boxdata.get("user_id");
  // final _password = _boxdata.get("PASSWORD");
  // final _deviceId = _boxdata.get("deviceId");
  // final _cid = _boxdata.get("CID");

  // // debugPrint("DDDDDDDDDDDDDDDDDDDDDDDD $deviceId");
  // // debugPrint("pppppppppppppppppppppppDD $password");

  // final timer_track_url = databox.get("timer_track_url");

  // int count = 0;
  // String location = "";
  // // Location location1 = Location();
  // Timer.periodic(const Duration(minutes: 5), (timer) async {
  //   if ((_userId == null || _userId.toString().isEmpty) ||
  //       (_password == null || _password.toString().isEmpty) ||
  //       (_cid == null || _cid.toString().isEmpty) ||
  //       (_boxdata.get('background_service') == false ||
  //           _boxdata.get('background_service') == null)) {
  //     timer.cancel();
  //     stopBackgroundService();
  //   }
  //   if (service is AndroidServiceInstance) {
  //     if (await service.isForegroundService()) {
  //       print("-------------------- ${_cid} --- ${_userId} --- ${_password}");
  //       if (await Geolocator.isLocationServiceEnabled()) {
  //         // print("+++++++++++++++++++++++++++++++++++++++++++++");

  //         geo.Position position = await geo.Geolocator.getCurrentPosition();
  //         List<geocoding.Placemark> placemarks = await geocoding
  //             .placemarkFromCoordinates(position.latitude, position.longitude);
  //         String address = "${placemarks[0].street!} ${placemarks[0].country!}";
  //         // location = location.isEmpty
  //         //     ? "${position.latitude}|${position.longitude}|$address"
  //         //     : "$location||${position.latitude}|${position.longitude}|$address";
  //         String nowDateTime =
  //             DateFormat('yyyy-MM-dd h.m.s').format(DateTime.now());
  //         if ((minLatitude <= position.latitude &&
  //                 position.latitude <= maxLatitude) &&
  //             (minLongitude <= position.longitude &&
  //                 position.longitude <= maxLongitude)) {
  //           if (position.latitude != 0 &&
  //               position.longitude != 0 &&
  //               address.isNotEmpty) {
  //             if (location.isEmpty) {
  //               location =
  //                   "${position.latitude}|${position.longitude}|$address|$nowDateTime";
  //             } else {
  //               location = location +
  //                   "||" +
  //                   "${position.latitude}|${position.longitude}|$address|$nowDateTime";
  //             }
  //             count++;
  //           }
  //         }

  //         // print(count);

  //         if (count >= 3) {
  //           var _data = await timeTracker(
  //               location, _cid, _userId, _password, _deviceId, timer_track_url);

  //           // print(data['status']);
  //           if (_data['status'] == "Success") {
  //             Fluttertoast.showToast(msg: "Location Tracking success $_userId");
  //           } else {
  //             Fluttertoast.showToast(msg: "Location Tracking Failed");
  //             timer.cancel();
  //             stopBackgroundService();
  //           }
  //           // print("location:---------------------- ${location}");
  //           count = 0;
  //           location = '';
  //         }
  //       } else {
  //         Fluttertoast.showToast(
  //             msg: "Turn On Your GPS !", backgroundColor: Colors.red);
  //       }
  //     }
  //   }
  // });
}

// Function to stop the background service
Future stopBackgroundService() async {
  if (await FlutterBackgroundService().isRunning()) {
    FlutterBackgroundService().invoke('stopService');
    await Future.delayed(Duration.zero);
    print('Background service stopped.');
  }
}

// Function to restart the background service
Future restartBackgroundService() async {
  if (await FlutterBackgroundService().isRunning()) {
    FlutterBackgroundService().invoke("stopService");
    await Future.delayed(Duration.zero);
  }
  await FlutterBackgroundService().startService();
  await initializeService();
}

Future checkLocationPermision() async {
  if (await FlutterBackgroundService().isRunning()) {
    final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
    Timer.periodic(Duration(seconds: 3), (timer) async {
      String? storedCID = await _secureStorage.read(key: 'cid');
      String? storedUserId = await _secureStorage.read(key: 'userId');
      String? storedPassword = await _secureStorage.read(key: 'password');
      String? storedDeviceMac = await _secureStorage.read(key: 'device_mac');
      String? location_tracking_url =
          await _secureStorage.read(key: 'timer_track_url');
      String? location_tracking_service =
          await _secureStorage.read(key: 'background_service') ?? 'false';
      if (storedCID == null ||
          storedCID.isEmpty ||
          storedUserId == null ||
          storedUserId.isEmpty ||
          storedPassword == null ||
          storedPassword.isEmpty ||
          location_tracking_service == "false") {
        timer.cancel();
      } else {
        LocationPermission checkPermission = await Geolocator.checkPermission();
        if (checkPermission != LocationPermission.always) {
          await Geolocator.openLocationSettings();
        }
      }
    });
  }
}
