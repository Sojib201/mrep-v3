// ignore_for_file: public_member_api_docs, sort_constructors_first, file_names, non_constant_identifier_names, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables, use_build_context_synchronously, prefer_interpolation_to_compose_strings
// import 'dart:async';
// import 'dart:ui';

import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marquee/marquee.dart';

import 'package:mrap_v03/Pages/DCR_section/for_mpo_route_doc.dart';
import 'package:mrap_v03/Pages/Expense/expense_entry_v2.dart';
import 'package:mrap_v03/Pages/activity_log_page.dart';
import 'package:mrap_v03/Pages/approval_page.dart';

import 'package:mrap_v03/Pages/order_sections/for_mpo_route_claient.dart';
import 'package:mrap_v03/Pages/order_sections/order_approval_area_page.dart';
import 'package:mrap_v03/Pages/plugin_reports_page.dart';
import 'package:mrap_v03/Pages/tour_plan_page.dart';
import 'package:mrap_v03/Pages/user_location/area_list.dart';
import 'package:mrap_v03/Pages/user_location/nearby_colleague.dart';
import 'package:mrap_v03/Widgets/custome_expantion_tile.dart';
import 'package:mrap_v03/chat_feature/firebase_apis.dart';
import 'package:mrap_v03/chat_feature/user_inbox_list.dart';
import 'package:mrap_v03/core/utils/app_text_style.dart';

import 'package:mrap_v03/local_storage/boxes.dart';
import 'package:mrap_v03/screens.dart';
import 'package:mrap_v03/service/all_service.dart';

import 'package:geolocator/geolocator.dart' as geo;
import 'package:mrap_v03/service/auth_services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Widgets/user_info_widgets.dart';
import '../core/utils/app_colors.dart';
import '../core/utils/image_constant.dart';
import '../local_storage/hive_data_model.dart';
import 'Expense/attendanceMtrHistory.dart';
import 'Expense/expense_approval.dart';
import 'Expense/expense_draft_v2.dart';
import 'Expense/expense_log.dart';
import 'Expense/expense_report_page.dart';
import 'Expense/expense_summary.dart';

var tempdocName = "";
String areaName = "";
String areaid = "";
String docId = "";

// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  String userName;
  String user_id;
  String userPassword;
  int? data;

  //
  // bool offer_flag;
  // bool note_flag;
  // bool client_edit_flag;
  // bool os_show_flag;
  // bool os_details_flag;
  // bool ord_history_flag;
  // bool inv_histroy_flag;
  // bool rx_doc_must;
  // bool rx_type_must;
  // bool rx_gallery_allow;
  // String endTime;

  MyHomePage({
    Key? key,
    required this.userName,
    required this.user_id,
    required this.userPassword,
    this.data,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Box? box;
  List data = [];
  double screenHeight = 0.0;
  double screenWidth = 0.0;

  String report_sales_url = '';
  String report_dcr_url = '';
  String report_rx_url = '';
  String leave_request_url = '';
  String leave_report_url = '';
  // String plugin_url = '';
  // String tour_plan_url = '';
  String tour_compliance_url = '';
  // String activity_log_url = '';
  // String approval_url = '';
  String cid = '';
  String userId = '';
  String userPassword = '';
  String? logo_url_1;
  String? logo_url_2;
  bool areaPage = false;
  bool exp_approval_flag = false;
  String? userName;
  String? startTime;
  String user_sales_coll_ach_url = '';
  String timer_track_url = '';
  String? user_id;
  String deviceId = "";
  String mobile_no = '';
  String? endTime;
  bool orderFlag = false;
  bool dcrFlag = false;
  bool rxFlag = false;
  bool leaveFlag = false;
  bool othersFlag = false;
  bool visitPlanFlag = false;
  bool pluginFlag = false;
  bool leave_flag = false;
  bool notice_flag = false;
  bool timer_flag = false;
  int notice_reload_duration = 60;
  String notice = '';
  String targetAmount = '0';
  String salesAmount = '0';
  String achievementAmount = '0';
  Box? buttonNames;
  bool target_sales_achievement_flag = false;
  bool notice_auto_scroll_flag = false;
  String order_approval_url = "";
  String order_list = "";
  bool order_approval_flag = false;
  bool isExpenseSync = false;
  bool isloading = true;

  // List noticeList = [];

  String version = 'test';
  var prefix;
  var prefix2;
  // Location location = Location();
  List<NoticeListModel> noticeList = [];
  final mydatabox = Boxes.allData();
  bool isBN = false;

  final ScrollController _scrollController = ScrollController();
  bool _isExpanded = false;

  void _scrollToExpandedTile() {
    // Delay the scroll to allow expansion animation to complete
    Future.delayed(const Duration(seconds: 5), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void initState() {
    isExpenseSync = databox.get('isExpenseSync') ?? false;
    super.initState();
    isBN = Boxes.allData().get("toggleIsActive") ?? false;
    restartBackgroundService();
    AllServices().getPermission();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (mydatabox.get('auto_day_end') == true &&
            mydatabox.get('attendance').toString() !=
                AllServices().getTodayDate()) {
          mydatabox.put('attendance', '');
          mydatabox.put("startTime", '');
          mydatabox.put("endTime", '');
        }
        if (mydatabox.get('attendance').toString() ==
                AllServices().getTodayDate() &&
            // (mydatabox.get('attendance').toString().isNotEmpty ||
            //         mydatabox.get('attendance') != null) &&
            mydatabox.get('attendanceUserId') == mydatabox.get("USER_ID")) {
          const SizedBox.shrink();
        } else {
          if (mydatabox.get('attendanceUserId') != mydatabox.get("USER_ID")) {
            mydatabox.put('attendance', '');
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AttendanceScreen(),
            ),
          );
        }

        userPassword = mydatabox.get("PASSWORD") ?? widget.userPassword;
        startTime = mydatabox.get("startTime") ?? '';
        endTime = mydatabox.get("endTime") ?? '';
        report_sales_url = mydatabox.get("report_sales_url") ?? '';
        notice_reload_duration = mydatabox.get('notice_reload_duration') ?? 60;
        report_dcr_url = mydatabox.get("report_dcr_url") ?? '';
        report_rx_url = mydatabox.get("report_rx_url") ?? '';
        leave_request_url = mydatabox.get("leave_request_url") ?? '';
        leave_report_url = mydatabox.get("leave_report_url") ?? '';
        // tour_plan_url = mydatabox.get("tour_plan_url") ?? '';
        tour_compliance_url = mydatabox.get("tour_compliance_url") ?? '';
        // activity_log_url = mydatabox.get("activity_log_url") ?? '';
        // plugin_url = mydatabox.get("plugin_url") ?? '';
        user_sales_coll_ach_url =
            mydatabox.get("user_sales_coll_ach_url") ?? '';
        timer_track_url = mydatabox.get("timer_track_url") ?? '';
        // approval_url = mydatabox.get("approval_url") ?? '';
        cid = mydatabox.get("CID");
        userId = mydatabox.get("USER_ID") ?? widget.user_id;
        logo_url_1 = mydatabox.get('logo_url_1') ?? null;
        logo_url_2 = mydatabox.get('logo_url_2') ?? null;
        areaPage = mydatabox.get("areaPage")!;
        userName = mydatabox.get("userName");
        user_id = mydatabox.get("user_id");
        mobile_no = mydatabox.get("mobile_no") ?? '';
        deviceId = mydatabox.get("deviceId") ?? '';
        orderFlag = mydatabox.get('order_flag') ?? false;
        dcrFlag = mydatabox.get('dcr_flag') ?? false;
        rxFlag = mydatabox.get('rx_flag') ?? false;
        othersFlag = mydatabox.get('others_flag') ?? false;
        visitPlanFlag = mydatabox.get('visit_plan_flag') ?? false;
        pluginFlag = mydatabox.get('plagin_flag') ?? false;
        leave_flag = mydatabox.get('leave_flag') ?? false;
        notice_flag = mydatabox.get('notice_flag') ?? false;
        timer_flag = mydatabox.get('timer_flag') ?? false;
        exp_approval_flag = mydatabox.get('exp_approval_flag') ?? false;
        target_sales_achievement_flag =
            mydatabox.get('target_sales_achievement_flag') ?? false;
        notice_auto_scroll_flag =
            mydatabox.get('notice_auto_scroll_flag') ?? false;
        order_approval_url = mydatabox.get('order_approval_url') ?? "";
        order_list = mydatabox.get('order_list') ?? order_list;
        order_approval_flag = mydatabox.get('') ?? true;

        ///change to false///
        print("......................................");
        getButtonNames();
        print("......................................");

        debugPrint('timer flag ::::$timer_flag');

        var parts = startTime?.split(' ');

        prefix = parts![0].trim();
        // debugPrint("prefix ashbe $prefix");
        String dt = DateTime.now().toString();
        var parts2 = dt.split(' ');
        prefix2 = parts2[0].trim();
        // debugPrint("dateTime ashbe$prefix2");
      });

      setState(() {
        fetchNoticeList();
        if (notice == "" || notice.isEmpty) {
          getApi();
        }
        Timer.periodic(Duration(minutes: notice_reload_duration), (_) async {
          await getApi();
        });
        int space = startTime!.indexOf(" ");
        String removeSpace = startTime!.substring(space + 1, startTime!.length);
        startTime = removeSpace.replaceAll("'", '');
        int space1 = endTime!.indexOf(" ");
        String removeSpace1 = endTime!.substring(space1 + 1, endTime!.length);
        endTime = removeSpace1.replaceAll("'", '');
        getLatLong();
        //  :const SizedBox.shrink();
      });
    });

    // if (background_service == true) {
    //   if (mydatabox.get('timer_flag') == true) {

    //   } else {
    //     FlutterBackgroundService().isRunning().then((value) {
    //       if (value) {
    //         FlutterBackgroundService().invoke("stopService");
    //       }
    //     });
    //   }
    // } else {
    //   FlutterBackgroundService().isRunning().then((value) {
    //     if (value) {
    //       FlutterBackgroundService().invoke("stopService");
    //     }
    //   });
    // }

    debugPrint(report_sales_url);
    debugPrint(report_dcr_url);
    debugPrint(report_rx_url);

    //chat feauture user acitve inactive status update
    FirebaseAPIs.updateActiveStatus(true);
    WidgetsBinding.instance.addObserver(AppLifecycleListener());
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');

      if (Boxes.userData().isNotEmpty) {
        if (message.toString().contains('resume')) {
          FirebaseAPIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          FirebaseAPIs.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
  }

  ///...............................Apex Pharma..................................///
  Future<void> getApi() async {
    List<Map<String, dynamic>> noticeList = await noticeEvent();

    final noticeBox = Hive.box<NoticeListModel>('noticeList');
    for (var noticeMap in noticeList) {
      NoticeListModel noticeModel = NoticeListModel(
        uiqueKey: noticeMap['uniqueKey'] ?? 0,
        notice_date: noticeMap['notice_date'] ?? '',
        notice: noticeMap['notice'] ?? '',
        notice_pdf_url: noticeMap['notice_pdf_url'] ?? '',
      );

      // Add the NoticeModel object to the Hive box
      await noticeBox.add(noticeModel);
    }
    fetchNoticeList();
  }

  //
  // void getNoticeListFromHive() async {
  //   final noticeBox = Hive.box<NoticeListModel>('noticeList');
  //   setState(() {
  //     noticeList = noticeBox.values.toList();
  //   });
  // }

  void fetchNoticeList() {
    print('entered to fetch');
    final noticeBox = Hive.box<NoticeListModel>('noticeList');
    print('noticebox called');
    for (NoticeListModel i in noticeList) {
      print("******************************f");
      print(i.notice_date);
      print('noticelist j$i');
    }

    noticeList = noticeBox.values.toList();
    convertToString();
    targetAmount = mydatabox.get('target_amount') ?? '0';
    salesAmount = mydatabox.get('sales_amount') ?? '0';
    achievementAmount = mydatabox.get('achievement_amount') ?? '0';
    print(
        'targetAmount $targetAmount============salesAmount $salesAmount======================achievement $achievementAmount');
    print("notice ----------------  $notice");
    if (mounted) {
      setState(() {});
    }
  }

  void convertToString() {
    if (noticeList.isNotEmpty) {
      List<String> notices = noticeList.map((item) => item.notice).toList();
      print("&&&&&&&&&&&&");
      // print();
      print(notices);
      notice = notices.join("      ■      ");
    } else {
      notice = "";
    }
  }

  Future<void> getButtonNames() async {
    try {
      buttonNames = Hive.box('buttonNames');
      debugPrint("Retrieved buttonNames: ${buttonNames?.values}");
    } catch (e) {
      debugPrint("Error retrieving buttonNames: $e");
    }
  }

  ///...............................Apex Pharma..................................///
//   restartBackgroundService()async{
//  await getPermission();

//   }

  // getPermission() async {
  //   bool _serviceEnabled;
  //   PermissionStatus _permissionGranted;

  //   _serviceEnabled = await location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled) {
  //       return;
  //     }
  //   }

  //   _permissionGranted = await location.hasPermission();
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await location.requestPermission();
  //     if (_permissionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }

  //   if (_serviceEnabled &&
  //       _permissionGranted == PermissionStatus.granted &&
  //       timer_flag == true) {
  //     //await initializeService();

  //     BGservice.serviceOn();
  //     debugPrint('Starting Background Service...');

  //     debugPrint('Starting Background Service...');
  //   }

  //   setState(() {});
  // }

  // getLoc() {
  //   String location = "";
  //   Timer.periodic(const Duration(minutes: 3), (timer) {
  //     getLatLong();
  //     if (lat != 0.0 && long != 0.0) {
  //       if (location == "") {
  //         location = lat.toString() + "|" + long.toString();
  //       } else {
  //         location = location + "||" + lat.toString() + "|" + long.toString();
  //       }
  //     }

  //     debugPrint(location.split('||').length);
  //     // debugPrint(location.length);
  //   });
  // }

  // Future<Position> _determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return Future.error('Location services are disabled.');
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }
  //   return await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  // }

  // getLatLong() {
  //   Future<Position> data = _determinePosition();
  //   data.then((value) {
  //     setState(() {
  //       lat = value.latitude;
  //       long = value.longitude;
  //     });
  //     getAddress(value.latitude, value.longitude);
  //   }).catchError((error) {});
  // }

  // getAddress(lat, long) async {
  //   List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
  //   setState(() {
  //     address = placemarks[0].street! + " " + placemarks[0].country!;
  //   });
  //   // for (int i = 0; i < placemarks.length; i++) {}
  // }

  int _currentSelected = 0;
  _onItemTapped(int index) async {
    if (index == 0) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => UserList()));
    }

    if (index == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => RxPage(
                    address: '',
                    areaId: '',
                    areaName: '',
                    ck: '',
                    dcrKey: 0,
                    docId: '',
                    docName: '',
                    uniqueId: 0,
                    draftRxMedicinItem: [],
                    image1: '',
                    dcrGrad: '',
                    isDirectCapture: true,
                  )));
      setState(() {
        _currentSelected = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("confirm".tr()),
            content: Text("do_you_exit_app".tr()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text("no".tr()),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  "yes".tr(),
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: SizedBox(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: kPrimaryColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: logo_url_2 != null
                        ? CachedNetworkImage(
                            imageUrl: logo_url_2!,
                            errorWidget: (context, url, error) => Image.asset(
                              ImageConstant.mRep7LogoImage,
                              color: Colors.white,
                            ),
                          )
                        : Image.asset(
                            ImageConstant.mRep7LogoImage,
                            color: Colors.white,
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: DropdownButton<Locale>(
                      style: kNavItemTextStyle,
                      value: context.locale,
                      icon: Icon(
                        Icons.language,
                        color: Colors.black,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: Locale('en'),
                          child: Text('English'),
                        ),
                        DropdownMenuItem(
                          value: Locale('bn'),
                          child: Text('বাংলা'),
                        ),
                        DropdownMenuItem(
                          value: Locale('hi'),
                          child: Text('Hindi'),
                        ),
                        DropdownMenuItem(
                          value: Locale('fr'),
                          child: Text('French'),
                        ),
                      ],
                      onChanged: (Locale? locale) {
                        context.setLocale(locale!);
                      },
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.sync_outlined, color: kAccentColor),
                  title: Text('sync_data'.tr(), style: kNavItemTextStyle),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => SyncDataTabScreen(
                                  cid: cid,
                                  userId: userId,
                                  userPassword: userPassword,
                                )));
                  },
                ),
                ListTile(
                  leading:
                      const Icon(Icons.pin_drop_sharp, color: kAccentColor),
                  title: Text('my_location'.tr(), style: kNavItemTextStyle),
                  onTap: () {
                    if (mydatabox.get("latitude") != null &&
                        mydatabox.get("longitude") != null) {
                      final String url =
                          "https://www.google.com/maps/search/?api=1&query=${mydatabox.get("latitude")},${mydatabox.get("longitude")}";
                      launchUrl(Uri.parse(url));
                    }
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (_) => ShowLocation(
                    //
                    //           latitude: mydatabox.get("latitude"),
                    //           longitude: mydatabox.get("longitude"),
                    //         )));
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (_) => OpenStreetMapScreen(
                    //               latitude: mydatabox.get("latitude"),
                    //               longitude: mydatabox.get("longitude"),
                    //             )));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.people, color: kAccentColor),
                  title: Text('my_colleagues'.tr(), style: kNavItemTextStyle),
                  onTap: () async {
                    List<String> areaList =
                        await mydatabox.get('area_list').cast<String>();
                    if (areaList.length == 1) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NearbyColleague(
                              areaId: areaList[0],
                            ),
                          ));

                      // Map<String,dynamic> selectedEmployeeAddress = await GetEmployeeAddress(finalList[index].repId.toString());
                      // if(selectedEmployeeAddress.isNotEmpty)
                      // {
                      //   print("Called ***************");
                      //   if (selectedEmployeeAddress['lat']!= "" && selectedEmployeeAddress['long'] != "") {
                      //     final String url = "https://www.google.com/maps/search/?api=1&query=${selectedEmployeeAddress['lat']},${selectedEmployeeAddress['long']}";
                      //     launchUrl(Uri.parse(url));
                      //   }
                      //   else  {
                      //     Fluttertoast.showToast(msg: "Address not found",backgroundColor: kErrorColor);
                      //   }
                      //
                      // }
                      // else
                      // {
                      //   Fluttertoast.showToast(msg: "Address not found",backgroundColor: kErrorColor);
                      //
                      // }
                    } else if (areaList.length > 1) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AreaListScreen(areaList: areaList),
                          ));
                    } else {
                      Fluttertoast.showToast(
                          msg: "No List Found", backgroundColor: kErrorColor);
                    }
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (_) => NearbyColleague(),
                    //     ));
                  },
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(Icons.vpn_key, color: kAccentColor),
                  title: Text(
                    'change_password'.tr(),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 15, 53, 85)),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ChangePasswordScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: kAccentColor),
                  title: Text('logout'.tr(), style: kNavItemTextStyle),
                  onTap: () async {
                    //firebase
                    // await FirebaseAPIs.updateActiveStatus(false);
                    // // await  FirebaseAPIs.updatePushToken(ProfileScreenController.to.userInfo.value.userId.toString(),"");
                    // final box = Hive.box('userInfo');
                    // await box.delete("user");
                    // print("Data deleted");
                    // FirebaseAPIs.user = {};
                    //for firebase
                    await AuthServices.logOut(context);
                  },
                ),
              ],
            ),
          ),
        ),

        // endDrawer:   Drawer(
        //   child: SizedBox(
        //     child: ListView(
        //       padding: EdgeInsets.zero,
        //       children: [
        //         DrawerHeader(
        //           decoration: const BoxDecoration(
        //               color:kPrimaryColor),
        //           child: Padding(
        //             padding: const EdgeInsets.all(16.0),
        //             child: logo_url_2 != null
        //                 ? CachedNetworkImage(
        //               imageUrl: logo_url_2!,
        //               errorWidget: (context, url, error) =>
        //                   Image.asset(ImageConstant.mRep7LogoImage,color: kSecondaryColor,),
        //             )
        //                 : Image.asset(ImageConstant.mRep7LogoImage,color: Colors.white),
        //           ),
        //         ),
        //         ListTile(
        //           leading:
        //           const Icon(Icons.library_add_check, color: kAccentColor),
        //           title: Text(
        //               'attendance'.tr(),
        //               style: kNavItemTextStyle
        //           ),
        //           onTap: () {
        //             Navigator.push(
        //                 context,
        //                 MaterialPageRoute(
        //                     builder: (context) =>
        //                     const AttendanceScreen()));
        //           },
        //         ),
        //         visitPlanFlag?ListTile(
        //           leading:
        //           const Icon(Icons.flag_rounded, color: kAccentColor),
        //           title: Text(
        //               'tour_plan'.tr(),
        //               style: kNavItemTextStyle
        //           ),
        //           onTap: () {
        //             Navigator.of(context)
        //                 .push(MaterialPageRoute(
        //               builder: (context) =>
        //                   TourPlanPage(),
        //             ));
        //           },
        //         ):SizedBox.shrink(),
        //         notice_flag?ListTile(
        //           leading: const Icon(Icons.notifications_active,
        //               color: kAccentColor),
        //           title: Text(
        //               'notice'.tr(),
        //               style: kNavItemTextStyle
        //           ),
        //           onTap: () {
        //             Navigator.push(context,
        //                 MaterialPageRoute(builder: (_) => NoticeScreen()));
        //           },
        //         ):SizedBox.shrink(),
        //         leave_flag?Link(
        //           uri: Uri.parse(
        //               '$leave_request_url?cid=$cid&rep_id=$userId&rep_pass=$userPassword'),
        //           target: LinkTarget.blank,
        //           builder: (BuildContext ctx,
        //               FollowLink? openLink) {
        //             return ListTile(
        //               leading: const Icon(Icons.leave_bags_at_home,  color: kAccentColor),
        //               title: Text(
        //                   'leave_request'.tr(),
        //                   style: kNavItemTextStyle
        //               ),
        //               onTap: () {
        //                 openLink!();
        //               },
        //             );
        //           },
        //
        //         ):SizedBox.shrink(),
        //         leave_flag?Link(
        //           uri: Uri.parse(
        //               '$leave_report_url?cid=$cid&rep_id=$userId&rep_pass=$userPassword'),
        //           target: LinkTarget.blank,
        //           builder: (BuildContext ctx,
        //               FollowLink? openLink) {
        //             return  ListTile(
        //               leading: const Icon(Icons.sticky_note_2,  color: kAccentColor),
        //               title: Text(
        //                   'leave_report'.tr(),
        //                   style: kNavItemTextStyle
        //               ),
        //               onTap: () {
        //                 openLink!();
        //               },
        //             );
        //           },
        //         ):SizedBox.shrink(),
        //         pluginFlag?ListTile(
        //           leading: const Icon(Icons.newspaper,  color: kAccentColor),
        //           title: Text(
        //               'plugin'.tr(),
        //               style: kNavItemTextStyle
        //           ),
        //           onTap: () async {
        //             Navigator.of(context)
        //                 .push(MaterialPageRoute(
        //               builder: (context) =>
        //                   PlugInReportsPage(),
        //             ));
        //
        //           },
        //         ):SizedBox.shrink(),
        //         visitPlanFlag?ListTile(
        //           leading: const Icon(Icons.approval_sharp,  color: kAccentColor),
        //           title: Text(
        //               'approval'.tr(),
        //               style:kNavItemTextStyle
        //           ),
        //           onTap: () async {
        //             if(exp_approval_flag)
        //             {
        //               Navigator.of(context)
        //                   .push(
        //                 MaterialPageRoute(
        //                   builder: (context) =>
        //                       ApprovalPage(),
        //                 ),
        //               );
        //             }
        //             else{
        //               AllServices()
        //                   .messageForUser(
        //                   "not_authorized_msg"
        //                       .tr());
        //
        //             }
        //
        //           },
        //         ):SizedBox.shrink(),
        //       ],
        //     ),
        //   ),
        // ),
        appBar: AppBar(
          leading: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 2.0, top: 6, bottom: 6), // Adjust padding as needed
                child: logo_url_1 != null
                    ? CachedNetworkImage(
                        imageUrl: logo_url_1!,
                        errorWidget: (context, url, error) => SizedBox.shrink(),
                      )
                    : SizedBox.shrink(),
              ),
              IconButton(
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          title: notice == "" || notice_auto_scroll_flag == false
              ? Container(
                  margin: EdgeInsets.only(
                      left: 0.0), // Adjust margin to control the gap
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.black, width: 1.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: FittedBox(
                    child: Text(
                      'MREPORTING $appVersion',
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => NoticeScreen()));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black, width: 1.0),
                        color: Colors.white),
                    child: Center(
                      child: Marquee(
                        text: notice,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                        scrollAxis: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        blankSpace: 300,
                        velocity: 50.0,
                        startPadding: 10.0,
                        accelerationDuration: Duration(seconds: 0),
                        accelerationCurve: Curves.bounceIn,
                        decelerationDuration: Duration(milliseconds: 0),
                        decelerationCurve: Curves.easeOut,
                      ),
                    ),
                  ),
                ),
          titleTextStyle: const TextStyle(
            color: Color.fromARGB(255, 27, 56, 34),
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
          centerTitle: true,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        bottomNavigationBar: rxFlag == true
            ? BottomAppBar(
                color: kPrimaryColor,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RxPage(
                          address: '',
                          areaId: '',
                          areaName: '',
                          ck: '',
                          dcrKey: 0,
                          docId: '',
                          docName: '',
                          uniqueId: 0,
                          draftRxMedicinItem: [],
                          image1: '',
                          dcrGrad: '',
                          isDirectCapture: true,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                        Text(
                          'Camera',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              )

            // BottomNavigationBar(
            //   elevation: 0,
            //   // backgroundColor: Color.fromARGB(255, 138, 201, 149),
            //         // type: BottomNavigationBarType.fixed,
            //         onTap: _onItemTapped,
            //         currentIndex: _currentSelected,
            //         // showUnselectedLabels: true,
            //         // unselectedItemColor:Colors.white,
            //         // selectedItemColor: Colors.white,
            //         items: <BottomNavigationBarItem>[
            //           BottomNavigationBarItem(
            //             label: 'inbox'.tr(),
            //             icon:Icon(Icons.chat),
            //           ),
            //           // rxFlag == false
            //           //     ?
            //           BottomNavigationBarItem(
            //             label: 'camera'.tr(),
            //             icon:Icon(Icons.camera_alt_rounded,color: Colors.white,size: 24,)
            //             // Image.asset("assets/icons/camera.png",height: 24,color: Colors.white,)
            //             // Icon(
            //             //   Icons.photo_camera_outlined,
            //             //   color: Colors.black87,
            //             // ),
            //           )
            //           // : const BottomNavigationBarItem(
            //           //     label: '',
            //           //     icon: Icon(
            //           //       Icons.photo_camera_outlined,
            //           //       color: Colors.white,
            //           //     ),
            //           //   )
            //         ],
            //       )
            : const Text(""),
        body: SafeArea(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ///*****************************************************  User information Section***********************************************///
                  UserInfoWidget(
                    endTime: endTime.toString(),
                    userName: userName.toString(),
                    userId: userId,
                    mobileNo: mobile_no,
                    startTime: startTime.toString(),
                    prefix: prefix,
                    prefix2: prefix2,
                  ),
                  // Container(
                  //   //height: screenHeight / 9.3,
                  //   width: MediaQuery.of(context).size.width,
                  //   color: kContainerBackgroundColor,
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         flex: 5,
                  //         child: Padding(
                  //             padding: const EdgeInsets.all(5.0),
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 FittedBox(
                  //                   fit: BoxFit.contain,
                  //                   child: Text(
                  //                     userName.toString(),
                  //
                  //                     // ' $userName',
                  //                     style:
                  //                      titleTextHeadingStyleBold,
                  //                   ),
                  //                 ),
                  //                 FittedBox(
                  //                     fit: BoxFit.contain,
                  //                     child:
                  //                         // cid == "NOVO"
                  //                         //    ? Text(
                  //                         //        'Initial: ' +
                  //                         //            widget.user_id.toUpperCase() +
                  //                         //            '\n' +
                  //                         //            mobile_no,
                  //                         //        // ' $userName',
                  //                         //        style: const TextStyle(
                  //                         //          color: Color.fromARGB(
                  //                         //              255, 15, 53, 85),
                  //                         //          fontSize: 18,
                  //                         //          // fontWeight: FontWeight.bold
                  //                         //        ),
                  //                         //      )
                  //                         //    :
                  //
                  //                         Text(
                  //                       '${'id'.tr()}: $user_id\n$mobile_no',
                  //                       // ' $userName',
                  //                       style:titleTextHeadingStyle
                  //                     )),
                  //               ],
                  //             )),
                  //       ),
                  //       Expanded(
                  //         flex: 3,
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(5.0),
                  //           child: Column(
                  //             // mainAxisAlignment: MainAxisAlignment.start,
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               GestureDetector(
                  //                 onTap: (() {
                  //                   Navigator.push(
                  //                       context,
                  //                       MaterialPageRoute(
                  //                           builder: (context) =>
                  //                               const AttendanceScreen()));
                  //                 }),
                  //                 child: FittedBox(
                  //                   fit: BoxFit.contain,
                  //                   child: prefix != prefix2
                  //                       ? Text(
                  //                           '[${'attendance'.tr()}]'
                  //                           '\n'
                  //                           '${'start'.tr()}:'
                  //                           " "
                  //                           '\n'
                  //                           "${'end'.tr()}: "
                  //                           " ",
                  //                           style: titleTextHeadingStyle
                  //                         )
                  //                       : Text(
                  //                           '[${'attendance'.tr()}]'
                  //                                   '\n'
                  //                                   '${'start'.tr()}: ' +
                  //                               startTime.toString() +
                  //                               '\n' +
                  //                               "${'end'.tr()}: " +
                  //                               endTime.toString(),
                  //                           style: titleTextHeadingStyle,
                  //                         ),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(
                    height: 8,
                  ),

                  ///************************************************ Target Sales Achievement *********************************************///

                  target_sales_achievement_flag
                      ? Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    topRight: Radius.circular(6),
                                  ),
                                  color: Color(0xff70BA85).withOpacity(0.3),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Target",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  height: 1.5),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Sales",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    height: 1.5),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Achievement",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  height: 1.5),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                height: 2,
                                color: Colors.white,
                              ),
                              Container(
                                height: 50,
                                color: Color.fromARGB(255, 222, 237, 250),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          child: Text(
                                            targetAmount,
                                            style: TextStyle(height: 1.5),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        color:
                                            Color(0xff70BA85).withOpacity(0.3),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            child: Text(
                                              salesAmount,
                                              style: TextStyle(height: 1.5),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          child: Text(
                                            achievementAmount,
                                            style: TextStyle(height: 1.5),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(),
                  SizedBox(
                    height: target_sales_achievement_flag ? 5 : 2,
                  ),

                  ///************************************************ Order area Field *********************************************///

                  orderFlag
                      ? CustomExpansionTileWidget(
                          isExpanded: () {
                            //   setState(() {
                            //   _scrollToExpandedTile();
                            //
                            // });
                          },
                          title: "order_section".tr(),
                          imageAsset: ImageConstant.newOrder2Image,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: customBuildIconButton(
                                      height: 50,
                                      width: 50,
                                      icon: ImageConstant.newOrderImage,
                                      onClick: () async {
                                        if (areaPage == false) {
                                          await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ClaientRoutePage()));
                                          //  await getAllCustomarData(); //todo old without route
                                          setState(() {
                                            //     Box box= Hive.box('mpoForClaient');
                                            // print("*******client ${ box.values.toList()}");
                                          });
                                        } else {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => AreaPage()),
                                          );
                                          setState(() {});
                                        }

                                        //  debugPrint(areaPage);
                                      },
                                      // title: buttonNames?.get('new_order') == "" ? 'New Order' : buttonNames?.get('new_order') ?? 'New Order',
                                      title: "new_order".tr(),
                                      sizeWidth: screenWidth,
                                      inputColor: Colors.white
                                      // inputColor: const Color(0xff70BA85)
                                      //     .withOpacity(.3),
                                      ),
                                ),
                                order_approval_flag == true
                                    ? SizedBox(width: 5)
                                    : SizedBox.shrink(),
                                order_approval_flag == true
                                    ? Expanded(
                                        child: customBuildIconButton(
                                          height: 50,
                                          width: 50,
                                          icon:
                                              ImageConstant.orderApprovalImage,
                                          onClick: () async {
                                            {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        OrderApprovalAreaScreen()),
                                              );
                                              setState(() {});
                                            }

                                            //  debugPrint(areaPage);
                                          },
                                          // title: buttonNames?.get('order_approval') == "" ? 'Order Approval' : buttonNames?.get('order_approval') ?? 'Order Approval',
                                          title: "order_approval".tr(),
                                          sizeWidth: screenWidth,
                                          inputColor: Colors.white,
                                          // inputColor:
                                          //     const Color(0xff70BA85)
                                          //         .withOpacity(.3),
                                        ),
                                      )
                                    : SizedBox.shrink(),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Stack(
                                    children: [
                                      customBuildIconButton(
                                        height: 50,
                                        width: 50,
                                        icon: ImageConstant.draftImage,
                                        onClick: () async {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const DraftOrderPage(),
                                            ),
                                          );
                                          setState(() {});
                                        },
                                        // title: buttonNames?.get('draft_order') == "" ? 'Draft Order' : buttonNames?.get('draft_order') ?? 'Draft Order',
                                        title: "draft_order".tr(),
                                        sizeWidth: screenWidth,
                                        inputColor: Colors.white,
                                      ),
                                      Positioned(
                                          right: 0,
                                          child: Container(
                                            height: 35,
                                            width: 35,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  135, 2, 160, 68),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Center(
                                              child: Text(
                                                  Boxes.getCustomerUsers()
                                                      .length
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: customBuildIconButton(
                                    height: 45,
                                    width: 45,
                                    icon: ImageConstant.documentsImage,
                                    onClick: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              OrderReportWebViewScreen(
                                            report_url: report_sales_url,
                                            cid: cid,
                                            userId: userId,
                                            userPassword: userPassword,
                                          ),
                                        ),
                                      );
                                    },
                                    // title: buttonNames?.get('order_report') == "" ? 'Report' : buttonNames?.get('order_report') ?? 'Report',
                                    title: "report".tr(),
                                    sizeWidth: screenWidth,
                                    inputColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          containerColor: expansionContainerBackColour1,
                        )
                      : Container(),
                  orderFlag
                      ? const SizedBox(
                          height: 10,
                        )
                      : const SizedBox.shrink(),

                  ///******************************************** DCR Section ********************************************///

                  dcrFlag
                      ? CustomExpansionTileWidget(
                          isExpanded: () {
                            // setState(() {
                            //   _scrollToExpandedTile();
                            // });
                          },
                          title: "dcr_section".tr(),
                          imageAsset: ImageConstant.doctorImage,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: customBuildIconButton(
                                    icon: ImageConstant.newDcr2Image,
                                    onClick: () async {
                                      if (areaPage == false) {
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DoctorTerritoryPage()));

                                        //  SyncDcrtoHive().getData(context);//todo old
                                        setState(() {});
                                      } else {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  AreaPage(isdcr: "dcr")),
                                        );
                                        setState(() {});
                                      }
                                    },
                                    // title: buttonNames?.get('new_dcr') == "" ? 'New DCR' : buttonNames?.get('new_dcr') ?? 'New DCR',
                                    title: "new_dcr".tr(),
                                    sizeWidth: screenWidth,
                                    inputColor: Colors.white,
                                    height: 50,
                                    width: 50,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Stack(
                                    children: [
                                      customBuildIconButton(
                                        height: 40,
                                        width: 40,
                                        icon: ImageConstant.firstAidKitImage,
                                        onClick: () async {
                                          await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const DraftDCRScreen()));
                                          setState(() {});
                                        },
                                        // title: buttonNames?.get('draft_dcr') == "" ? 'Draft DCR' : buttonNames?.get('draft_dcr') ?? 'Draft DCR',
                                        title: "draft_dcr".tr(),
                                        sizeWidth: screenWidth,
                                        inputColor: Colors.white,
                                      ),
                                      Positioned(
                                        right: 0,
                                        child: Container(
                                          height: 35,
                                          width: 35,
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                135, 2, 160, 68),
                                            borderRadius:
                                                BorderRadius.circular(17),
                                          ),
                                          child: Center(
                                            child: Text(
                                              Boxes.dcrUsers()
                                                  .length
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: customBuildIconButton(
                                    height: 50,
                                    width: 50,
                                    icon: ImageConstant.dcrReportImage,
                                    onClick: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DcrReportWebView(
                                            report_url: report_dcr_url,
                                            cid: cid,
                                            userId: userId,
                                            userPassword: userPassword,
                                            // deviceId: deviceId,
                                          ),
                                        ),
                                      );
                                    },
                                    // title: buttonNames?.get('dcr_report') == "" ? 'DCR Report' : buttonNames?.get('dcr_report') ?? 'DCR Report',
                                    title: "dcr_report".tr(),
                                    sizeWidth: screenWidth,
                                    inputColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          containerColor:
                              const Color(0xff56CCF2).withOpacity(.3),
                        )
                      : Container(),
                  dcrFlag
                      ? const SizedBox(
                          height: 10,
                        )
                      : const SizedBox.shrink(),

                  ///********************************************* New Rx section **************************************///

                  rxFlag
                      ? CustomExpansionTileWidget(
                          isExpanded: () {
                            // setState(() {
                            //   _scrollToExpandedTile();
                            // });
                          },
                          title: buttonNames?.get('seen_rx_capture') == ""
                              ? 'rx_section'.tr()
                              : buttonNames?.get('seen_rx_capture') ??
                                  'rx_section'.tr(),
                          imageAsset: ImageConstant.prescription1Image,
                          containerColor:
                              kExpansionTileExpandedColorSet1.withAlpha(30),
                          children: [
                            customBuildIconButton(
                              height: 42,
                              width: 42,
                              icon: ImageConstant.prescriptionRxImage,
                              onClick: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RxPage(
                                      address: '',
                                      areaId: '',
                                      areaName: '',
                                      ck: '',
                                      dcrKey: 0,
                                      docId: '',
                                      docName: '',
                                      uniqueId: 0,
                                      draftRxMedicinItem: [],
                                      image1: '',
                                      dcrGrad: '',
                                    ),
                                  ),
                                );
                                setState(() {});
                              },
                              // title: buttonNames?.get('seen_rx_capture') == "" ? 'Seen RX Capture' : buttonNames?.get('seen_rx_capture') ?? 'Seen RX Capture',
                              title: "seen_rx_capture".tr(),
                              sizeWidth: screenWidth,
                              inputColor: Colors.white,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Stack(
                                    children: [
                                      customBuildIconButton(
                                        height: 39,
                                        width: 39,
                                        icon: ImageConstant.folderRxImage,
                                        onClick: () async {
                                          await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const RxDraftPage()));

                                          setState(() {});
                                        },
                                        // title: buttonNames?.get('draft_seen_rx') == "" ? 'Draft Seen Rx' : buttonNames?.get('draft_seen_rx') ?? 'Draft Seen Rx',
                                        title: "draft_seen_rx".tr(),
                                        sizeWidth: screenWidth,
                                        inputColor: Colors.white,
                                      ),
                                      Positioned(
                                          right: 0,
                                          child: Container(
                                            height: 35,
                                            width: 35,
                                            decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                    135, 2, 160, 68),
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Center(
                                                child: Text(
                                              Boxes.rxdDoctor()
                                                  .length
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                          ))
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: customBuildIconButton(
                                    height: 42,
                                    width: 42,
                                    icon: ImageConstant.rxReportImage,
                                    onClick: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => RxReportPageWebView(
                                            cid: cid,
                                            userId: userId,
                                            userPassword: userPassword,
                                            report_url: report_rx_url,
                                          ),
                                        ),
                                      );
                                    },
                                    // title: buttonNames?.get('seen_rx_report') == "" ? 'Seen RX Report' : buttonNames?.get('seen_rx_report') ?? 'Seen RX Report',
                                    title: "seen_rx_report".tr(),
                                    sizeWidth: screenWidth,
                                    inputColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        )
                      : Container(),
                  rxFlag == true
                      ? const SizedBox(
                          height: 10,
                        )
                      : const SizedBox.shrink(),

                  ///*******************************************Expense and Attendance  section ***********************************///
                  othersFlag == true
                      ? CustomExpansionTileWidget(
                          isExpanded: () {
                            // _scrollToExpandedTile();
                          },
                          title: "expense".tr(),
                          imageAsset: ImageConstant.spendingImage,
                          containerColor:
                              kExpansionTileExpandedColorSet2.withAlpha(30),
                          children: [
                            prefix2 != prefix
                                ?
                                // startTime == ""
                                //     ?
                                Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Container(
                                      height: 30,
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "Please Give Meter Reading First",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  )
                                // : Text("ok")
                                : const Text(""),
                            Container(
                              height: size.height * 0.16,
                              child: customBuildButton(
                                // elevation: 0.0,
                                onClick: () async {
                                  // newList = await expenseEntry();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AttendanceScreen(
                                              // expenseTypelist: newList,
                                              // callback: () {}, tempExpList: [],
                                              // expDraftDate: '',
                                              // tempExpenseList: [],
                                              ),
                                    ),
                                  );
                                },
                                title: "attendance_meter_reading".tr(),
                                sizeWidth: MediaQuery.of(context).size.width,
                                inputColor: Colors.white,
                                //inputColor: const Color(0xff56CCF2).withOpacity(.3),
                                icon: Icons.chrome_reader_mode_sharp,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              height: size.height * 0.16,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: double.infinity,
                                      child: customBuildButton(
                                        onClick: () async {
                                          if (isExpenseSync == true) {
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const ExpenseEntry(),
                                              ),
                                            );
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: 'Please Sync Expense',
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                          }
                                          setState(() {});
                                          // isClick = true;
                                          // debugPrint("clicked is:$isClick");
                                          // }
                                        },
                                        // color: Colors.green,
                                        title: isloading
                                            ? "expense_entry".tr()
                                            : "Loading...",
                                        sizeWidth:
                                            MediaQuery.of(context).size.width,

                                        icon: Icons.draw_rounded,
                                        inputColor: Colors.white,
                                        //inputColor: const Color(0xff56CCF2).withOpacity(.3),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 6.0,
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: double.infinity,
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: double.infinity,
                                            child: customBuildButton(
                                              onClick: () async {
                                                await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const ExpenseDraft()));
                                              },
                                              title: "draft".tr(),
                                              sizeWidth: 300,
                                              icon: Icons.pending_actions_sharp,

                                              inputColor: Colors.white,
                                              //inputColor: const Color(0xff56CCF2).withOpacity(.3),
                                            ),
                                          ),
                                          Positioned(
                                              right: 0,
                                              child: Container(
                                                height: 35,
                                                width: 35,
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      135, 2, 160, 68),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                      Hive.box(
                                                              "draftForExpense")
                                                          .length
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            exp_approval_flag == true
                                ? Container(
                                    height: size.height * 0.16,
                                    margin: EdgeInsets.only(bottom: 10.0),
                                    child: customBuildButton(
                                      onClick: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ExpenseApprovalPage(),
                                          ),
                                        );
                                      },
                                      title: "approval".tr(),
                                      sizeWidth:
                                          MediaQuery.of(context).size.width,
                                      icon: Icons.approval,
                                      inputColor: Colors.white,
                                      //inputColor: const Color(0xff56CCF2).withOpacity(.3),
                                    ),
                                  )
                                : SizedBox(),
                            Container(
                                height: size.height * 0.16,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: double.infinity,
                                        child: customBuildButton(
                                          onClick: () async {
                                            // debugPrint(ExpenseLog);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const ExpenseLogScreen(),
                                              ),
                                            );
                                          },
                                          title: "expense_log".tr(),
                                          sizeWidth: 300,
                                          inputColor: Colors.white,
                                          //inputColor: const Color(0xff56CCF2).withOpacity(.3),
                                          icon: Icons.receipt_long_sharp,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 6.0,
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: double.infinity,
                                        child: customBuildButton(
                                          icon: Icons.summarize,
                                          inputColor: Colors.white,
                                          //inputColor: const Color(0xff56CCF2).withOpacity(.3),
                                          onClick: () async {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const AttendanceMeterHistory()));
                                          },
                                          sizeWidth: 300,
                                          title:
                                              'attendance_mtr_reading_log'.tr(),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                                height: size.height * 0.16,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: double.infinity,
                                        child: customBuildButton(
                                          icon: Icons.summarize,
                                          inputColor: Colors.white,
                                          onClick: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const ExpenseSummaryScreen()));
                                          },
                                          sizeWidth: 300,
                                          title: 'expense_summary'.tr(),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 6.0,
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: double.infinity,
                                        child: customBuildButton(
                                          onClick: () async {
                                            // var url =

                                            //     '$expense_report?cid=$cid&rep_id=$userId&rep_pass=$user_pass';
                                            // debugPrint(url);
                                            // if (await canLaunch(url)) {
                                            //   await launch(url);
                                            // } else {
                                            //   throw 'Could not launch $url';
                                            // }
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  ExpenseReportPage(),
                                            ));
                                          },
                                          title: "expense_details".tr(),
                                          sizeWidth:
                                              MediaQuery.of(context).size.width,
                                          icon: Icons.document_scanner,
                                          inputColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        )
                      : Container(),
                  othersFlag
                      ? const SizedBox(
                          height: 10,
                        )
                      : const SizedBox.shrink(),

                  ///***********Others****************///
                  CustomExpansionTileWidget(
                    isExpanded: () {
                      _scrollToExpandedTile();
                    },
                    title: "others".tr(),
                    imageAsset: ImageConstant.otherImage,
                    containerColor: const Color(0x7095BAFF).withOpacity(.3),
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    elevation: 5,
                                    child: Container(
                                      width: screenWidth,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              8,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: TextButton.icon(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const AttendanceScreen()));
                                          },
                                          label: Text(
                                            // buttonNames?.get('leave_request') == "" ? 'Leave Request' : buttonNames?.get('leave_request') ?? 'Leave Request',
                                            "attendance".tr(),
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 29, 67, 78),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          icon: const Icon(
                                            Icons.library_add_check,
                                            color:
                                                Color.fromARGB(255, 27, 56, 34),
                                            size: 28,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    elevation: 5,
                                    child: Container(
                                      width: screenWidth,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              8,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: TextButton.icon(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        NoticeScreen()));
                                          },
                                          label: Text(
                                            // buttonNames?.get('leave_report') == "" ? 'Leave Report' : buttonNames?.get('leave_report') ?? 'Leave Report',
                                            "notice".tr(),
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 29, 67, 78),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          icon: const Icon(
                                            Icons.notifications_active,
                                            color:
                                                Color.fromARGB(255, 27, 56, 34),
                                            size: 28,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      ///******************************************* Leave Request and Leave Report **********************************///
                      leave_flag
                          ? Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Link(
                                          uri: Uri.parse(
                                              '$leave_request_url?cid=$cid&rep_id=$userId&rep_pass=$userPassword'),
                                          target: LinkTarget.blank,
                                          builder: (BuildContext ctx,
                                              FollowLink? openLink) {
                                            // debugPrint(
                                            //     "$leave_request_url?cid=$cid&rep_id=$userId&rep_pass=$userPassword");
                                            return Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              elevation: 5,
                                              child: Container(
                                                width: screenWidth,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    8,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: TextButton.icon(
                                                    onPressed: openLink,
                                                    label: Text(
                                                      // buttonNames?.get('leave_request') == "" ? 'Leave Request' : buttonNames?.get('leave_request') ?? 'Leave Request',
                                                      "leave_request".tr(),
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 29, 67, 78),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    icon: const Icon(
                                                      Icons
                                                          .leave_bags_at_home_rounded,
                                                      color: Color.fromARGB(
                                                          255, 27, 56, 34),
                                                      size: 28,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: Link(
                                          uri: Uri.parse(
                                              '$leave_report_url?cid=$cid&rep_id=$userId&rep_pass=$userPassword'),
                                          target: LinkTarget.blank,
                                          builder: (BuildContext ctx,
                                              FollowLink? openLink) {
                                            return Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              elevation: 5,
                                              child: Container(
                                                width: screenWidth,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    8,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: TextButton.icon(
                                                    onPressed: openLink,
                                                    label: Text(
                                                      // buttonNames?.get('leave_report') == "" ? 'Leave Report' : buttonNames?.get('leave_report') ?? 'Leave Report',
                                                      "leave_report".tr(),
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 29, 67, 78),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    icon: const Icon(
                                                      Icons.insert_drive_file,
                                                      color: Color.fromARGB(
                                                          255, 27, 56, 34),
                                                      size: 28,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      othersFlag
                          ? const SizedBox(
                              height: 5,
                            )
                          : const SizedBox.shrink(),

                      ///******************************************  Tour Plan *********************************************///
                      visitPlanFlag
                          ? Container(
                              // color: const Color(0xFFDDEBF7),
                              height: screenHeight / 7,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                elevation: 5,
                                                child: Container(
                                                  // color: const Color.fromARGB(
                                                  //     255, 217, 224, 250),
                                                  width: screenWidth,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      8,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: TextButton.icon(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .push(
                                                                MaterialPageRoute(
                                                          builder: (context) =>
                                                              TourPlanPage(),
                                                        ));
                                                      },
                                                      label: Text(
                                                        // buttonNames?.get('tour_plan') == "" ? 'Tour Plan' : buttonNames?.get('tour_plan') ?? 'Tour Plan',
                                                        "tour_plan".tr(),
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    29,
                                                                    67,
                                                                    78),
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      icon: const Icon(
                                                        Icons.tour_sharp,
                                                        color: Color.fromARGB(
                                                            255, 27, 56, 34),
                                                        size: 28,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            // ggggg
                                            Expanded(
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                elevation: 5,
                                                child: Container(
                                                  // color: const Color.fromARGB(
                                                  //     255, 217, 224, 250),
                                                  width: screenWidth,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      8,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: TextButton.icon(
                                                      onPressed:
                                                          exp_approval_flag
                                                              ? () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              ApprovalPage(),
                                                                    ),
                                                                  );
                                                                }
                                                              : () {
                                                                  AllServices()
                                                                      .messageForUser(
                                                                          "not_authorized_msg"
                                                                              .tr());
                                                                },
                                                      label: Text(
                                                        // buttonNames?.get('approval') == "" ? 'Approval' : buttonNames?.get('approval') ?? 'Approval',
                                                        "approval".tr(),
                                                        // 'Approval & Compliance',
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    29,
                                                                    67,
                                                                    78),
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      icon: const Icon(
                                                        Icons.touch_app_rounded,
                                                        color: Color.fromARGB(
                                                            255, 27, 56, 34),
                                                        size: 28,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      visitPlanFlag
                          ? const SizedBox(
                              height: 5,
                            )
                          : const SizedBox.shrink(),

                      ///***********************************  Plugg-in & Reports *************************************************///
                      pluginFlag
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              elevation: 5,
                                              child: Container(
                                                width: screenWidth,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    8,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: TextButton.icon(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .push(
                                                              MaterialPageRoute(
                                                        builder: (context) =>
                                                            PlugInReportsPage(),
                                                      ));
                                                    },
                                                    label: Text(
                                                      // buttonNames?.get('plug_in_reports') == " " ? 'Plug-in &  Reports' : buttonNames?.get('plug_in_reports') ?? 'Plug-in &  Reports',
                                                      'plugin'.tr(),
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 29, 67, 78),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    icon: const Icon(
                                                      Icons.insert_drive_file,
                                                      color: Color.fromARGB(
                                                          255, 27, 56, 34),
                                                      size: 28,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              elevation: 5,
                                              child: Container(
                                                width: screenWidth,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    8,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: TextButton.icon(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .push(
                                                              MaterialPageRoute(
                                                        builder: (context) =>
                                                            ActivityLogPage(),
                                                      ));
                                                    },
                                                    label: Text(
                                                      // buttonNames?.get('activity_log') == "" ? 'Activity Log' : buttonNames?.get('activity_log') ?? 'Activity Log',
                                                      'activity_log'.tr(),
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 29, 67, 78),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    icon: const Icon(
                                                      Icons
                                                          .local_activity_rounded,
                                                      color: Color.fromARGB(
                                                          255, 27, 56, 34),
                                                      size: 28,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Container(),
                      pluginFlag == true
                          ? const SizedBox(
                              height: 10,
                            )
                          : const SizedBox.shrink(),

                      ///****************************************** Sync Data************************************************///
                      // Container(
                      //   // color: const Color(0xFFE2EFDA),
                      //   height: screenHeight / 7,
                      //   width: screenWidth,
                      //   child: Column(
                      //     children: [
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           //==========================================================Notice flag +Notice url will be here====================================
                      //           notice_flag
                      //               ? Expanded(
                      //             child: customBuildButton(
                      //
                      //               icon: Icons.note_alt,
                      //               onClick: () {
                      //                 Navigator.push(
                      //                     context,
                      //                     MaterialPageRoute(
                      //                         builder: (_) =>
                      //                         const NoticeScreen()));
                      //               },
                      //               // title: buttonNames?.get('notice') == "" ? 'Notice' : buttonNames?.get('notice') ?? 'Notice',
                      //               title: "notice".tr(),
                      //               sizeWidth: screenWidth,
                      //               inputColor: Colors.white,
                      //             ),
                      //           )
                      //               : const SizedBox.shrink(),
                      //
                      //           Expanded(
                      //             child: customBuildButton(
                      //               icon: Icons.sync,
                      //               onClick: () {
                      //                 Navigator.push(
                      //                     context,
                      //                     MaterialPageRoute(
                      //                         builder: (_) => SyncDataTabScreen(
                      //                           cid: cid,
                      //                           userId: userId,
                      //                           userPassword: userPassword,
                      //                         )));
                      //               },
                      //               // title: buttonNames?.get('sync_data') == "" ? 'Sync Data' : buttonNames?.get('sync_data') ?? 'Sync Data',
                      //               title: 'sync_data'.tr(),
                      //               sizeWidth: screenWidth,
                      //               inputColor: Colors.white,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  )
                  // ExpansionTile(
                  //   tilePadding: EdgeInsets.only(right: 24,left: 16),
                  //   collapsedBackgroundColor:const Color(0x7095BAFF).withOpacity(.3),
                  //   backgroundColor: const Color(0x7095BAFF).withOpacity(.3),
                  //   childrenPadding: EdgeInsets.symmetric(horizontal: 10),
                  //
                  //   trailing: Column(
                  //
                  //     mainAxisSize: MainAxisSize.max,
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Icon(Icons.keyboard_double_arrow_down)
                  //     ],
                  //   ),
                  //     title: Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         children: [
                  //           Image.asset(
                  //             "assets/icons/other.png",
                  //             height: 60,
                  //           ),
                  //           // SizedBox(
                  //           //   width: 10,
                  //           // ),
                  //           // Icon(Icons.shopping_cart,size: 35,),
                  //           Expanded(
                  //             child: Text(
                  //               textAlign: TextAlign.center,
                  //               "others".tr(),
                  //               style: const TextStyle(
                  //                   color: Color.fromARGB(255, 29, 67, 78),
                  //                   fontSize: 18,
                  //                   fontWeight: FontWeight.w500),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  // children: [
                  //   ///******************************************* Leave Request and Leave Report **********************************///
                  //   !leave_flag
                  //       ? Container(
                  //
                  //     height: screenHeight / 6.9,
                  //     width: MediaQuery.of(context).size.width,
                  //
                  //     child: Column(
                  //       children: [
                  //         Row(
                  //           children: [
                  //             Expanded(
                  //               child: Link(
                  //                 uri: Uri.parse(
                  //                     '$leave_request_url?cid=$cid&rep_id=$userId&rep_pass=$userPassword'),
                  //                 target: LinkTarget.blank,
                  //                 builder: (BuildContext ctx,
                  //                     FollowLink? openLink) {
                  //                   // debugPrint(
                  //                   //     "$leave_request_url?cid=$cid&rep_id=$userId&rep_pass=$userPassword");
                  //                   return Card(
                  //                     // shape: RoundedRectangleBorder(
                  //                     //     borderRadius:
                  //                     // BorderRadius.circular(40)),
                  //                     elevation: 5,
                  //                     child: Container(
                  //
                  //                       width: screenWidth,
                  //
                  //                       height: MediaQuery.of(context)
                  //                           .size
                  //                           .height /
                  //                           8,
                  //                       child: Padding(
                  //                         padding:
                  //                         const EdgeInsets.all(10.0),
                  //                         child: TextButton.icon(
                  //                           onPressed: openLink,
                  //                           label: Text(
                  //                             // buttonNames?.get('leave_request') == "" ? 'Leave Request' : buttonNames?.get('leave_request') ?? 'Leave Request',
                  //                             "leave_request".tr(),
                  //                             style: TextStyle(
                  //                                 color: Color.fromARGB(
                  //                                     255, 29, 67, 78),
                  //                                 fontSize: 16,
                  //                                 fontWeight:
                  //                                 FontWeight.w500),
                  //                           ),
                  //                           icon: const Icon(
                  //                             Icons
                  //                                 .leave_bags_at_home_rounded,
                  //                             color: Color.fromARGB(
                  //                                 255, 27, 56, 34),
                  //                             size: 28,
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   );
                  //                 },
                  //               ),
                  //             ),
                  //             const SizedBox(
                  //               width: 5,
                  //             ),
                  //             Expanded(
                  //               child: Link(
                  //                 uri: Uri.parse(
                  //                     '$leave_report_url?cid=$cid&rep_id=$userId&rep_pass=$userPassword'),
                  //                 target: LinkTarget.blank,
                  //                 builder: (BuildContext ctx,
                  //                     FollowLink? openLink) {
                  //                   return Card(
                  //                     elevation: 5,
                  //                     child: Container(
                  //                       color: Colors.white,
                  //                       width: screenWidth,
                  //                       height: MediaQuery.of(context)
                  //                           .size
                  //                           .height /
                  //                           8,
                  //                       child: Padding(
                  //                         padding:
                  //                         const EdgeInsets.all(10.0),
                  //                         child: TextButton.icon(
                  //                           onPressed: openLink,
                  //                           label: Text(
                  //                             // buttonNames?.get('leave_report') == "" ? 'Leave Report' : buttonNames?.get('leave_report') ?? 'Leave Report',
                  //                             "leave_report".tr(),
                  //                             style: TextStyle(
                  //                                 color: Color.fromARGB(
                  //                                     255, 29, 67, 78),
                  //                                 fontSize: 16,
                  //                                 fontWeight:
                  //                                 FontWeight.w500),
                  //                           ),
                  //                           icon: const Icon(
                  //                             Icons.insert_drive_file,
                  //                             color: Color.fromARGB(
                  //                                 255, 27, 56, 34),
                  //                             size: 28,
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   );
                  //                 },
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ],
                  //     ),
                  //   )
                  //       : Container(),
                  //   othersFlag
                  //       ? const SizedBox(
                  //     height: 5,
                  //   )
                  //       : const SizedBox.shrink(),
                  //
                  //   ///******************************************  Tour Plan *********************************************///
                  //   visitPlanFlag
                  //       ? Container(
                  //     // color: const Color(0xFFDDEBF7),
                  //     height: screenHeight / 7,
                  //     width: MediaQuery.of(context).size.width,
                  //     child: Column(
                  //       children: [
                  //         Column(
                  //           children: [
                  //             Row(
                  //               children: [
                  //                 Expanded(
                  //                   child: Card(
                  //                     elevation: 5,
                  //                     child: Container(
                  //                       // color: const Color.fromARGB(
                  //                       //     255, 217, 224, 250),
                  //                       width: screenWidth,
                  //                       height: MediaQuery.of(context)
                  //                           .size
                  //                           .height /
                  //                           8,
                  //                       child: Padding(
                  //                         padding:
                  //                         const EdgeInsets.all(10.0),
                  //                         child: TextButton.icon(
                  //                           onPressed: () {
                  //                             Navigator.of(context)
                  //                                 .push(MaterialPageRoute(
                  //                               builder: (context) =>
                  //                                   TourPlanPage(),
                  //                             ));
                  //                           },
                  //                           label: Text(
                  //                             // buttonNames?.get('tour_plan') == "" ? 'Tour Plan' : buttonNames?.get('tour_plan') ?? 'Tour Plan',
                  //                             "tour_plan".tr(),
                  //                             style: TextStyle(
                  //                                 color: Color.fromARGB(
                  //                                     255, 29, 67, 78),
                  //                                 fontSize: 16,
                  //                                 fontWeight:
                  //                                 FontWeight.w500),
                  //                           ),
                  //                           icon: const Icon(
                  //                             Icons.tour_sharp,
                  //                             color: Color.fromARGB(
                  //                                 255, 27, 56, 34),
                  //                             size: 28,
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 const SizedBox(
                  //                   width: 5,
                  //                 ),
                  //                 // ggggg
                  //                 Expanded(
                  //                   child: Card(
                  //                     elevation: 5,
                  //                     child: Container(
                  //                       // color: const Color.fromARGB(
                  //                       //     255, 217, 224, 250),
                  //                       width: screenWidth,
                  //                       height: MediaQuery.of(context)
                  //                           .size
                  //                           .height /
                  //                           8,
                  //                       child: Padding(
                  //                         padding:
                  //                         const EdgeInsets.all(10.0),
                  //                         child: TextButton.icon(
                  //                           onPressed: exp_approval_flag
                  //                               ? () {
                  //                             Navigator.of(context)
                  //                                 .push(
                  //                               MaterialPageRoute(
                  //                                 builder: (context) =>
                  //                                     ApprovalPage(),
                  //                               ),
                  //                             );
                  //                           }
                  //                               : () {
                  //                             AllServices()
                  //                                 .messageForUser(
                  //                                 "not_authorized_msg"
                  //                                     .tr());
                  //                           },
                  //                           label: Text(
                  //                             // buttonNames?.get('approval') == "" ? 'Approval' : buttonNames?.get('approval') ?? 'Approval',
                  //                             "approval".tr(),
                  //                             // 'Approval & Compliance',
                  //                             style: TextStyle(
                  //                                 color: Color.fromARGB(
                  //                                     255, 29, 67, 78),
                  //                                 fontSize: 15,
                  //                                 fontWeight:
                  //                                 FontWeight.w500),
                  //                           ),
                  //                           icon: const Icon(
                  //                             Icons.touch_app_rounded,
                  //                             color: Color.fromARGB(
                  //                                 255, 27, 56, 34),
                  //                             size: 28,
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ],
                  //         ),
                  //       ],
                  //     ),
                  //   )
                  //       : Container(),
                  //   visitPlanFlag
                  //       ? const SizedBox(
                  //     height: 5,
                  //   )
                  //       : const SizedBox.shrink(),
                  //
                  //   ///***********************************  Plugg-in & Reports *************************************************///
                  //   pluginFlag
                  //       ? Container(
                  //     color: const Color(0xFFDDEBF7),
                  //     height: screenHeight / 7,
                  //     width: MediaQuery.of(context).size.width,
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Column(
                  //           children: [
                  //             Row(
                  //               children: [
                  //                 Expanded(
                  //                   child: Card(
                  //                     elevation: 5,
                  //                     child: Container(
                  //                       color: Colors.white,
                  //                       width: screenWidth,
                  //                       height: MediaQuery.of(context)
                  //                           .size
                  //                           .height /
                  //                           8,
                  //                       child: Padding(
                  //                         padding:
                  //                         const EdgeInsets.all(10.0),
                  //                         child: TextButton.icon(
                  //                           onPressed: () {
                  //                             Navigator.of(context)
                  //                                 .push(MaterialPageRoute(
                  //                               builder: (context) =>
                  //                                   PlugInReportsPage(),
                  //                             ));
                  //                           },
                  //                           label: Text(
                  //                             // buttonNames?.get('plug_in_reports') == " " ? 'Plug-in &  Reports' : buttonNames?.get('plug_in_reports') ?? 'Plug-in &  Reports',
                  //                             'plugin'.tr(),
                  //                             style: TextStyle(
                  //                                 color: Color.fromARGB(
                  //                                     255, 29, 67, 78),
                  //                                 fontSize: 16,
                  //                                 fontWeight:
                  //                                 FontWeight.w500),
                  //                           ),
                  //                           icon: const Icon(
                  //                             Icons.insert_drive_file,
                  //                             color: Color.fromARGB(
                  //                                 255, 27, 56, 34),
                  //                             size: 28,
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 const SizedBox(
                  //                   width: 5,
                  //                 ),
                  //                 Expanded(
                  //                   child: Card(
                  //                     elevation: 5,
                  //                     child: Container(
                  //                       color: Colors.white,
                  //                       width: screenWidth,
                  //                       height: MediaQuery.of(context)
                  //                           .size
                  //                           .height /
                  //                           8,
                  //                       child: Padding(
                  //                         padding:
                  //                         const EdgeInsets.all(10.0),
                  //                         child: TextButton.icon(
                  //                           onPressed: () {
                  //                             Navigator.of(context)
                  //                                 .push(MaterialPageRoute(
                  //                               builder: (context) =>
                  //                                   ActivityLogPage(),
                  //                             ));
                  //                           },
                  //                           label: Text(
                  //                             // buttonNames?.get('activity_log') == "" ? 'Activity Log' : buttonNames?.get('activity_log') ?? 'Activity Log',
                  //                             'activity_log'.tr(),
                  //                             style: TextStyle(
                  //                                 color: Color.fromARGB(
                  //                                     255, 29, 67, 78),
                  //                                 fontSize: 16,
                  //                                 fontWeight:
                  //                                 FontWeight.w500),
                  //                           ),
                  //                           icon: const Icon(
                  //                             Icons.local_activity_rounded,
                  //                             color: Color.fromARGB(
                  //                                 255, 27, 56, 34),
                  //                             size: 28,
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ],
                  //         ),
                  //       ],
                  //     ),
                  //   )
                  //       : Container(),
                  //   pluginFlag == true
                  //       ? const SizedBox(
                  //     height: 10,
                  //   )
                  //       : const SizedBox.shrink(),
                  //
                  //   ///****************************************** Sync Data************************************************///
                  //   // Container(
                  //   //   // color: const Color(0xFFE2EFDA),
                  //   //   height: screenHeight / 7,
                  //   //   width: screenWidth,
                  //   //   child: Column(
                  //   //     children: [
                  //   //       Row(
                  //   //         mainAxisAlignment: MainAxisAlignment.center,
                  //   //         children: [
                  //   //           //==========================================================Notice flag +Notice url will be here====================================
                  //   //           notice_flag
                  //   //               ? Expanded(
                  //   //             child: customBuildButton(
                  //   //
                  //   //               icon: Icons.note_alt,
                  //   //               onClick: () {
                  //   //                 Navigator.push(
                  //   //                     context,
                  //   //                     MaterialPageRoute(
                  //   //                         builder: (_) =>
                  //   //                         const NoticeScreen()));
                  //   //               },
                  //   //               // title: buttonNames?.get('notice') == "" ? 'Notice' : buttonNames?.get('notice') ?? 'Notice',
                  //   //               title: "notice".tr(),
                  //   //               sizeWidth: screenWidth,
                  //   //               inputColor: Colors.white,
                  //   //             ),
                  //   //           )
                  //   //               : const SizedBox.shrink(),
                  //   //
                  //   //           Expanded(
                  //   //             child: customBuildButton(
                  //   //               icon: Icons.sync,
                  //   //               onClick: () {
                  //   //                 Navigator.push(
                  //   //                     context,
                  //   //                     MaterialPageRoute(
                  //   //                         builder: (_) => SyncDataTabScreen(
                  //   //                           cid: cid,
                  //   //                           userId: userId,
                  //   //                           userPassword: userPassword,
                  //   //                         )));
                  //   //               },
                  //   //               // title: buttonNames?.get('sync_data') == "" ? 'Sync Data' : buttonNames?.get('sync_data') ?? 'Sync Data',
                  //   //               title: 'sync_data'.tr(),
                  //   //               sizeWidth: screenWidth,
                  //   //               inputColor: Colors.white,
                  //   //             ),
                  //   //           ),
                  //   //         ],
                  //   //       ),
                  //   //     ],
                  //   //   ),
                  //   // ),
                  //
                  // ],),

                  // ///******************************************* Leave Request and Leave Report **********************************///
                  // leave_flag
                  //     ? Container(
                  //         color: const Color(0xFFE2EFDA),
                  //         height: screenHeight / 6.9,
                  //         width: MediaQuery.of(context).size.width,
                  //         child: Column(
                  //           children: [
                  //             Row(
                  //               children: [
                  //                 Expanded(
                  //                   child: Link(
                  //                     uri: Uri.parse(
                  //                         '$leave_request_url?cid=$cid&rep_id=$userId&rep_pass=$userPassword'),
                  //                     target: LinkTarget.blank,
                  //                     builder: (BuildContext ctx,
                  //                         FollowLink? openLink) {
                  //                       // debugPrint(
                  //                       //     "$leave_request_url?cid=$cid&rep_id=$userId&rep_pass=$userPassword");
                  //                       return Card(
                  //                         elevation: 5,
                  //                         child: Container(
                  //                           color: Colors.white,
                  //                           width: screenWidth,
                  //                           height: MediaQuery.of(context)
                  //                                   .size
                  //                                   .height /
                  //                               8,
                  //                           child: Padding(
                  //                             padding:
                  //                                 const EdgeInsets.all(10.0),
                  //                             child: TextButton.icon(
                  //                               onPressed: openLink,
                  //                               label: Text(
                  //                                 // buttonNames?.get('leave_request') == "" ? 'Leave Request' : buttonNames?.get('leave_request') ?? 'Leave Request',
                  //                                 "leave_request".tr(),
                  //                                 style: TextStyle(
                  //                                     color: Color.fromARGB(
                  //                                         255, 29, 67, 78),
                  //                                     fontSize: 16,
                  //                                     fontWeight:
                  //                                         FontWeight.w500),
                  //                               ),
                  //                               icon: const Icon(
                  //                                 Icons
                  //                                     .leave_bags_at_home_rounded,
                  //                                 color: Color.fromARGB(
                  //                                     255, 27, 56, 34),
                  //                                 size: 28,
                  //                               ),
                  //                             ),
                  //                           ),
                  //                         ),
                  //                       );
                  //                     },
                  //                   ),
                  //                 ),
                  //                 const SizedBox(
                  //                   width: 5,
                  //                 ),
                  //                 Expanded(
                  //                   child: Link(
                  //                     uri: Uri.parse(
                  //                         '$leave_report_url?cid=$cid&rep_id=$userId&rep_pass=$userPassword'),
                  //                     target: LinkTarget.blank,
                  //                     builder: (BuildContext ctx,
                  //                         FollowLink? openLink) {
                  //                       return Card(
                  //                         elevation: 5,
                  //                         child: Container(
                  //                           color: Colors.white,
                  //                           width: screenWidth,
                  //                           height: MediaQuery.of(context)
                  //                                   .size
                  //                                   .height /
                  //                               8,
                  //                           child: Padding(
                  //                             padding:
                  //                                 const EdgeInsets.all(10.0),
                  //                             child: TextButton.icon(
                  //                               onPressed: openLink,
                  //                               label: Text(
                  //                                 // buttonNames?.get('leave_report') == "" ? 'Leave Report' : buttonNames?.get('leave_report') ?? 'Leave Report',
                  //                                 "leave_report".tr(),
                  //                                 style: TextStyle(
                  //                                     color: Color.fromARGB(
                  //                                         255, 29, 67, 78),
                  //                                     fontSize: 16,
                  //                                     fontWeight:
                  //                                         FontWeight.w500),
                  //                               ),
                  //                               icon: const Icon(
                  //                                 Icons.insert_drive_file,
                  //                                 color: Color.fromARGB(
                  //                                     255, 27, 56, 34),
                  //                                 size: 28,
                  //                               ),
                  //                             ),
                  //                           ),
                  //                         ),
                  //                       );
                  //                     },
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ],
                  //         ),
                  //       )
                  //     : Container(),
                  // othersFlag
                  //     ? const SizedBox(
                  //         height: 5,
                  //       )
                  //     : const SizedBox.shrink(),
                  //
                  // ///******************************************  Tour Plan *********************************************///
                  // visitPlanFlag
                  //     ? Container(
                  //         color: const Color(0xFFDDEBF7),
                  //         height: screenHeight / 7,
                  //         width: MediaQuery.of(context).size.width,
                  //         child: Column(
                  //           children: [
                  //             Column(
                  //               children: [
                  //                 Row(
                  //                   children: [
                  //                     Expanded(
                  //                       child: Card(
                  //                         elevation: 5,
                  //                         child: Container(
                  //                           color: const Color.fromARGB(
                  //                               255, 217, 224, 250),
                  //                           width: screenWidth,
                  //                           height: MediaQuery.of(context)
                  //                                   .size
                  //                                   .height /
                  //                               8,
                  //                           child: Padding(
                  //                             padding:
                  //                                 const EdgeInsets.all(10.0),
                  //                             child: TextButton.icon(
                  //                               onPressed: () {
                  //                                 Navigator.of(context)
                  //                                     .push(MaterialPageRoute(
                  //                                   builder: (context) =>
                  //                                       TourPlanPage(),
                  //                                 ));
                  //                               },
                  //                               label: Text(
                  //                                 // buttonNames?.get('tour_plan') == "" ? 'Tour Plan' : buttonNames?.get('tour_plan') ?? 'Tour Plan',
                  //                                 "tour_plan".tr(),
                  //                                 style: TextStyle(
                  //                                     color: Color.fromARGB(
                  //                                         255, 29, 67, 78),
                  //                                     fontSize: 16,
                  //                                     fontWeight:
                  //                                         FontWeight.w500),
                  //                               ),
                  //                               icon: const Icon(
                  //                                 Icons.tour_sharp,
                  //                                 color: Color.fromARGB(
                  //                                     255, 27, 56, 34),
                  //                                 size: 28,
                  //                               ),
                  //                             ),
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                     const SizedBox(
                  //                       width: 5,
                  //                     ),
                  //                     // ggggg
                  //                     Expanded(
                  //                       child: Card(
                  //                         elevation: 5,
                  //                         child: Container(
                  //                           color: const Color.fromARGB(
                  //                               255, 217, 224, 250),
                  //                           width: screenWidth,
                  //                           height: MediaQuery.of(context)
                  //                                   .size
                  //                                   .height /
                  //                               8,
                  //                           child: Padding(
                  //                             padding:
                  //                                 const EdgeInsets.all(10.0),
                  //                             child: TextButton.icon(
                  //                               onPressed: exp_approval_flag
                  //                                   ? () {
                  //                                       Navigator.of(context)
                  //                                           .push(
                  //                                         MaterialPageRoute(
                  //                                           builder: (context) =>
                  //                                               ApprovalPage(),
                  //                                         ),
                  //                                       );
                  //                                     }
                  //                                   : () {
                  //                                       AllServices()
                  //                                           .messageForUser(
                  //                                               "not_authorized_msg"
                  //                                                   .tr());
                  //                                     },
                  //                               label: Text(
                  //                                 // buttonNames?.get('approval') == "" ? 'Approval' : buttonNames?.get('approval') ?? 'Approval',
                  //                                 "approval".tr(),
                  //                                 // 'Approval & Compliance',
                  //                                 style: TextStyle(
                  //                                     color: Color.fromARGB(
                  //                                         255, 29, 67, 78),
                  //                                     fontSize: 15,
                  //                                     fontWeight:
                  //                                         FontWeight.w500),
                  //                               ),
                  //                               icon: const Icon(
                  //                                 Icons.touch_app_rounded,
                  //                                 color: Color.fromARGB(
                  //                                     255, 27, 56, 34),
                  //                                 size: 28,
                  //                               ),
                  //                             ),
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ],
                  //             ),
                  //           ],
                  //         ),
                  //       )
                  //     : Container(),
                  // visitPlanFlag
                  //     ? const SizedBox(
                  //         height: 5,
                  //       )
                  //     : const SizedBox.shrink(),
                  //
                  // ///***********************************  Plugg-in & Reports *************************************************///
                  // pluginFlag
                  //     ? Container(
                  //         color: const Color(0xFFDDEBF7),
                  //         height: screenHeight / 7,
                  //         width: MediaQuery.of(context).size.width,
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.center,
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             Column(
                  //               children: [
                  //                 Row(
                  //                   children: [
                  //                     Expanded(
                  //                       child: Card(
                  //                         elevation: 5,
                  //                         child: Container(
                  //                           color: Colors.white,
                  //                           width: screenWidth,
                  //                           height: MediaQuery.of(context)
                  //                                   .size
                  //                                   .height /
                  //                               8,
                  //                           child: Padding(
                  //                             padding:
                  //                                 const EdgeInsets.all(10.0),
                  //                             child: TextButton.icon(
                  //                               onPressed: () {
                  //                                 Navigator.of(context)
                  //                                     .push(MaterialPageRoute(
                  //                                   builder: (context) =>
                  //                                       PlugInReportsPage(),
                  //                                 ));
                  //                               },
                  //                               label: Text(
                  //                                 // buttonNames?.get('plug_in_reports') == " " ? 'Plug-in &  Reports' : buttonNames?.get('plug_in_reports') ?? 'Plug-in &  Reports',
                  //                                 'plugin'.tr(),
                  //                                 style: TextStyle(
                  //                                     color: Color.fromARGB(
                  //                                         255, 29, 67, 78),
                  //                                     fontSize: 16,
                  //                                     fontWeight:
                  //                                         FontWeight.w500),
                  //                               ),
                  //                               icon: const Icon(
                  //                                 Icons.insert_drive_file,
                  //                                 color: Color.fromARGB(
                  //                                     255, 27, 56, 34),
                  //                                 size: 28,
                  //                               ),
                  //                             ),
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                     const SizedBox(
                  //                       width: 5,
                  //                     ),
                  //                     Expanded(
                  //                       child: Card(
                  //                         elevation: 5,
                  //                         child: Container(
                  //                           color: Colors.white,
                  //                           width: screenWidth,
                  //                           height: MediaQuery.of(context)
                  //                                   .size
                  //                                   .height /
                  //                               8,
                  //                           child: Padding(
                  //                             padding:
                  //                                 const EdgeInsets.all(10.0),
                  //                             child: TextButton.icon(
                  //                               onPressed: () {
                  //                                 Navigator.of(context)
                  //                                     .push(MaterialPageRoute(
                  //                                   builder: (context) =>
                  //                                       ActivityLogPage(),
                  //                                 ));
                  //                               },
                  //                               label: Text(
                  //                                 // buttonNames?.get('activity_log') == "" ? 'Activity Log' : buttonNames?.get('activity_log') ?? 'Activity Log',
                  //                                 'activity_log'.tr(),
                  //                                 style: TextStyle(
                  //                                     color: Color.fromARGB(
                  //                                         255, 29, 67, 78),
                  //                                     fontSize: 16,
                  //                                     fontWeight:
                  //                                         FontWeight.w500),
                  //                               ),
                  //                               icon: const Icon(
                  //                                 Icons.local_activity_rounded,
                  //                                 color: Color.fromARGB(
                  //                                     255, 27, 56, 34),
                  //                                 size: 28,
                  //                               ),
                  //                             ),
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ],
                  //             ),
                  //           ],
                  //         ),
                  //       )
                  //     : Container(),
                  // pluginFlag == true
                  //     ? const SizedBox(
                  //         height: 10,
                  //       )
                  //     : const SizedBox.shrink(),
                  //
                  // ///****************************************** Sync Data************************************************///
                  // Container(
                  //   color: const Color(0xFFE2EFDA),
                  //   height: screenHeight / 7,
                  //   width: screenWidth,
                  //   child: Column(
                  //     children: [
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           //==========================================================Notice flag +Notice url will be here====================================
                  //           notice_flag
                  //               ? Expanded(
                  //                   child: customBuildButton(
                  //                     icon: Icons.note_alt,
                  //                     onClick: () {
                  //                       Navigator.push(
                  //                           context,
                  //                           MaterialPageRoute(
                  //                               builder: (_) =>
                  //                                   const NoticeScreen()));
                  //                     },
                  //                     // title: buttonNames?.get('notice') == "" ? 'Notice' : buttonNames?.get('notice') ?? 'Notice',
                  //                     title: "notice".tr(),
                  //                     sizeWidth: screenWidth,
                  //                     inputColor: Colors.white,
                  //                   ),
                  //                 )
                  //               : const SizedBox.shrink(),
                  //
                  //           Expanded(
                  //             child: customBuildButton(
                  //               icon: Icons.sync,
                  //               onClick: () {
                  //                 Navigator.push(
                  //                     context,
                  //                     MaterialPageRoute(
                  //                         builder: (_) => SyncDataTabScreen(
                  //                               cid: cid,
                  //                               userId: userId,
                  //                               userPassword: userPassword,
                  //                             )));
                  //               },
                  //               // title: buttonNames?.get('sync_data') == "" ? 'Sync Data' : buttonNames?.get('sync_data') ?? 'Sync Data',
                  //               title: 'sync_data'.tr(),
                  //               sizeWidth: screenWidth,
                  //               inputColor: Colors.white,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Future deleteChace() async {
  //   await getTemporaryDirectory().then(
  //     (value) {
  //       Directory(value.path).delete(recursive: true);
  //     },
  //   );
  // }

  getLatLong() {
    Future<geo.Position> data = AllServices().determinePosition();
    data.then((value) {
      debugPrint("value $value");
      setState(() {
        var latitude = value.latitude;
        var longitude = value.longitude;

        debugPrint(
            "Splass Screen Lat Long :::::::::::::  $latitude : $longitude");

        mydatabox.put("latitude", latitude);
        mydatabox.put("longitude", longitude);
      });
    }).catchError((error) {
      // debugPrint("Error $error");
    });
  }

  getAllCustomarData() async {
    // await openBox();
    final box = Hive.box('data');
    var mymap = box.toMap().values.toList();

    if (mymap.isEmpty) {
      data.add('empty');
    } else {
      data = mymap;

      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => CustomerListScreen(
                    terrorId: "",
                    terrorName: '',
                    data: data,
                  )));
    }
  }

  // // // Draft Item order section.......................

  // Future orderOpenBox() async {
  //   var dir = await getApplicationDocumentsDirectory();
  //   Hive.init(dir.path);
  //   box = await Hive.openBox('DraftOrderList');
  // }
  // Future timetrack() async {
  //   final response = await http.post(
  //     Uri.parse("$timer_track_url"),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, String>{
  //       "cid": cid,
  //       "user_id": userId,
  //       "user_pass": widget.userPassword,
  //       'device_id': deviceId!,

  //       // "locations": Location,

  //     }),
  //   );
  //   Map<String, dynamic> data = json.decode(response.body);
  //   // status = data['status'];
  //   final startTime = data['start_time'];
  //   final endTime = data['end_time'];
  //   final prefs = await SharedPreferences.getInstance();

  //   // if (status == "Success") {
  //   //   await prefs.setString('startTime', startTime);
  //   //   await prefs.setString('endTime', endTime);
  //   //   debugPrint('hello');

  //   //   Navigator.pushReplacement(
  //   //       context,
  //   //       MaterialPageRoute(
  //   //           builder: (context) => MyHomePage(
  //   //                 userName: userName,
  //   //                 user_id: user_id,
  //   //                 userPassword: userPass!,
  //   //               )));

  //   //   Fluttertoast.showToast(msg: "Attendance $submitType Successfully");
  //   // } else {
  //   //   return "Failed";
  //   // }
  //   return "Null";
  // }
}

// class BGservice {
//   static Future<void> serviceOn() async {
//     await initializeService();
//   }
// }

// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();
//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//         // this will executed when app is in foreground or background in separated isolate
//         onStart: onStart,

//         // auto start service
//         autoStart: true,
//         isForegroundMode: true,
//         initialNotificationContent: "Background Service is Running",
//         initialNotificationTitle: "Mrep V03"),
//     iosConfiguration: IosConfiguration(
//       // auto start service
//       autoStart: true,

//       // this will executed when app is in foreground in separated isolate
//       onForeground: onStart,

//       // you have to enable background fetch capability on xcode project
//       onBackground: onIosBackground,
//     ),
//   );
//   service.startService();
// }

// FutureOr<bool> onIosBackground(ServiceInstance service) {
//   WidgetsFlutterBinding.ensureInitialized();
//   debugPrint('FLUTTER BACKGROUND FETCH');
//   return true;
// }

// void onStart(ServiceInstance service) {
//   DartPluginRegistrant.ensureInitialized();

//   if (service is AndroidServiceInstance) {
//     service.on('setAsForeground').listen((event) {
//       service.setAsForegroundService();
//     });

//     service.on('setAsBackground').listen((event) {
//       service.setAsBackgroundService();
//     });
//   }

//   service.on('stopService').listen((event) {
//     service.stopSelf();
//   });
//   //********************Loop start********************
//   Timer.periodic(const Duration(minutes:5), (timer) async {
//     // if (!(await service.isServiceRunning())) timer.cancel();

//     // //     //------------Internet Connectivity Check---------------------------
//     // final bool isConnected = await InternetConnectionChecker().hasConnection;
//     // debugPrint('Internet connection: $isConnected');
//     // // // ----------------------------------------------------------------------
//     // //     //----------------Set Notification------------------
//     // if (isConnected) {
//     //   service.setNotificationInfo(
//     //     title: "mRep7",
//     //     content: "Updated at ${DateTime.now()}",
//     //   );
//     // } else {
//     //   service.setNotificationInfo(
//     //     title: "mRep7",
//     //     content: "Updated at ${DateTime.now()}",
//     //   );
//     // }

//     //     //------------------------Geo Location-----------------

//     try {
//       geo.Position? position = await geo.Geolocator.getCurrentPosition();
//       if (position != null) {
//         lat = position.latitude;
//         long = position.longitude;

//         List<geocoding.Placemark> placemarks =
//             await geocoding.placemarkFromCoordinates(lat, long);

//         address = placemarks[0].street! + " " + placemarks[0].country!;
//       }
//     } on Exception catch (e) {
//       debugPrint("Exception geolocator section: $e");
//     }

//     debugPrint('latlong: $lat, $long');

//     //     //--------------------Api Hit Logic-----------------------------

//     if (lat != 0.0 && long != 0.0) {
//       if (location == "") {
//         location = "$lat|$long|$address";
//       } else {
//         location = "$location||$lat|$long|$address";
//       }

//     }

//     debugPrint("Your Location is::$location");

//     // service.sendData(
//     //   {
//     //     //"current_date": DateTime.now().toIso8601String(),
//     //   },
//     // );
//     //     //-------------------------------------------------
//   });
//   Timer.periodic(Duration(minutes:15), (timer) async {

//   //  SharedPreferences preferences =await SharedPreferences.getInstance();
//   //  preferences.setString("Address", address);
//    var dir = await getApplicationDocumentsDirectory();
//     Hive.init(dir.path);
//   await Hive.openBox("alldata");
//     var body = await timeTracker(location);

//     debugPrint(body);
//     if (body["ret_str"] == "Invalid/Inactive User") {
//       if (body["status"] == "Success") {
//         location = "";

//         debugPrint("When Faild Then Location::: $location");

//       } else {
//         Fluttertoast.showToast(msg: "Location Tracking Failed");
//         location = "";
//         debugPrint("When Faild Then Location::: $location");
//       }
//     } else {
//       location='';
//        debugPrint("When Successssssssssssssssss Then Location::: $location");
//        Fluttertoast.showToast(msg: "Location Tracking success");

//       SameDeviceId = body["timer_flag"];
//       debugPrint(SameDeviceId);
//     }
//   });
// }
