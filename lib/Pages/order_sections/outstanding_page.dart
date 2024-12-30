import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../local_storage/boxes.dart';

class OutstandingPage extends StatefulWidget {
  OutstandingPage({
    super.key,
    required this.clientId,
  });
  final String clientId;

  @override
  State<OutstandingPage> createState() => _OutstandingPageState();
}

class _OutstandingPageState extends State<OutstandingPage> {
  double progress = 0;
  final databox = Boxes.allData();
  String cid = '';
  String userId = '';
  String userPassword = '';
  String repOutsUrl = '';

  @override
  void initState() {
    cid = databox.get("CID")!;
    userId = databox.get("user_id")!;
    userPassword = databox.get("PASSWORD")!;
    repOutsUrl = databox.get("report_outst_url") ?? "";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("$repOutsUrl?cid=$cid&rep_id=$userId&rep_pass=$userPassword&client_id=${widget.clientId}");
    return Scaffold(
      appBar: AppBar(
        title: Text("Outstanding"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                    url: Uri.parse(
                        "$repOutsUrl?cid=$cid&rep_id=$userId&rep_pass=$userPassword&client_id=${widget.clientId}")),
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
