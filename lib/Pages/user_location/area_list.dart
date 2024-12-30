import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/utils/app_colors.dart';
import '../../models/employee_list_model.dart';
import '../../service/apiCall.dart';
import 'nearby_colleague.dart';

class AreaListScreen extends StatefulWidget {
  final List<String> areaList;
  const AreaListScreen({super.key, required this.areaList});

  @override
  State<AreaListScreen> createState() => _AreaListScreenState();
}

class _AreaListScreenState extends State<AreaListScreen> {
  TextEditingController searchByNameTE = TextEditingController();
  bool isSearching = false;
  List<String> finalList = [];
  // List<Employee> searchList=[];
  List<String> searchList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('area_list'.tr()),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              child: TextField(
                controller: searchByNameTE,
                // onSubmitted: (value) {
                //   //  FirebaseAPIs.addChatUser(value.toString());
                // },
                onChanged: (value) {
                  if (value == "") {
                    isSearching = false;
                  } else {
                    isSearching = true;
                    searchList.clear();
                    for (var i in widget.areaList) {
                      if (i.toLowerCase().contains(value.toLowerCase()) ||
                          i.toLowerCase().contains(value.toLowerCase())) {
                        searchList.add(i);
                      }
                    }
                  }
                  setState(() {});
                },
                decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.search_rounded,
                      color: Colors.green,
                    ),
                    fillColor: Colors.white70,
                    filled: true,
                    hintText: "Search By Area ID",
                    hintStyle:
                        TextStyle(fontSize: 14, color: Colors.grey.shade500),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(6),
                    )),
              ),
            ),
            Expanded(
                child: ListView.builder(
              itemCount:
                  isSearching ? searchList.length : widget.areaList.length,
              itemBuilder: (context, index) {
                if (isSearching) {
                  finalList = searchList;
                } else {
                  finalList = widget.areaList;
                }
                return Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                    height: 70,
                    child: Center(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: kPrimaryColor,
                          child:
                              Icon(Icons.pin_drop_sharp, color: Colors.white),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios,color: kSecondaryColor,),
                        title: Text(
                          finalList[index] ?? 'Unknown',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        // trailing: Icon(Icons.more_vert),
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NearbyColleague(
                                  areaId: finalList[0],
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

                          // Navigator.push(context,MaterialPageRoute(builder: (context) {
                          //   return
                          //     OpenStreetMapScreen(latitude: double.parse(employeeData[index]['employee_lat'].toString()),
                          //       longitude: double.parse(employeeData[index]['employee_lon'].toString()),);
                          // },));
                          // Handle on tap if needed
                        },
                      ),
                    ),
                  ),
                );
              },
            )),

            // Expanded(
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: FutureBuilder(
            //       future: GetEmployeeList(),
            //       builder: (context, snapshot) {
            //         if(snapshot.hasData)
            //         {
            //           employeeList.clear();
            //           employeeList =snapshot.data!;
            //
            //           List<Employee> finalList = isSearching?searchList:employeeList;
            //
            //           return
            //         }
            //         if(snapshot.connectionState==ConnectionState.waiting)
            //         {
            //           return Center(child: CircularProgressIndicator(),);
            //         }
            //         else
            //         {
            //           return Text("No data available");
            //         }
            //
            //       },
            //
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
