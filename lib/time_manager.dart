// import 'dart:async';
//
// import 'package:hive/hive.dart';
// import 'package:mrap_v03/service/apiCall.dart';
//
// import 'local_storage/hive_data_model.dart';
//
// class TimerManager {
//   static final TimerManager _instance = TimerManager._internal();
//   Timer? _apiTimer;
//
//   factory TimerManager() {
//     return _instance;
//   }
//
//   TimerManager._internal();
//
//   void startTimer() {
//     if (_apiTimer == null || !_apiTimer!.isActive) {
//       _apiTimer = Timer.periodic(Duration(hours: 1), (timer) {
//         getApi();
//       });
//     }
//   }
//
//   Future<void> getApi() async {
//     List<Map<String, dynamic>> noticeList = await noticeEvent();
//
//     final noticeBox = Hive.box<NoticeListModel>('noticeList');
//     for (var noticeMap in noticeList) {
//       NoticeListModel noticeModel = NoticeListModel(
//         uiqueKey: noticeMap['uniqueKey'] ?? 0,
//         notice_date: noticeMap['notice_date'] ?? '',
//         notice: noticeMap['notice'] ?? '',
//         notice_pdf_url: noticeMap['notice_pdf_url'] ?? '',
//       );
//
//       // Add the NoticeModel object to the Hive box
//       await noticeBox.add(noticeModel);
//     }
//     fetchNoticeList();
//   }
//
//   void fetchNoticeList() {
//     print('entered to fetch');
//     final noticeBox = Hive.box<NoticeListModel>('noticeList');
//     print('noticebox called');
//
//     print('noticelist j$noticeList');
//     convertToString();
//     noticeList = noticeBox.values.toList();
//     targetAmount = mydatabox.get('target_amount') ?? '0';
//     salesAmount = mydatabox.get('sales_amount') ?? '0';
//     achievementAmount = mydatabox.get('achievement_amount') ?? '0';
//     if(mounted){
//       setState(() {});
//     }
//   }
//   void convertToString() {
//     if (noticeList.length != 0){
//       // notice = "${noticeList[0].notice}";
//       // for (int i = 1; i < noticeList.length; i++) {
//       //   notice = notice + "      ||      " + noticeList[i].notice ;
//       // }
//       // Extract the "notice" values
//       List<String> notices = noticeList.map((item) => item.notice).toList();
//       print(notices);
//
//       // Join them into a single string separated by commas
//       notice = notices.join("      ■      ");
//     }
//     else {
//       notice = "";
//     }
//   }
//
//   void stopTimer() {
//     _apiTimer?.cancel();
//   }
// }
