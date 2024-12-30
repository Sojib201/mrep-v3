// ignore_for_file: non_constant_identifier_names, prefer_const_literals_to_create_immutables, deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mrap_v03/Pages/DCR_section/dcr_gift_sample_PPM_page.dart';
import 'package:mrap_v03/Pages/DCR_section/doctor_add_page.dart';
import 'package:mrap_v03/Pages/DCR_section/microunion_add_page.dart';

import 'package:mrap_v03/Widgets/customerListWidget.dart';
import 'package:mrap_v03/core/utils/app_colors.dart';
import 'package:mrap_v03/core/utils/app_text_style.dart';
import 'package:mrap_v03/local_storage/boxes.dart';

import 'doctor_edit_page.dart';

// ignore: must_be_immutable
class DcrListPage extends StatefulWidget {
  List dcrDataList;
  String? areaId;
  String? areaName;

  DcrListPage({
    Key? key,
    required this.dcrDataList,
    this.areaId,
    this.areaName,
  }) : super(key: key);

  @override
  State<DcrListPage> createState() => _DcrListPageState();
}

class _DcrListPageState extends State<DcrListPage> {
  Box? box;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  // String doctor_url = '';
  // String microunion_url = '';
  String cid = '';
  String userId = '';
  String userPassword = '';
  bool docFlag = false;
  // String doctor_url_edit = "";
  bool doctorEdit = false;

  final TextEditingController searchController = TextEditingController();
  List foundUsers = [];
  int _counter = 0;
  final mydata = Boxes.allData();
  String? logo_url_1;
  String? logo_url_2;

  @override
  void initState() {
    // SharedPreferences.getInstance().then((prefs) {
    setState(() {
      cid = mydata.get("CID")!;
      userId = mydata.get("USER_ID")!;
      userPassword = mydata.get("PASSWORD")!;
      // doctor_url = mydata.get("doctor_url")!;
      // microunion_url = mydata.get("microunion_url")!;
      docFlag = mydata.get("doc_flag") ?? false;
      doctorEdit = mydata.get('doc_edit_flag') ?? false;
      logo_url_1 = mydata.get('logo_url_1') ?? null;
      logo_url_2 = mydata.get('logo_url_2') ?? null;
      // doctor_url_edit = mydata.get("doctor_edit_url")!;
    });
    // debugPrint('$doctor_url?cid=$cid&rep_id=$userId&rep_pass=$userPassword');
    if (mydata.get("_dcrcounter") != null) {
      int? a = mydata.get("_dcrcounter");

      setState(() {
        _counter = a!;
      });
    }
    // });
    foundUsers = widget.dcrDataList;
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });

    mydata.put('_dcrcounter', _counter);

    setState(() {});
  }

  void runFilter(String enteredKeyword) {
    foundUsers = widget.dcrDataList;
    List results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = foundUsers;
      // debugPrint(results);
    } else {
      var starts = foundUsers
          .where((s) => s['doc_name']
              .toLowerCase()
              .startsWith(enteredKeyword.toLowerCase()))
          .toList();

      var contains = foundUsers
          .where((s) =>
              s['doc_name']
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              s['doc_id']
                  .toLowerCase()
                  .startsWith(enteredKeyword.toLowerCase()))
          .toList()
        ..sort((a, b) =>
            a['doc_name'].toLowerCase().compareTo(b['doc_name'].toLowerCase()));

      results = [...starts, ...contains];
    }

    // Refresh the UI
    setState(() {
      foundUsers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // backgroundColor: const Color.fromARGB(255, 138, 201, 149),
        // flexibleSpace: Container(
        //   decoration: const BoxDecoration(
        //     // LinearGradient
        //     gradient: LinearGradient(
        //       // colors for gradient
        //       colors: [
        //         Color(0xff70BA85),
        //         Color(0xff56CCF2),
        //       ],
        //     ),
        //   ),
        // ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title:  Text('doctor_list'.tr()),
        // titleTextStyle: const TextStyle(
        //     color: Color.fromARGB(255, 27, 56, 34),
        //     fontWeight: FontWeight.w500,
        //     fontSize: 20),
        centerTitle: true,
      ),
      endDrawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                  color: kPrimaryColor),
              child: Column(
                children: [
                  logo_url_2 != null ?  CachedNetworkImage(
                    height: screenHeight*.15,
                    imageUrl: logo_url_2!,
                    errorWidget: (context, url, error) => Image.asset("assets/images/mRep7_logo.png",color: Colors.white,),
                  )
                      : Image.asset("assets/images/mRep7_logo.png",color: Colors.white,),
                  // Image.asset('assets/images/mRep7_logo.png'),
                  // Expanded(
                  //   child: Text(
                  //     '${widget.clientName}',
                  //     // 'Chemist: ADEE MEDICINE CORNER(6777724244)',
                  //     style: const TextStyle(
                  //         color: Colors.white,
                  //         fontSize: 18,
                  //         fontWeight: FontWeight.bold),
                  //   ),
                  // ),
                  // Expanded(
                  //     child: Text(
                  //   widget.clientId,
                  //   style: const TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 15,
                  //       fontWeight: FontWeight.bold),
                  // ))
                ],
              ),
            ),
            docFlag
                ? ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            DoctorAddPage(areaId: widget.areaId.toString()),
                      ));
                    },
                    leading:
                        const Icon(Icons.person_add, color: kAccentColor),
                    title:  Text(
                      'doctor'.tr(),
                      style:kNavItemTextStyle,
                    ),
                  )
                : Container(),
            docFlag
                ? ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            MicrounionAddPage(areaId: widget.areaId.toString()),
                      ));
                    },
                    //  (){
                    //   Navigator.push(context, MaterialPageRoute(builder: (context)=>TerritoryPage(baseurl:   '$microunion_url?cid=$cid&rep_id=$userId&rep_pass=$userPassword', roat: "route_id",)));

                    // },
                    leading: const Icon(Icons.medical_information,
                        color: kAccentColor),
                    title:  Text(
                      'pocket_market'.tr(),
                      style: kNavItemTextStyle,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (value) => runFilter(value),
                controller: searchController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  labelText: 'search'.tr(),
                  suffixIcon: searchController.text.isEmpty &&
                          searchController.text == ''
                      ? const Icon(Icons.search)
                      : IconButton(
                          onPressed: () {
                            searchController.clear();
                            runFilter('');
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.black,
                            // size: 28,
                          ),
                        ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.areaName.toString()} | ${widget.areaId.toString().toUpperCase()}",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w800,
                    color: kSecondaryColor,
                  ),
                ),
                Divider(
                  thickness: 1.0,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 9,
            child: foundUsers.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: searchController.text.isNotEmpty
                        ? foundUsers.length
                        : widget.dcrDataList.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext itemBuilder, index) {
                      return Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          side:
                              const BorderSide(color: Colors.white70, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            doctorEdit == true
                                ? InkWell(
                                    onTap: () async {
                                      // var url =
                                      //     '$doctor_url_edit?cid=$cid&rep_id=$userId&rep_pass=$userPassword&doc_id=${foundUsers[index]['doc_id'].toString()}';
                                      // debugPrint(url);
                                      // if (await canLaunch(url)) {
                                      //   await launch(url);
                                      // } else {
                                      //   throw 'Could not launch $url';
                                      // }

                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => DoctorEditPage(
                                            docId:
                                                "${foundUsers[index]['doc_id'].toString()}",
                                          ),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Icon(Icons.edit),
                                    ),
                                  )
                                : SizedBox(),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  _incrementCounter();

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DcrGiftSamplePpmPage(
                                        ck: '',
                                        dcrKey: 0,
                                        uniqueId: _counter,
                                        draftOrderItem: [],
                                        docName: foundUsers[index]['doc_name'],
                                        docId: foundUsers[index]['doc_id'],
                                        areaName: widget.areaName.toString(),
                                        // foundUsers[index]//todo Old
                                        //     ['area_name'],
                                        areaId: widget.areaId.toString(),
                                        //  foundUsers[index]['area_id'],//todo old
                                        address: "",
                                        //  foundUsers[index]['address'],//todo old
                                        note: '',
                                        dVisitedWith: "",
                                        nonExcution: "",
                                        selectedDeliveryTime: "",
                                      ),
                                    ),
                                  );
                                },
                                child: CustomerListCardWidget(
                                    clientName: foundUsers[index]['doc_name'] +
                                        '(${foundUsers[index]['doc_id']})',
                                    base:
                                        //  foundUsers[index]['area_name'] +
                                        //     '(${foundUsers[index]['area_id']})',//todo Old
                                        "",
                                    marketName:
                                        //  foundUsers[index]['address'], //todo Old
                                        "",
                                    outstanding: ''),
                              ),
                            ),
                          ],
                        ),
                      );
                    })
                : const Text(
                    'No results found',
                    style: TextStyle(fontSize: 24),
                  ),
          ),
        ],
      ),
    );
  }
}
