import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../local_storage/boxes.dart';

class CustomerEditPage extends StatefulWidget {
  CustomerEditPage({
    super.key,
    required this.clientId,
  });
  final String clientId;

  @override
  State<CustomerEditPage> createState() => _CustomerEditPageState();
}

class _CustomerEditPageState extends State<CustomerEditPage> {
  double progress = 0;
  String client_edit_url = '';
  final databox = Boxes.allData();
  String cid = '';
  String userId = '';
  String userPassword = '';

  @override
  void initState() {
    cid = databox.get("CID")!;
    userId = databox.get("user_id")!;
    client_edit_url = databox.get("client_edit_url")!;
    userPassword = databox.get("PASSWORD")!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("http://ww11.yeapps.com/apl/client_update/clientNew_add?cid=APEX&rep_id=9657&rep_pass=1234&terri_id=TR486");
    return Scaffold(
      appBar: AppBar(
        title: Text("Customer Edit"),
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
                        "$client_edit_url?cid=$cid&rep_id=$userId&rep_pass=$userPassword&client_id=${widget.clientId}")),
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
