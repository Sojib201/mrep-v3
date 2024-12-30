import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:mrap_v03/Pages/DCR_section/dcr_list_page.dart';

import '../../screens.dart';

class DoctorTerritoryPage extends StatefulWidget {
  const DoctorTerritoryPage({Key? key}) : super(key: key);

  @override
  State<DoctorTerritoryPage> createState() => _DoctorTerritoryPageState();
}

class _DoctorTerritoryPageState extends State<DoctorTerritoryPage> {
  List doctorData = [];
  List doctorList = [];
  bool isDoctorForMPOSync = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Box box = Hive.box('mpoForDoctor');
      print('5555555555555555555555555');
      print(box.get(0));
      // print("Doctor =========${Hive.box("mpoForDoctor").toMap().values.toList()}");
      setState(() {
        doctorData = Hive.box("mpoForDoctor").values.toList();

        isDoctorForMPOSync = mydatabox.get('isDoctorForMPOSync') ?? false;

        if (isDoctorForMPOSync == false) {
          Fluttertoast.showToast(
              msg: 'Please Sync Doctor',
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      });
      print("*******doctor   $doctorData");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:  Text("territory".tr(),)
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
                child: ListView.builder(
                    itemCount: doctorData.length,
                    itemBuilder: (context, index) {
                      print("HHHHHHHLIst$doctorList");
                      return InkWell(
                        onTap: () async {
                          doctorList = doctorData[index]["doctorlist"];
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DcrListPage(
                                dcrDataList: doctorList,
                                // areaId: doctorData[index]["route"],
                                areaId: doctorData[index]["route"]
                                        .toString()
                                        .contains('|')
                                    ? doctorData[index]["route"]
                                        .toString()
                                        .split('|')[1]
                                    : doctorData[index]["route"],
                                areaName: doctorData[index]["route"]
                                        .toString()
                                        .contains('|')
                                    ? doctorData[index]["route"]
                                        .toString()
                                        .split('|')[0]
                                    : doctorData[index]["route"],
                              ),
                            ),
                          );
                          setState(() {});
                        },
                        child: Card(
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading:   Image.asset("assets/icons/district.png",),
                              title: Text(
                                doctorData[index]["route"],
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios_outlined),
                            ),
                          ),
                        ),
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
