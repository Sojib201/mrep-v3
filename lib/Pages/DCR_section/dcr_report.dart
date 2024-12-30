// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:mrap_v03/local_storage/boxes.dart';

// // ignore: must_be_immutable
// class DcrReportWebView extends StatefulWidget {
//   String report_url;
//   String cid;
//   String deviceId;
//   String userId;
//   String userPassword;
//   DcrReportWebView(
//       {Key? key,
//       required this.report_url,
//       required this.cid,
//       required this.deviceId,
//       required this.userId,
//       required this.userPassword})
//       : super(key: key);

//   @override
//   State<DcrReportWebView> createState() => _DcrReportWebViewState();
// }

// class _DcrReportWebViewState extends State<DcrReportWebView> {
//   double progress = 0;
//   String? deviceId = '';
//   final boxdata=Boxes.allData();

//   @override
//   void initState() {
//     // SharedPreferences.getInstance().then((prefs) {
//       deviceId = boxdata.get("deviceId");
//       // deviceBrand = prefs.getString("deviceBrand");
//       // deviceModel = prefs.getString("deviceModel");
//     // });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     debugPrint(widget.report_url +
//         "?cid=${widget.cid}&rep_id=${widget.userId}&rep_pass=${widget.userPassword}");
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Dcr Report'),
//           centerTitle: true,
//           leading: IconButton(
//             onPressed: () => Navigator.pop(context),
//             icon: const Icon(Icons.home),
//           ),
//         ),
//         body: Stack(
//           children: [
//             Align(
//               alignment: Alignment.center,
//               child: SafeArea(
//                 child: Center(
//                   child: InAppWebView(
//                     initialUrlRequest: URLRequest(
//                         url: Uri.parse(
//                             "http://www.google.com"

//                             // widget.report_url +
//                             //     "?cid=${widget.cid}&rep_id=${widget.userId}&password=${widget.userPassword}&device_id=${widget.deviceId}"
//                             )
//                             ),
//                     onReceivedServerTrustAuthRequest:
//                         (controller, challenge) async {
//                       // debugPrint(challenge);
//                       return ServerTrustAuthResponse(
//                           action: ServerTrustAuthResponseAction.PROCEED);
//                     },
//                     onProgressChanged:
//                         (InAppWebViewController controller, int progress) {
//                       setState(() {
//                         this.progress = progress / 100;
//                       });
//                     },
//                   ),
//                 ),
//               ),
//             ),
//             Align(alignment: Alignment.topCenter, child: _buildProgressBar()),
//           ],
//         ));
//   }

//   Widget _buildProgressBar() {
//     if (progress != 1.0) {
//       // return CircularProgressIndicator();
// // You can use LinearProgressIndicator also
//       return LinearProgressIndicator(
//         value: progress,
//         valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
//         backgroundColor: Colors.blue,
//         minHeight: 7,
//       );
//     }
//     return Container();
//   }
// }

// ignore_for_file: non_constant_identifier_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mrap_v03/local_storage/boxes.dart';

// ignore: must_be_immutable
class DcrReportWebView extends StatefulWidget {
  String report_url;
  String cid;
  String userId;
  String userPassword;
  DcrReportWebView(
      {Key? key,
      required this.report_url,
      required this.cid,
      required this.userId,
      required this.userPassword})
      : super(key: key);

  @override
  State<DcrReportWebView> createState() => _DcrReportWebViewState();
}

class _DcrReportWebViewState extends State<DcrReportWebView> {
  late InAppWebViewController _webViewController;
  double progress = 0;
  String? deviceId = '';
  final databox = Boxes.allData();
  @override
  void initState() {
    deviceId = databox.get("deviceId");

    // deviceBrand = prefs.getString("deviceBrand");
    // deviceModel = prefs.getString("deviceModel");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint( "${widget.report_url}?cid=${widget.cid}&rep_id=${widget.userId}&rep_pass=${widget.userPassword}");
    // var a = widget.report_url +
    //     "sales_report_invoice/sales_report_detail_url?cid=${widget.cid}&rep_id=${widget.userId}&password=${widget.userPassword}&device_id=$deviceId";
    // debugPrint('------------------------------');
    // debugPrint(
    //     "${widget.report_url}?cid=${widget.cid}&rep_id=${widget.userId}&rep_pass=${widget.userPassword}");

    return WillPopScope(
      onWillPop: () async {
        if (await _webViewController.canGoBack()) {
          _webViewController.goBack();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
          appBar: AppBar(
            // backgroundColor: const Color.fromARGB(255, 138, 201, 149),

            title:  Text('dcr_report'.tr()),
            centerTitle: true,
            // titleTextStyle: const TextStyle(
            //     color: Color.fromARGB(255, 27, 56, 34),
            //     fontWeight: FontWeight.w500,
            //     fontSize: 20),
            // centerTitle: true,
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.home)),
          ),
          body: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: SafeArea(
                  child: Center(
                    child: InAppWebView(
                      initialUrlRequest: URLRequest(
                          url: Uri.parse(
                              "${widget.report_url}?cid=${widget.cid}&rep_id=${widget.userId}&rep_pass=${widget.userPassword}")),
                      onWebViewCreated: (controller) {
                        _webViewController = controller;
                      },
                      // url: Uri.parse(widget.report_url +
                      //     "?cid=${widget.cid}&rep_id=${widget.userId}&password=${widget.userPassword}&device_id=$deviceId")),
                      onReceivedServerTrustAuthRequest:
                          (controller, challenge) async {
                        // debugPrint(challenge);
                        return ServerTrustAuthResponse(
                            action: ServerTrustAuthResponseAction.PROCEED);
                      },
                      onProgressChanged:
                          (InAppWebViewController controller, int progress) {
                        setState(() {
                          this.progress = progress / 100;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Align(alignment: Alignment.topCenter, child: _buildProgressBar()),
            ],
          )),
    );
  }

  Widget _buildProgressBar() {
    if (progress != 1.0) {
      // return const CircularProgressIndicator();
// You can use LinearProgressIndicator also
      return LinearProgressIndicator(
        value: progress,
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
        backgroundColor: Colors.blue,
        minHeight: 7,
      );
    }
    return Container();
  }
}
