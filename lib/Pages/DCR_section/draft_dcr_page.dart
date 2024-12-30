import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mrap_v03/Pages/DCR_section/dcr_gift_sample_PPM_page.dart';
import 'package:mrap_v03/local_storage/hive_data_model.dart';
import 'package:mrap_v03/local_storage/boxes.dart';

import '../../core/utils/app_colors.dart';

class DraftDCRScreen extends StatefulWidget {
  const DraftDCRScreen({Key? key}) : super(key: key);

  @override
  State<DraftDCRScreen> createState() => _DraftDCRScreenState();
}

class _DraftDCRScreenState extends State<DraftDCRScreen> {
  // final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  Box? box;

  List itemDraftList = [];
  List<DcrGSPDataModel> addedDcrGSPList = [];
  List<DcrGSPDataModel> filteredOrder = [];
  List<DcrDataModel> dcrDataList = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      box = Boxes.selectedDcrGSP();
      addedDcrGSPList = box!.toMap().values.toList().cast<DcrGSPDataModel>();

      box = Boxes.dcrUsers();
      dcrDataList = box!.toMap().values.toList().cast<DcrDataModel>();

      setState(() {});
    });
    super.initState();
  }

  Future<void> deletedoctor(DcrDataModel dcrDataModel) async {
    dcrDataModel.delete();
  }

  deletDcrGSPitem(int id) {
    final box = Hive.box<DcrGSPDataModel>("selectedDcrGSP");
    final Map<dynamic, DcrGSPDataModel> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.uiqueKey == id) desiredKey = key;
    });
    box.delete(desiredKey);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text('draft_dcr'.tr()), centerTitle: true),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: Boxes.dcrUsers().listenable(),
          builder: (BuildContext context, Box box, Widget? child) {
            final orderCustomers = box.values.toList().cast<DcrDataModel>();
            return genContent(orderCustomers);
          },
        ),
      ),
    );
  }
  Widget genContent(List<DcrDataModel> user) {
    if (user.isEmpty) {
      return const Center(
        child: Text(
          "No Data Found",
          style: TextStyle(fontSize: 20),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: user.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {},
            child: Card(
              color: Colors.white,
              child: ExpansionTile(
                textColor: Colors.black87,
                iconColor: kPrimaryColor,

                title: Text(
                  // "${user[index].docName} (${user[index].areaName}) ",//todo old
                  "${user[index].docName} (${user[index].areaId}) ",
                  maxLines: 2,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Text("${user[index].docId}  "),
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
                                  title:  Text("confirm".tr().tr()),
                                  content:  Text(
                                    "are_you_sure_you_want_to_delete_the_doctor".tr(),),
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
                                        final ckey = user[index].uiqueKey;
                                        deletedoctor(user[index]);

                                        deletDcrGSPitem(ckey);
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
                            final vititedwith = user[index].visitedWith;
                            final note = user[index].note;
                            final nonExcution = user[index].non_Excution;
                            final selectedDeliveryTime = user[index].shift;
                            debugPrint("Visited with $vititedwith");
                            debugPrint("Note $note");
                            debugPrint("Note $nonExcution");

                            final dcrKey = user[index].uiqueKey;

                            filteredOrder = [];
                            addedDcrGSPList
                                .where((item) => item.uiqueKey == dcrKey)
                                .forEach(
                            (item) {
                            final temp = DcrGSPDataModel(
                            uiqueKey: item.uiqueKey,
                            quantity: item.quantity,
                            giftName: item.giftName,
                            giftId: item.giftId,
                            giftType: item.giftType);
                            filteredOrder.add(temp);
                            },
                            );

                            Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (_) => DcrGiftSamplePpmPage(
                            ck: 'isCheck',
                            dcrKey: dcrKey,
                            uniqueId: dcrKey,
                            draftOrderItem: filteredOrder,
                            docName: user[index].docName,
                            docId: user[index].docId,
                            areaName: user[index].areaName,
                            areaId: user[index].areaId,
                            address: user[index].address,
                            dVisitedWith: vititedwith ?? "",
                            note: note ?? "",
                            nonExcution: nonExcution ?? "",
                            selectedDeliveryTime:
                            selectedDeliveryTime ?? "",
                            ),
                            ),
                            );

                            print(selectedDeliveryTime);}
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
                      //   onPressed: () {
                      //     showDialog(
                      //       context: context,
                      //       builder: (BuildContext context) {
                      //         return AlertDialog(
                      //           title:  Text("confirm".tr().tr()),
                      //           content:  Text(
                      //               "are_you_sure_you_want_to_delete_the_doctor".tr(),),
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
                      //                 final ckey = user[index].uiqueKey;
                      //                 deletedoctor(user[index]);
                      //
                      //                 deletDcrGSPitem(ckey);
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
                      //   label:  Text(
                      //     "delete".tr(),
                      //     style: TextStyle(color: Colors.red),
                      //   ),
                      // ),
                      // TextButton.icon(
                      //   onPressed: () {
                      //     final vititedwith = user[index].visitedWith;
                      //     final note = user[index].note;
                      //     final nonExcution = user[index].non_Excution;
                      //     final selectedDeliveryTime = user[index].shift;
                      //     debugPrint("Visited with $vititedwith");
                      //     debugPrint("Note $note");
                      //     debugPrint("Note $nonExcution");
                      //
                      //     final dcrKey = user[index].uiqueKey;
                      //
                      //     filteredOrder = [];
                      //     addedDcrGSPList
                      //         .where((item) => item.uiqueKey == dcrKey)
                      //         .forEach(
                      //       (item) {
                      //         final temp = DcrGSPDataModel(
                      //             uiqueKey: item.uiqueKey,
                      //             quantity: item.quantity,
                      //             giftName: item.giftName,
                      //             giftId: item.giftId,
                      //             giftType: item.giftType);
                      //         filteredOrder.add(temp);
                      //       },
                      //     );
                      //
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (_) => DcrGiftSamplePpmPage(
                      //           ck: 'isCheck',
                      //           dcrKey: dcrKey,
                      //           uniqueId: dcrKey,
                      //           draftOrderItem: filteredOrder,
                      //           docName: user[index].docName,
                      //           docId: user[index].docId,
                      //           areaName: user[index].areaName,
                      //           areaId: user[index].areaId,
                      //           address: user[index].address,
                      //           dVisitedWith: vititedwith ?? "",
                      //           note: note ?? "",
                      //           nonExcution: nonExcution ?? "",
                      //           selectedDeliveryTime:
                      //               selectedDeliveryTime ?? "",
                      //         ),
                      //       ),
                      //     );
                      //
                      //     print(selectedDeliveryTime);
                      //   },
                      //   icon: const Icon(
                      //     Icons.arrow_forward_outlined,
                      //     color: Colors.blue,
                      //   ),
                      //   label:  Text(
                      //     "details".tr(),
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
}
