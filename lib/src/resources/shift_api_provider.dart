import 'package:http/http.dart' show Client, Response;
import 'package:shift_flutter/src/models/paginated.dart';
import 'dart:io';
import 'dart:convert';
import '../services/network/utils.dart';
import '../services/http_service.dart';
import '../models/user.dart';
import '../models/user_activity.dart';
import '../models/message.dart';
import '../models/event.dart';
import '../models/event_type.dart';
import '../models/notification_user.dart';

/// a class [ShiftApiProvider] é responsavel pelas requisições que são feitas dentro
/// do servidor do shift

class ShiftApiProvider {
  Client client = Client();
  // variavel resposanvel pelas requisições e sets de usuarios logados
  static final httpService = new HttpService();
  //variavel que contem a url base para requisições com o servidor
  final urlApiBase = '${NetworkUtils.urlBase}${NetworkUtils.serverApi}';

  Future<int> getTokenStatus() async {
    final authClient = await httpService.getClient();

    final r = await client.get(Uri.parse("${urlApiBase}logged-user"), headers: {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader:
          'Bearer ${authClient.credentials.accessToken}'
    });
    return r.statusCode;
  }

  Future<User> getLoggedUser() async {
    final authClient = await httpService.getClient();

    final r = await client.get(Uri.parse("${urlApiBase}logged-user"), headers: {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader:
          'Bearer ${authClient.credentials.accessToken}'
    });

    return new User.fromJson(jsonDecode(r.body));
  }

  Future<List<UserActivity>> getLastActivities() async {
    final authClient = await httpService.getClient();
    final List<UserActivity> listUserActivity = [];

    final r = await client
        .get(Uri.parse('${urlApiBase}logged-user/last-activities'), headers: {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader:
          'Bearer ${authClient.credentials.accessToken}'
    });

    for (var item in jsonDecode(r.body)) {
      listUserActivity.add(new UserActivity.fromJson(item));
    }

    return listUserActivity;
  }

  Future<Message> getMessage(int id) async {
    String ids = id.toString();
    final authClient = await httpService.getClient();
    Response r;
    r = await client.get(Uri.parse('${urlApiBase}message/$ids'), headers: {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader:
          'Bearer ${authClient.credentials.accessToken}'
    });
    Message m = new Message.fromJson(jsonDecode(r.body));
    return m;
  }

  Future<List<Message>> getMessages(String filter) async {
    final authClient = await httpService.getClient();
    Response r;
    List<Message> tickets = [];
    r = await client.get(Uri.parse('${urlApiBase}messages/$filter'), headers: {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader:
          'Bearer ${authClient.credentials.accessToken}'
    });
    print(r.body);
    for (var i = 0; i < jsonDecode(r.body).length; i++) {
      tickets.add(new Message.fromJson(jsonDecode(r.body)[i]));
    }
    return tickets;
  }

  Future<Paginated<Message>> getMessagesPaginated(
      String filter, int pageLength, int page) async {
    final authClient = await httpService.getClient();
    Response r;
    r = await client.get(
        Uri.parse(
            '${urlApiBase}messages/$filter?pageLength=$pageLength&page=$page'),
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${authClient.credentials.accessToken}'
        });
    return new Paginated<Message>.fromJson(
      jsonDecode(r.body),
      (data) {
        return new Message.fromJson(data);
      },
    );
  }

  Future<List<dynamic>> getChatList() async {
    final authClient = await httpService.getClient();
    Response r;
    r = await client.get(Uri.parse('${urlApiBase}chat/list'), headers: {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader:
          'Bearer ${authClient.credentials.accessToken}'
    });
    print(r.body);
    return jsonDecode(r.body);
  }

  Future<void> markAsRead(int messageId) async {
    final authClient = await httpService.getClient();

    try {
      await client.get(
          Uri.parse('${urlApiBase}messages/mark-as-read/$messageId'),
          headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'Bearer ${authClient.credentials.accessToken}'
          });

      print('To no priver $messageId');
    } catch (e) {
      print(e);
    }
  }

  Future<void> markNotificationAsRead(int notificaitionId) async {
    final authClient = await httpService.getClient();
    print(notificaitionId);
    await client.get(
        Uri.parse('${urlApiBase}notification/mark-as-read/$notificaitionId'),
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${authClient.credentials.accessToken}'
        });
  }

  Future<List<Event>> getHistory(int messageId) async {
    final authClient = await httpService.getClient();
    List<Event> events = [];

    final r = await client.get(
        Uri.parse('${urlApiBase}messages/get_history/$messageId'),
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${authClient.credentials.accessToken}'
        });

    for (var i = 0; i < jsonDecode(r.body).length; i++) {
      events.add(new Event.fromJson(
          new EventType.fromJson(jsonDecode(r.body)[i]['type']),
          new User.fromJson(jsonDecode(r.body)[i]['user']),
          new UserActivity.fromJson(jsonDecode(r.body)[i])));
    }

    return events;
  }

  Future<List<User>> getMessageUsers(int messageId) async {
    final authClient = await httpService.getClient();
    List<User> users = [];

    final r = await client
        .get(Uri.parse('${urlApiBase}messages/$messageId/get-users'), headers: {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader:
          'Bearer ${authClient.credentials.accessToken}'
    });

    for (var i = 0; i < jsonDecode(r.body).length; i++) {
      users.add(new User.fromJson(jsonDecode(r.body)[i]));
    }

    return users;
  }

  Future<Paginated<NotificationUser>> getUserNotifications(
      int pageLength, int page) async {
    final authClient = await httpService.getClient();
    Response r;
    r = await client.get(
        Uri.parse(
            '${urlApiBase}user/notifications/paginated?pageLength=$pageLength&page=$page'),
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${authClient.credentials.accessToken}'
        });
    print(r.body);
    return new Paginated<NotificationUser>.fromJson(
      jsonDecode(r.body),
      (data) {
        return new NotificationUser.fromJson(data);
      },
    );
  }

  Future<int> sendUserDeviceInfo(String token, String systemVersion,
      String systemName, String model, String name) async {
    final authClient = await httpService.getClient();
    final s = await client.post(
        Uri.parse('${urlApiBase}userDeviceDataForPushNotification'),
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${authClient.credentials.accessToken}',
        },
        body: {
          'deviceToken': token,
          'systemVersion': systemVersion,
          'systemName': systemName,
          'model': model,
          'name': name
        });
    return s.statusCode;
  }

  Future<int> changePassword(String newPassword) async {
    final authClient = await httpService.getClient();
    //upload_image
    final s =
        await client.post(Uri.parse('${urlApiBase}updatePassword'), headers: {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader:
          'Bearer ${authClient.credentials.accessToken}',
    }, body: {
      'password': newPassword,
    });

    return s.statusCode;
  }

  Future<int> changeAvatar(String image, String ext) async {
    print("\n\n *********************** \n\n");
    print(image);
    print("\n\n\n**********$ext**********\n\n\n");
    final authClient = await httpService.getClient();
    final s =
        await client.post(Uri.parse('${urlApiBase}upload_image'), headers: {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader:
          'Bearer ${authClient.credentials.accessToken}',
    }, body: {
      'image': image,
      'extension': ext,
    });
    print("\n\n *********************** \n\n");
    print(s.body);
    print("\n\n *********************** \n\n");
    return s.statusCode;
  }

  Future<void> chat(var messageId, String message) async {
    final authClient = await httpService.getClient();
    try {
      var res =
          await client.post(Uri.parse('${urlApiBase}message/chat'), headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader:
            'Bearer ${authClient.credentials.accessToken}'
      }, body: {
        'message_id': messageId.toString(),
        'message': message,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendPushNotificationUser(
      List<int> uids, String title, String message) async {
    print(uids.toString());
    await post("notification/push/send/users", body: {
      "users": uids,
      "title": title,
      "message": message,
    });
  }

  Future<Paginated<User>> searchUsers(String search, int page) async {
    var res =
        await get("users/search", params: {"search": search, "page": page});
    return new Paginated.fromJson(jsonDecode(res.body), (item) {
      return User.fromJson(item);
    });
  }

  Future<Map<String, String>> headers() async {
    final authClient = await httpService.getClient();
    return {
      HttpHeaders.acceptHeader: 'application/json',
      "content-type": "application/json",
      HttpHeaders.authorizationHeader:
          'Bearer ${authClient.credentials.accessToken}'
    };
  }

  Future<Response> get(String url, {Map<String, dynamic>? params}) async {
    Response r;
    if (params != null) {
      url += "?";
      for (var key in params.keys) {
        url += "&" + key + "=" + params[key].toString();
      }
    }
    print(url);
    r = await client.get(Uri.parse(urlApiBase + url), headers: await headers());
    print(r.body);
    return r;
  }

  Future<Response> post(String url, {Map<String, dynamic>? body}) async {
    print(url);
    var res = await client.post(Uri.parse(urlApiBase + url),
        headers: await headers(), body: jsonEncode(body));
    print(res.body);
    return res;
  }
}
