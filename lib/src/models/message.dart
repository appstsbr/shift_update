import 'package:shift_flutter/src/models/user_activity.dart';

class Message {
  final int id;
  final String title;
  final String status;
  final String description;
  final int messageRead;
  final int receiverId;
  final String deletedAt;
  final String createdAt;
  final String updatedAt;
  final String closedAt;
  final String message;
  final int clientId;
  final String receiverName;
  final String receiverAvatar;
  final String translatedStatus;
  final String ticket;
  final int totalReceivers;
  final int hasChat;
  final UserActivity lastHistory;
  final List<UserActivity> historys;

  Message(
      {required this.id,
      required this.title,
      required this.status,
      required this.description,
      required this.messageRead,
      required this.receiverId,
      required this.receiverName,
      required this.receiverAvatar,
      required this.deletedAt,
      required this.createdAt,
      required this.updatedAt,
      required this.closedAt,
      required this.message,
      required this.clientId,
      required this.translatedStatus,
      required this.ticket,
      required this.totalReceivers,
      required this.lastHistory,
      required this.historys,
      required this.hasChat});

  factory Message.fromJson(Map<String, dynamic> json) {
    List<UserActivity> historys = [];
    if (json.containsKey("historys")) {
      for (Map<String, dynamic> h in json["historys"]) {
        historys.add(UserActivity.fromJson(h));
      }
    }
    return new Message(
        id: json['id'] ?? 0,
        title: json['title'] != null ? json['title'] : "",
        status: json['status'] != null ? json['status'] : "",
        description: json['description'] != null ? json['description'] : "",
        messageRead: json['message_read'] ?? 0,
        receiverId: json['receiver_id'] ?? 0,
        deletedAt: json['deleted_at'] ?? "",
        createdAt: json['created_at'] ?? "",
        updatedAt: json['updated_at'] ?? "",
        closedAt: json['closed_at'] ?? "",
        message: json['ticket'] ?? "",
        clientId: json['client_id'] ?? 0,
        hasChat: json["has_chat"] ?? 0,
        receiverName:
            json['receiver_name'] != null ? json['receiver_name'] : "",
        receiverAvatar: json['receiver_avatar'] != null
            ? json['receiver_avatar']
            : "https://shift.t-systems.com.br/images/no-photo.jpg",
        translatedStatus:
            json['translated_status'] != null ? json['translated_status'] : "",
        ticket: json['ticket'] == null ? "Sem ticket" : json['ticket'] ?? "",
        totalReceivers: json["total_receivers"],
        historys: historys,
        lastHistory: json['last_history'] == null
            ? UserActivity.placeholder()
            : UserActivity.fromJson(json['last_history']));
  }

  int get messageId => id;
  String get messageTitle => title;
  String get messageStatus => status;
  String get messageDescription => description;
  int get messageMessageRead => messageRead;
  int get messageReceiverId => receiverId;
  String get messageDeletedAt => deletedAt;
  String get messageCreatedAt => createdAt;
  String get messageUpdatedAt => updatedAt;
  String get messageClosedAt => closedAt;
  String get messageMessage => message;
  int get messageClientId => clientId;
  String get messageReceiverName => receiverName;
  String get messageReceiverAvatar => receiverAvatar;
  String get messageTranslatedStatus => translatedStatus;
  String get messageTicket => ticket;
}
