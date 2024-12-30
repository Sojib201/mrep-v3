// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:mrap_v03/Pages/Expense/expense_entry_v2.dart';
import 'package:mrap_v03/Pages/Expense/expense_section.dart';

import '../../core/utils/app_colors.dart';

// ignore: must_be_immutable
class ExpenseDraft extends StatefulWidget {
  const ExpenseDraft({Key? key}) : super(key: key);

  @override
  State<ExpenseDraft> createState() => _ExpenseDraftState();
}

class _ExpenseDraftState extends State<ExpenseDraft> {
  Box box = Hive.box("draftForExpense");

  @override
  Widget build(BuildContext context) {
    debugPrint(box.keys.toString());
    return Scaffold(
        appBar: AppBar(
          title:  Text("draft".tr()),

          // leading: IconButton(
          //     onPressed: () {
          //       Navigator.pushAndRemoveUntil(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => const ExpensePage()),
          //           (route) => false);
          //     },
          //     icon: const Icon(Icons.arrow_back_sharp)),
          centerTitle: true,
          // automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Expanded(
              child: box.isNotEmpty
                  ? ListView.builder(
                      itemCount: box.keys.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ExpansionTile(
                            textColor: Colors.black87,
                              iconColor: kSecondaryColor,
                              title: Text(box.keys.toList()[index].toString()),
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(

                                      child: InkWell(
                                        onTap: (){
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title:  Text("confirm".tr()),
                                                content: const Text(
                                                    "Are you sure you want to Delete Expanse?"),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      // User clicked No, so close the dialog
                                                      Navigator.of(context)
                                                          .pop(false);
                                                    },
                                                    child:  Text("no".tr()),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      box.delete(box.keys
                                                          .toList()[index]);
                                                      setState(() {});
                                                      // User clicked Yes, so close the dialog and return true
                                                      Navigator.of(context)
                                                          .pop(true);
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
                                          // newList = await expenseEntry();

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => ExpenseEntry(
                                                draftDate: box.keys
                                                    .toList()[index]
                                                    .toString()
                                                    .split(' ')[0],
                                                draftExpenseCategory: box.keys
                                                    .toList()[index]
                                                    .toString()
                                                    .split(' ')[1],
                                                // draftDate: box.keys
                                                //     .toList()[index]
                                                //     .toString(),
                                              ),
                                            ),
                                          );
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
                                    //           title:  Text("confirm".tr()),
                                    //           content: const Text(
                                    //               "Are you sure you want to Delete Expanse?"),
                                    //           actions: [
                                    //             TextButton(
                                    //               onPressed: () {
                                    //                 // User clicked No, so close the dialog
                                    //                 Navigator.of(context)
                                    //                     .pop(false);
                                    //               },
                                    //               child:  Text("no".tr()),
                                    //             ),
                                    //             TextButton(
                                    //               onPressed: () {
                                    //                 box.delete(box.keys
                                    //                     .toList()[index]);
                                    //                 setState(() {});
                                    //                 // User clicked Yes, so close the dialog and return true
                                    //                 Navigator.of(context)
                                    //                     .pop(true);
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
                                    //   onPressed: () async {
                                    //     // newList = await expenseEntry();
                                    //
                                    //     Navigator.push(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //         builder: (_) => ExpenseEntry(
                                    //           draftDate: box.keys
                                    //               .toList()[index]
                                    //               .toString()
                                    //               .split(' ')[0],
                                    //           draftExpenseCategory: box.keys
                                    //               .toList()[index]
                                    //               .toString()
                                    //               .split(' ')[1],
                                    //           // draftDate: box.keys
                                    //           //     .toList()[index]
                                    //           //     .toString(),
                                    //         ),
                                    //       ),
                                    //     );
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
                                )
                              ]),
                        );
                      })
                  : const Center(
                      child: Text(
                        "No Data Found",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
            )
          ],
        ));
  }
}
