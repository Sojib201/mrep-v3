
import 'package:flutter/material.dart';
import 'package:mrap_v03/chat_feature/firebase_apis.dart';
import 'package:mrap_v03/chat_feature/message_model.dart';
import 'package:mrap_v03/chat_feature/user_info_model.dart';
import 'package:mrap_v03/core/utils/app_colors.dart';

import '../my_date_util.dart';

bool isUnread = false;

class InboxCardWidget extends StatelessWidget {
  final UserInfoModel receiverUserInfo;
  const InboxCardWidget({
    super.key,
    required this.receiverUserInfo,
  });

  @override
  Widget build(BuildContext context) {
    bool sendByMe = true;

    Message? message;
    UserInfoModel? receiverUserData;
    return Container(
        margin: const EdgeInsets.only(left: 12, right: 12, bottom: 4, top: 4),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey, width: 1)),
        child: Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: StreamBuilder(
                stream: FirebaseAPIs.getUserInfo(
                    receiverUserInfo.userId.toString()),
                builder: (context, snapshot) {
                  final data = snapshot.data?.docs;
                  final receiverData = data
                          ?.map((e) => UserInfoModel.fromJson(e.data()))
                          .toList() ??
                      [];

                  if (receiverData.isNotEmpty) {
                    receiverUserData = receiverData[0];
                    return StreamBuilder(
                      stream: FirebaseAPIs.getLastMessage(receiverUserData!),
                      builder: (context, snapshot) {
                        final data = snapshot.data?.docs;
                        final list = data
                                ?.map((e) => Message.fromJson(e.data()))
                                .toList() ??
                            [];
                        if (list.isNotEmpty) {
                          message = list[0];
                          sendByMe = message!.fromId.toString() ==
                              FirebaseAPIs.user['user_id'];
                          return ListTile(
                            // contentPadding: EdgeInsets.zero,
                            leading: Stack(children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                        color: Colors.grey, width: 2)),
                                child: Icon(Icons.person, size: 35,),
                              ),
                              //   CircleAvatar(
                              //   radius: 25,
                              //   backgroundImage:AssetImage(ImageConstant.demoProfile),
                              // ),
                              Positioned(
                                  right: 0,
                                  bottom: 1,
                                  child: receiverUserData!.isOnline!
                                      ? const UserActive()
                                      : const UserInactive())
                            ]),
                            title: Text(
                              receiverUserData!.name.toString(),
                              // style: AppTextStyle.bodyMediumBlackSemiBold,
                            ),
                            subtitle: message != null
                                ? sendByMe
                                    ? Text(
                                        overflow: TextOverflow.ellipsis,
                                        message!.type == Type.image
                                            ? "Image"
                                            : "You: ${message!.msg}",
                                        maxLines: 1,
                                      )
                                    : message!.read!.isEmpty
                                        ? Text(
                                            overflow: TextOverflow.ellipsis,
                                            message!.type == Type.image
                                                ? "Image"
                                                : "${message!.msg}",
                                            maxLines: 1,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700),
                                          )
                                        : Text(
                                            overflow: TextOverflow.ellipsis,
                                            message!.type == Type.image
                                                ? "Image"
                                                : "${message!.msg}",
                                            maxLines: 1,
                                          )
                                : const Text(""),
                            contentPadding: EdgeInsets.zero,
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  MyDateUtil.getLastMessageTime(
                                      context: context,
                                      time: message!.sent.toString()),
                                  // style: AppTextStyle.titleText,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                sendByMe
                                    ? const SizedBox()
                                    : message!.read!.isEmpty
                                        ? Container(
                                  height: 15,
                                  width: 15,
                                  decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius:
                                    BorderRadius.circular(100),
                                  ),
                                  // child: const Center(child: Text("2",style: TextStyle(color: Colors.white),)),
                                )

                                        // const UnReadIndicator()
                                        : Text("")
                              ],
                            ),
                          );
                        } else {
                          return ListTile(
                            // contentPadding: EdgeInsets.zero,
                            leading: Stack(children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                        color: Colors.grey, width: 2)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Icon(Icons.person, size: 35),
                                ),
                              ),
                            ]),
                            title: Text(
                              receiverUserInfo.name.toString(),
                              // style: AppTextStyle.bodyMediumBlackSemiBold,
                            ),
                            subtitle: Text(""),
                            contentPadding: EdgeInsets.zero,
                          );
                        }
                      },
                    );
                  } else {
                    return ListTile(
                      // contentPadding: EdgeInsets.zero,
                      leading: Stack(children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: Colors.grey, width: 2)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Icon(Icons.person, size: 35),
                          ),
                        ),
                      ]),
                      title: Text(
                        receiverUserInfo.name.toString(),
                        // style: AppTextStyle.bodyMediumBlackSemiBold,
                      ),
                      subtitle: Text(""),
                      contentPadding: EdgeInsets.zero,
                    );
                  }
                })));
  }
}

// class ReadIndicator extends StatelessWidget {
//
//   const ReadIndicator({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     isUnRead=true;
//     return const Text("");
//   }
// }
//
// class UnReadIndicator extends StatelessWidget {
//   const UnReadIndicator({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     isUnRead=false;
//     return Container(
//         height: 15,
//         width: 15,
//         decoration: BoxDecoration(
//           color:Colors.green,
//           borderRadius:
//               BorderRadius.circular(100),
//         ),
//         // child: const Center(child: Text("2",style: TextStyle(color: Colors.white),)),
//       );
//   }
// }

class UserInactive extends StatelessWidget {
  const UserInactive({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      width: 12,
      decoration: BoxDecoration(
          color: const Color(0xFFC5CEE0),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Colors.white, width: 1.5)),
    );
  }
}

class UserActive extends StatelessWidget {
  const UserActive({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      width: 12,
      decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Colors.white, width: 1.5)),
    );
  }
}
