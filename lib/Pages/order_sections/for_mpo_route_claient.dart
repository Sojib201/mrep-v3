import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mrap_v03/core/utils/app_colors.dart';
import 'package:mrap_v03/core/utils/image_constant.dart';

import '../../screens.dart';

class ClaientRoutePage extends StatefulWidget {
  const ClaientRoutePage({Key? key}) : super(key: key);

  @override
  State<ClaientRoutePage> createState() => _ClaientRoutePageState();
}

class _ClaientRoutePageState extends State<ClaientRoutePage> {
  List clientdata = [];
  List clientlist = [];
  bool isClientForMPOSync = false;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    print("*******client ${Hive.box("mpoForClaient").values.toList()}");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        clientdata = Hive.box("mpoForClaient").values.toList();
        isClientForMPOSync = mydatabox.get('isClientForMPOSync') ?? false;

        if (isClientForMPOSync == false) {
          Fluttertoast.showToast(
              msg: 'Please Sync Customer',
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      });
      searchAreaList('');
    });
  }

  List filterAreaList = [];
  searchAreaList(String search) async {
    if (search.isEmpty) {
      filterAreaList = clientdata;
    } else {
      filterAreaList = clientdata
          .where((element) =>
              element['route'].toString().toLowerCase().contains(search))
          .toList();
    }
    setState(() {});
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:  Text("territory".tr()),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                // onChanged: (value) => runFilter(value),
                controller: searchController
                  ..addListener(() {
                    searchAreaList(searchController.text.toLowerCase());
                    setState(() {});
                  }),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  labelText: 'search'.tr(),
                  suffixIcon: searchController.text.isEmpty &&
                          searchController.text == ''
                      ? const Icon(Icons.search)
                      : IconButton(
                          onPressed: () {
                            searchController.clear();
                            // runFilter('');
                            setState(() {});
                          },
                          icon: const Icon(Icons.clear)),
                ),
              ),
            ),
            Expanded(
                child: filterAreaList.isEmpty
                    ? Center(
                        child: Text(
                          "No Data found",
                          style: TextStyle(fontSize: 24),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filterAreaList.length,
                        itemBuilder: (context, index) {
                          print("HHHHHHHLIst$clientlist");
                          var area = filterAreaList[index];
                          return InkWell(
                            onTap: () async {
                              clientlist = area["clientlist"];
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CustomerListScreen(
                                    data: clientlist,
                                    // terrorId: area["route"],
                                    terrorId: area["route"]
                                            .toString()
                                            .contains('|')
                                        ? area["route"].toString().split('|')[1]
                                        : area["route"],
                                    terrorName: area["route"]
                                            .toString()
                                            .contains('|')
                                        ? area["route"].toString().split('|')[0]
                                        : area["route"],
                                  ),
                                ),
                              );
                              setState(() {});
                            },
                            child: Card(
                              elevation: 10,
                              margin: EdgeInsets.fromLTRB(08.0, 0.0, 8.0, 10),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading:
                                  Image.asset(ImageConstant.districtImage),
                                  title: Text(
                                    area["route"],
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  trailing: const Icon(
                                      Icons.arrow_forward_ios_rounded,color: kSecondaryColor,),
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
