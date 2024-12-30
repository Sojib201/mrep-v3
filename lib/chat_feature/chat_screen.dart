
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mrap_v03/chat_feature/widgets/chat_message_tile.dart';
import 'package:mrap_v03/chat_feature/firebase_apis.dart';
import 'package:mrap_v03/chat_feature/message_model.dart';
import 'package:mrap_v03/chat_feature/my_date_util.dart';
import 'package:mrap_v03/chat_feature/user_info_model.dart';

import '../Pages/loginPage.dart';
import '../Pages/user_location/openStreet.dart';

class ChatScreen extends StatefulWidget {
  final UserInfoModel receiverInfo ;
  const ChatScreen({super.key, required this.receiverInfo});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> messageList = [];

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  final Random _rnd = Random();

  TextEditingController messageController = TextEditingController();
  String? messageId;
  String? chatRoomId;
  bool showEmoji = false;
  int lineCount = 2;
  @override
  Widget build(BuildContext context) {
    UserInfoModel receiverUserData = widget.receiverInfo;
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 28,
        elevation: 1,
        // foregroundColor: Colors.black,
        // backgroundColor: Colors.white,
        centerTitle: false,
        title: StreamBuilder(
          stream: FirebaseAPIs.getUserInfo(widget.receiverInfo.userId.toString()),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final receiverData = data
                ?.map((e) => UserInfoModel.fromJson(e.data()))
                .toList() ??

                [];

            if (receiverData.isNotEmpty) {
              receiverUserData = receiverData[0];
              return Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                            color: Colors.grey)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Icon(Icons.person,size: 35,),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        receiverData[0].name.toString(),
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),

                      // receiverInfo.isOnline!
                      receiverData[0].isOnline!
                          ? const Row(
                        children: [
                          Icon(
                            Icons.circle_rounded,
                            size: 8,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            "Online",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                height: 1.5),
                          ),
                        ],
                      )
                          : Text(
                        MyDateUtil.getLastActiveTime(
                            context: context,
                            lastActive: receiverData[0]
                                .lastActive
                                .toString()),
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            height: 1.5),
                      )
                    ],
                  ),
                ],
              );
            } else {
              receiverUserData = widget.receiverInfo;
              return Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                            color: Colors.grey, width: 2)),
                    child: Icon(Icons.person,size: 35,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.receiverInfo.name.toString(),
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                      widget.receiverInfo.isOnline!
                          ? const Row(
                        children: [
                          Icon(
                            Icons.circle_rounded,
                            size: 8,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            "Online",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                height: 1.5),
                          ),
                        ],
                      )
                          : Text(
                        MyDateUtil.getLastActiveTime(
                            context: context,
                            lastActive:
                            widget.receiverInfo.lastActive.toString()),
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            height: 1.5),
                      )
                    ],
                  ),
                ],
              );
            }
          },
        ),
        // title: Text(widget.name!),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            // Get.back();
            // Get.offAllNamed("/inbox");
            // Navigator.pushAndRemoveUntil(
            //   context,
            //   MaterialPageRoute(builder: (context) => const InboxScreen()),
            //   (route) => false,
            // );
          },
        ),
        actions: [
          InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => OpenStreetMapScreen(
                          latitude: mydatabox.get("latitude"),
                          longitude: mydatabox.get("longitude"),
                        )));

              },
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Icon(Icons.pin_drop,color: Colors.white,
                ),
              )),
          // const SizedBox(
          //   width: 12,
          // ),
          // // InkWell(
          // //     onTap: () {},
          // //     child: SvgPicture.asset(
          // //       ImageConstant.videoCallIcon,
          // //     )),
          // const SizedBox(
          //   width: 8,
          // ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder(
                stream: FirebaseAPIs.getAllMessages(widget.receiverInfo),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                  //if data is loading
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                    //if some or all data is loaded then show it
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;
                      messageList = data
                          ?.map((e) => Message.fromJson(e.data()))
                          .toList() ??
                          [];

                      if (messageList.isNotEmpty) {
                        return ListView.builder(
                            reverse: true,
                            itemCount: messageList.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return ChatMessageTile(
                                context,
                                message: messageList[index],
                                receiverInfo: receiverUserData,
                              );

                              //return MessageCard(message: ctrl.messageList[index]);
                            });
                      } else {
                        return const Center(
                          child: Text('Say Hii! 👋',
                              style: TextStyle(fontSize: 20)),
                        );
                      }
                  }
                },
              )),
          SizedBox(
            height: 5,
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              //height: 80,
              child: Column(
                children: [
                  Divider(
                    color: Colors.grey,
                    height: 5,
                    thickness: 1.5,
                    endIndent: 0,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  // Container(
                  //   color: Colors.white,
                  //   height: 40,
                  //   margin: const EdgeInsets.only(left: 8, right: 8),
                  //   child: ListView.separated(
                  //     itemCount: suggestMsgList.length,
                  //     padding: EdgeInsets.zero,
                  //     shrinkWrap: false,
                  //     scrollDirection: Axis.horizontal,
                  //     separatorBuilder: (context, index) => const SizedBox(
                  //       width: 10,
                  //     ),
                  //     itemBuilder: (context, index) => InkWell(
                  //       onTap: (){
                  //         ctrl.messageController.text="${ctrl.messageController.text} ${suggestMsgList[index]}";
                  //       },
                  //       child:  SuggestMsgWidget(suggestMsg: suggestMsgList[index]),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    child: Container(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                minLines: 1,
                                maxLines: 4,
                                textInputAction: TextInputAction.newline,
                                keyboardType: TextInputType.multiline,
                                controller: messageController,
                                onTap: () {
                                  if (showEmoji) {
                                    showEmoji = false;
                                    // setState{();}
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: "Type a message",
                                  hintStyle: TextStyle(
                                      color: Colors.grey.shade500),
                                  // suffixIcon: GestureDetector(
                                  //   child:
                                  //       Image.asset(ImageConstant.attachmentIcon,),
                                  //   onTap: () async {
                                  //     FilePickerResult? result =
                                  //         await FilePicker.platform.pickFiles();
                                  //     if (result != null) {
                                  //       PlatformFile file = result.files.first;
                                  //       print(file.name);
                                  //       print(file.size);
                                  //       print(file.extension);
                                  //       print(file.path);
                                  //       ctrl.messageController.text = file.name;
                                  //     } else {
                                  //       // User canceled the picker
                                  //     }
                                  //   },
                                  // ),
                                  // prefixIcon: GestureDetector(
                                  //   child: Image.asset(ImageConstant.smileEmoji,),
                                  //   onTap: () {
                                  //     ctrl.showEmoji = !ctrl.showEmoji;
                                  //     FocusManager.instance.primaryFocus
                                  //         ?.unfocus();
                                  //
                                  //     ctrl.update();
                                  //   },
                                  // ),
                                  // contentPadding: const EdgeInsets.all(4),
                                  border: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.grey.shade100),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(20),
                                  ),

                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                if (messageController.text.isNotEmpty) {
                                  // if (messageList.isEmpty) {
                                  //   //on first message (add user to my_user collection of chat user)
                                  //   FirebaseAPIs.sendFirstMessage(
                                  //       receiverUserData,
                                  //       messageController.text
                                  //           .trim()
                                  //           .toString(),
                                  //       Type.text);
                                  // } else {
                                    //simply send message
                                    FirebaseAPIs.sendMessage(
                                        receiverUserData,
                                        messageController.text
                                            .trim()
                                            .toString(),
                                        Type.text);
                                  }
                                  messageController.text = '';
                                },
                                // ctrl.update();
                              // },
                              child: SizedBox(
                                height: 50,
                                child: CircleAvatar(
                                  backgroundColor: Colors.black,
                                  //  backgroundImage: AssetImage(ImageConstant.sendIcon),
                                  child:
                                      Container(
                                        margin: EdgeInsets.only(left: 6),
                                        decoration: BoxDecoration(
                                          // color: Colors.black54,
                                          borderRadius: BorderRadius.circular(100)

                                        ),
                                        child: Icon(Icons.send,color: Colors.white,),
                                      )
                                  // Image.asset(
                                  //     'assets/images/sendicon.png',),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          //   if (showEmoji)
          //     Expanded(
          //       child: EmojiPicker(
          //         onBackspacePressed: () {},
          //         textEditingController: ctrl.messageController,
          //         config: Config(
          //           columns: 7,
          //           emojiSizeMax: 28 * (Platform.isIOS ? 1.2 : 1.0),
          //         ),
          //       ),
          //     ),
        ],
      ),

    );
  }
}
