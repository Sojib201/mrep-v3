// ignore_for_file: public_member_api_docs, sort_constructors_first, file_names, prefer_typing_uninitialized_variables, use_build_context_synchronously, deprecated_member_use, prefer_interpolation_to_compose_strings, unnecessary_null_comparison
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart' as geo;
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;
import 'package:mrap_v03/Widgets/custom_dialog.dart';
import 'package:mrap_v03/core/utils/app_colors.dart';

import 'package:mrap_v03/screens.dart';
import 'package:path_provider/path_provider.dart';

import 'package:mrap_v03/Pages/DCR_section/show_dcr_discussionData.dart';
import 'package:mrap_v03/Pages/DCR_section/show_dcr_gitfData.dart';
import 'package:mrap_v03/Pages/DCR_section/show_dcr_ppmData.dart';
import 'package:mrap_v03/Pages/DCR_section/show_dcr_sampleData.dart';
import 'package:mrap_v03/local_storage/boxes.dart';
import 'package:mrap_v03/local_storage/hive_data_model.dart';

import '../../constant.dart';
import '../../core/utils/app_text_style.dart';
import '../../service/network_connectivity.dart';

// ignore: must_be_immutable
class DcrGiftSamplePpmPage extends StatefulWidget {
  int dcrKey;
  int uniqueId;
  String ck;
  String docName;
  String docId;
  String areaName;
  String areaId;
  String address;
  List<DcrGSPDataModel> draftOrderItem;
  String dVisitedWith;
  String note;
  String nonExcution;
  String selectedDeliveryTime;
  DcrGiftSamplePpmPage({
    Key? key,
    required this.dcrKey,
    required this.uniqueId,
    required this.ck,
    required this.docName,
    required this.docId,
    required this.areaName,
    required this.areaId,
    required this.address,
    required this.draftOrderItem,
    required this.dVisitedWith,
    required this.note,
    required this.nonExcution,
    required this.selectedDeliveryTime,
  }) : super(key: key);

  @override
  State<DcrGiftSamplePpmPage> createState() => _DcrGiftSamplePpmPageState();
}

class _DcrGiftSamplePpmPageState extends State<DcrGiftSamplePpmPage> {
  final TextEditingController datefieldController = TextEditingController();
  final TextEditingController timefieldController = TextEditingController();
  final TextEditingController paymentfieldController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final _quantityController = TextEditingController();
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  double screenHeight = 0.0;
  double screenWidth = 0.0;

  // List<DcrGiftDataModel> addedDcrGift = [];
  List<DcrGSPDataModel> addedDcrGSPList = [];

  List addedDcrsample = [];
  List addedDcrPpm = [];
  bool isGiftSync = false;
  bool isSampleSync = false;
  bool isPPMSync = false;

  Box? box;

  int _currentSelected = 1;

  List doctorGiftlist = [];
  List doctorSamplelist = [];
  List doctorPpmlist = [];
  List doctorDiscussionlist = [];
  List<String> dcr_visitedWithList = [];
  int dropDownNumber = 0;
  String noteText = '';
  String submit_url = '';
  String? cid;
  String? userId;
  String? userPassword;
  String itemString = '';
  String userName = '';
  String user_id = '';
  String startTime = '';
  String endTime = '';
  List visitedWith = [];
  double? latitude;
  double? longitude;
  String? deviceId = '';
  String? deviceBrand = '';
  String? deviceModel = '';
  String? dropdownVisitWithValue = '_';
  String doctor_url_edit = "";
  List<String> deliveryTime = ['Morning', 'Evening'];
  bool _isLoading = true;
  bool dcr_discussion = true;
  bool areaPage = false;

  bool docEditFlag = false;
  var dcrString = '';
  var newString;
  String visitedWithString = '';
  String drftVisitShow = '';
  String selectedDeliveryTime = 'Morning';
  List<String> CauseForNonExecution = [];
  String causeData = '';
  final jobRoleCtrl = TextEditingController();
  String? logo_url_2;

  final mydata = Boxes.allData();
  @override
  void initState() {
    super.initState();
    // dcr_visitedWithList.clear();
    // SharedPreferences.getInstance().then((prefs) {
    setState(() {
      // prefs.getStringList("dcr_visit_with_list")!.clear();
      isGiftSync = mydata.get('isGiftSync') ?? false;
      isSampleSync = mydata.get('isSampleSync') ?? false;
      isPPMSync = mydata.get('isPPMSync') ?? false;
      startTime = mydata.get("startTime") ?? '';
      endTime = mydata.get("endTime") ?? '';
      doctor_url_edit = mydata.get("doctor_edit_url")!;
      submit_url = mydata.get("submit_url")!;
      cid = mydata.get("CID");
      areaPage = mydata.get("areaPage")!;
      userId = mydata.get("USER_ID");
      userPassword = mydata.get("PASSWORD");
      userName = mydata.get("userName")!;
      user_id = mydata.get("user_id")!;
      latitude = mydata.get("latitude");
      longitude = mydata.get("longitude");
      deviceId = mydata.get("deviceId");
      deviceBrand = mydata.get("deviceBrand");
      deviceModel = mydata.get("deviceModel");
      dcr_discussion = mydata.get("dcr_discussion") ?? false;
      docEditFlag = mydata.get("doc_edit_flag") ?? false;
      dcr_visitedWithList = mydata.get("dcr_visit_with_list")!;
      CauseForNonExecution = mydata.get("cause_for_non_execution_list")!;
      logo_url_2 = databox.get('logo_url_2') ?? null;
      dropdownVisitWithValue = dcr_visitedWithList.first;
    });
    // });
    addedDcrGSPList = widget.draftOrderItem;
    setState(() {});
    if (widget.ck != '') {
      selectedDeliveryTime = widget.selectedDeliveryTime;
      jobRoleCtrl.text = widget.nonExcution;
      if (jobRoleCtrl.text.isNotEmpty) {
        addedDcrGSPList.clear();
      }
      debugPrint("New Drtft Data *************** $selectedDeliveryTime");
      if (widget.dVisitedWith.contains("|")) {
        visitedWithString = widget.dVisitedWith;
        drftVisitShow = widget.dVisitedWith.replaceAll("|", ",");

        debugPrint(visitedWithString);
      } else {
        visitedWithString = widget.dVisitedWith;
        drftVisitShow = visitedWithString;
      }

      //  dcrString =dvisitedwith;
      //  debugPrint("visited wint: $dcrString");
      noteController.text = widget.note;
      noteText = widget.note;

      calculatingTotalitemString();
    } else {
      return;
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    noteController.dispose();
    paymentfieldController.dispose();
    timefieldController.dispose();
    datefieldController.dispose();
    super.dispose();
  }

  initialValue(String val) {
    return TextEditingController(text: val);
  }

  Future<void> _showMyDialog(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Please Confirm'),
          content: SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                Text('Are you sure to remove the Item?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                if (widget.ck != '') {
                  final uniqueKey = widget.dcrKey;
                  deleteSingleGSPItem(uniqueKey, index);

                  setState(() {});
                } else {
                  addedDcrGSPList.removeAt(index);
                  setState(() {});
                }
                // debugPrint('Confirmed');
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  deleteSingleGSPItem(int rxDcrUniqueKey, int index) {
    final box = Hive.box<DcrGSPDataModel>("selectedDcrGSP");

    final Map<dynamic, DcrGSPDataModel> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.uiqueKey == rxDcrUniqueKey) desiredKey = key;
    });
    box.delete(desiredKey);
    addedDcrGSPList.removeAt(index);

    setState(() {});
  }

  _onItemTapped(int index) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (index == 0) {
      await putAddedDcrGSPData(visitedWithString);
      Navigator.pop(context);
      setState(() {
        _currentSelected = index;
      });

      print(selectedDeliveryTime);
    } else {}

    if (index == 1) {
      if (areaPage == false) {
        if (addedDcrGSPList.isNotEmpty || jobRoleCtrl.text != "") {
          // setState(() {
          //   _isLoading = false;
          // });
          bool result = await NetworkConnecticity.checkConnectivity();
          if (result == true) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title:  Text("confirm".tr()),
                content:  Text("are_you_sure_you_want_to_delete_the_doctor".tr()),
                actions: [
                  TextButton(
                    onPressed: () {
                      // User clicked No, so close the dialog
                      Navigator.of(context).pop(false);
                    },
                    child:  Text("no".tr()),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLoading = false;
                      });
                      orderGSPSubmit(visitedWithString);
                      Navigator.of(context).pop(true);
                    },
                    child:  Text("yes".tr()),
                  ),
                ],
              ),
            );
          } else {
            _submitToastforOrder3();
            setState(() {
              _isLoading = true;
            });
            // debugPrint(InternetConnectionChecker().lastTryResults);
          }
        } else {
          Fluttertoast.showToast(
              msg: 'Please add something',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } else {
        // setState(() {
        //   _isLoading = false;
        // });
        bool result = await NetworkConnecticity.checkConnectivity();
        if (result == true) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title:  Text("confirm".tr()),
              content:  Text("are_you_sure_you_want_to_delete_the_doctor".tr()),
              actions: [
                TextButton(
                  onPressed: () {
                    // User clicked No, so close the dialog
                    Navigator.of(context).pop(false);
                  },
                  child:  Text("no".tr()),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLoading = false;
                    });
                    orderGSPSubmit(visitedWithString);
                    Navigator.of(context).pop(true);
                  },
                  child:  Text("yes".tr()),
                ),
              ],
            ),
          );
        } else {
          _submitToastforOrder3();
          setState(() {
            _isLoading = true;
          });
          // debugPrint(InternetConnectionChecker().lastTryResults);
        }
      }

      setState(() {
        _currentSelected = index;
      });
    }
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
    return _isLoading
        ? Scaffold(
            key: _drawerKey,
            appBar: AppBar(
              // backgroundColor: const Color.fromARGB(255, 138, 201, 149),

              // flexibleSpace: Container(
              //   decoration: const BoxDecoration(
              //     // LinearGradient
              //     gradient: LinearGradient(
              //       // colors for gradient
              //       colors: [
              //         Color(0xff70BA85),
              //         Color(0xff56CCF2),
              //       ],
              //     ),
              //   ),
              // ),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
              title: Text(
                'visit_doctor'.tr(),
                // style: TextStyle(
                //     color: Color.fromARGB(255, 27, 56, 34),
                //     fontWeight: FontWeight.w500,
                //     fontSize: 20),
              ),
              centerTitle: true,
            ),
            endDrawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    padding: const EdgeInsets.all(8),
                    // padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
                    decoration: const BoxDecoration(
                      color: kPrimaryColor,
                    ),
                    child: Column(
                      children: [
                        logo_url_2 != null
                            ? CachedNetworkImage(
                                height: screenHeight * .11,
                                imageUrl: logo_url_2!,
                                errorWidget: (context, url, error) =>
                                    Image.asset("assets/images/mRep7_logo.png"),
                              )
                            : Image.asset(
                                "assets/images/mRep7_logo.png",
                                color: Colors.white,
                              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FittedBox(
                                    child: Text(
                                      widget.docName,
                                      // 'Chemist: ADEE MEDICINE CORNER(6777724244)',
                                      style: navDrawerTitle,
                                    ),
                                  ),
                                  FittedBox(
                                    child: Text(widget.docId,
                                        // 'Chemist: ADEE MEDICINE CORNER(6777724244)',
                                        style: navDrawerTitle2),
                                  ),
                                ],
                              ),
                            ),
                            // const SizedBox(
                            //   width: 10,
                            // ),
                            // docEditFlag
                            //     ? Expanded(
                            //         flex: 1,
                            //         child: IconButton(
                            //           onPressed: () async {
                            //             //var url ='https://ww11.yeapps.com/ipi/doctor_update/doctor_add?cid=IBNSINA&rep_id=it03&rep_pass=1234&doc_id=10001';
                            //             var url =
                            //                 '$doctor_url_edit?cid=$cid&rep_id=$userId&rep_pass=$userPassword&doc_id=${widget.docId}';
                            //             debugPrint(url);
                            //             if (await canLaunch(url)) {
                            //               await launch(url);
                            //             } else {
                            //               throw 'Could not launch $url';
                            //             }
                            //             // if (await canLaunchUrl(Uri.parse(url))) {
                            //             //   await launchUrl(Uri.parse(url));
                            //             // } else {
                            //             //   throw 'Could not launch $url';
                            //             // }
                            //           },
                            //           icon: const Icon(
                            //             Icons.edit,
                            //             color: Colors.white,
                            //             // size: 15,
                            //           ),
                            //         ),
                            //       )
                            //     : Container()
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      elevation: 5,
                      child: Container(
                        width: screenWidth,
                        //height: screenHeight / 12,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xff56CCF2).withOpacity(.3),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 6,
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    FittedBox(
                                      child: Text(
                                        "${widget.docName}",
                                        style: const TextStyle(
                                            color: Color.fromARGB(255, 2, 3, 2),
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    FittedBox(
                                      child: Text(
                                        "${widget.areaName} | ${widget.areaId}",
                                        style: const TextStyle(
                                            color:
                                                Color.fromARGB(255, 5, 10, 6),
                                            fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // const Spacer(),
                              // const SizedBox(
                              //   width: 30,
                              // ),
                              // dcr_visitedWithList.isNotEmpty
                              //     ? Expanded(
                              //         flex: 3,
                              //         child: Column(
                              //           crossAxisAlignment:
                              //               CrossAxisAlignment.start,
                              //           children: [
                              //             const SizedBox(
                              //               height: 10,
                              //             ),
                              //             const Text(
                              //               "Visited With :",
                              //               style: TextStyle(
                              //                 color:
                              //                     Color.fromARGB(255, 3, 7, 4),
                              //                 fontSize: 16,
                              //               ),
                              //             ),
                              //             const SizedBox(
                              //               height: 10,
                              //             ),
                              //             Expanded(
                              //               child: InkWell(
                              //                 onTap: () {
                              //                   showDialog(
                              //                       context: context,
                              //                       builder:
                              //                           (BuildContext context) {
                              //                         return AlertDialog(
                              //                           content: Container(
                              //                             height: 300,
                              //                             child: GFMultiSelect(
                              //                               items:
                              //                                   dcr_visitedWithList,
                              //                               onSelect: (value) {
                              //                                 dcrString = '';
                              //                                 if (value
                              //                                     .isNotEmpty) {
                              //                                   for (var e
                              //                                       in value) {
                              //                                     if (dcrString ==
                              //                                         '') {
                              //                                       dcrString =
                              //                                           dcr_visitedWithList[
                              //                                               e];
                              //                                     } else {
                              //                                       dcrString += '|' +
                              //                                           dcr_visitedWithList[
                              //                                               e];
                              //                                     }
                              //                                   }
                              //                                 }

                              //                                 debugPrint(
                              //                                     'selected $value ');
                              //                                 debugPrint(dcrString);
                              //                               },
                              //                               // submitButton:
                              //                               //     submButton(),
                              //                               cancelButton:
                              //                                   cancalButton(),
                              //                               dropdownTitleTileText:
                              //                                   '',
                              //                               // dropdownTitleTileColor: Colors.grey[200],
                              //                               dropdownTitleTileMargin:
                              //                                   EdgeInsets.zero,
                              //                               dropdownTitleTilePadding:
                              //                                   EdgeInsets
                              //                                       .fromLTRB(
                              //                                           10,
                              //                                           0,
                              //                                           10,
                              //                                           0),
                              //                               dropdownUnderlineBorder:
                              //                                   const BorderSide(
                              //                                       color: Colors
                              //                                           .transparent,
                              //                                       width: 2),
                              //                               // dropdownTitleTileBorder:
                              //                               //     Border.all(color: Colors.grey, width: 1),
                              //                               // dropdownTitleTileBorderRadius: BorderRadius.circular(5),
                              //                               expandedIcon:
                              //                                   const Icon(
                              //                                 Icons
                              //                                     .keyboard_arrow_down,
                              //                                 color: Colors
                              //                                     .black54,
                              //                               ),
                              //                               collapsedIcon:
                              //                                   const Icon(
                              //                                 Icons
                              //                                     .keyboard_arrow_up,
                              //                                 color: Colors
                              //                                     .black54,
                              //                               ),

                              //                               // dropdownTitleTileTextStyle: const TextStyle(
                              //                               //     fontSize: 14, color: Colors.black54),
                              //                               padding:
                              //                                   const EdgeInsets
                              //                                       .all(0),
                              //                               margin:
                              //                                   const EdgeInsets
                              //                                       .all(0),
                              //                               type: GFCheckboxType
                              //                                   .basic,
                              //                               activeBgColor: Colors
                              //                                   .green
                              //                                   .withOpacity(
                              //                                       0.5),
                              //                               inactiveBorderColor:
                              //                                   Colors.grey,
                              //                             ),
                              //                           ),
                              //                         );
                              //                       });
                              //                   debugPrint("ok");
                              //                 },
                              //                 child: dcrString == null
                              //                     ? Text("Select")
                              //                     : Text(dcrString),
                              //               ),
                              //             ),

                              //             //=================================================Experiment
                              //             // Expanded(
                              //             //   // flex: 2,
                              //             //   child: DropdownButton(
                              //             //     isExpanded: true,
                              //             //     dropdownColor:
                              //             //         const Color.fromARGB(
                              //             //             255, 187, 234, 250),
                              //             //     // Initial Value
                              //             //     value: dropdownVisitWithValue,

                              //             //     // Down Arrow Icon
                              //             //     icon: const Icon(
                              //             //       Icons.keyboard_arrow_down,
                              //             //       color: Color.fromARGB(
                              //             //           255, 27, 56, 34),
                              //             //     ),

                              //             //     // Array list of items

                              //             //     items: dcr_visitedWithList
                              //             //         .map((item) {
                              //             //       return DropdownMenuItem(
                              //             //         value: item,
                              //             //         child: Row(
                              //             //           children: [
                              //             //             StatefulBuilder(builder:
                              //             //                 (BuildContext context,
                              //             //                     StateSetter
                              //             //                         stateSetter) {
                              //             //               return Checkbox(
                              //             //                 onChanged: (value) {
                              //             //                   stateSetter(() {
                              //             //                     _firstValue =
                              //             //                         value!;
                              //             //                     debugPrint(value);
                              //             //                   });
                              //             //                 },
                              //             //                 value: _firstValue,
                              //             //               );
                              //             //             }),
                              //             //             Text(
                              //             //               item,
                              //             //               style: const TextStyle(
                              //             //                 color: Color.fromARGB(
                              //             //                     255, 9, 19, 11),
                              //             //                 fontSize: 16,
                              //             //               ),
                              //             //             ),
                              //             //           ],
                              //             //         ),
                              //             //       );
                              //             //     }).toList(),

                              //             //     onChanged: (String? newValue) {
                              //             //       setState(() {
                              //             //         dropdownVisitWithValue =
                              //             //             newValue!;
                              //             //         debugPrint(dropdownVisitWithValue);
                              //             //       });
                              //             //     },
                              //             //   ),
                              //             // ),
                              //       ],
                              //     ),
                              //   )
                              // : const Text("")
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                      child: Row(
                        children: [
                          const Expanded(
                              flex: 2,
                              child: Text(
                                "Visited With",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              )),
                          dcr_visitedWithList.isNotEmpty
                              ? Expanded(
                                  flex: 4,
                                  child: GFMultiSelect(
                                    color: Colors.white,
                                    size: 20,

                                    items: dcr_visitedWithList,
                                    onSelect: (value) {
                                      // dcrString = '';
                                      if (value.isNotEmpty) {
                                        for (var e in value) {
                                          if (dcrString == '') {
                                            dcrString = dcr_visitedWithList[e];
                                          } else {
                                            dcrString +=
                                                '|${dcr_visitedWithList[e]}';
                                          }
                                        }
                                      }

                                      setState(() {
                                        visitedWithString = '';

                                        visitedWithString = dcrString;
                                      });

                                      debugPrint('selected $value ');
                                      debugPrint(dcrString);
                                    },
                                    cancelButton: cancalButton(),
                                    dropdownTitleTileText: drftVisitShow,
                                    // dropdownTitleTileColor: Colors.grey[200],
                                    dropdownTitleTileMargin: EdgeInsets.zero,
                                    dropdownTitleTilePadding:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    dropdownUnderlineBorder: const BorderSide(
                                        color: Colors.transparent, width: 0.5),
                                    dropdownTitleTileBorder: Border.all(
                                        color: Colors.grey, width: 0.5),
                                    dropdownTitleTileBorderRadius:
                                        BorderRadius.circular(5),
                                    expandedIcon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.black54,
                                    ),
                                    collapsedIcon: const Icon(
                                      Icons.keyboard_arrow_up,
                                      color: Colors.black54,
                                    ),

                                    // submitButton: Text('OK'),
                                    // dropdownTitleTileTextStyle: const TextStyle(
                                    //     fontSize: 14, color: Colors.black54),

                                    padding: const EdgeInsets.all(0),
                                    margin: const EdgeInsets.all(0),
                                    type: GFCheckboxType.basic,
                                    activeBgColor:
                                        Colors.green.withOpacity(0.5),
                                    inactiveBorderColor: Colors.grey,
                                  ),
                                )
                              : const SizedBox.shrink(),
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              // width: 220,
                              child: Center(
                                child: DropdownButton<String>(
                                  value: selectedDeliveryTime,
                                  items: deliveryTime
                                      .map(
                                        (String item) =>
                                            DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (item) => setState(
                                    () {
                                      selectedDeliveryTime = item.toString();
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                      child: SizedBox(
                        // height: 55,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: kSecondaryColor,
                          ),
                          // elevation: 6,

                          child: TextFormField(
                            maxLength: 50,
                            minLines: 1,
                            maxLines: 3,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z0-9 ]')),
                            ],
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black),
                            controller: noteController,
                            decoration: const InputDecoration(
                                counterText: "",
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                labelText: '   Feedback/Note/Place of Work',
                                labelStyle: TextStyle(color: Colors.black54)),
                            onChanged: (value) {
                              setState(() {
                                noteText = noteController.text;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    //   child: SizedBox(
                    //     height: 55,
                    //     child: Container(
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(20),
                    //         color: const Color.fromARGB(255, 138, 201, 149)
                    //             .withOpacity(.5),
                    //       ),
                    //       // elevation: 6,

                    //       child: TextFormField(
                    //         keyboardType: TextInputType.text,
                    //         inputFormatters: <TextInputFormatter>[
                    //           FilteringTextInputFormatter.deny(
                    //               RegExp(r'[@#%^!~\\/:;]'))
                    //         ],
                    //         style: const TextStyle(
                    //             fontSize: 18, color: Colors.black),
                    //         controller: noteController,
                    //         focusNode: FocusNode(),
                    //         autofocus: false,
                    //         decoration: const InputDecoration(
                    //             border: OutlineInputBorder(
                    //                 borderSide: BorderSide.none),
                    //             labelText: '  Feedback/Note/Place of Work',
                    //             labelStyle: TextStyle(color: Colors.blueGrey)),
                    //         onChanged: (value) {
                    //           noteText = (noteController.text)
                    //               .replaceAll(RegExp('[^A-Za-z0-9]'), " ");
                    //         },
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                      child: Row(
                        children: [
                          const Expanded(
                              flex: 2, child: Text('Non Execution:')),
                          Expanded(
                            flex: 3,
                            child: CustomDropdown(
                              // hintText: ff_type[0],
                              hintText: "Non Execution",
                              fillColor:
                                  const Color.fromARGB(255, 138, 201, 149)
                                      .withOpacity(.3),
                              items: CauseForNonExecution,
                              controller: jobRoleCtrl,
                              onChanged: (value) {
                                if (addedDcrGSPList.isNotEmpty) {
                                  customDialog(
                                    title: "Confirmation",
                                    content:
                                        "If you select non-execution the added item will be cleared",
                                    cancelOnTap: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        jobRoleCtrl.clear();
                                        causeData = '';
                                      });
                                    },
                                    confirmOnTap: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        causeData = value;
                                        addedDcrGSPList.clear();
                                      });
                                    },
                                  );
                                } else {
                                  setState(() {
                                    causeData = value;
                                    addedDcrGSPList.clear();
                                  });
                                }

                                debugPrint(
                                    "developer select listxxxx $causeData");
                                debugPrint(
                                    "developer select list ${jobRoleCtrl.text}");
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Doctor Gift section..................................
                    SizedBox(
                      height: screenHeight / 2.5,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: addedDcrGSPList.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (BuildContext itemBuilder, index) {
                          return Card(
                            elevation: 15,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Colors.white70, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              height: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 10,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    addedDcrGSPList[index]
                                                        .giftName,
                                                    style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 9, 38, 61),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16),
                                                  ),
                                                ),
                                                // Text(
                                                //   '(${addedDcrGSPList[index].giftType})',
                                                //   style: const TextStyle(
                                                //       fontSize: 16),
                                                // ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              _showMyDialog(index);
                                            },
                                            icon: const Icon(
                                              Icons.clear,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          addedDcrGSPList[index].giftType !=
                                                  "Discussion"
                                              ? Row(
                                                  children: [
                                                    const Text(
                                                      'Qt:  ',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Color.fromARGB(
                                                              255, 9, 38, 61)),
                                                    ),
                                                    Text(
                                                      addedDcrGSPList[index]
                                                          .quantity
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 9, 38, 61),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                )
                                              : const Text(""),
                                          const Spacer(),
                                          Row(
                                            children: [
                                              Text(
                                                '(${addedDcrGSPList[index].giftType})',
                                                style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 9, 38, 61),
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    causeData.isNotEmpty || jobRoleCtrl.text.isNotEmpty
                        ? SizedBox()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  // const SizedBox(
                                  //   height: 5,
                                  // ),
                                  Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        getDcrGitData();
                                      },
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                16,
                                        width: screenWidth / 5.7,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: kSecondaryColor,
                                        ),
                                        child: Center(
                                          child: FittedBox(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                // Icon(Icons.add, color: Colors.white),
                                                // SizedBox(width: 5),
                                                Text(
                                                  'gift'.tr(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  //     ElevatedButton(
                                  //   onPressed: () {
                                  // getDcrSampleData();
                                  //   },
                                  //   style: ElevatedButton.styleFrom(
                                  //     fixedSize: Size(screenWidth / 4,
                                  //         MediaQuery.of(context).size.height / 16),
                                  //     primary:
                                  //         const Color.fromARGB(255, 55, 129, 167),
                                  //     shape: RoundedRectangleBorder(
                                  //       borderRadius:
                                  //           BorderRadius.circular(10), // <-- Radius
                                  //     ),
                                  //   ),
                                  //   child: FittedBox(
                                  //     child: Row(
                                  //         mainAxisAlignment:
                                  //             MainAxisAlignment.center,
                                  //         children: const [
                                  //           Icon(Icons.add, color: Colors.white),
                                  //           SizedBox(width: 5),
                                  //           Text(
                                  //              'Sample',
                                  //             style: TextStyle(
                                  //               color: Colors.white,
                                  //               fontSize: 18,
                                  //             ),
                                  //           ),
                                  //         ]),
                                  //   ),
                                  // ),
                                  Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        getDcrSampleData();
                                      },
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                16,
                                        width: screenWidth / 4,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: kSecondaryColor,
                                        ),
                                        child: Center(
                                          child: FittedBox(
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  // Icon(Icons.add,
                                                  //     color: Colors.white),
                                                  // SizedBox(width: 5),
                                                  Text(
                                                    'sample'.tr(),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 16),
                                                  ),
                                                ]),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      getDcrPpmData();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: Size(
                                          screenWidth / 4.8,
                                          MediaQuery.of(context).size.height /
                                              16
                                      ),
                                      backgroundColor: kSecondaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10), // <-- Radius
                                      ),
                                    ),
                                    child: FittedBox(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Icon(Icons.add, color: Colors.white),
                                          // SizedBox(width: 5),
                                          Text(
                                            'ppm'.tr(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              dcr_discussion == true
                                  ? Column(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            getDcrDiscussionData();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: Size(
                                                screenWidth / 4,
                                                MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    16),
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 138, 201, 149),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10), // <-- Radius
                                            ),
                                          ),
                                          child: FittedBox(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                // Icon(Icons.add, color: Colors.white),
                                                // SizedBox(width: 5),
                                                Text(
                                                  'discuss'.tr(),
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 7, 14, 8),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container()
                            ],
                          ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              onTap: _onItemTapped,
              currentIndex: _currentSelected,
              showUnselectedLabels: true,
              // unselectedItemColor: Colors.grey[800],
              // selectedItemColor: const Color.fromRGBO(10, 135, 255, 1),
              // backgroundColor: Colors.white,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  label: 'save_drafts'.tr(),
                  icon: Icon(Icons.drafts),
                ),
                // BottomNavigationBarItem(
                //   label: '',
                //   icon: Icon(
                //     Icons.clear,
                //     color: Color.fromRGBO(255, 254, 254, 1),
                //   ),
                // ),
                BottomNavigationBarItem(
                  label: 'submit'.tr(),
                  icon: Icon(Icons.save),
                ),
              ],
            ),
          )
        : Container(
            padding: const EdgeInsets.all(100),
            color: Colors.white,
            child: const Center(child: CircularProgressIndicator()));
  }

// doctor gift section............................
  // Future giftOpenBox() async {
  //   var dir = await getApplicationDocumentsDirectory();
  //   Hive.init(dir.path);
  //   box = await Hive.openBox('dcrGiftListData');
  // }

  // dcr gift section...........................
  getDcrGitData() async {
    // await giftOpenBox();

    if (isGiftSync == true) {
      var mymap = Hive.box('dcrGiftListData').values.toList();

      if (mymap.isEmpty) {
        Fluttertoast.showToast(
            msg: "No Gift Found", backgroundColor: Colors.red);
        doctorGiftlist.add('empty');
      } else {
        doctorGiftlist = mymap;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DcrGiftDataPage(
              uniqueId: widget.uniqueId,
              doctorGiftlist: doctorGiftlist,
              tempList: addedDcrGSPList,
              tempListFunc: (value) {
                addedDcrGSPList = value;
                calculatingTotalitemString();

                setState(() {});
              },
            ),
          ),
        );
      }
    } else {
      Fluttertoast.showToast(
          msg: 'Please sync gift',
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  // doctor Sample section.......................................................

  // Future sampleOpenBox() async {
  //   var dir = await getApplicationDocumentsDirectory();
  //   Hive.init(dir.path);
  //   box = await Hive.openBox('dcrSampleListData');
  // }

  getDcrSampleData() async {
    // await sampleOpenBox();

    if (isSampleSync == true) {
      var mymap = Hive.box('dcrSampleListData').values.toList();

      if (mymap.isEmpty) {
        debugPrint('empty Sample');
        Fluttertoast.showToast(
            msg: "No Sample Found", backgroundColor: Colors.red);
        doctorSamplelist.add('empty');
      } else {
        doctorSamplelist = mymap;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DcrSampleDataPage(
              uniqueId: widget.uniqueId,
              doctorSamplelist: doctorSamplelist,
              tempList: addedDcrGSPList,
              tempListFunc: (value) {
                addedDcrGSPList = value;
                calculatingTotalitemString();

                setState(() {});
              },
            ),
          ),
        );
      }
    } else {
      Fluttertoast.showToast(
          msg: 'Please sync Sample',
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
  // Doctor PPM section..........................................

  // Future ppmOpenBox() async {
  //   var dir = await getApplicationDocumentsDirectory();
  //   Hive.init(dir.path);
  //   box = await Hive.openBox('dcrPpmListData');
  // }

  getDcrPpmData() async {
    // await ppmOpenBox();

    if (isPPMSync == true) {
      var mymap = Hive.box('dcrPpmListData').values.toList();

      if (mymap.isEmpty) {
        Fluttertoast.showToast(
            msg: "No PPM Found", backgroundColor: Colors.red);
        doctorPpmlist.add('empty');
      } else {
        doctorPpmlist = mymap;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DcrPpmDataPage(
              uniqueId: widget.uniqueId,
              doctorPpmlist: doctorPpmlist,
              tempList: addedDcrGSPList,
              tempListFunc: (value) {
                addedDcrGSPList = value;
                calculatingTotalitemString();

                setState(() {});
              },
            ),
          ),
        );
      }
    } else {
      Fluttertoast.showToast(
          msg: 'Please sync PPM',
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
//=====================Discussion ====================================================
//=========================================================================================

  // Future discussionOpenBox() async {
  //   var dir = await getApplicationDocumentsDirectory();
  //   Hive.init(dir.path);
  //   box = await Hive.openBox('syncItemData');
  // }

  getDcrDiscussionData() async {
    // await discussionOpenBox();

    var mymap = Hive.box('syncItemData').values.toList();

    if (mymap.isEmpty) {
      Fluttertoast.showToast(
          msg: "No Discussion Found", backgroundColor: Colors.red);
      doctorDiscussionlist.add('empty');
    } else {
      doctorDiscussionlist = mymap;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DcrDiscussionPage(
            uniqueId: widget.uniqueId,
            doctorDiscussionlist: doctorDiscussionlist,
            tempList: addedDcrGSPList,
            tempListFunc: (value) {
              addedDcrGSPList = value;
              calculatingTotalitemString();

              setState(() {});
            },
          ),
        ),
      );
    }
  }

  calculatingTotalitemString() {
    itemString = '';

    if (addedDcrGSPList.isNotEmpty) {
      for (var element in addedDcrGSPList) {
        if (itemString == '') {
          itemString =
              '${element.giftId}|${element.quantity}|${element.giftType}';
        } else {
          itemString +=
              '||${element.giftId}|${element.quantity}|${element.giftType}';
        }

        setState(() {});
      }
    } else {}
  }

  cancalButton() {
    dcrString = "";
  }

  submButton() {
    if (dcrString.contains("|")) {
      newString = dcrString.replaceAll(",", "|");
      debugPrint(newString);
    }
    Navigator.pop(context);
  }

  // Saved Added Gift, Sample, PPM to Hive

  // Save Gift data to hive
  Future addedSampleOpenBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('addedDcrSampletData');
  }

  Future putAddedDcrGSPData(String visitewith) async {
    List<DcrDataModel> doctorList = [];

    if (widget.ck != '') {
      for (int i = 0; i <= addedDcrGSPList.length; i++) {
        deleteDcrGSPItem(widget.dcrKey);

        setState(() {});
      }

      setState(() {});

      Navigator.pop(context);

      for (var d in addedDcrGSPList) {
        final box = Boxes.selectedDcrGSP();

        box.add(d);
      }
      for (var dcr in doctorList) {
        final box = Boxes.dcrUsers();
        box.add(dcr);
      }

      final box1 = Boxes.dcrUsers();
      final box = Boxes.dcrUsers().toMap();
      box.forEach((key, value) {
        if (value.uiqueKey == widget.uniqueId) {
          box1.put(
              key,
              DcrDataModel(
                uiqueKey: value.uiqueKey,
                docName: value.docName,
                docId: value.docId,
                areaId: value.areaId,
                areaName: value.areaName,
                address: 'address',
                visitedWith: visitewith,
                note: noteText,
                non_Excution: causeData,
                shift: selectedDeliveryTime,
              ));
        }
      });
    } else {
      debugPrint("visted with string in dcr $visitewith");
      var doctor = DcrDataModel(
        uiqueKey: widget.uniqueId,
        docName: widget.docName,
        docId: widget.docId,
        areaId: widget.areaId,
        areaName: widget.areaName,
        address: 'address',
        visitedWith: visitewith,
        note: noteText,
        non_Excution: causeData,
        shift: selectedDeliveryTime,
      );
      doctorList.add(doctor);

      for (var dcr in doctorList) {
        final box = Boxes.dcrUsers();
        box.add(dcr);
      }

      for (var d in addedDcrGSPList) {
        final box = Boxes.selectedDcrGSP();

        box.add(d);
      }
    }
  }

  deleteDcrGSPItem(int id) {
    final box = Hive.box<DcrGSPDataModel>("selectedDcrGSP");

    final Map<dynamic, DcrGSPDataModel> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.uiqueKey == widget.dcrKey) desiredKey = key;
    });
    box.delete(desiredKey);
  }

  deleteDoctor(int id) {
    final box = Hive.box<DcrDataModel>("selectedDcr");

    final Map<dynamic, DcrDataModel> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.uiqueKey == widget.dcrKey) desiredKey = key;
    });
    box.delete(desiredKey);
  }

  Future<dynamic> orderGSPSubmit(String visitedwith) async {
    String address = '';
    double lat = 0.0;
    double long = 0.0;

    try {
      geo.Position? position = await geo.Geolocator.getCurrentPosition();
      if (position != null) {
        List<geocoding.Placemark> placemarks = await geocoding
            .placemarkFromCoordinates(position.latitude, position.longitude);

        setState(() {
          address = "${placemarks[0].street!} ${placemarks[0].country!}";
          lat = position.latitude;
          long = position.longitude;
        });
      }
    } on Exception catch (e) {
      debugPrint("Exception geolocator section: $e");
    }

//todo add addresss
    // if (itemString != '') {
    String a = '${submit_url}api_dcr_submit/submit_data';
    debugPrint(a);
    debugPrint(visitedwith);

    debugPrint(
        "${submit_url}api_dcr_submit/submit_data?cid=$cid&user_id=$userId&user_pass=$user_pass&device_id=$deviceId&doc_id=${widget.docId}&doc_area_id=${widget.areaId}&latitude=$latitude&longitude=$longitude&item_list_gsp=${jobRoleCtrl.text.isEmpty ? itemString : ''}&visit_with=$dcrString&remarks=$noteText&causeExcucution=${jobRoleCtrl.text}&shift=$selectedDeliveryTime&app_version=$appVersion");
    try {
      final http.Response response = await http.post(
        Uri.parse('${submit_url}api_dcr_submit/submit_data'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(
          <String, dynamic>{
            'cid': cid,
            'user_id': userId,
            'user_pass': userPassword,
            'device_id': deviceId,
            'doc_id': widget.docId,
            'doc_area_id': widget.areaId,
            'visit_with': dcrString,
            "latitude": (minLatitude <= lat && lat <= maxLatitude) ? lat : '',
            'longitude':
                (minLongitude <= long && long <= maxLongitude) ? long : '',
            'location_detail': ((minLatitude <= lat && lat <= maxLatitude) &&
                    (minLongitude <= long && long <= maxLongitude))
                ? address
                : '',
            "item_list_gsp": jobRoleCtrl.text.isEmpty ? itemString : '',
            "remarks": noteText,
            "causeExcucution": jobRoleCtrl.text,
            "shift": selectedDeliveryTime,
            'app_version': appVersion,
          },
        ),
      );
      // debugPrint(itemString);
      // debugPrint(userId);
      // debugPrint(userPassword);
      // debugPrint(widget.docId);
      var orderInfo = json.decode(response.body);

      print("--------------------${orderInfo}");
      String status = orderInfo['status'];
      String ret_str = orderInfo['ret_str'];

      if (status == "Success") {
        for (int i = 0; i <= addedDcrGSPList.length; i++) {
          deleteDcrGSPItem(widget.dcrKey);

          setState(() {});
        }

        deleteDoctor(widget.dcrKey);

        setState(() {
          _isLoading = true;
        });

        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(
        //         builder: (context) => MyHomePage(
        //               userName: userName,
        //               user_id: user_id,
        //               userPassword: userPassword ?? '',
        //             )),
        //     (Route<dynamic> route) => false);

        addedDcrGSPList.clear();
        _submitToastforOrder(ret_str);
        Navigator.of(context).pop();
      } else {
        setState(() {
          _isLoading = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('${orderInfo['ret_str']}'),
            backgroundColor: Colors.red));
      }
    } on Exception catch (e) {
      // ignore: avoid_print
      print(e);
      setState(() {
        _isLoading = true;
      });
      // throw Exception("Error on server");
    }
    // } else {
    //   setState(() {
    //     _isLoading = true;
    //   });
    //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //       content: Text(
    //         'Please Add something',
    //       ),
    //       backgroundColor: Colors.red));
    // }
  }

  void _submitToastforOrder(String ret_str) {
    Fluttertoast.showToast(
        msg: "DCR Submitted\n$ret_str",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green.shade900,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
