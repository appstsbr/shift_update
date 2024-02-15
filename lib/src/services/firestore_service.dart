import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shift_flutter/src/models/chat_group.dart';
import 'package:shift_flutter/src/models/user.dart';
import 'package:shift_flutter/src/resources/shift_api_provider.dart';
import 'package:shift_flutter/src/services/shift_local_storage.dart';

/// a class [FirestoreService] e responsavel pelo envio de mensagens imagens e criação de grupos
/// alem do envio de mensagens dentro de eventos
class FirestoreService {
  // varivel responsavel por receber uma instancia do FirebaseFirestore
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// metodo responsavel por enviar mensagens dentro dos chats apartir do tipo de evento
  /// eventos que se classificam em chat, grupos, eventos
  /// atualizando assim os dados de pesquisas de mensagens dentro dos chats
  Future<String> sendMessageChat(
      String message, int eventId, User user, String? type) async {
    DocumentReference data = _firestore
        .collection('events')
        .doc(eventId.toString())
        .collection("chat")
        .doc();
    if (type!.isEmpty) {
      type = "text";
    }
    await data.set({
      "message": message,
      "name": user.name,
      "date": DateTime.now(),
      "user_id": user.id,
      "type": type,
    });

    await ShiftApiProvider().chat(eventId, message);

    return data.id;
  }

  // metodo responsavel pelo envio de mensagens e imagens dentro dos grupos
  Future<String> sendMessageGroup(
      String message, ChatGroup chatGroup, User user, String? type) async {
    DocumentReference data = _firestore
        .collection('groups')
        .doc(chatGroup.id)
        .collection("chat")
        .doc();

    if (type!.isEmpty) {
      type = "text";
    }

    await data.set({
      "message": message,
      "name": user.name,
      "date": DateTime.now(),
      "user_id": user.id,
      "type": type,
    });

    await _firestore.collection('groups').doc(chatGroup.id).update({
      "last_id": data.id,
      "last": user.name!.split(" ")[0] + ": " + message,
      "update": DateTime.now()
    });

    List<int> uids = [];
    chatGroup.usersData!.forEach((u) {
      if (user.id != u.id) uids.add(u.id!);
    });
    await ShiftApiProvider().sendPushNotificationUser(
        uids, chatGroup.name.toString(), user.name! + ": " + message);
    return data.id;
  }

  //metodo responsavel por buscar todos os grupos na qual o usuario esta presente
  Query getGroups(int id) {
    return _firestore
        .collection("groups")
        .where("users", arrayContains: id.toString())
        .orderBy("update", descending: true);
  }

  ///metodo responsavel por ficar fazendo requisições repetidas ao firebase
  ///buscando assim mudanças e criações de grupos
  Stream<QuerySnapshot> streamGroups(int id) {
    return _firestore
        .collection('groups')
        .where("users", arrayContains: id.toString())
        .orderBy("update", descending: true)
        .snapshots();
  }

  //metodo responsavel por enviar imagens para coleções dentro dos chats
  Future<String> sendImageChat(
    String message,
    String img,
    int eventId,
    User user,
  ) async {
    DocumentReference doc = _firestore
        .collection('events')
        .doc(eventId.toString())
        .collection("chat")
        .doc();

    await doc.set({
      "message": message,
      "name": user.name,
      "date": DateTime.now(),
      "user_id": user.id,
      "type": "image",
      "img": img,
    });

    await ShiftApiProvider().chat(eventId, message);
    return doc.id;
  }

  //metodo responsavel por enviar imagens para coleções dentro dos grupos
  Future<String> sendImageGroupChat(
    String message,
    String img,
    String groupId,
    User user,
  ) async {
    DocumentReference doc =
        _firestore.collection('groups').doc(groupId).collection("chat").doc();

    await doc.set({
      "message": message,
      "name": user.name,
      "date": DateTime.now(),
      "user_id": user.id,
      "type": "image",
      "img": img,
    });

    await _firestore.collection('groups').doc(groupId).update({
      "last_id": doc.id,
      "last": user.name!.split(" ")[0] + ": Image",
      "update": DateTime.now()
    });

    ShiftLocalStorage().saveToStorage(groupId, doc.id);

    await ShiftApiProvider().chat(groupId, message);
    return doc.id;
  }

  ///metodo responsavel por ficar fazendo requisições repetidas ao firebase
  ///buscando assim mudanças dentro do dos chats do usuario
  Stream<QuerySnapshot> getMessages(int eventId) {
    return _firestore
        .collection('events')
        .doc(eventId.toString())
        .collection("chat")
        .orderBy("date", descending: true)
        .snapshots();
  }

  ///metodo responsavel por ficar fazendo requisições repetidas ao firebase
  ///buscando assim mudanças dentro dos grupos em busca de atualizações
  Stream<QuerySnapshot> getGroupMessages(String groupId) {
    return _firestore
        .collection('groups')
        .doc(groupId)
        .collection("chat")
        .orderBy("date", descending: true)
        .snapshots();
  }

  //metodo responsavel pela exclusão dos grupos que o usuario faz parte
  Future<void> deleteGroup(String groupId) async {
    DocumentReference doc;

    var chat = await _firestore
        .collection('groups')
        .doc(groupId)
        .collection("chat")
        .get();
    for (var m in chat.docs) {
      m.reference.delete();
    }

    doc = _firestore.collection('groups').doc(groupId);
    await doc.delete();
  }

  //metodo responsavel por salvar os grupos
  Future saveGroup(Map<String, dynamic> data) async {
    if (data["users"].length == 0) {
      await deleteGroup(data["id"]);
      return;
    }
    DocumentReference doc;
    data["update"] = DateTime.now();
    if (data.containsKey("id")) {
      doc = _firestore.collection('groups').doc(data["id"]);
      return await doc.get().then((value) async {
        print(
            "\n\n******************** ID SETADO NO BANCO -> ${value.id} \n********************\n\n");
        return await doc.set(data).then((value) {
          print("Grupo Setado");
          return true;
        });
      });
    } else {
      doc = _firestore.collection('groups').doc();
    }
    if (data["users"].length == 0) {}
  }
}
