import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:mrap_v03/Pages/loginPage.dart';
import 'package:mrap_v03/service/apiCall.dart';
import 'package:flutter/material.dart';

class DcrAndOrderHive {
  Box box = Hive.box('mpoForClaient');

  dcrandOrder(contexts) async {
    var data = await getClaintandDoctot();
    List client = [];
    List doctor = [];
    if (data["status"] == "Success") {
      await mydatabox.put('isClientForMPOSync', true);
      await mydatabox.put('isDoctorForMPOSync', true);

      client = data["client"];
      doctor = data["doctor"];

      debugPrint("Claint Data $client");
      debugPrint("Doctor data$doctor");
      await putClientForMpo(client);
      await putDcrForMpo(doctor);

      Timer(const Duration(seconds: 5), () => Navigator.pop(contexts));

      return buildShowDialog(contexts);
    } else {
      print("Errror");
    }
  }

  putClientForMpo(client) async {
    //Box box= Hive.box('mpoForClaient');
    await box.clear();
    for (var d in client) {
      box.add(d);
    }
    debugPrint("boxCient${box.values}");
  }

  putDcrForMpo(doctor) async {
    Box box = Hive.box('mpoForDoctor');
    await box.clear();
    for (var d in doctor) {
      box.add(d);
      debugPrint("ADDD------------$d");
    }
    debugPrint("boxDoctor${box.values}");
    print("------------------------------------------000000");

    print(box.values.toString());
  }

  buildShowDialog(BuildContext context) {
    return showDialog(
        barrierColor: Colors.black,
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
              DefaultTextStyle(
                style: TextStyle(color: Colors.white, fontSize: 18),
                child: Text('DCR & Client synchronizing... '),
              )
            ],
          );
        });
  }
}
