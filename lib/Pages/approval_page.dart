import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../local_storage/boxes.dart';

class ApprovalPage extends StatefulWidget {
  ApprovalPage({
    super.key,
  });
  @override
  State<ApprovalPage> createState() => _ApprovalPageState();
}

class _ApprovalPageState extends State<ApprovalPage> {
  late InAppWebViewController _webViewController;
  double progress = 0;
  final databox = Boxes.allData();
  String cid = '';
  String userId = '';
  String userPassword = '';
  String approval_url = '';

  @override
  void initState() {
    cid = databox.get("CID")!;
    userId = databox.get("user_id")!;
    userPassword = databox.get("PASSWORD")!;
    approval_url = databox.get("approval_url") ?? '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('$approval_url?cid=$cid&user_id=$userId&user_pass=$userPassword');
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
          title: Text("approval".tr()),
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
                          '$approval_url?cid=$cid&user_id=$userId&user_pass=$userPassword')),
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
