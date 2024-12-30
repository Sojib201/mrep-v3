

import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:mrap_v03/chat_feature/message_model.dart';
import 'package:mrap_v03/chat_feature/user_info_model.dart';

class FirebaseAPIs {
  static final box = Hive.box("userInfo");
  static var userJsonString = box.get('user');
  static UserInfoModel me = UserInfoModel();


  //getUserDetailsFromHive
  static Future<String> currentUser() async {

    Map<String, dynamic> user = json.decode(userJsonString);
    print("this from firebase api class current uID :${user["user_id"]}");
    return user["user_id"].toString();
  }

  static Map<String, dynamic> user =json.decode(userJsonString) ;

  static FirebaseFirestore mDB = FirebaseFirestore.instance;
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllChatList() {
    return FirebaseAPIs.mDB.collection("chat_list").snapshots();
  }

  // #save userDetails in hive for auto log in and firebase purpose like userEXist or not etc.
  // make a object name user where userINfo will be loaded from hive
  // (static User get user => auth.currentUser!;)//same system but with hive.
  // // for checking if user exists or not?
  // static Future<bool> userExists() async {
  //   return (await mDB.collection('users').doc(user['user_id']).get()).exists;
  // }

  // static Future<void> createUser(Map<String, dynamic> userInfo) async {
  //   return await mDB
  //       .collection('users')
  //       .doc(userInfo['user_id'])
  //       .set(userInfo);
  // }
 // static Stream<int> getUnreadMessageCount(String currentUserId) {
 //    return FirebaseFirestore.instance
 //        .collection('chats')
 //        .doc(getConversationID(currentUserId))
 //         .collection("messages")
 //        .where('read', isEqualTo: "")
 //        .snapshots()
 //        .map((snapshot) => snapshot.docs.length);
 //  }
 // static Stream<QuerySnapshot<Map<String, dynamic>>> getUnreadMessageCount() {
 //
 //       return  mDB.collection('chats')
 //
 //             .where('participants', arrayContains: user["user_id"]) // assuming you store participants as an array
 //             .snapshots();
 //
 //         // Get count of unread messages
 //  }



  //getSelfInfo it will be called when user enter the app

  // for getting current user info
  // static Future<void> getSelfInfo() async {
  //   await mDB.collection('users').doc(user["user_id"]).get().then((
  //       selectedUser) async {
  //     if (await userExists()) {
  //       me = UserInfoModel.fromJson(selectedUser.data()!);
  //        // await getFirebaseMessagingToken();
  //        print("self info called");
  //      await FirebaseAPIs.updatePushToken(user["user_id"].toString(),me.pushToken.toString());
  //       //for setting user status to active
  //       //FirebaseAPIs.updateActiveStatus(true);
  //       // log('My Data: ${user.data()}');
  //     } else {
  //       await createUser(user).then((value) => getSelfInfo());
  //     }
  //   });
  // }

//
// /////////////////////////////
//   // for getting all users from firestore database
//   static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
//       List<String> userIds) {
//     log('\nUserIds: $userIds');
//
//     return firestore
//         .collection('users')
//         .where('id',
//         whereIn: userIds.isEmpty
//             ? ['']
//             : userIds) //because empty list throws an error
//     // .where('id', isNotEqualTo: user.uid)
//         .snapshots();
//   }
// ///////////////////////
//   this funtion could be call when user click on "chat now" button or after first message send.that will be better aproach
// //////////
//
//   // for adding an user to my user when first message is send
//   static Future<void> sendFirstMessage(
//       ChatUser chatUser, String msg, Type type) async {
//     await firestore
//         .collection('users')
//         .doc(chatUser.id)
//         .collection('my_users')
//         .doc(user.uid)
//         .set({}).then((value) => sendMessage(chatUser, msg, type));
//   }
//
//
// /////////
//
//
  // for getting id's of known users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyDepoUsersId() {
    return mDB.collection("depotList").doc(user["depot_name"])
        .collection('users')
        .doc(user['user_id'])
        .collection('my_users')
        .snapshots();
  }

  // for getting all users from firestore database
  // static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
  //     List<String> userIds) {
  //   log('\nUserIds: $userIds');
  //
  //   return mDB
  //       .collection('users')
  //       .where('user_id',
  //       whereIn: userIds.isEmpty
  //           ? ['']
  //           : userIds) //because empty list throws an error
  //   // .where('id', isNotEqualTo: user.uid)
  //
  //       .snapshots();
  // }


// for adding an chat user for our conversation
//   static Future<bool> addChatUser(UserInfoModel targetUser) async {
//
//     final data = await mDB
//
//         .collection('users')
//         .where('user_id', isEqualTo: targetUser.userId)
//         .get();
//
//     log('data: ${data.docs}');
//
//     if (data.docs.isNotEmpty && data.docs.first.id != user['user_id']) {
//       //user exists
//       // final lastTime =DateTime.now().toString();
//       log('user exists: ${data.docs.first.data()}');
//       targetUser.lastMsgSent= DateTime.now();
//       print(targetUser.lastMsgSent);
//
//       mDB
//           .collection('users')
//           .doc(user['user_id'])
//           .collection('my_users')
//           .doc(targetUser.userId)
//           .set(targetUser.toJson());
//
//       return true;
//     } else {
//       //user doesn't exists
//
//       return false;
//     }
//   }

// //////

  // update online or last active status of user
  static Future<void> updateActiveStatus(bool isOnline) async {

    mDB.collection("depotList").doc(user["depot_name"]).collection('users').doc(user['user_id']).update({
      'is_online': isOnline,
      'last_active': DateTime
          .now()
          .millisecondsSinceEpoch
          .toString(),
       // 'push_token': me.pushToken,
    });
  }
  //updateprofileImage url
  // static Future<void> updateProfileImageURL(String imageURL) async {
  //   mDB.collection('users').doc(user['user_id']).update({
  //     'image': imageURL,
  //   });
  // }
  // static Future<void> updateJobStatus(String id,String status,String notificationID,) async {
  //   mDB.collection('notifications').doc(id).collection("notification_list").doc(notificationID).update(
  //       {"status":status});
  // }
  // static Future<void> updatePushToken(String userID,String pushToken) async {
  //   mDB.collection('users').doc(userID).update(
  //       {"push_token":pushToken});
  // }
  //****************************************
  // useful for getting conversation id
  static String getConversationID(String id) =>
      user['user_id'].hashCode <= id.hashCode
          ? '${user['user_id']}_$id'
          : '${id}_${user['user_id']}';

  // for getting all messages of a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      UserInfoModel user) {
    return mDB
        .collection(
        'chats/${getConversationID(user.userId.toString())}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  // for adding an user to my user when first message is send
  // static Future<void> sendFirstMessage(UserInfoModel chatUser, String msg,
  //     Type type) async {
  //  //  getSelfInfo();
  //  // await FirebaseAPIs.addChatUser(chatUser);
  //
  //  // await FirebaseAPIs.addChatUser(me);
  //  me.lastMsgSent=DateTime.now();
  //
  //   await mDB
  //       .collection('users')
  //       .doc(chatUser.userId)
  //       .collection('my_users')
  //       .doc(user['user_id'])
  //       .set(me.toJson()).then((value) => sendMessage(chatUser, msg, type));
  // }

  // for sending message
  static Future<void> sendMessage(UserInfoModel chatUser, String msg, Type type) async {
    //message sending time (also used as id)
    final time = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();

    //message to send
    final Message message = Message(
        toId: chatUser.userId,
        msg: msg,
        read: '',
        type: type,
        fromId: user['user_id'],
        sent: time);

    final lastSent = DateTime
        .now().toString();
    //add last sent msg time

    mDB
         .collection("depotList")
        .doc(user["depot_name"])
        .collection('users')
        .doc(chatUser.userId)
        .collection('my_users')
        .doc(user['user_id'])
        .update({"last_msg_sent":lastSent});
    mDB
        .collection("depotList")
        .doc(user["depot_name"])
        .collection('users')
        .doc(user['user_id'])
        .collection('my_users')
        .doc(chatUser.userId)
        .update({"last_msg_sent":lastSent});

    final ref = mDB
        .collection(
        'chats/${getConversationID(chatUser.userId.toString())}/messages/');
    await ref.doc(time).set(message.toJson());

    // await ref.doc(time).set(message.toJson()).then((value) =>
    // sendPushNotification(chatUser,chatUser.name.toString(), type == Type.text ? msg : 'image',"inbox"));
  }

  //update read status of message
  static Future<void> updateMessageReadStatus(Message message) async {
    mDB
        .collection(
        'chats/${getConversationID(message.fromId.toString())}/messages/')
        .doc(message.sent)
        .update({'read': DateTime
        .now()
        .millisecondsSinceEpoch
        .toString()});
  }

  //get only last message of a specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      UserInfoModel selectedUser) {
    return mDB
        .collection(
        'chats/${getConversationID(selectedUser.userId.toString())}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }
  //get only last message of a specific chat
  static Future<QuerySnapshot<Map<String, dynamic>>> getTargetUserLastMessage(
      String selectedUser) async {
    return await mDB
        .collection(
        'chats/${getConversationID(selectedUser)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .get(); // This is changed to `.get()` instead of `.snapshots()`
  }

  // for getting specific user info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      String userId) {
    return mDB
    .collection("depotList")
    .doc(user["depot_name"])
        .collection('users')
        .where('user_id', isEqualTo:userId)
        .snapshots();
  }

  //push notification
  // for accessing firebase messaging (Push Notification)
 // static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  //for getting firebase messaging token
  // static Future<void> getFirebaseMessagingToken() async {
  //   await fMessaging.requestPermission();
  //
  //   await fMessaging.getToken().then((t) {
  //     if (t != null) {
  //       me.pushToken = t;
  //       log('Push Token is : $t');
  //     }
  //   });
  // }
  // for sending push notification (Updated Codes)
  // static Future<void> sendPushNotification(
  //     UserInfoModel chatUser,String title,String msg,String screen) async {
  //
  //   try {
  //     final body = {
  //       "message": {
  //         "token": chatUser.pushToken,
  //         "notification": {
  //           "title": title, // The title that will be shown in the notification
  //           "body": msg,    // The message that will be shown in the notification
  //           // "sound": "default", // Optional: set sound for the notification
  //           // "click_action": "FLUTTER_NOTIFICATION_CLICK" // Ensure this is set to handle the notification click
  //         },
  //         "data": {
  //           "screen": screen, // Custom data field, can be anything you need to handle// Optional: redundant, but can be used if needed in foreground handling
  //         }
  //       }
  //     };
  //
  //     // Firebase Project > Project Settings > General Tab > Project ID
  //     const projectID = 'chatappprac-d7a2b';
  //
  //     // get firebase admin token
  //     final bearerToken = await NotificationAccessToken.getToken;
  //
  //     log('bearerToken: $bearerToken');
  //
  //     // handle null token
  //     if (bearerToken == null) return;
  //
  //     var res = await post(
  //       Uri.parse(
  //           'https://fcm.googleapis.com/v1/projects/chatappprac-d7a2b/messages:send'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $bearerToken'
  //         // HttpHeaders.contentTypeHeader: 'application/json',
  //         // HttpHeaders.authorizationHeader: 'Bearer $bearerToken'
  //       },
  //       body: jsonEncode(body),
  //     );
  //
  //     log('Response status: ${res.statusCode}');
  //
  //     log('Response body: ${res.body}');
  //   } catch (e) {
  //     log('\nsendPushNotificationE: $e');
  //   }
  // }

  // Future<Map<String, dynamic>?> getSenderInfo(String userId) async {
  //   try {
  //     DocumentSnapshot documentSnapshot =
  //         await mDB.collection('users').doc(userId).get();
  //
  //     if (documentSnapshot.exists) {
  //       return documentSnapshot.data() as Map<String, dynamic>?;
  //     } else {
  //       print('User not found');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error fetching user details: $e');
  //     return null;
  //   }
  // }

  // static Future<void> sendNotificationData(dynamic body,UserInfoModel chatUser,String title, String msg) async {
  //   String notificationID = DateTime.now().microsecondsSinceEpoch.toString();
  //   body["notification_id"]=notificationID;
  //   await mDB
  //       .collection('notifications')
  //       .doc(chatUser.userId.toString())
  //       .collection("notification_list")
  //       .doc(notificationID)
  //       .set(body).then((value) => sendPushNotification(chatUser,title,msg,"notification"));
  // }
  // for getting notfication
  // static Stream<QuerySnapshot<Map<String, dynamic>>> getMyNotificationList() {
  //   return mDB
  //       .collection('notifications')
  //       .doc(user['user_id'])
  //       .collection('notification_list')
  //       .snapshots();
  // }
  // static Future<void> updateUserDetails(String name,String email) async {
  //   mDB.collection('users').doc(user['user_id']).update(
  //       {"name":name,
  //       "email":email});
  // }
  //

 // static Stream<List<String>> getChatIds() {
 //   // Listen to changes in the 'chats' collection
 //   return mDB.collection('chats').snapshots().map((snapshot) {
 //     List<String> chatIds = [];
 //
 //     for (var doc in snapshot.docs) {
 //       String chatId = doc.id;
 //       print("dkjflkds $chatId");
 //
 //       // Check if the chatId contains the currentUserId
 //       if (chatId.contains(user["user_id"])) {
 //         chatIds.add(chatId);
 //       }
 //     }
 //
 //     return chatIds; // Return the list of chat IDs containing the user ID
 //   });
 // }

  // static Stream<int> countUnreadMessages(String targetUser) async* {
  //   // Listen to chat IDs stream
  //   await for (var chatIds in getChatIds(user["user_id"])) {
  //     int totalUnreadCount = 1;
  //     print("total id ${chatIds}")
  //
  //     for (String chatId in chatIds) {
  //       // Listen to messages in each chat
  //       final messagesSnapshot = await mDB.collection('chats').doc(chatId).collection('messages').get();
  //
  //       for (var messageDoc in messagesSnapshot.docs) {
  //         // Check if the message is unread
  //         if (messageDoc['read'] == null || messageDoc['read'].isEmpty) {
  //           totalUnreadCount++;
  //         }
  //       }
  //     }
  //     yield totalUnreadCount; // Emit the total unread messages count
  //   }
  // }
////////
}