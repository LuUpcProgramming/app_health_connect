import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryAdvice {
  String title;
  String description;
  String date;
 

  HistoryAdvice({
    required this.title,
    required this.description,
    required this.date,
  });

  // Método para convertir un UserProfile a un mapa (útil para JSON)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'date': date,
    };
  }

  // Método para crear un UserProfile desde un mapa (útil para JSON)
  factory HistoryAdvice.fromJson(Map<String, dynamic> json) {
    return HistoryAdvice(
      title: json['title'],
      description: json['description'],
      date: json['date'],
    );
  }

  factory HistoryAdvice.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return HistoryAdvice(
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        date: data['date'] ?? '',
      );
    }
    return throw Exception();
  }
}
