class NotificationUser {
  final int? notificationId;
  final int? historyId;
  final int? userId;
  final int? messageId;
  final int? typeId;
  final String? historyMessage;
  final String? createdAt;
  final String? updatedAt;

  NotificationUser(
      {required this.notificationId,
      required this.historyId,
      required this.userId,
      required this.messageId,
      required this.typeId,
      required this.historyMessage,
      required this.createdAt,
      required this.updatedAt});

  factory NotificationUser.fromJson(Map<String, dynamic> json) {
    return new NotificationUser(
      historyId: json["id"],
      userId: json["user_id"],
      messageId: json["message_id"],
      typeId: json["type_id"],
      historyMessage: json["title"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      notificationId: json["notification_id"],
    );
  }

  int get notificationUserId => notificationId!;
  int get notificationUserHistoryId => historyId!;
  int get notificationUserUserId => userId!;
  int get notificationUserMessageId => messageId!;
  int get notificationUserTypeId => typeId!;
  String get notificationUserHistoryMessage => historyMessage!;
  String get notificationUserCreatedAt => createdAt!;
  String get notificationUserUpdatedAt => updatedAt!;
}
