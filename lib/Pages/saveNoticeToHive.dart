// import 'dart:convert';
//
// import 'package:hive/hive.dart';
// import 'package:mrap_v03/local_storage/boxes.dart';
//
// import '../local_storage/hive_data_model.dart';
//
// void saveNoticeListToHive(String jsonData) {
//   final List<Map<String, dynamic>> noticeList = json.decode(jsonData);
//
//   final noticeBox = Boxes.getNoticeList();
//
//   for (final noticeMap in noticeList) {
//     final noticeModel = NoticeListModel(
//       notice_date: noticeMap['notice_date'],
//       notice: noticeMap['notice'],
//       notice_pdf_url: noticeMap['notice_pdf_url'],
//     );
//     noticeBox.add(noticeModel);
//   }
// }