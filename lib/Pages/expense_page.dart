// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mrap_v03/local_storage/boxes.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({Key? key}) : super(key: key);

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  TextEditingController dateController = TextEditingController();
  TextEditingController workLocController = TextEditingController();
  TextEditingController expensetypeController = TextEditingController();
  TextEditingController fromAddressController = TextEditingController();
  TextEditingController toAddressController = TextEditingController();
  TextEditingController distanceController = TextEditingController();
  TextEditingController vehicleTypeController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  String? userPass;
  String? userId;
  String? cid;
  String? sync_url;
  bool exp_approval_flag = false;

  bool _isLoading = true;
  var status;

  DateTime dateTime = DateTime.now();

  final _formKey = GlobalKey<FormState>();
  final databox = Boxes.allData();

  @override
  void initState() {
    userPass = databox.get("PASSWORD");
    cid = databox.get("CID");
    userId = databox.get("USER_ID");
    sync_url = databox.get("sync_url")!;
    exp_approval_flag = databox.get("exp_approval_flag")!;

    debugPrint("Expance Flage:$exp_approval_flag");
    // debugPrint("${userPass},${cid},${userId}");

    super.initState();
  }

  @override
  void dispose() {
    dateController.dispose();
    workLocController.dispose();
    expensetypeController.dispose();
    fromAddressController.dispose();
    toAddressController.dispose();
    distanceController.dispose();
    vehicleTypeController.dispose();
    amountController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Scaffold(
            backgroundColor: const Color(0xFFDDEBF7),
            appBar: AppBar(
              title: Text("expense".tr()),
              centerTitle: true,
            ),
            body: SizedBox(
              // width: MediaQuery.of(context).size.width * 0.8,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: TextFormField(
                                controller: dateController,
                                onTap: () async {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  final date = await pickDate();
                                  if (date == null) {
                                    return;
                                  } else {
                                    setState(
                                      () {
                                        dateTime = date;
                                      },
                                    );
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText:
                                      "${dateTime.year}-${dateTime.month}-${dateTime.day}",
                                  labelStyle:
                                      const TextStyle(color: Colors.black),
                                  border: const OutlineInputBorder(),
                                  suffixIcon: const Icon(Icons.calendar_today,
                                      color: Colors.teal),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: TextFormField(
                                controller: workLocController,
                                autofocus: false,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'please_provide_your_work_location'
                                        .tr();
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    labelText: 'Work Location',
                                    labelStyle: TextStyle(color: Colors.black),
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: TextFormField(
                                controller: expensetypeController,
                                autofocus: false,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'please_provide_expense_type'.tr();
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    labelText: 'Expense Type',
                                    labelStyle: TextStyle(color: Colors.black),
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: TextFormField(
                                controller: fromAddressController,
                                autofocus: false,
                                keyboardType: TextInputType.streetAddress,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Provide Your Starting Street Address';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    labelText: 'From Address',
                                    labelStyle: TextStyle(color: Colors.black),
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: TextFormField(
                                controller: toAddressController,
                                autofocus: false,
                                keyboardType: TextInputType.streetAddress,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Provide Your Ending Address';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    labelText: 'To Address',
                                    labelStyle: TextStyle(color: Colors.black),
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: TextFormField(
                                controller: distanceController,
                                autofocus: false,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Provide Distance ';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    labelText: 'Distance(Km)',
                                    labelStyle: TextStyle(color: Colors.black),
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: TextFormField(
                                controller: vehicleTypeController,
                                autofocus: false,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Provide Vehicle Type ';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    labelText: 'Vehicle Type',
                                    labelStyle: TextStyle(color: Colors.black),
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: TextFormField(
                                controller: amountController,
                                autofocus: false,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Provide Amount';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    labelText: 'Amount',
                                    labelStyle: TextStyle(color: Colors.black),
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  height:
                                      MediaQuery.of(context).size.height * 0.07,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.teal,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        // orderSubmit();
                                        var status = await ExpenseAPI();
                                        // debugPrint(_status);
                                        if (status == "Success") {
                                          dateController.clear();
                                          workLocController.clear();
                                          expensetypeController.clear();
                                          fromAddressController.clear();
                                          toAddressController.clear();
                                          distanceController.clear();
                                          vehicleTypeController.clear();
                                          amountController.clear();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      'Expense Submitted')));

                                          setState(() {
                                            _isLoading = true;
                                          });
                                        }
                                      }
                                    },
                                    child: const Text(
                                      "Submit",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ),
          )
        : Container(
            padding: const EdgeInsets.all(50),
            color: Colors.white,
            child: const Center(child: CircularProgressIndicator()));
  }

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1990),
        lastDate: DateTime(2060),
        builder: (context, child) {
          return Theme(
            data: ThemeData(
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFFE2EFDA),
                surface: Colors.teal,
              ),
              dialogBackgroundColor: Colors.blueGrey,
            ), // This will change to light theme.
            child: child!,
          );
        },
      );

  Future ExpenseAPI() async {
    final response = await http.post(
      Uri.parse(
          // 'w05.yeapps.com/acme_api/api_expense_submit/submit_data'
          '$sync_url'
          "api_expense_submit/submit_data"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "cid": cid!,
        "user_id": userId!,
        "user_pass": userPass!,
        "exp_date": dateTime.toString(),
        "work_location": workLocController.text,
        "exp_type": expensetypeController.text,
        "addr_from": fromAddressController.text,
        "addr_to": toAddressController.text,
        "distance_km": distanceController.text,
        "vehicle_type": vehicleTypeController.text,
        "exp_amt": amountController.text,
      }),
    );
    var data = json.decode(response.body);
    status = data["status"];
    if (status == "Success") {
      setState(() {
        _isLoading = true;
      });
    } else {
      setState(() {
        _isLoading = true;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Submit Failed')));
    }
    return "Null";
  }

  buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(
                height: 10,
              ),
            ],
          );
        });
  }
}

class TextForm extends StatelessWidget {
  final suffixIcon;
  final String labelText;
  final onTap;
  final TextEditingController? controller;
  const TextForm(
      {Key? key,
      required this.labelText,
      this.onTap,
      this.suffixIcon,
      this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          labelText: labelText,
          filled: true,
          fillColor: const Color(0xFFE2EFDA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          labelStyle: const TextStyle(color: Colors.black, fontSize: 20),
        ),
        onTap: onTap,
      ),
    );
  }
}
