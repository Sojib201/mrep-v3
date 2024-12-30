import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../local_storage/boxes.dart';

class CustomerAddPage extends StatefulWidget {
  CustomerAddPage({
    super.key,
    required this.terriId,
  });
  final String terriId;

  @override
  State<CustomerAddPage> createState() => _CustomerAddPageState();
}

class _CustomerAddPageState extends State<CustomerAddPage> {
  double progress = 0;
  String client_edit_url = '';
  final databox = Boxes.allData();
  String cid = '';
  String userId = '';
  String userPassword = '';
  String client_url = '';

  @override
  void initState() {
    cid = databox.get("CID")!;
    userId = databox.get("user_id")!;
    client_edit_url = databox.get("client_edit_url")!;
    userPassword = databox.get("PASSWORD")!;
    client_url = databox.get("client_url") ?? '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("$client_url?cid=$cid&rep_id=$userId&rep_pass=$userPassword&terri_id=${widget.terriId}");
    return Scaffold(
      appBar: AppBar(
        title: Text("Customer Add"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                    url: Uri.parse(
                        "$client_url?cid=$cid&rep_id=$userId&rep_pass=$userPassword&terri_id=${widget.terriId}")),
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
