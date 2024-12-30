

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mrap_v03/core/utils/app_colors.dart';
import 'package:mrap_v03/models/employee_list_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../service/apiCall.dart';
import 'demoList.dart';


class NearbyColleague extends StatefulWidget {
 final String areaId;
  const NearbyColleague({super.key, required this.areaId});

  @override
  State<NearbyColleague> createState() => _NearbyColleagueState();
}

class _NearbyColleagueState extends State<NearbyColleague> {
  TextEditingController searchByNameTE = TextEditingController();
  bool isSearching=false;
  List<Employee> employeeList=[];
  List<Employee> searchList=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('my_colleagues'.tr()),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 8,
              left: 8,
              right: 8,

            ),
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
                  for (var i in employeeList) {
                    if (i.repId.toLowerCase().contains(value.toLowerCase()) || i.repName.toLowerCase().contains(value.toLowerCase())) {
                      searchList.add(i);
                    }
                  }
                }
                setState(() {

                });

              },
              decoration:
              InputDecoration(
                  suffixIcon: Icon(Icons.search_rounded,color: Colors.green,),
                  fillColor:Colors.white70,
                  filled: true,
                  hintText: "Search By Name | User ID",
                  hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500),
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder(
                future: GetEmployeeList(widget.areaId),
                builder: (context, snapshot) {
                  if(snapshot.hasData)
                    {
                      employeeList.clear();
                      employeeList =snapshot.data!;

                      List<Employee> finalList = isSearching?searchList:employeeList;
            
                      return ListView.builder(
                        itemCount: finalList.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: kPrimaryColor,
                                child: Icon(Icons.person, color: Colors.white),
                              ),
                              title: Text(
                                finalList[index].repName ?? 'Unknown',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              subtitle: Text(
                                'ID: ${finalList[index].repId}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              trailing: Icon(Icons.arrow_forward_ios,color: kSecondaryColor,),
                              // trailing: Icon(Icons.more_vert),
                              onTap: () async {
            
                                Map<String,dynamic> selectedEmployeeAddress = await GetEmployeeAddress(finalList[index].repId.toString());
                                if(selectedEmployeeAddress.isNotEmpty)
                                  {
                                    print("Called ***************");
                                    if (selectedEmployeeAddress['lat']!= "" && selectedEmployeeAddress['long'] != "") {
                                      final String url = "https://www.google.com/maps/search/?api=1&query=${selectedEmployeeAddress['lat']},${selectedEmployeeAddress['long']}";
                                      launchUrl(Uri.parse(url));
                                    }
                                  else  {
                                      Fluttertoast.showToast(msg: "Address not found",backgroundColor: kErrorColor);
                                    }
            
                                  }
                                else
                                  {
                                    Fluttertoast.showToast(msg: "Address not found",backgroundColor: kErrorColor);
            
                                  }
            
            
            
                                // Navigator.push(context,MaterialPageRoute(builder: (context) {
                                //   return
                                //     OpenStreetMapScreen(latitude: double.parse(employeeData[index]['employee_lat'].toString()),
                                //       longitude: double.parse(employeeData[index]['employee_lon'].toString()),);
                                // },));
                                // Handle on tap if needed
                              },
                            ),
                          );
                        },
                      );
                    }
                  if(snapshot.connectionState==ConnectionState.waiting)
                    {
                      return Center(child: CircularProgressIndicator(),);
                    }
                  else
                    {
                     return Text("No data available");
                    }
            
                },
            
              ),
            ),
          ),
        ],
      ),
    );
  }
}

