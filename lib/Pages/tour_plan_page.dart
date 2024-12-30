import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../local_storage/boxes.dart';

class TourPlanPage extends StatefulWidget {
  TourPlanPage({
    super.key,
  });
  @override
  State<TourPlanPage> createState() => _TourPlanPageState();
}

class _TourPlanPageState extends State<TourPlanPage> {
  late InAppWebViewController _webViewController;
  double progress = 0;
  String tour_plan_url = '';
  final databox = Boxes.allData();
  String cid = '';
  String userId = '';
  String userPassword = '';

  @override
  void initState() {
    cid = databox.get("CID")!;
    userId = databox.get("user_id")!;
    userPassword = databox.get("PASSWORD")!;
    tour_plan_url = databox.get("tour_plan_url") ?? '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          title: Text("tour_plan".tr()),
          leading: IconButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.home)),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
                child: InAppWebView(
                  initialUrlRequest: URLRequest(
                      url: Uri.parse(
                          '$tour_plan_url?cid=$cid&rep_id=$userId&rep_pass=$userPassword')),
                  onWebViewCreated: (controller) {
                    _webViewController = controller;
                  },
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
              Align(alignment: Alignment.topCenter, child: _buildProgressBar()),
            ],
          ),
        ),
      ),
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
