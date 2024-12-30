import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../local_storage/boxes.dart';

class LastInvoicePage extends StatefulWidget {
  LastInvoicePage({
    super.key,
    required this.clientId,
  });
  final String clientId;

  @override
  State<LastInvoicePage> createState() => _LastInvoicePageState();
}

class _LastInvoicePageState extends State<LastInvoicePage> {
  double progress = 0;
  final databox = Boxes.allData();
  String cid = '';
  String userId = '';
  String userPassword = '';
  String repLastInvUrl = '';

  @override
  void initState() {
    cid = databox.get("CID")!;
    userId = databox.get("user_id")!;
    userPassword = databox.get("PASSWORD")!;
    repLastInvUrl = databox.get("report_last_inv_url") ?? "";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint( "$repLastInvUrl?cid=$cid&rep_id=$userId&rep_pass=$userPassword&client_id=${widget.clientId}");
    return Scaffold(
      appBar: AppBar(
        title: Text("Last Invoice"),
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
                        "$repLastInvUrl?cid=$cid&rep_id=$userId&rep_pass=$userPassword&client_id=${widget.clientId}")),
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
