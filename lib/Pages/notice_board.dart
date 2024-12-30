import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mrap_v03/Pages/notice_board_pdf.dart';
import 'package:mrap_v03/local_storage/boxes.dart';
import 'package:mrap_v03/service/apiCall.dart';

import '../local_storage/hive_data_model.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  // List noticelist = [];
  bool isloading=false;
  List<NoticeListModel> noticeList = [];
  @override
  void initState() {
    super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_){
      fetchNoticeList();
  });
  }

  void fetchNoticeList() {
    final noticeBox = Boxes.getNoticeList();
    setState(() {
      noticeList = noticeBox.values.toList();
    });
  }

  // getApi() async {
  // setState(() {
  //     isloading=true;
  // });
  //   noticelist = await noticeEvent();
  //   setState(() {
  //
  //   isloading=false;
  //   });
  //   debugPrint("list $noticelist");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("notice".tr()),
        centerTitle: true,
      ),
      body:isloading?const Center(child: CircularProgressIndicator(),):noticeList.isNotEmpty? Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: noticeList.length,
                itemBuilder: (context, index) {
                  print(noticeList[index].notice_pdf_url);
                  print(noticeList[index].notice);
                  print("fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff");
                  // noticeDate =noticelist[index]["notice_date"]
                  //     .replaceAll(" ", "\n\n");
                  var str = noticeList[index].notice_date;
                  var parts = str.split(' ');
                  var prefix = parts[0].trim();
                  var prefixTime = parts[1].trim();
                  var prefixSplit = prefix.split("-");
                  var lastPart = prefixSplit[2];
                  var secPart = prefixSplit[1];
                  var firstPart = prefixSplit[0];
                  debugPrint(prefixSplit[2]);

                  // prefix: "date"
                  // var date =
                  //     parts.sublist(1).join(':').trim(); // date: "'2019:04:01'"
                  return InkWell(
                    onTap: (){
                      noticeList[index].notice_pdf_url != "" ? Navigator.push(context, MaterialPageRoute(builder: (context)=>PdfViewerPage(url: noticeList[index].notice_pdf_url, notice: noticeList[index].notice,))) : null ;
                    },
                    child: Card(
                      elevation: 6,
                      child: Container(
                        color: const Color.fromARGB(255, 189, 247, 237),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(5, 8, 0, 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                // height: 60,
                                // width: 80,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color.fromARGB(255, 138, 201, 149),
                                      Color.fromARGB(255, 119, 199, 133),
                                      Color.fromARGB(255, 62, 201, 91),
                                    ],
                                    // colors: [
                                    //   Color.fromARGB(255, 189, 247, 237),
                                    //   Color.fromARGB(255, 212, 245, 190)
                                    // ],
                                  ),
                                  // shape: BoxShape.circle,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 8, 5, 8),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        lastPart,
                                        style: const TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            secPart,
                                            // + "," + firstPart
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            firstPart,
                                            // + "," + firstPart
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      prefixTime,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Divider(),
                                    Text(
                                      noticeList[index].notice,
                                      textAlign: TextAlign.justify,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          )
        ],
      ):const Center(child:  Text("No Data found"))
    );
  }
}
