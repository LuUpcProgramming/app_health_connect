import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryAdvice {
  String idUsuario;
  List<HistoryAdviceDetail> listaHistorialDetalle;

  HistoryAdvice({
    required this.idUsuario,
    this.listaHistorialDetalle = const [],
  });

  set value(HistoryAdvice value) {}

  // Método para convertir un UserProfile a un mapa (útil para JSON)
  Map<String, dynamic> toJson() {
    return {
      'idUsuario': idUsuario,
      'listaHistorialDetalle':
          listaHistorialDetalle.map((message) => message.toJson()).toList(),
    };
  }

  // Método para crear un UserProfile desde un mapa (útil para JSON)
  factory HistoryAdvice.fromJson(Map<String, dynamic> json) {
    return HistoryAdvice(
        idUsuario: json['idUsuario'],
        listaHistorialDetalle:
            List<HistoryAdviceDetail>.from(json['listaHistorialDetalle']));
  }

  factory HistoryAdvice.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return HistoryAdvice(
          idUsuario: data['idUsuario'] ?? '',
          listaHistorialDetalle: (data['listaHistorialDetalle']
                  as List<dynamic>)
              .map((item) =>
                  HistoryAdviceDetail.fromJson(item as Map<String, dynamic>))
              .toList());
    } else {
      return HistoryAdvice(idUsuario: '0', listaHistorialDetalle: []);
    }
  }
}

class HistoryAdviceDetail {
  String title;
  String description;
  String date;
  String problema;
  String estadoAnimo;

  HistoryAdviceDetail({
    this.title = '',
    this.description = '',
    this.date = '',
    this.problema = '',
    this.estadoAnimo = ''
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'problema':problema,
      'estadoAnimo':estadoAnimo
      //'createdAt': createdAt,
    };
  }

  // Factory constructor to create an instance from a JSON map
  factory HistoryAdviceDetail.fromJson(Map<String, dynamic> json) {
    return HistoryAdviceDetail(
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      date: json['date'] ?? "",
      problema: json['problema'] ?? "",
      estadoAnimo: json['estadoAnimo'] ?? "",
    );
  }
}
