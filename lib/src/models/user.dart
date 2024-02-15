import 'dart:convert';

/// class [User] utilizada como model para os usuarios

class User {
  final int? id;
  final String? name;
  final String? img;
  final String? email;
  final String? username;
  final String? phone;
  final String? cell;
  final String? avatar;
  final int? clientId;
  final int? hasAccessToPortal;
  final int? needsSms;
  final int? check;
  final int? canUseChat;
  final int? canUseExternalChat;

  User(
      {required this.id,
      required this.name,
      required this.img,
      required this.email,
      required this.username,
      required this.phone,
      required this.cell,
      required this.avatar,
      required this.clientId,
      required this.hasAccessToPortal,
      required this.needsSms,
      required this.canUseChat,
      required this.canUseExternalChat,
      required this.check});

  factory User.fromJson(Map<String, dynamic> json) {
    print("Recebendo Json $json");
    return new User(
      id: json['id'],
      name: json['name'] ?? "",
      img: json['img'] ?? "",
      email: json['email'] ?? "",
      username: json['username'] ?? "",
      phone: json['phone'] ?? "",
      cell: json['cell'] ?? "",
      avatar: json['avatar'] ?? "",
      clientId: json['client_id'] ?? 0,
      hasAccessToPortal: json['has_access_to_portal'] ?? 0,
      needsSms: json['needs_sms'] ?? 0,
      check: json['check'] ?? 0,
      canUseChat: json["can_use_chat"] ?? 0,
      canUseExternalChat: json["can_use_external_chat"] ?? 0,
    );
  }

  int get userId => id!;
  String get userFullName => name!;
  String get userImg => img!;
  String get userEmail => email!;
  String get userName => username!;
  String get userPhone => phone!;
  String get userCell => cell!;
  String get userAvatar => avatar!;
  int get userClientId => clientId!;
  int get userHasAccessToPortal => hasAccessToPortal!;
  int get userNeedsSms => needsSms!;
  int get userCheckNotification => check!;

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "id": id,
      "img": img,
    };
  }
}
