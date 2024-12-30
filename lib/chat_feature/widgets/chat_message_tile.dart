



import 'package:flutter/material.dart';
import 'package:mrap_v03/chat_feature/firebase_apis.dart';
import 'package:mrap_v03/chat_feature/message_model.dart';
import 'package:mrap_v03/chat_feature/my_date_util.dart';
import 'package:mrap_v03/chat_feature/user_info_model.dart';

class ChatMessageTile extends StatelessWidget {
  const ChatMessageTile(
    BuildContext context, {

        super.key,
    required this.message,
    required this.receiverInfo,
  });
  final Message message;
  final UserInfoModel receiverInfo;



  @override
  Widget build(BuildContext context) {
    bool sendByMe = FirebaseAPIs.user['user_id'].toString() == message.fromId.toString();
    if(!sendByMe)
      {
        if (message.read!.isEmpty) {
          FirebaseAPIs.updateMessageReadStatus(message);
        }
      }

    return Row(
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        const SizedBox(width: 4,),
        sendByMe
            ? const Text("")
            : Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Colors.grey, width: 2)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child:
                    Icon(Icons.person),
                  // CachedNetworkImage(
                  //   height: 30,
                  //   width: 30,
                  //   imageUrl: receiverInfo.image!.toString(),
                  //   fit: BoxFit.cover,
                  //   placeholder: (context, url) => Image.asset(
                  //       ImageConstant.receiverImg,
                  //       fit: BoxFit.cover),
                  //   errorWidget: (context, url, error) => Image.asset(
                  //       ImageConstant.receiverImg,
                  //       fit: BoxFit.cover),
                  // ),
                ),
              ),
        Flexible(
            child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.7),
          child: Column(
            crossAxisAlignment:
            sendByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                // margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                margin: EdgeInsets.only(left: 8,right: 8,top: 8,bottom: 2),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: sendByMe
                            ? const Color(0xFF404040)
                            : const Color(0xFFC5CEE0)),
                    borderRadius: BorderRadius.only(
                        topRight: const Radius.circular(16),
                        topLeft: const Radius.circular(16),
                        bottomRight: sendByMe
                            ? const Radius.circular(6)
                            : const Radius.circular(16),
                        bottomLeft: sendByMe
                            ? const Radius.circular(16)
                            : const Radius.circular(6)),
                    color: sendByMe ? const Color(0xFF404040) : Colors.white),
                child: Text(
                  message.msg.toString(),
                  style: TextStyle(
                      color: sendByMe ? Colors.white : const Color(0xFF151C33)),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 8,right: 12),
                child: Row(
                  mainAxisAlignment:
                  sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    if(sendByMe)
                      message.read!.isNotEmpty?
                      Icon(Icons.done_all,size: 16):Icon(Icons.done,size: 16,),
                    SizedBox(width: 3,),
                    Text(MyDateUtil.getMessageTime(context: context, time:message.sent.toString()), textAlign: TextAlign.right,),


                  ],
                ),
              ),

            ],
          ),
        )),
        // sendByMe
        //     ? CircleAvatar(
        //         //backgroundColor: const Color(0xFF404040),
        //         backgroundImage: AssetImage(ImageConstant.receiverImg),
        //       )
        //     : const Text(""),
      ],
    );
  }
}
