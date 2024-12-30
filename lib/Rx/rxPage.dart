// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print, file_names, must_be_immutable, unused_local_variable, use_build_context_synchronously
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mrap_v03/Rx/medicin_list_screen.dart';
import 'package:mrap_v03/core/utils/image_constant.dart';

import 'package:photo_view/photo_view.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:geocoding/geocoding.dart' as geocoding;

import 'package:mrap_v03/Pages/homePage.dart';
import 'package:mrap_v03/Pages/loginPage.dart';
import 'package:mrap_v03/Rx/doctorListfromHive.dart';
import 'package:mrap_v03/local_storage/boxes.dart';

import '../constant.dart';
import '../local_storage/hive_data_model.dart';
import 'package:image/image.dart' as img;

import '../main.dart';
import '../service/network_connectivity.dart';

var quantity = "";

class RxPage extends StatefulWidget {
  final isDirectCapture;
  int dcrKey;
  int uniqueId;
  String ck;
  String docName;
  String dcrGrad;
  String docId;
  String areaName;
  String areaId;
  String address;
  String image1;
  List<MedicineListModel> draftRxMedicinItem;

  RxPage({
    Key? key,
    required this.dcrKey,
    required this.uniqueId,
    required this.ck,
    required this.docName,
    required this.dcrGrad,
    required this.docId,
    required this.areaName,
    required this.areaId,
    required this.address,
    required this.image1,
    required this.draftRxMedicinItem, this.isDirectCapture=false,
  }) : super(key: key);

  @override
  State<RxPage> createState() => _RxPageState();
}

class _RxPageState extends State<RxPage> {
  Map<String, TextEditingController> controllers = {};
  // TextEditingController textController = TextEditingController();
  // List<TextEditingController> textController = [];

  String address = "";

  late TransformationController controller;
  TapDownDetails? tapDownDetails;
  Box? box;
  List doctorData = [];
  List medicineData = [];
  List<RxDcrDataModel> finalDoctorList = [];
  List<MedicineListModel> finalMedicineList = [];
  List finalDraftDoctorList = [];
  List finalDraftMedicineList = [];
  List rxMedicineDataList = [];
  List tempMedicineList = [];
  File? imagePath;
  XFile? file;
  String a = '';

  bool isMedicineSync = false;
  bool isRxDoctorSync = false;
  // File? _image;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  int _currentSelected = 3;
  int _currentSelected2 = 2;
  int counterForDoctor = 0;
  int _counterforRx = 0;
  bool _isCameraClick = false;
  int objectImageId = 0;

  String? submit_url;
  String? photo_submit_url;
  String? cid;
  String? userId;
  String? userPassword;
  String itemString = '';
  String userName = '';
  String user_id = '';
  String startTime = '';
  String endTime = '';
  int tempCount = 0;
  // String? docId;
  double latitude = 0.0;
  double longitude = 0.0;
  String? deviceId = '';
  String? deviceBrand = '';
  String? deviceModel = '';
  bool _isLoading = true;
  bool _activeCounter = false;
  String dropdownRxTypevalue = 'Rx Type';

  List<String> rxTypeList = [];

  String finalImage = '';
  final databox = Boxes.allData();

  @override
  void initState() {
    if(widget.isDirectCapture)
    {
      cameraFuntionality();
    }
    // Boxes.rxdDoctor().clear();
    // Boxes.getMedicine().clear();

    debugPrint("id ${widget.uniqueId}");
    debugPrint("counterrx $_counterforRx");
    // debugPrint(widget.uniqueId);
    if (widget.docId != '') {
      docId = widget.docId;
      counterForDoctor = widget.uniqueId;
    }

    // for (int i = 0; i < widget.draftRxMedicinItem.length; i++) {
    //   int a = widget.draftRxMedicinItem[i].quantity;
    //   debugPrint("r bolo ki khbr ${a}");
    //   if (a != "") {
    //     textController[index].text = a.toString();
    //     debugPrint("accha accha ${textController[index].text}");
    //   }
    // }
    // textController.text = widget.draftRxMedicinItem[index].quantity;

    setState(() {
      isMedicineSync = databox.get('isMedicineSync') ?? false;
      isRxDoctorSync = databox.get('isRxDoctorSync') ?? false;
      photo_submit_url = databox.get('photo_submit_url');
      latitude = databox.get("latitude") ?? 0.0;
      longitude = databox.get("longitude") ?? 0.0;
      submit_url = databox.get("submit_url");
      cid = databox.get("CID");
      userId = databox.get("USER_ID");
      userPassword = databox.get("PASSWORD");
      userName = databox.get("userName")!;
      user_id = databox.get("user_id")!;
      deviceId = databox.get("deviceId");
      deviceBrand = databox.get("deviceBrand");
      deviceModel = databox.get("deviceModel");
      rx_doc_must = databox.get("rx_doc_must") ?? false;
      rx_type_must = databox.get("rx_type_must") ?? false;
      rx_gallery_allow = databox.get("rx_gallery_allow") ?? false;

      rxTypeList = databox.get("rx_type_list")!;
      dropdownRxTypevalue =
      widget.dcrGrad.isEmpty ? rxTypeList.first : widget.dcrGrad;
      // if (widget.uniqueId == 0) {
      //   int? a = prefs.getInt('DCLCounter') ?? 0;

      //   setState(() {
      //     widget.uniqueId = a;
      //   });
      // }
    });
    // if (prefs.getInt('RxCounter') != null) {
    //   int? a = prefs.getInt('RxCounter');
    //   setState(() {
    //     _counterforRx = a!;
    //   });
    // }

    finalMedicineList = widget.draftRxMedicinItem;
    tempCount = widget.draftRxMedicinItem.length;
    setState(() {});
    if (widget.ck != '') {
      setState(() {
        _activeCounter = true;
      });

      int space = widget.image1.indexOf(" ");
      String removeSpace =
      widget.image1.substring(space + 1, widget.image1.length);
      finalImage = removeSpace.replaceAll("'", '');

      finalDoctorList.add(RxDcrDataModel(
        uiqueKey: widget.uniqueId,
        docName: widget.docName,
        docId: widget.docId,
        areaId: widget.areaId,
        areaName: widget.areaName,
        address: widget.address,
        presImage: finalImage,
        dcrGrad: dropdownRxTypevalue,
      ));
    } else {
      return;
    }

    super.initState();
  }

  int _rxCounter() {
    var dt = DateFormat('HH:mm:ssss').format(DateTime.now());

    String time = dt.replaceAll(":", '');

    setState(() {
      _counterforRx = int.parse(time);
    });

    return _counterforRx;
  }

  void calculateRxItemString() {
    itemString = '';
    if (finalMedicineList.isNotEmpty) {
      for (var element in finalMedicineList) {
        if (itemString == '') {
          itemString = '${element.itemId}|${element.quantity}';
        } else {
          itemString += '||${element.itemId}|${element.quantity}';
        }
      }
    }
    print("============================= ${itemString}");
  }

  void _onItemTapped(int index) async {
    if (index == 2) {
      // setState(() {
      //   _isLoading = false;
      // });
      // orderSubmit();
      if ((widget.image1 != '' || imagePath != null) &&
          finalMedicineList.isNotEmpty) {
        bool result = await NetworkConnecticity.checkConnectivity();
        if (result == true) {
          if (rx_doc_must == true) {
            if (finalDoctorList[0].docId != "") {
              // _rxImageSubmit();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title:  Text("confirm".tr()),
                  content:
                  const Text("Are you sure you want to submit the RX?"),
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
                        Navigator.of(context).pop(false);
                        uploadImage(imagePath!);
                      },
                      child:  Text("yes".tr()),
                    ),
                  ],
                ),
              );
            } else {
              _submitToastforDoctor();
              setState(() {
                _isLoading = true;
              });
            }
          } else {
            // _rxImageSubmit();
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title:  Text("confirm".tr()),
                content: const Text("Are you sure want to submit RX?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      // User clicked No, so close the dialog
                      Navigator.of(_).pop(false);
                    },
                    child:  Text("no".tr()),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      uploadImage(imagePath!);
                    },
                    child:  Text("yes".tr()),
                  ),
                ],
              ),
            );
          }
        } else {
          _submitToastforOrder3();
          setState(() {
            _isLoading = true;
          });
          // debugPrint(InternetConnectionChecker().lastTryResults);
        }
      } else {
        setState(() {
          _isLoading = true;
        });
        _submitToastforphoto();
      }

      setState(() {
        _currentSelected = index;
      });
    }

    if (index == 0) {
      if (imagePath != null || widget.image1 != '') {
        putAddedRxData();
      } else {
        _submitToastforphoto();
      }
      //   putAddedRxData();
      // } else if ((imagePath != null || widget.image1 != '') &&
      //     finalMedicineList.isNotEmpty) {

      // } else {
      //   _submitToastforphoto();
      // }
      // putAddedRxData();

      setState(() {
        _currentSelected = index;
      });
    }
    if (index == 1) {
      _galleryFunctionality();
      setState(() {
        _currentSelected = index;
      });
    }
    if (index == 3) {
      // if ((imagePath != null || widget.image1 != '')) {
      //   debugPrint("image will save on draft");
      //   finalDoctorList.add(
      //     RxDcrDataModel(
      //       uiqueKey: widget.uniqueId > 0 ? widget.uniqueId : _counterforRx,
      //       docName: widget.uniqueId > 0
      //           ? widget.uniqueId.toString()
      //           : _counterforRx.toString(),
      //       docId: '',
      //       areaId: '',
      //       areaName: 'areaName',
      //       address: 'address',
      //       presImage: imagePath.toString(),
      //     ),
      //   );
      //   for (var dcr in finalDoctorList) {
      //     final box = Boxes.rxdDoctor();

      //     box.add(dcr);
      //   }
      //   for (var d in finalMedicineList) {
      //     final box = Boxes.getMedicine();

      //     box.add(d);
      //   }
      // }
      if (widget.uniqueId == 0) {
        widget.uniqueId++;
      } else if (_counterforRx == 0) {
        _counterforRx++;
      }

      cameraFuntionality();
      setState(() {
        _currentSelected = index;
      });
    }
  }

  void _onItemTapped2(int index) async {
    if (index == 1) {
      // setState(() {
      //   _isLoading = false;
      // });
      // orderSubmit();
      if ((widget.image1 != '' || imagePath != null) &&
          finalMedicineList.isNotEmpty) {
        bool result = await NetworkConnecticity.checkConnectivity();

        if (result == true) {
          if (rx_doc_must == true) {
            if (finalDoctorList[0].docId != "") {
              // _rxImageSubmit();
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title:  Text("confirm".tr()),
                  content: const Text("Are you sure want to submit RX?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // User clicked No, so close the dialog
                        Navigator.of(_).pop(false);
                      },
                      child:  Text("no".tr()),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(_).pop(false);

                        // // _rxImageSubmit();

                        uploadImage(imagePath!);
                      },
                      child:  Text("yes".tr()),
                    ),
                  ],
                ),
              );
            } else {
              _submitToastforDoctor();
              setState(() {
                _isLoading = true;
              });
            }
          } else {
            // _rxImageSubmit();
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title:  Text("confirm".tr()),
                content: const Text("Are you sure you want to submit the RX?"),
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
                      Navigator.of(context).pop(false);
                      uploadImage(imagePath!);
                    },
                    child:  Text("yes".tr()),
                  ),
                ],
              ),
            );
          }
        } else {
          _submitToastforOrder3();
          setState(() {
            _isLoading = true;
          });
          // debugPrint(InternetConnectionChecker().lastTryResults);
        }
      } else {
        setState(() {
          _isLoading = true;
        });
        _submitToastforphoto();
      }

      setState(() {
        _currentSelected2 = index;
      });
    }

    if (index == 0) {
      if (imagePath != null || widget.image1 != '') {
        putAddedRxData();
        Fluttertoast.showToast(msg: "Saved successfully",backgroundColor: Colors.green);
      } else {
        _submitToastforphoto();
      }
      setState(() {
        _currentSelected2 = index;
      });
    }

    if (index == 2) {
      // if (widget.uniqueId == 0) {
      //   widget.uniqueId++;
      // } else if (_counterforRx == 0) {
      //   _counterforRx++;
      // }
      cameraFuntionality();

      setState(() {
        _currentSelected2 = index;
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

    return WillPopScope(
      onWillPop: () async {
        if (_isLoading == false) {
          return false;
        }
        return true;
      },
      child: _isLoading
          ? Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title:  Text('seen_rx_capture'.tr()),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ///*********************************doctor info******************************************///
                finalDoctorList.isNotEmpty
                    ? SizedBox(
                  height: screenHeight / 9,
                  child: Card(
                    color: const Color(0xffDDEBF7),
                    elevation: 10,
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(
                          color: Colors.white70, width: 1),
                      // borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      height: 70,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xffDDEBF7),
                        //borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${finalDoctorList[0].docName} '
                                        '(${finalDoctorList[0].docId})',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19,
                                    ),
                                  ),
                                  // SizedBox(height: 10),
                                  FittedBox(
                                    child: Text(
                                      '${finalDoctorList[0].areaName}(${finalDoctorList[0].areaId}) , ${finalDoctorList[0].address}',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            rx_type_must == true
                                ? Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child:
                                    DropdownButtonFormField(
                                      decoration:
                                      const InputDecoration(
                                          enabled: false),
                                      isExpanded: true,
                                      value:
                                      dropdownRxTypevalue,

                                      icon: const Icon(
                                        Icons
                                            .keyboard_arrow_down,
                                        color: Colors.black,
                                      ),

                                      // Array list of items
                                      items: rxTypeList.map(
                                              (String items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(
                                                items,
                                                style:
                                                const TextStyle(
                                                  color: Colors
                                                      .black,
                                                  // fontSize: 16,
                                                ),
                                              ),
                                            );
                                          }).toList(),

                                      onChanged:
                                          (String? newValue) {
                                        setState(() {
                                          dropdownRxTypevalue =
                                          newValue!;
                                        });
                                      },
                                    ),
                                  )
                                ],
                              ),
                            )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                    : SizedBox(
                  height: screenHeight / 9,
                  child: Card(
                    color: const Color(0xffDDEBF7),
                    elevation: 10,
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(
                          color: Colors.white70, width: 1),
                      // borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      height: 70,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xffDDEBF7),
                        //borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: tempdocName == ""
                                  ?  Text(
                                'no_doctor_selected'.tr(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                                ),
                              )
                                  : Text(
                                tempdocName,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                                ),
                              ),
                            ),
                            rx_type_must == true
                                ? Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  // const Text(
                                  //   "Rx Type : ",
                                  //   style: TextStyle(
                                  //       color: Colors.black,
                                  //       fontSize: 16),
                                  // ),
                                  Expanded(
                                    child:
                                    DropdownButtonFormField(
                                      decoration:
                                      const InputDecoration(
                                          enabled: false),
                                      isExpanded: true,
                                      // Initial Value
                                      value:
                                      dropdownRxTypevalue,

                                      // Down Arrow Icon
                                      icon: const Icon(
                                        Icons
                                            .keyboard_arrow_down,
                                        color: Colors.black,
                                      ),

                                      // Array list of items
                                      items: rxTypeList.map(
                                              (String items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(
                                                items,
                                                style:
                                                const TextStyle(
                                                  color: Colors
                                                      .black,
                                                  // fontSize: 16,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                      // After selecting the desired option,it will
                                      // change button value to selected value
                                      onChanged:
                                          (String? newValue) {
                                        setState(() {
                                          dropdownRxTypevalue =
                                          newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                //////////////////camera////////////////////
                Row(
                  // mainAxisAlignment: MainAxisAlignment.start,

                  children: [
                    Expanded(
                      child: Card(
                        elevation: 5,
                        child: Container(
                          height: screenHeight / 3.3,
                          // width: screenWidth / 1.8,
                          decoration: const BoxDecoration(
                            // borderRadius: BorderRadius.circular(10),
                            color: Colors.grey,
                          ),
                          child: widget.image1 != ''
                              ? InkWell(
                            onDoubleTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ZoomForRxDraftImage(finalImage),
                                ),
                              );
                            },
                            child: Hero(
                              tag: "imageForDraft",
                              child: Image.file(
                                File(finalImage),
                              ),
                            ),
                          )
                          // ? FullScreenWidget(
                          //     child: PhotoView(
                          //         imageProvider:
                          //             gFileImage(File(finalImage))
                          //
                          //         // Image.file(File(finalImage)),
                          //         ))
                              : file == null
                              ? Column(
                            children: [
                              Expanded(
                                flex: 4,
                                child: InkWell(
                                  onTap: (){
                                    cameraFuntionality();



                                  },
                                  child: Image.asset(
                                    'assets/images/dummy.jpg',
                                    fit: BoxFit.cover,width: double.infinity,
                                  ),
                                ),
                              ),
                              Expanded(
                                // flex: 4,
                                  child: Container(
                                    color: Colors.white,
                                    child:  Center(
                                      child: Text(
                                        "double_tap_to_zoom".tr(),
                                        style:
                                        TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ))
                            ],
                          )
                              : InkWell(
                            onDoubleTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ZoomForRxImage(imagePath),
                                ),
                              );
                            },
                            child: Hero(
                              tag: "img",
                              child: Image.file(imagePath!),
                            ),
                          ),
                          // : FullScreenWidget(
                          //     child: PhotoView(
                          //     imageProvider: FileImage(
                          //       imagePath!,
                          //     ),
                          //
                          //     // Image.file(File(finalImage)),
                          //   )),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (isRxDoctorSync == true) {
                              // if (_activeCounter == true) {
                              //   setState(() {
                              //     counterForDoctor = _counterforRx;
                              //   });
                              // }
                              // debugPrint('drcounter:$counterForDoctor');
                              setState(() {});
                              if (imagePath != null) {
                                getRxDoctorData();
                              } else if (widget.image1 != "") {
                                getRxDoctorData();
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'Please Take Image First ',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: 'Please sync doctor data',
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          },
                          child: Center(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(5.0),
                              ),
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(100),
                                        color: Colors.white,
                                      ),
                                      width: screenWidth / 5,
                                      height: screenHeight / 9,

                                      // color: const Color(0xffDDEBF7),
                                      child: Container(
                                        color: Colors.white,
                                        child: Column(
                                          mainAxisSize:
                                          MainAxisSize.min,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              ImageConstant.doctorPngImage,
                                              // color: Colors.teal,
                                              width: screenWidth / 7,
                                              height: screenWidth / 7,
                                              fit: BoxFit.cover,
                                            ),
                                            FittedBox(
                                              child: Text(
                                                'doctor'.tr(),
                                                style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  color: Colors.teal,
                                                  fontSize:
                                                  screenHeight / 45,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (isMedicineSync == true) {
                              debugPrint(imagePath.toString());
                              setState(() {});

                              if (imagePath != null) {
                                if (widget.uniqueId >= 0 &&
                                    finalDoctorList.isNotEmpty) {
                                  getMedicine();
                                  // debugPrint(widget.uniqueId);
                                } else if (_activeCounter == false) {
                                  // debugPrint('activeCounter:$_activeCounter');
                                  _rxCounter();
                                  getMedicine();
                                  // debugPrint('test:${widget.uniqueId}');
                                  setState(() {
                                    _activeCounter = true;
                                  });
                                } else if (_activeCounter == true) {
                                  getMedicine();
                                }
                              } else if (widget.image1 != "") {
                                if (widget.uniqueId >= 0 &&
                                    finalDoctorList.isNotEmpty) {
                                  getMedicine();
                                  // debugPrint(widget.uniqueId);
                                } else if (_activeCounter == false) {
                                  // debugPrint('activeCounter:$_activeCounter');
                                  _rxCounter();
                                  getMedicine();
                                  // debugPrint('test:${widget.uniqueId}');
                                  setState(() {
                                    _activeCounter = true;
                                  });
                                } else if (_activeCounter == true) {
                                  getMedicine();
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'Please Take Image First ',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: 'Please Sync Medicine',
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          },
                          child: Center(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(5.0),
                              ),
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: screenWidth / 5,
                                      height: screenHeight / 10,

                                      // color: const Color(0xffDDEBF7),
                                      child: Container(
                                        color: Colors.white,
                                        child: Column(
                                          mainAxisSize:
                                          MainAxisSize.min,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/images/cap.png',
                                              // color: Colors.teal,
                                              width: screenWidth / 10,
                                              height: screenWidth / 8,
                                              fit: BoxFit.cover,
                                            ),
                                            FittedBox(
                                              child: Text(
                                                'medicine'.tr(),
                                                style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  color: Colors.teal,
                                                  fontSize:
                                                  screenHeight / 45,
                                                ),
                                              ),
                                            )
                                            // Image.asset(
                                            //   'assets/images/doctor.jpg',
                                            //   // width: 60,
                                            //   // height: 40,
                                            //   fit: BoxFit.cover,
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),


                ////////////////////////////////medicine List View////////////////
                finalMedicineList.isNotEmpty
                    ? Card(
                  elevation: 15,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                        color: Colors.white70, width: 1),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  color: const Color(0xffDDEBF7),
                  child: SizedBox(
                    height: screenHeight / 1.7,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: finalMedicineList.length,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(bottom: 200.0),
                      itemBuilder:
                          (BuildContext itemBuilder, index) {
                        return Card(
                          elevation: 10,
                          color: const Color.fromARGB(
                              255, 217, 248, 219),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Colors.white70, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          '${finalMedicineList[index].name} '
                                              '(${finalMedicineList[index].itemId})',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            // fontWeight:
                                            // FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            // var x =
                                            if (finalMedicineList[
                                            index]
                                                .quantity >
                                                1) {
                                              finalMedicineList[
                                              index]
                                                  .quantity--;
                                            }

                                            // calculateRxItemString(
                                            //     x.toString());
                                            setState(() {});
                                          },
                                          icon: const Icon(
                                              Icons.remove)),
                                      Container(
                                        width: 40,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors
                                                    .grey)),
                                        // color: !pressAttention
                                        //     ? Colors.white
                                        //     : Colors.blueAccent,
                                        child: Center(
                                          child: Text(
                                            finalMedicineList[index]
                                                .quantity
                                                .toString(),
                                            textAlign: TextAlign.center,

                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          // var y =
                                          finalMedicineList[index]
                                              .quantity++;
                                          // calculateRxItemString(
                                          //     y.toString());
                                          setState(() {});
                                        },
                                        icon: const Icon(Icons.add),
                                      ),
                                      IconButton(
                                        // color: Colors.red,
                                        onPressed: () {
                                          _showMyDialog(index);
                                        },
                                        icon: const Icon(
                                          Icons.clear,
                                          // size: 20,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
                    : const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: rx_gallery_allow == true
            ? BottomNavigationBar(
          backgroundColor:  Color.fromARGB(255, 138, 201, 149),
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
          currentIndex: _currentSelected,
          showUnselectedLabels: true,
          // unselectedItemColor: Colors.grey[800],
          // selectedItemColor: const Color.fromRGBO(10, 135, 255, 1),
          items:  <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: 'save_drafts'.tr(),
              icon: Icon(Icons.drafts),
            ),
            BottomNavigationBarItem(
              label: 'Gallery',
              icon: Icon(Icons.add_photo_alternate),
            ),
            BottomNavigationBarItem(
              label: 'submit'.tr(),
              icon: Icon(Icons.save),
            ),
            BottomNavigationBarItem(
              label: 'camera'.tr(),
              icon: Icon(Icons.camera_alt),
            ),
          ],
        )
            : BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped2,
          currentIndex: _currentSelected2,
          showUnselectedLabels: true,
          // unselectedItemColor: Colors.grey[800],
          // selectedItemColor: const Color.fromRGBO(10, 135, 255, 1),
          items:  <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: 'save_drafts'.tr(),
              icon: Icon(Icons.drafts,),
            ),
            BottomNavigationBarItem(
              label: 'submit'.tr(),
              icon: Icon(Icons.save),
            ),
            BottomNavigationBarItem(
              label: 'camera'.tr(),
              icon: Icon(Icons.camera_alt),
            ),
          ],
        ),
      )
          : Container(
        padding: const EdgeInsets.all(100),
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  // rx Submitt................................................
  Future<dynamic> rxSubmit(String fileName) async {
    debugPrint("File Name :::::::$fileName");
    double lat = 0.0;
    double long = 0.0;
    try {
      geo.Position? position = await geo.Geolocator.getCurrentPosition();
      if (position != null) {
        List<geocoding.Placemark> placemarks = await geocoding
            .placemarkFromCoordinates(position.latitude, position.longitude);
          lat = position.latitude;
          long = position.longitude;
          address = "${placemarks[0].street!} ${placemarks[0].country!}";

      }
    }
    on Exception catch (e) {
      debugPrint("Exception geo-locator section: $e");
    }

    debugPrint(
        '${submit_url!}api_rx_submit/submit_data?cid=$cid&user_id=$userId&user_pass=$userPassword&device_id=$deviceId&doctor_id=${finalDoctorList.isEmpty ? '' : finalDoctorList[0].docId}&area_id=${finalDoctorList.isEmpty ? '' : finalDoctorList[0].areaId}&rx_type=$dropdownRxTypevalue&latitude=$lat&longitude=$long&image_name=$fileName&cap_time=${"dt"}&item_list=$itemString&app_version=$appVersion');
    // if (itemString != '') {
    // debugPrint(itemString);
    var dt = DateFormat('HH:mm:ss').format(DateTime.now());

    String time = dt.replaceAll(":", '');
    String a = '${user_id}_$time';

    try {
      final http.Response response = await http.post(
        Uri.parse('${submit_url!}api_rx_submit/submit_data'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(
          <String, dynamic>{
            'cid': cid,
            'user_id': userId,
            'user_pass': userPassword,
            'device_id': deviceId,
            'doctor_id':
            finalDoctorList.isEmpty ? '' : finalDoctorList[0].docId,
            'area_id': finalDoctorList.isEmpty ? '' : finalDoctorList[0].areaId,
            'rx_type': dropdownRxTypevalue,
            "latitude": (minLatitude <= lat && lat <= maxLatitude) ? lat : '',
            'longitude':
            (minLongitude <= long && long <= maxLongitude) ? long : '',
            'image_name': fileName,
            'cap_time': dt.toString(),
            "item_list": itemString,
            'app_version' : appVersion,
          },
        ),
      );

      var orderInfo = json.decode(response.body);
      String status = orderInfo['status'];
      debugPrint(orderInfo['status']);
      String ret_str = orderInfo['ret_str'];

      if (status == "Success") {
        if (widget.ck != '') {
          for (int i = 0; i <= finalMedicineList.length; i++) {
            // deleteMedicinItem(widget.dcrKey);//this one is Old
            deleteMedicinItem(widget.uniqueId); //! this is new one like Rx

            // finalItemDataList.clear();
            // setState(() {});
          }

          // deleteRxDoctor(widget.dcrKey);//this one is Old
          deleteRxDoctor(widget.uniqueId); //! This one is New One like RX
        }
        //todo! Add New Like RX
        else {
          for (int i = 0; i <= finalMedicineList.length; i++) {
            deleteMedicinItem(objectImageId);

            // finalItemDataList.clear();
            // setState(() {});
          }

          deleteRxDoctor(objectImageId);
        }

        //end add new

        // setState(() {
        //   _isLoading = true;
        // });

        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(
        //       builder: (context) => MyHomePage(
        //         userName: userName,
        //         user_id: user_id,
        //         userPassword: userPassword ?? '',
        //       ),
        //     ),
        //     (Route<dynamic> route) => false);

        print("===============================");


          widget.image1 = '';
          imagePath = null;
          file = null;
          finalMedicineList.clear();
          finalImage = '';

        _submitToastforOrder(ret_str);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('${orderInfo['ret_str']}'),
              backgroundColor: Colors.red),
        );
      }
    } on Exception catch (_) {
      throw Exception("Error on server");
    }
    finally{
      setState(() {
        _isLoading = true;
      });
    }
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //       content: Text(
    //         'Please Order something',
    //       ),
    //       backgroundColor: Color.fromARGB(255, 180, 59, 109)));
    // }
  }
  //testing
  Future<void> uploadImage(File imageFile) async {
    try {
      _isLoading=false;
      setState(() {

      });
      calculateRxItemString();
      File _image;
      if (widget.image1.isNotEmpty) {
        _image = File('${finalImage}');
      } else {
        _image = imageFile;
      }
      Uint8List compressedImageBytes = await compute(_compressImage, await _image.readAsBytes());

      await _uploadCompressedImage(compressedImageBytes);

    } catch (error) {
      _showSnackBar('Error: ${error.toString()}');
    }
  }

  Future<void> _uploadCompressedImage(Uint8List imageBytes) async {
    final request = http.MultipartRequest('POST', Uri.parse("$photo_submit_url"))
      ..files.add(http.MultipartFile.fromBytes(
        'productImage',
        imageBytes,
        filename: 'resized_image.jpg',
      ));

    final response = await request.send();
    final responseBody = await http.Response.fromStream(response);

    if (response.statusCode == 200) {

      print('Upload successful: ${responseBody.body}');
      var imgData = jsonDecode(responseBody.body);
      var imageName = '';
      if (imgData['res_data']['status'] == 'Success') {
        imageName = "${imgData['res_data']['ret_str'].toString()}";
        rxSubmit(imageName);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Rx Image submit Failed'),
              backgroundColor: Colors.red),
        );
      }
    } else {
      _showSnackBar('Upload failed: ${response.statusCode}');
      print('Failed to upload: ${response.statusCode}, ${responseBody.body}');
    }
  }

  static Uint8List _compressImage(Uint8List originalBytes) {
    final img.Image? image = img.decodeImage(originalBytes);
    if (image == null) {
      throw Exception('Unable to decode image');
    }

    const int targetFileSize = 900 * 1024; // 900 KB
    int quality = 90;
    List<int> compressedBytes;

    do {
      compressedBytes = img.encodeJpg(image, quality: quality);
      quality -= 10;
    } while (compressedBytes.length > targetFileSize && quality > 10);

    return Uint8List.fromList(compressedBytes);
  }


  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }


  //

  // // ------------------------ Rx Submit (Kamrul) --------------
  //
  // Future rxImageUpload({dynamic imageFile}) async {
  //   print("-------------------------------------");
  //   setState(() {
  //     _isLoading = false;
  //   });
  //   // await Future.delayed(Duration(milliseconds: 500));
  //   try {
  //     calculateRxItemString();
  //     dynamic _image;
  //     if (widget.image1.isNotEmpty) {
  //       _image = File('${finalImage}');
  //     } else {
  //       _image = imageFile;
  //     }
  //     // await Future.delayed(Duration(milliseconds: 50));
  //     img.Image? imageTemp = img.decodeImage( await _image.readAsBytesSync());
  //
  //     int desiredFileSizeInBytes = 900 * 1024;
  //
  //     final int initialQuality = 90; // Initial quality value
  //     int currentQuality = initialQuality;
  //
  //     List<int> imageBytes;
  //     do {
  //       imageBytes = img.encodeJpg(imageTemp!, quality: currentQuality);
  //       currentQuality -= 10; // Decrease quality in steps
  //     } while (
  //     imageBytes.length > desiredFileSizeInBytes && currentQuality >= 10);
  //
  //     // await Future.delayed(Duration(milliseconds: 50));
  //
  //     final request =
  //     http.MultipartRequest('POST', Uri.parse("$photo_submit_url"))
  //       ..files.add(
  //         await http.MultipartFile.fromBytes(
  //           'productImage',
  //           imageBytes,
  //           filename: 'resized_image.jpg',
  //         ),
  //       );
  //     var response = await request.send();
  //
  //     if (response.statusCode == 200) {
  //       var res = await http.Response.fromStream(response);
  //       var imgData = jsonDecode(res.body);
  //       var imageName = '';
  //       if (imgData['res_data']['status'] == 'Success') {
  //         imageName = "${imgData['res_data']['ret_str'].toString()}";
  //         rxSubmit(imageName);
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //               content: Text('Rx Image submit Failed'),
  //               backgroundColor: Colors.red),
  //         );
  //       }
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //             content: Text('Rx Image submit Failed'),
  //             backgroundColor: Colors.red),
  //       );
  //     }
  //   } catch (e) {
  //     throw Exception(e.toString());
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  // ..........Rx Image Submit.................................
  // Future<dynamic> _rxImageSubmit() async {
  //   setState(() {
  //     calculateRxItemString();
  //   });
  //
  //   var dt = DateFormat('HH:mm:ss').format(DateTime.now());
  //
  //   String time = dt.replaceAll(":", '');
  //
  //   var postUri = Uri.parse(photo_submit_url!);
  //
  //   http.MultipartRequest request = http.MultipartRequest("POST", postUri);
  //   if (widget.image1 != '') {
  //     final compressfileForImage = await compressFile(File(finalImage));
  //
  //     setState(() {
  //       finalImage = compressfileForImage.toString();
  //     });
  //
  //     int space = finalImage.indexOf(" ");
  //     String removeSpace = finalImage.substring(space + 1, finalImage.length);
  //     finalImage = removeSpace.replaceAll("'", '');
  //
  //     http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
  //       'productImage', finalImage.toString(),
  //       // filename: a,
  //       // filename: finalImage.split("-").last
  //     );
  //
  //     request.files.add(multipartFile);
  //     http.StreamedResponse response = await request.send();
  //     var res = await http.Response.fromStream(response);
  //     final jsonData = json.decode(res.body);
  //     debugPrint("result 2nd condition rx image $jsonData");
  //     final fileName = jsonData['fileName'];
  //
  //     // debugPrint(fileName);
  //     if (fileName != '') {
  //       rxSubmit(fileName);
  //     } else {
  //       setState(() {
  //         _isLoading = true;
  //       });
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //             content: Text('Rx Image submit Failed'),
  //             backgroundColor: Colors.red),
  //       );
  //     }
  //     // debugPrint(response.statusCode);
  //   } else {
  //     final compressfileForImage = await compressFile(imagePath!);
  //     String rxImage = '';
  //
  //     setState(() {
  //       rxImage = compressfileForImage.toString();
  //     });
  //
  //     int space = rxImage.indexOf(" ");
  //     String removeSpace = rxImage.substring(space + 1, rxImage.length);
  //     finalImage = removeSpace.replaceAll("'", '');
  //
  //     http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
  //       'productImage', finalImage,
  //       // filename: a,
  //       // filename: finalImage.split("-").last
  //     );
  //
  //     //request.fields["rxImage"] = finalImage;
  //     request.files.add(multipartFile);
  //     http.StreamedResponse response = await request.send();
  //
  //     var res = await http.Response.fromStream(response);
  //     final jsonData = json.decode(res.body);
  //     final fileName = jsonData['fileName'];
  //
  //     // debugPrint(fileName);
  //     if (fileName != '') {
  //       rxSubmit(fileName);
  //     } else {
  //       setState(() {
  //         _isLoading = true;
  //       });
  //
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //             content: Text('Rx Image submit Failed'),
  //             backgroundColor: Colors.red),
  //       );
  //     }
  //   }
  // }

  // .......... Submit Toast messege..............
  void _submitToastforOrder(String ret_str) {
    Fluttertoast.showToast(
        msg: "Rx Submitted\n$ret_str",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green.shade900,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  deleteRxDoctor(int id) {
    final box = Hive.box<RxDcrDataModel>("RxdDoctor");

    final Map<dynamic, RxDcrDataModel> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.uiqueKey == id) desiredKey = key;
    });
    box.delete(desiredKey);
  }

// Save RX data to Hive......................................

  deleteMedicinItem(int id) {
    final box = Hive.box<MedicineListModel>("draftMdicinList");

    final Map<dynamic, MedicineListModel> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.uiqueKey == id) desiredKey = key;
    });
    box.delete(desiredKey);
  }

  Future putAddedRxData() async {
    if (widget.ck != '') {
      for (int i = 0; i <= finalMedicineList.length; i++) {
        deleteMedicinItem(widget.dcrKey);

        setState(() {});
      }
      // deleteRxDoctor(widget.uniqueId);

      final Doctorbox = Boxes.rxdDoctor();
      Doctorbox.toMap().forEach((key, value) {
        if (value.uiqueKey == widget.dcrKey) {
          value.docName = finalDoctorList[0].docName;
          value.docId = finalDoctorList[0].docId;
          value.address = finalDoctorList[0].address;
          value.areaId = finalDoctorList[0].areaId;
          value.areaName = finalDoctorList[0].areaName;
          value.dcrGrad = dropdownRxTypevalue.toString();

          Doctorbox.put(key, value);
        }
      });
      // for (var dcr in finalDoctorList) {
      //   final box = Boxes.rxdDoctor();

      //   box.add(dcr);
      // }

      for (var d in finalMedicineList) {
        d.uiqueKey = widget.dcrKey;
        final box = Boxes.getMedicine();
        box.add(d);
      }

      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => MyHomePage(
      //               userName: userName,
      //               user_id: user_id,
      //               userPassword: userPassword ?? '',
      //             )),
      //     (route) => false);
    } else {
      for (var dcr in finalDoctorList) {
        debugPrint('uiniquIdD:${dcr.uiqueKey}');
        final box = Boxes.rxdDoctor();
        final medicineBox = Boxes.getMedicine();
        dcr.uiqueKey = objectImageId;
        box.toMap().forEach((key, value) {
          if (dcr.uiqueKey == value.uiqueKey) {
            value.docName = dcr.docName;
            value.docId = dcr.docId;
            value.areaName = dcr.areaName;
            value.areaId = dcr.areaId;
            value.address = dcr.address;
            value.dcrGrad = dropdownRxTypevalue.toString();
            box.put(key, value);
            if (finalMedicineList.isNotEmpty) {
              for (var element in finalMedicineList) {
                element.uiqueKey = objectImageId;
                medicineBox.add(element);
              }
            }
          }
        });
      }

      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => MyHomePage(
      //         userName: userName,
      //         user_id: user_id,
      //         userPassword: userPassword ?? '',
      //       ),
      //     ),
      //     (route) => false);
    }
    setState(() {
      widget.image1 = '';
      imagePath = null;
      file = null;
      finalMedicineList.clear();
      finalImage = '';
    });

    // if (finalMedicineList.isEmpty) {
    //   debugPrint("medicine is not selected");
    //   // for (int i = 0; i <= tempCount; i++) {
    //   //   deleteMedicinItem(widget.dcrKey);

    //   //   // finalItemDataList.clear();
    //   //   setState(() {});
    //   // }

    //   // setState(() {});

    //   // // Navigator.pushAndRemoveUntil(
    //   // //     context,
    //   // //     MaterialPageRoute(
    //   // //         builder: (context) => MyHomePage(
    //   // //               userName: userName,
    //   // //               user_id: user_id,
    //   // //               userPassword: userPassword ?? '',
    //   // //             )),
    //   // //     (route) => false);
    // } else {
    //   debugPrint("dr is not selected");
    //   // if (finalDoctorList.isEmpty) {
    //   //   finalDoctorList.add(
    //   //     RxDcrDataModel(
    //   //       uiqueKey: _counterforRx,
    //   //       docName: 'UnKnownDoctor',
    //   //       docId: '',
    //   //       areaId: '',
    //   //       areaName: 'areaName',
    //   //       address: 'address',
    //   //       presImage: imagePath.toString(),
    //   //     ),
    //   //   );
    //   //   for (var dcr in finalDoctorList) {
    //   //     final box = Boxes.rxdDoctor();

    //   //     box.add(dcr);
    //   //   }
    //   //   for (var d in finalMedicineList) {
    //   //     final box = Boxes.getMedicine();

    //   //     box.add(d);
    //   //   }

    //   //   Navigator.pop(context);
    //   // } else {
    //   //   finalDoctorList[0].presImage = imagePath.toString();
    //   //   for (var dcr in finalDoctorList) {
    //   //     debugPrint('uiniquIdD:${dcr.uiqueKey}');
    //   //     final box = Boxes.rxdDoctor();
    //   //     box.toMap().forEach((key, value) {
    //   //       if (dcr.uiqueKey == value.uiqueKey) {
    //   //         value.docName = dcr.docName;
    //   //         value.docId = dcr.docId;
    //   //         value.areaName = dcr.areaName;
    //   //         value.areaId = dcr.areaId;
    //   //         value.address = dcr.address;
    //   //         box.put(key, value);
    //   //       }
    //   //     });

    //   //     // box.add(dcr);
    //   //   }

    //   //   for (var d in finalMedicineList) {
    //   //     debugPrint('uiniquIdM:${d.uiqueKey}');
    //   //     final box = Boxes.getMedicine();

    //   //     box.add(d);
    //   //   }

    //   //   Navigator.pop(context);
    //   // }
    // }
  }

  //! Future openBox() async {
  //!   var dir = await getApplicationDocumentsDirectory();
  //!   Hive.init(dir.path);
  //!   box = await Hive.openBox('dcrListData');
  //! }

////////////////////////////docotr//////////////////////////
  getRxDoctorData() {
    //! await openBox();
    var box = Hive.box("dcrListData");
    var mymap = box.toMap().values.toList();
    if (mymap.isNotEmpty) {
      doctorData = mymap;

      if (_activeCounter == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DoctorListFromHiveData(
              counterCallback: (value) {
                counterForDoctor = value;

                setState(() {});
              },
              a: a,
              doctorData: doctorData,
              tempList: finalDoctorList,
              counterForDoctorList: widget.uniqueId > 0
                  ? widget.uniqueId
                  : _isCameraClick == true
                  ? objectImageId
                  : _counterforRx,
              tempListFunc: (value) {
                finalDoctorList = value;
                for (var element in finalDoctorList) {
                  docId = element.docId;
                  //todo! for last Doctor
                  tempdocName = element.docName;
                  areaName = element.areaName;
                  areaid = element.areaId;
                  address = element.address;
                }

                setState(() {});
              },
            ),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DoctorListFromHiveData(
              counterCallback: (value) {
                counterForDoctor = value;

                // setState(() {});
              },
              a: a,
              doctorData: doctorData,
              tempList: finalDoctorList,
              counterForDoctorList:
              widget.uniqueId > 0 ? widget.uniqueId : counterForDoctor,
              tempListFunc: (value) {
                finalDoctorList = value;
                for (var element in finalDoctorList) {
                  docId = element.docId;
                  //todo for set last Doctor
                  tempdocName = element.docName;
                  areaName = element.areaName;
                  areaid = element.areaId;
                  address = element.address;
                }

                setState(() {});
              },
            ),
          ),
        );
      }
    } else {
      doctorData.add('Empty');
    }
  }

///////////////////////////////medicine///////////////////////////////
  //! Future openBox1() async {
  //!   var dir = await getApplicationDocumentsDirectory();
  //!   Hive.init(dir.path);
  //!   box = await Hive.openBox('medicineList');
  //! }

  getMedicine() {
    //! await openBox1();
    var box = Hive.box('medicineList');
    var mymap = box.toMap().values.toList();
    if (mymap.isNotEmpty) {
      medicineData = mymap;
      // debugPrint('test1:$counterForDoctor');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MedicinListScreen(
            counter:
            (finalDoctorList.isNotEmpty && finalDoctorList[0].docId != '')
                ? counterForDoctor
                : _isCameraClick == true
                ? objectImageId
                : widget.uniqueId > 0
                ? widget.uniqueId
                : _counterforRx,
            medicineData: medicineData,
            tempList: finalMedicineList,
            tempListFunc: (value) {
              finalMedicineList = value;
              setState(() {});
            },
            img1: finalImage,
            img: imagePath,
          ),
        ),
      );
    } else {
      medicineData.add('Empty');
    }
  }

  deleteMedicineItem(int id, int index) {
    final box = Hive.box<MedicineListModel>("draftMdicinList");
    final Map<dynamic, MedicineListModel> medicineMap = box.toMap();
    dynamic newKey;
    medicineMap.forEach((key, value) {
      if (value.uiqueKey == id) {
        newKey = key;
      }
    });
    box.delete(newKey);
    finalMedicineList.removeAt(index);
  }

  // void _submitToastforSelectDoctor() {
  //   Fluttertoast.showToast(
  //       msg: 'Please Select Doctor First',
  //       toastLength: Toast.LENGTH_LONG,
  //       gravity: ToastGravity.CENTER,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //       fontSize: 16.0);
  // }

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
                Text('Do you want to delete this medicine?'),
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
                  final medicineUniqueKey = finalMedicineList[index].uiqueKey;

                  deleteMedicineItem(medicineUniqueKey, index);
                  setState(() {});
                } else {
                  finalMedicineList.removeAt(index);
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

  int uniqueIdForImage() {
    int id = 0;
    id = int.parse(
        DateFormat('HH:mm:ssss').format(DateTime.now()).replaceAll(":", ''));
    setState(() {
      objectImageId = id;
    });
    return id;
  }

   Future<void> cameraFuntionality() async {
    setState(() {
      debugPrint('changebefore: $_isCameraClick');
      _isCameraClick = true;
      debugPrint('changeafter: $_isCameraClick');
    });
    file = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 85
      //preferredCameraDevice: CameraDevice.rear,
      // maxHeight: 800,
      // maxWidth: 700,
    );
    if (file != null) {
      debugPrint("file from cam $file");
      setState(() {
        file;
        imagePath = File(file!.path);
        widget.image1 = '';
        debugPrint("image path from cam$imagePath");

        if (imagePath != null && widget.ck == "") {
          // if (finalDoctorList.)
          debugPrint("image will save on draft");
          if (finalDoctorList.isEmpty) {
            finalDoctorList.add(
              RxDcrDataModel(
                // uiqueKey:
                //     widget.image1 != '' ? widget.uniqueId : uniqueIdForImage(),
                // docName: objectImageId.toString(),
                // docId: '',
                // areaId: '',
                // areaName: 'areaName',
                // address: 'address',
                // presImage: imagePath.toString(),
                uiqueKey:
                widget.image1 != '' ? widget.uniqueId : uniqueIdForImage(),
                docName:
                tempdocName == "" ? objectImageId.toString() : tempdocName,
                docId: docId == '' ? "" : docId,
                areaId: areaid == "" ? "" : areaid,
                areaName: areaName == '' ? "areaName" : areaName,
                address: address == '' ? "address" : address,
                presImage: imagePath.toString(),
                dcrGrad: dropdownRxTypevalue.toString(),
              ),
            );

            for (var dcr in finalDoctorList) {
              final box = Boxes.rxdDoctor();

              box.add(dcr);
            }
            for (var d in finalMedicineList) {
              final box = Boxes.getMedicine();

              box.add(d);
            }
          } else {
            finalDoctorList.clear();
            finalDoctorList.add(
              RxDcrDataModel(
                // uiqueKey:
                //     widget.image1 != '' ? widget.uniqueId : uniqueIdForImage(),
                // docName: objectImageId.toString(),
                // docId: '',
                // areaId: '',
                // areaName: 'areaName',
                // address: 'address',
                // presImage: imagePath.toString(),
                uiqueKey:
                widget.image1 != '' ? widget.uniqueId : uniqueIdForImage(),
                docName:
                tempdocName == "" ? objectImageId.toString() : tempdocName,
                docId: docId == "" ? '' : docId,
                areaId: areaid == '' ? "" : areaid,
                areaName: areaName == '' ? "areaName" : areaName,
                address: address == '' ? "address" : address,
                presImage: imagePath.toString(),
                dcrGrad: dropdownRxTypevalue.toString(),
              ),
            );

            for (var dcr in finalDoctorList) {
              final box = Boxes.rxdDoctor();

              box.add(dcr);
            }
            for (var d in finalMedicineList) {
              final box = Boxes.getMedicine();

              box.add(d);
            }
          }
        } else if (imagePath != null && widget.ck != '') {
          final Doctorbox = Boxes.rxdDoctor();
          Doctorbox.toMap().forEach((key, value) {
            if (value.uiqueKey == widget.dcrKey) {
              value.presImage = imagePath.toString();
              Doctorbox.put(key, value);
            }
          });
          // widget.image1 = imagePath.toString();
          debugPrint(
              "This Print is Total Darft data${Doctorbox.values.length}");
          // int langth=Doctorbox.values.toList().length.toInt();
          // widget.callback(langth);
        }
      });
    }
  }

  Future<void> _galleryFunctionality() async {
    file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
      //preferredCameraDevice: CameraDevice.rear,
      maxHeight: 800,
      maxWidth: 700,
    );
    if (file != null) {
      setState(() {
        file;
        imagePath = File(file!.path);
      });
    }
  }

  void _submitToastforphoto() {
    Fluttertoast.showToast(
        msg: 'Please Select Medicine',
        // msg: 'Please Take Image and Select Medicine',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _submitToastforDoctor() {
    Fluttertoast.showToast(
        msg: 'Please Select Doctor.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<File> compressFile(File file) async {
    final filePath = file.absolute.path;

    // Create output file path
    // eg:- "Volume/VM/abcd_out.jpeg"
    final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    debugPrint("file path${file.absolute.path}");
    debugPrint("out path$outPath");
    var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, outPath,
        quality: 95, minHeight: 800, minWidth: 800);

    print(file.lengthSync());
    print(result!.lengthSync());
    debugPrint("result $result");

    return result;
  }
}

class ZoomForRxImage extends StatelessWidget {
  File? img;
  ZoomForRxImage(this.img, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
              tag: 'imageHero',
              child: PhotoView(
                imageProvider: FileImage(img!),
              )),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class ZoomForRxDraftImage extends StatelessWidget {
  String? draftFinalImage;
  ZoomForRxDraftImage(this.draftFinalImage, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageForDraft',
            child: PhotoView(
              imageProvider: FileImage(File(draftFinalImage!)),
            ),
          ),
        ),
        onTap: () {
          Navigator.of(context);
        },
      ),
    );
  }
}
