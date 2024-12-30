import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../local_storage/boxes.dart';

class PlugInReportsPage extends StatefulWidget {
  PlugInReportsPage({
    super.key,
  });
  @override
  State<PlugInReportsPage> createState() => _PlugInReportsPageState();
}

class _PlugInReportsPageState extends State<PlugInReportsPage> {
  late InAppWebViewController _webViewController;
  double progress = 0;
  final databox = Boxes.allData();
  String cid = '';
  String userId = '';
  String userPassword = '';
  String plugin_url = '';

  @override
  void initState() {
    cid = databox.get("CID")!;
    userId = databox.get("user_id")!;
    userPassword = databox.get("PASSWORD")!;
    plugin_url = databox.get("plugin_url") ?? '';

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
          title: Text("plugin".tr()),
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
                          '$plugin_url?cid=$cid&rep_id=$userId&rep_pass=$userPassword')),
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
