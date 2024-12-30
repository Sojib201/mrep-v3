
import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mrap_v03/chat_feature/chat_screen.dart';
import 'package:mrap_v03/chat_feature/widgets/inboxchatcard.dart';
import 'package:mrap_v03/chat_feature/user_info_model.dart';
import 'package:mrap_v03/local_storage/boxes.dart';

import 'firebase_apis.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}
class _UserListState extends State<UserList>  {
  List<Map<String, dynamic>> allUsers = [];
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  final TextEditingController _search = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final box = Boxes.allData();
  Stream? userStream;
  //
  // List<UserInfoModel> myChatList = [];
  bool isSearching=false;

  TextEditingController searchByNameTE = TextEditingController();
  // final _chars =
  //     'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  // final Random _rnd = Random();
   List<UserInfoModel> chatList = [];
  final  List<UserInfoModel> searchList = [];
  //
  @override
  void initState() {
   userStream = FirebaseAPIs.getMyDepoUsersId();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print('rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr');
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("User List"),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 12,
              left: 12,
              right: 12,
              bottom: 8,
            ),
            child: TextField(
              controller: searchByNameTE,
              // onSubmitted: (value) {
              //   //  FirebaseAPIs.addChatUser(value.toString());
              // },
              onChanged: (value) {

                if (value == "") {
                  isSearching = false;
                } else {
                  isSearching = true;
                  searchList.clear();
                  for (var i in chatList) {
                    if (i.userId!.toLowerCase().contains(value.toLowerCase()) || i.name!.toLowerCase().contains(value.toLowerCase())) {
                      searchList.add(i);
                    }
                  }
                }
                setState(() {

                });

              },
              decoration:
              InputDecoration(
                suffixIcon: Icon(Icons.search_rounded,color: Colors.green,),
                  fillColor:Colors.white70,
                  filled: true,
                  hintText: "Search By Name | User ID",
                  hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.circular(6),
                  )),
            ),
          ),
          Expanded(
            child: StreamBuilder(
                        stream: userStream,
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              case ConnectionState.none:
                              return Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.green
                                  ));
                            case ConnectionState.active:
                            case ConnectionState.done:
                              final data = snapshot.data!.docs;
                              // print("length of getAllUsers data${data.length}");
                              if (data.isNotEmpty) {
                                chatList.clear();
                                for (var i in data) {
                              chatList.add(UserInfoModel.fromJson(i.data()));
                                }
                            chatList.sort((a, b) =>
                                    b.lastMsgSent!
                                        .compareTo(a.lastMsgSent!));
                                List<UserInfoModel> finalList = isSearching ? searchList : chatList;
                                // print("xxxxxxxxxxxxxxxxxxxxx");
                                // log(jsonEncode(finalList));
                                return ListView.builder(
                                  itemCount: finalList.length,
                                  itemBuilder: (context, index) {
                                    // int reversedIndex = finalList.length - 1 - index;
                                    if (finalList.isNotEmpty) {
                                    UserInfoModel receiverUserInfo =  finalList[index];
                                      return InkWell(
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                                              return ChatScreen(receiverInfo: finalList[index],);
                                            },));
                                           // Navigator.push(context,MaterialPageRoute(builder: (context) => ChatScreen2(receiverInfo: finalList[index]),));
                                            // Get.toNamed("/chatscreen", arguments: finalList[index]);
                                          },
                                          child: InboxCardWidget(receiverUserInfo: finalList[index]));
                                    } else {
                                      return const Text("No Chat Available");
                                    }
                                  },
                                );
                              } else {
                                return const Center(child: Text("No Chat Available"));
                              }
                          }
                        },

                          ),
          ),
        ],
      ),
    );

  }


}

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
