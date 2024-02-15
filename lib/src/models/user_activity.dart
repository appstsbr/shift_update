import 'package:shift_flutter/src/resources/format_string.dart';

class UserActivity {
  final int? id;
  final int? userId;
  final int? messageId;
  final int? typeId;
  final String? title;
  final String? translatedTitle;
  final String? createdAt;
  final String? updatedAt;
  final String? autorName;
  final String? autorAvatar;

  UserActivity(
      {required this.id,
      required this.userId,
      required this.messageId,
      required this.typeId,
      required this.title,
      required this.translatedTitle,
      required this.createdAt,
      required this.updatedAt,
      required this.autorName,
      required this.autorAvatar});

  factory UserActivity.fromJson(Map<String, dynamic> json) {
    return new UserActivity(
      id: json['id'],
      userId: json['user_id'],
      messageId: json['message_id'],
      typeId: json['type_id'],
      title: FormatString.capitalizeText(json['title']),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      translatedTitle: json['translated_title'],
      autorName: json['autor_name'],
      autorAvatar: json['autor_avatar'],
    );
  }
  factory UserActivity.placeholder() {
    return new UserActivity(
      id: 0,
      userId: 0,
      messageId: 0,
      typeId: 0,
      title: "",
      createdAt: "0000-00-00 00:00",
      updatedAt: "0000-00-00 00:00",
      translatedTitle: "",
      autorName: "",
      autorAvatar: "",
    );
  }

  int get userActivityId => id!;
  int get userActivityUserId => userId!;
  int get userActivityMessageId => messageId!;
  int get userActivityTypeId => typeId!;
  String get userActivityTitle => title!;
  String get userActivityTranslatedTitle => translatedTitle!;
  String get userActivityCreatedAt => createdAt!;
  String get userActivityUpdatedAt => updatedAt!;
}
