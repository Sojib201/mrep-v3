// To parse this JSON data, do
//
//     final message = messageFromJson(jsonString);



import 'dart:convert';

Message messageFromJson(String str) => Message.fromJson(json.decode(str));

String messageToJson(Message data) => json.encode(data.toJson());

class Message {
  String? toId;
  String? fromId;
  String? msg;
  Type? type;
  String? sent;
  String? read;

  Message({
    this.toId,
    this.fromId,
    this.msg,
    this.type,
    this.sent,
    this.read,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    toId: json["to_id"]??"",
    fromId: json["from_id"]??"",
    msg: json["msg"]??"",
    type: json["type"].toString() == Type.image.name ? Type.image : Type.text,
    sent: json["sent"]??"",
    read: json["read"]??"",
  );
  Map<String, dynamic> toJson() => {
    "to_id": toId,
    "from_id": fromId,
    "msg": msg,
    "type": type?.name,
    "sent": sent,
    "read": read,
  };
}
enum Type { text, image }