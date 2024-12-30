// ignore_for_file: file_names, prefer_typing_uninitialized_variables

import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mrap_v03/Rx/rxPage.dart';
import 'package:mrap_v03/local_storage/hive_data_model.dart';
import 'package:mrap_v03/local_storage/boxes.dart';
import 'package:path_provider/path_provider.dart';

import '../core/utils/app_colors.dart';

class RxDraftPage extends StatefulWidget {
  const RxDraftPage({
    Key? key,
  }) : super(key: key);

  @override
  State<RxDraftPage> createState() => _RxDraftPageState();
}

class _RxDraftPageState extends State<RxDraftPage> {
  // final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  Box? box;
  var screenHeight;
  var screenWidth;
  List itemDraftList = [];
  List<MedicineListModel> addedRxMedicinList = [];
  List<MedicineListModel> filteredMedicin = [];
  List<RxDcrDataModel> dcrDataList = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      box = Boxes.getMedicine();
      addedRxMedicinList =
          box!.toMap().values.toList().cast<MedicineListModel>();

      box = Boxes.dcrUsers();
      dcrDataList = box!.toMap().values.toList().cast<RxDcrDataModel>();

      setState(() {});
    });
    super.initState();
  }

  int currentSelected = 0;

  void onItemTapped(int index) async {
    if (index == 1) {
      // await putData();
      setState(() {
        currentSelected = index;
      });
      // debugPrint('order List seved to hive');
    } else {
      // debugPrint('ohe eta hbe na');
    }
    if (index == 0) {
      await Boxes.dcrUsers().clear();

      await Boxes.getMedicine().clear();

      setState(() {
        currentSelected = index;
      });
    }
  }

  Future<void> deleteRxDoctor(RxDcrDataModel rxDcrDataModel) async {
    rxDcrDataModel.delete();
  }

  deletRxMedicinItem(int id) {
    final box = Hive.box<MedicineListModel>("draftMdicinList");

    final Map<dynamic, MedicineListModel> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.uiqueKey == id) desiredKey = key;
    });
    box.delete(desiredKey);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text('draft_seen_rx'.tr()), centerTitle: true),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: Boxes.rxdDoctor().listenable(),
          builder: (BuildContext context, Box box, Widget? child) {
            final rxDoctor = box.values.toList().cast<RxDcrDataModel>();

            return genContent(rxDoctor);
          },
        ),
      ),
    );
  }

  Widget genContent(List<RxDcrDataModel> user) {
    if (user.isEmpty) {
      deleteChace();

      return  Center(
        child: Text(
          "no_data_found".tr(),
          style: TextStyle(fontSize: 20),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: user.length,
        itemBuilder: (BuildContext context, int index) {
          int space = user[index].presImage.indexOf(" ");
          String removeSpace = user[index]
              .presImage
              .substring(space + 1, user[index].presImage.length);
          String finalImage = removeSpace.replaceAll("'", '');

          return GestureDetector(
            onTap: () {},
            child: Card(
              elevation: 10,
              // color: const Color.fromARGB(255, 207, 240, 207),
              child: ExpansionTile(
                textColor: Colors.black87,
                childrenPadding: const EdgeInsets.all(0),
                // tilePadding: EdgeInsets.all(0),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: screenHeight / 8,
                        width: screenWidth / 6,
                        child: Image(
                          fit: BoxFit.cover,
                          image: FileImage(File(finalImage)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Text(
                            "${user[index].docName} (${user[index].docId}) ",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            user[index].areaName,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(

                        child: InkWell(
                          onTap: (){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title:  Text("confirm".tr(),),
                                  content:  Text(
                                      "are_you_sure_you_want_to_delete_the_rx".tr()),
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
                                        final rxDoctorkey = user[index].uiqueKey;
                                        deleteRxDoctor(user[index]);
                                        // deleteItem(user[index]);

                                        deletRxMedicinItem(rxDoctorkey);
                                        setState(() {});
                                        // User clicked Yes, so close the dialog and return true
                                        Navigator.of(context).pop(true);
                                      },
                                      child:  Text("yes".tr()),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Card(

                              color: kErrorColor,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
                                child: Row(
                                  children: [
                                    Icon(
                                        Icons.delete,
                                        color: Colors.white),
                                    Text(
                                      "delete".tr(),
                                      style: TextStyle(color: Colors.white,fontSize: 16),
                                    ),

                                  ],),
                              )
                          ),
                        ),
                      ),

                      SizedBox(

                        child: InkWell(
                          onTap: (){
                            {
                              final dcrKey = user[index].uiqueKey;
                              // debugPrint('dcr:$dcrKey');
                              filteredMedicin = [];
                              addedRxMedicinList
                                  .where((item) => item.uiqueKey == dcrKey)
                                  .forEach(
                                    (item) {
                                  debugPrint('gsp: ${item.uiqueKey}');
                                  final temp = MedicineListModel(
                                      uiqueKey: item.uiqueKey,
                                      strength: item.strength,
                                      brand: item.brand,
                                      company: item.company,
                                      formation: item.formation,
                                      name: item.name,
                                      generic: item.generic,
                                      itemId: item.itemId,
                                      quantity: item.quantity);

                                  filteredMedicin.add(temp);
                                },
                              );
                              // debugPrint('ami jani na ${user[index].presImage}');

                              // debugPrint(ckey);
                              if ((user[index].presImage != "") &&
                                  filteredMedicin.isEmpty) {
                                // debugPrint("dcrkey when only Image ${dcrKey}");
                                // debugPrint(
                                //     "dcrkey when only Image ${user[index].uiqueKey}");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        RxPage(
                                          ck: 'isCheckedByImage',
                                          dcrKey: dcrKey,
                                          uniqueId: user[index].uiqueKey,
                                          draftRxMedicinItem: filteredMedicin,
                                          docName: user[index].docName,
                                          docId: user[index].docId,
                                          areaName: user[index].areaName,
                                          areaId: user[index].areaId,
                                          address: user[index].address,
                                          image1: user[index].presImage,
                                          dcrGrad: user[index].dcrGrad,
                                        ),
                                  ),
                                );
                              } else {
                                // debugPrint("dcrkey when medicine ${dcrKey}");
                                // debugPrint(
                                //     "dcrkey when medicine ${user[index].uiqueKey}");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        RxPage(
                                          ck: 'isCheck',
                                          dcrKey: dcrKey,
                                          uniqueId: user[index].uiqueKey,
                                          draftRxMedicinItem: filteredMedicin,
                                          docName: user[index].docName,
                                          docId: user[index].docId,
                                          areaName: user[index].areaName,
                                          areaId: user[index].areaId,
                                          address: user[index].address,
                                          image1: user[index].presImage,
                                          dcrGrad: user[index].dcrGrad,
                                        ),
                                  ),
                                );
                              }
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (_) => RxPage(
                              //       ck: 'isCheck',
                              //       dcrKey: dcrKey,
                              //       uniqueId: user[index].uiqueKey,
                              //       draftRxMedicinItem: filteredMedicin,
                              //       docName: user[index].docName,
                              //       docId: user[index].docId,
                              //       areaName: user[index].areaName,
                              //       areaId: user[index].areaId,
                              //       address: user[index].address,
                              //       image1: user[index].presImage,
                              //     ),
                              //   ),
                              // );
                            }
                          },
                          child: Card(

                              color: kPrimaryColor,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
                                child: Row(children: [
                                  Icon(
                                      Icons.arrow_forward_outlined,
                                      color: Colors.white),
                                  Text(
                                    "details".tr(),
                                    style: TextStyle(color: Colors.white,fontSize: 16),
                                  ),

                                ],),
                              )
                          ),
                        ),
                      ),
                      // TextButton.icon(
                      //   // onPressed: () => deleteUser(user[index]),
                      //   onPressed: () {
                      //     showDialog(
                      //       context: context,
                      //       builder: (BuildContext context) {
                      //         return AlertDialog(
                      //           title:  Text("confirm".tr(),),
                      //           content:  Text(
                      //               "are_you_sure_you_want_to_delete_the_rx".tr()),
                      //           actions: [
                      //             TextButton(
                      //               onPressed: () {
                      //                 // User clicked No, so close the dialog
                      //                 Navigator.of(context).pop(false);
                      //               },
                      //               child:  Text("no".tr()),
                      //             ),
                      //             TextButton(
                      //               onPressed: () {
                      //                 final rxDoctorkey = user[index].uiqueKey;
                      //                 deleteRxDoctor(user[index]);
                      //                 // deleteItem(user[index]);
                      //
                      //                 deletRxMedicinItem(rxDoctorkey);
                      //                 setState(() {});
                      //                 // User clicked Yes, so close the dialog and return true
                      //                 Navigator.of(context).pop(true);
                      //               },
                      //               child:  Text("yes".tr()),
                      //             ),
                      //           ],
                      //         );
                      //       },
                      //     );
                      //   },
                      //   icon: const Icon(
                      //     Icons.delete,
                      //     color: Colors.red,
                      //   ),
                      //   label: Text(
                      //     "delete".tr(),
                      //     style: TextStyle(color: Colors.red),
                      //   ),
                      // ),
                      // TextButton.icon(
                      //   onPressed: () {
                      //     final dcrKey = user[index].uiqueKey;
                      //     // debugPrint('dcr:$dcrKey');
                      //     filteredMedicin = [];
                      //     addedRxMedicinList
                      //         .where((item) => item.uiqueKey == dcrKey)
                      //         .forEach(
                      //       (item) {
                      //         debugPrint('gsp: ${item.uiqueKey}');
                      //         final temp = MedicineListModel(
                      //             uiqueKey: item.uiqueKey,
                      //             strength: item.strength,
                      //             brand: item.brand,
                      //             company: item.company,
                      //             formation: item.formation,
                      //             name: item.name,
                      //             generic: item.generic,
                      //             itemId: item.itemId,
                      //             quantity: item.quantity);
                      //
                      //         filteredMedicin.add(temp);
                      //       },
                      //     );
                      //     // debugPrint('ami jani na ${user[index].presImage}');
                      //
                      //     // debugPrint(ckey);
                      //     if ((user[index].presImage != "") &&
                      //         filteredMedicin.isEmpty) {
                      //       // debugPrint("dcrkey when only Image ${dcrKey}");
                      //       // debugPrint(
                      //       //     "dcrkey when only Image ${user[index].uiqueKey}");
                      //       Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (_) => RxPage(
                      //             ck: 'isCheckedByImage',
                      //             dcrKey: dcrKey,
                      //             uniqueId: user[index].uiqueKey,
                      //             draftRxMedicinItem: filteredMedicin,
                      //             docName: user[index].docName,
                      //             docId: user[index].docId,
                      //             areaName: user[index].areaName,
                      //             areaId: user[index].areaId,
                      //             address: user[index].address,
                      //             image1: user[index].presImage,
                      //             dcrGrad: user[index].dcrGrad,
                      //           ),
                      //         ),
                      //       );
                      //     } else {
                      //       // debugPrint("dcrkey when medicine ${dcrKey}");
                      //       // debugPrint(
                      //       //     "dcrkey when medicine ${user[index].uiqueKey}");
                      //       Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (_) => RxPage(
                      //             ck: 'isCheck',
                      //             dcrKey: dcrKey,
                      //             uniqueId: user[index].uiqueKey,
                      //             draftRxMedicinItem: filteredMedicin,
                      //             docName: user[index].docName,
                      //             docId: user[index].docId,
                      //             areaName: user[index].areaName,
                      //             areaId: user[index].areaId,
                      //             address: user[index].address,
                      //             image1: user[index].presImage,
                      //             dcrGrad: user[index].dcrGrad,
                      //           ),
                      //         ),
                      //       );
                      //     }
                      //     // Navigator.push(
                      //     //   context,
                      //     //   MaterialPageRoute(
                      //     //     builder: (_) => RxPage(
                      //     //       ck: 'isCheck',
                      //     //       dcrKey: dcrKey,
                      //     //       uniqueId: user[index].uiqueKey,
                      //     //       draftRxMedicinItem: filteredMedicin,
                      //     //       docName: user[index].docName,
                      //     //       docId: user[index].docId,
                      //     //       areaName: user[index].areaName,
                      //     //       areaId: user[index].areaId,
                      //     //       address: user[index].address,
                      //     //       image1: user[index].presImage,
                      //     //     ),
                      //     //   ),
                      //     // );
                      //   },
                      //   // onPressed: () => editUser(user[index]),
                      //   icon: const Icon(
                      //     Icons.arrow_forward_outlined,
                      //     color: Colors.blue,
                      //     // size: 30,
                      //   ),
                      //   label:  Text("details".tr(),
                      //     style: TextStyle(color: Colors.blue),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  Future deleteChace() async {
    await getTemporaryDirectory().then(
      (value) {
        Directory(value.path).delete(recursive: true);
      },
    );
  }
}
