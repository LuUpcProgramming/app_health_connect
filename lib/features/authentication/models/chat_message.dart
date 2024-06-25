import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  String idUsuario;
  List<ChatMessageDetail> listaMensajes;

  ChatMessageModel({
    required this.idUsuario,
    this.listaMensajes = const [],
  });

  // Convierte un documento de Firestore a un objeto ChatMessageModel
  factory ChatMessageModel.fromJson(
      Map<String, dynamic> json, String idUsuario) {
    return ChatMessageModel(
        idUsuario: idUsuario,
        listaMensajes: List<ChatMessageDetail>.from(json['listaMensajes']));
  }

  // Convierte un objeto ChatMessageModel a un documento de Firestore
  Map<String, dynamic> toJson() {
    return {
      'idUsuario': idUsuario,
      'listaMensajes':
          listaMensajes.map((message) => message.toJson()).toList(),
    };
  }

  factory ChatMessageModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return ChatMessageModel(
          idUsuario: document.id,
          // listaMensajes: List<ChatMessageDetail>.from(data['listaMensajes']),
          listaMensajes: (data['listaMensajes'] as List<dynamic>)
              .map((item) =>
                  ChatMessageDetail.fromJson(item as Map<String, dynamic>))
              .toList());
    } else {
      return ChatMessageModel(idUsuario: '0', listaMensajes: []);
    }
  }
}

class ChatMessageDetail {
  final String role; // 'user' or 'assistant'
  final String content;
  //DateTime createdAt;

  ChatMessageDetail({
    required this.role,
    required this.content,
    //DateTime? createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
      //'createdAt': createdAt,
    };
  }

  // Factory constructor to create an instance from a JSON map
  factory ChatMessageDetail.fromJson(Map<String, dynamic> json) {
    return ChatMessageDetail(
      role: json['role'],
      content: json['content'],
    );
  }
}
