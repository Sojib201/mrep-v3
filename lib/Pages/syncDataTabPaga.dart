// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names, must_be_immutable, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mrap_v03/Pages/DCR_section/dcr_saveToHive.dart';
import 'package:mrap_v03/Pages/DCR_section/gift_sample_ppm_save&getTohive.dart';
import 'package:mrap_v03/Pages/Expense/expense_type_in_hive.dart';
import 'package:mrap_v03/Pages/homePage.dart';
import 'package:mrap_v03/Pages/order_and_dcr_root_sync.dart';
import 'package:mrap_v03/Sync_customer_items/syncItemsToHive.dart';
import 'package:mrap_v03/Widgets/syncCustomButton.dart';
import 'package:http/http.dart' as http;
import 'package:mrap_v03/core/utils/app_colors.dart';
import 'package:mrap_v03/local_storage/boxes.dart';

import '../Rx/Medicine/syncMedicineListToHive.dart';
import '../service/network_connectivity.dart';

class SyncDataTabScreen extends StatefulWidget {
  String cid;
  String userId;
  String userPassword;

  SyncDataTabScreen({
    Key? key,
    required this.cid,
    required this.userId,
    required this.userPassword,
  }) : super(key: key);

  @override
  State<SyncDataTabScreen> createState() => _SyncDataTabScreenState();
}

class _SyncDataTabScreenState extends State<SyncDataTabScreen> {
  // Box box=Hive.box('data');
  String sync_url = '';
  String cid = '';
  String userId = '';
  String userPassword = '';
  String userName = '';
  String user_id = '';
  String status = 'failed';
  String buttonTitle = '';
  bool _loading = false;
  bool orderFlag = false;
  bool dcrFlag = false;
  bool rxFlag = false;

  List data = [];
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  // List<SyncCustomerData>? data;

  final mydatabox = Boxes.allData();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        cid = mydatabox.get("CID") ?? widget.cid;
        userId = mydatabox.get("USER_ID") ?? widget.userId;

        userPassword = mydatabox.get("PASSWORD") ?? widget.userPassword;

        userName = mydatabox.get("userName");
        user_id = mydatabox.get("user_id")!;
        orderFlag = mydatabox.get('order_flag') ?? false;
        dcrFlag = mydatabox.get('dcr_flag') ?? false;
        rxFlag = mydatabox.get('rx_flag') ?? false;
      });

      debugPrint("new order flag $orderFlag");
      debugPrint("dcr flag $dcrFlag");
      debugPrint("rx flag$rxFlag");
    }
    // });
  }

  void _submitToastforOrder3() {
    Fluttertoast.showToast(
        msg: 'No Internet Connection\nPlease check your internet connection.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      backgroundColor: const Color(0xffD8E5F1),
      appBar: AppBar(
        title: Text(
          'sync_data'.tr(),
        ),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.home))],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blueGrey,
              ),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // orderFlag?
                      // Column(
                      //   children: [
                      //     syncCustomBuildButton(
                      //       onClick: () async {
                      //         setState(() {
                      //           buttonTitle = 'Sync';
                      //
                      //           _loading = true;
                      //         });
                      //         bool result =
                      //         await NetworkConnecticity.checkConnectivity();
                      //         if (result == true) {
                      //           dmPath(cid, context);
                      //           Future.delayed(const Duration(seconds: 7), () {
                      //             setState(() {
                      //               _loading = false;
                      //             });
                      //           });
                      //         } else {
                      //           _submitToastforOrder3();
                      //         }
                      //       },
                      //       color: Colors.white,
                      //       title: 'sync_all'.tr(),
                      //       sizeWidth: screenWidth,
                      //     ),
                      //     syncCustomBuildButton(
                      //       onClick: () async {
                      //         setState(() {
                      //           buttonTitle = 'ITEMS';
                      //           _loading = true;
                      //         });
                      //         bool result = await NetworkConnecticity
                      //             .checkConnectivity();
                      //         if (result == true) {
                      //           dmPath(cid, context);
                      //           Future.delayed(const Duration(seconds: 4),
                      //                   () {
                      //                 setState(() {
                      //                   _loading = false;
                      //                 });
                      //               });
                      //         } else {
                      //           _submitToastforOrder3();
                      //
                      //           // debugPrint('No internet :( Reason:');
                      //           // debugPrint(InternetConnectionChecker().lastTryResults);
                      //         }
                      //       },
                      //       color: Colors.white,
                      //       title: 'items'.tr(),
                      //       sizeWidth: screenWidth,
                      //     ) ,
                      //     syncCustomBuildButton(
                      //       onClick: () async {
                      //         setState(() {
                      //           buttonTitle = 'CUSTOMER';
                      //           _loading = true;
                      //         });
                      //         bool result = await NetworkConnecticity
                      //             .checkConnectivity();
                      //         if (result == true) {
                      //           dmPath(cid, context);
                      //           Future.delayed(const Duration(seconds: 4),
                      //                   () {
                      //                 setState(() {
                      //                   _loading = false;
                      //                 });
                      //               });
                      //           // _syncCustomerDataToHive();
                      //         } else {
                      //           _submitToastforOrder3();
                      //
                      //           // debugPrint('No internet :( Reason:');
                      //           // debugPrint(InternetConnectionChecker().lastTryResults);
                      //         }
                      //       },
                      //       color: Colors.white,
                      //       title: 'customer'.tr(),
                      //       sizeWidth: screenWidth,
                      //     ),
                      //   ],
                      // ):SizedBox.shrink(),
                      //   dcrFlag
                      //       ?syncCustomBuildButton(
                      //         onClick: () async {
                      //           setState(() {
                      //             buttonTitle = 'GIFT SAMPLE PPM';
                      //             _loading = true;
                      //           });
                      //           bool result = await NetworkConnecticity
                      //               .checkConnectivity();
                      //           if (result == true) {
                      //             dmPath(cid, context);
                      //             Future.delayed(const Duration(seconds: 3),
                      //                     () {
                      //                   setState(() {
                      //                     _loading = false;
                      //                   });
                      //                 });
                      //           } else {
                      //             _submitToastforOrder3();
                      //
                      //             // debugPrint('No internet :( Reason:');
                      //             // debugPrint(InternetConnectionChecker().lastTryResults);
                      //           }
                      //         },
                      //         color: Colors.white,
                      //         title: 'gift_sample_ppm'.tr(),
                      //         sizeWidth: screenWidth,
                      //       ):SizedBox.shrink(),
                      //   rxFlag?
                      //   syncCustomBuildButton(
                      //     onClick: () async {
                      //       setState(() {
                      //         buttonTitle = 'MEDICINE';
                      //         _loading = true;
                      //       });
                      //       bool result = await NetworkConnecticity
                      //           .checkConnectivity();
                      //       if (result == true) {
                      //         dmPath(cid, context);
                      //         Future.delayed(const Duration(seconds: 3),
                      //                 () {
                      //               setState(() {
                      //                 _loading = false;
                      //               });
                      //             });
                      //         // SyncMedicinetoHive().medicinetoHive(
                      //         //     sync_url, cid, userId, userPassword, context);
                      //       } else {
                      //         _submitToastforOrder3();
                      //
                      //         // debugPrint('No internet :( Reason:');
                      //         // debugPrint(InternetConnectionChecker().lastTryResults);
                      //       }
                      //     },
                      //     color: Colors.white,
                      //     title: 'medicine'.tr(),
                      //     sizeWidth: screenWidth,
                      //   ):SizedBox.shrink(),
                      //   dcrFlag  || rxFlag?syncCustomBuildButton(
                      //     onClick: () async {
                      //       setState(() {
                      //         buttonTitle = 'DOCTOR';
                      //         _loading = true;
                      //       });
                      //       bool result = await NetworkConnecticity
                      //           .checkConnectivity();
                      //       if (result == true) {
                      //         dmPath(cid, context);
                      //         Future.delayed(const Duration(seconds: 3),
                      //                 () {
                      //               setState(() {
                      //                 _loading = false;
                      //               });
                      //             });
                      //         // SyncDcrtoHive().syncDcrToHive(
                      //         //     sync_url, cid, userId, userPassword, context);
                      //       } else {
                      //         _submitToastforOrder3();
                      //
                      //         // debugPrint('No internet :( Reason:');
                      //         // debugPrint(InternetConnectionChecker().lastTryResults);
                      //       }
                      //     },
                      //     color: Colors.white,
                      //     title: 'doctor'.tr(),
                      //     sizeWidth: screenWidth,
                      //   ):SizedBox.shrink(),
                      syncCustomBuildButton(
                        onClick: () async {
                          setState(() {
                            buttonTitle = 'Sync';

                            _loading = true;
                          });
                          bool result =
                              await NetworkConnecticity.checkConnectivity();
                          if (result == true) {
                            dmPath(cid, context);
                            Future.delayed(const Duration(seconds: 7), () {
                              setState(() {
                                _loading = false;
                              });
                            });
                          } else {
                            _submitToastforOrder3();
                          }
                        },
                        color: Color(0xff4b9d98),
                        title: 'sync_all'.tr(),
                        sizeWidth: screenWidth,
                      ),

                      orderFlag
                          ? Row(
                              children: [
                                Expanded(
                                  child: syncCustomBuildButton(
                                    onClick: () async {
                                      setState(() {
                                        buttonTitle = 'ITEMS';
                                        _loading = true;
                                      });
                                      bool result = await NetworkConnecticity
                                          .checkConnectivity();
                                      if (result == true) {
                                        dmPath(cid, context);
                                        Future.delayed(
                                            const Duration(seconds: 4), () {
                                          setState(() {
                                            _loading = false;
                                          });
                                        });
                                      } else {
                                        _submitToastforOrder3();

                                        // debugPrint('No internet :( Reason:');
                                        // debugPrint(InternetConnectionChecker().lastTryResults);
                                      }
                                    },
                                    color: Colors.white,
                                    title: 'items'.tr(),
                                    sizeWidth: screenWidth,
                                  ),
                                ),
                                Expanded(
                                  child: syncCustomBuildButton(
                                    onClick: () async {
                                      setState(() {
                                        buttonTitle = 'CUSTOMER';
                                        _loading = true;
                                      });
                                      bool result = await NetworkConnecticity
                                          .checkConnectivity();
                                      if (result == true) {
                                        dmPath(cid, context);
                                        Future.delayed(
                                            const Duration(seconds: 4), () {
                                          setState(() {
                                            _loading = false;
                                          });
                                        });
                                        // _syncCustomerDataToHive();
                                      } else {
                                        _submitToastforOrder3();

                                        // debugPrint('No internet :( Reason:');
                                        // debugPrint(InternetConnectionChecker().lastTryResults);
                                      }
                                    },
                                    color: Colors.white,
                                    title: 'customer'.tr(),
                                    sizeWidth: screenWidth,
                                  ),
                                ),
                              ],
                            )
                          : const Text(""),
                      Row(
                        children: [
                          dcrFlag
                              ? Expanded(
                                  child: syncCustomBuildButton(
                                    onClick: () async {
                                      setState(() {
                                        buttonTitle = 'GIFT SAMPLE PPM';
                                        _loading = true;
                                      });
                                      bool result = await NetworkConnecticity
                                          .checkConnectivity();
                                      if (result == true) {
                                        dmPath(cid, context);
                                        Future.delayed(
                                            const Duration(seconds: 3), () {
                                          setState(() {
                                            _loading = false;
                                          });
                                        });
                                      } else {
                                        _submitToastforOrder3();

                                        // debugPrint('No internet :( Reason:');
                                        // debugPrint(InternetConnectionChecker().lastTryResults);
                                      }
                                    },
                                    color: Colors.white,
                                    title: 'gift_sample_ppm'.tr(),
                                    sizeWidth: screenWidth,
                                  ),
                                )
                              : const Text(""),
                          rxFlag
                              ? Expanded(
                                  child: syncCustomBuildButton(
                                    onClick: () async {
                                      setState(() {
                                        buttonTitle = 'MEDICINE';
                                        _loading = true;
                                      });
                                      bool result = await NetworkConnecticity
                                          .checkConnectivity();
                                      if (result == true) {
                                        dmPath(cid, context);
                                        Future.delayed(
                                            const Duration(seconds: 3), () {
                                          setState(() {
                                            _loading = false;
                                          });
                                        });
                                        // SyncMedicinetoHive().medicinetoHive(
                                        //     sync_url, cid, userId, userPassword, context);
                                      } else {
                                        _submitToastforOrder3();

                                        // debugPrint('No internet :( Reason:');
                                        // debugPrint(InternetConnectionChecker().lastTryResults);
                                      }
                                    },
                                    color: Colors.white,
                                    title: 'medicine'.tr(),
                                    sizeWidth: screenWidth,
                                  ),
                                )
                              : const Text(""),
                        ],
                      ),
                      dcrFlag || rxFlag
                          ? Row(
                              children: [
                                Expanded(
                                  child: syncCustomBuildButton(
                                    onClick: () async {
                                      setState(() {
                                        buttonTitle = 'DOCTOR';
                                        _loading = true;
                                      });
                                      bool result = await NetworkConnecticity
                                          .checkConnectivity();
                                      if (result == true) {
                                        dmPath(cid, context);
                                        Future.delayed(
                                            const Duration(seconds: 3), () {
                                          setState(() {
                                            _loading = false;
                                          });
                                        });
                                        // SyncDcrtoHive().syncDcrToHive(
                                        //     sync_url, cid, userId, userPassword, context);
                                      } else {
                                        _submitToastforOrder3();

                                        // debugPrint('No internet :( Reason:');
                                        // debugPrint(InternetConnectionChecker().lastTryResults);
                                      }
                                    },
                                    color: Colors.white,
                                    title: 'doctor'.tr(),
                                    sizeWidth: screenWidth,
                                  ),
                                ),
                                const Expanded(child: SizedBox())
                              ],
                            )
                          : const Text(""),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: syncCustomBuildButton(
                              isHome: true,
                              onClick: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MyHomePage(
                                      // userName: userName,
                                      // user_id: user_id,
                                      // userPassword: userPassword,
                                      userName: "",
                                      user_id: "",
                                      userPassword: "",
                                    ),
                                  ),
                                );
                              },
                              color: Color(0xff4b9d98),
                              title: 'go_to_home_page'.tr(),
                              sizeWidth: screenWidth,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  ///********************************* Dm Path function **********************************************************
  Future dmPath(String cid, context) async {
    String sync_url;
    try {
      final http.Response response = await http.get(
        Uri.parse(
            'http://w05.yeapps.com/dmpath/dmpath_v07/get_dmpath?cid=$cid'),
        // "http://192.168.0.102:8000/apx_pharma_api/dmpath_v07/get_dmpath?cid=$cid")
      );

      var userInfo = json.decode(response.body);
      var status = userInfo['res_data'];
      var login_url = status['login_url'];
      String sync_url = status['sync_url'];
      String submit_url = status['submit_url'];
      // String report_url = status['report_url'];
      String photo_submit_url = status['photo_submit_url'];
      String photo_url = status['photo_url'];
      String leave_request_url = status['leave_request_url'];
      String leave_report_url = status['leave_report_url'];
      String plugin_url = status['plugin_url'];
      String tour_plan_url = status['tour_plan_url'];
      String tour_compliance_url = status['tour_compliance_url'];
      String client_url = status['client_url'];
      String doctor_url = status['doctor_url'];
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
      String late_attendance_url = status['late_attendance_url'] ?? "";

      // final prefs = await SharedPreferences.getInstance();
      mydatabox.put('sync_url', sync_url);
      mydatabox.put('submit_url', submit_url);
      // mydatabox.put('report_url', report_url);
      mydatabox.put('photo_submit_url', photo_submit_url);
      mydatabox.put('activity_log_url', activity_log_url);
      mydatabox.put('client_outst_url', client_outst_url);
      mydatabox.put('user_area_url', user_area_url);
      mydatabox.put('photo_url', photo_url);
      mydatabox.put('leave_request_url', leave_request_url);
      mydatabox.put('leave_report_url', leave_report_url);
      mydatabox.put('plugin_url', plugin_url);
      mydatabox.put('tour_plan_url', tour_plan_url);
      mydatabox.put('tour_compliance_url', tour_compliance_url);
      mydatabox.put('client_url', client_url);
      mydatabox.put('doctor_url', doctor_url);
      mydatabox.put('user_sales_coll_ach_url', user_sales_coll_ach_url);
      mydatabox.put('os_details_url', os_details_url);
      mydatabox.put('ord_history_url', ord_history_url);
      mydatabox.put('inv_history_url', inv_history_url);
      mydatabox.put('client_edit_url', client_edit_url);
      mydatabox.put('timer_track_url', timer_track_url);

      if (response.statusCode == 200) {
        if (buttonTitle == 'Sync') {
          SyncItemstoHive()
              .syncItemsToHive(sync_url, cid, userId, userPassword, context);
          // _syncCustomerDataToHive(sync_url,context);//todo Old newOrder

          // SyncDcrtoHive()
          // .syncDcrToHive(sync_url, cid, userId, userPassword, context);//todo Old Dcr
          SyncDcrGSPtoHive()
              .syncDcrGiftToHive(sync_url, cid, userId, userPassword, context);
          SyncDcrGSPtoHive().syncDcrSampleToHive(
              sync_url, cid, userId, userPassword, context);
          SyncDcrGSPtoHive()
              .syncDcrPpmToHive(sync_url, cid, userId, userPassword, context);
          SyncMedicinetoHive()
              .medicinetoHive(sync_url, cid, userId, userPassword, context);

          SyncDcrtoHive().syncDcrToHive(
              sync_url, cid, userId, userPassword, context); //for rx doctor
          // SyncMedicinetoHive()
          //     .medicinetoHive(sync_url, cid, userId, userPassword, context);

          ExpenseTypeData().expenseEntry(context);
          DcrAndOrderHive().dcrandOrder(context); //New order and decr for MPO
        } else if (buttonTitle == 'ITEMS') {
          SyncItemstoHive()
              .syncItemsToHive(sync_url, cid, userId, userPassword, context);
        } else if (buttonTitle == 'CUSTOMER') {
          // _syncCustomerDataToHive(sync_url,context);//todo Old
          DcrAndOrderHive().dcrandOrder(context); //new
        } else if (buttonTitle == 'GIFT SAMPLE PPM') {
          SyncDcrGSPtoHive()
              .syncDcrGiftToHive(sync_url, cid, userId, userPassword, context);
          SyncDcrGSPtoHive().syncDcrSampleToHive(
              sync_url, cid, userId, userPassword, context);
          SyncDcrGSPtoHive()
              .syncDcrPpmToHive(sync_url, cid, userId, userPassword, context);
          SyncDcrGSPtoHive().syncDcrDiscussiontToHive(
              sync_url, cid, userId, userPassword, context);
        } else if (buttonTitle == 'MEDICINE') {
          SyncMedicinetoHive()
              .medicinetoHive(sync_url, cid, userId, userPassword, context);
        } else if (buttonTitle == 'DOCTOR') {
          SyncDcrtoHive().syncDcrToHive(
              sync_url, cid, userId, userPassword, context); //todo Old
          DcrAndOrderHive().dcrandOrder(context); //todo New
        }
      }

      // return isLoading;
    } on Exception catch (_) {
      throw Exception("Error on server");
    }
  }

  //!Future openBox() async {
  //!  var dir = await getApplicationDocumentsDirectory();
  //!  Hive.init(dir.path);
  //!  box = await Hive.openBox('data');
  //!}

  // Future<dynamic> _syncCustomerDataToHive(String sync_url,contex) async {
  //   String msg = 'Customer data synchronizing... ';
  //   // ScaffoldMessenger.of(context)
  //   //     .showSnackBar(const SnackBar(content: Text('Sync success')));
  //   buildShowDialog(context, msg);
  //   var url =
  //       '$sync_url/api_client/client_list?cid=$cid&user_id=$userId&user_pass=$userPassword';

  //   debugPrint(url);
  //   //! await openBox();
  //   try {
  //     var response = await http.get(Uri.parse(
  //         '$sync_url/api_client/client_list?cid=$cid&user_id=$userId&user_pass=$userPassword'));
  //     Map<String, dynamic> jsonResponseDcrData = jsonDecode(response.body);
  //     status = jsonResponseDcrData['status'];
  //     var clientList = jsonResponseDcrData['clientList'];

  //     if (status == 'Success') {
  //       await putData(clientList);
  //       Timer(const Duration(seconds: 3), () => Navigator.pop(context));
  //     } else {
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(const SnackBar(content: Text('Didn\'t sync Data')));
  //     }
  //   } on Exception catch (_) {
  //     // Fluttertoast.showToast(msg: "Error on server");
  //     throw Exception("Error on server");
  //   }
  //   // return Future.value(true);
  // }

  // Future putData(data) async {
  //   await box.clear();

  //   for (var d in data) {
  //     box.add(d);
  //   }
  // }

  // buildShowDialog(BuildContext context, String msg) {
  //   return showDialog(
  //       barrierColor: Colors.black,
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             const CircularProgressIndicator(),
  //             const SizedBox(
  //               height: 10,
  //             ),
  //             DefaultTextStyle(
  //               style: const TextStyle(color: Colors.white, fontSize: 18),
  //               child: Text(msg),
  //             )
  //           ],
  //         );
  //       });
  // }
}
