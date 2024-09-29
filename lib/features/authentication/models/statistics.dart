import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Estadisticas {
  final String estadoAnimoPromedio;
  final String mensajeEstadoAnimo;
  final List<int> progresoLogros;
  final List<int> progresoPlanes;
  // final List<int> progresoSemanal;
  // final List<int> progresoMensual;
  final List<Logro> logros;

  Estadisticas({
    required this.estadoAnimoPromedio,
    required this.mensajeEstadoAnimo,
    required this.progresoLogros,
    required this.progresoPlanes,
    required this.logros,
  });
}

class Logro {
  final String titulo;
  final IconData icono;

  Logro({
    required this.titulo,
    required this.icono,
  });
}

class EstadisticasDiaria {
  String fecha;
  String estadoAnimo;
  String descripcionAnimo;
  int cantPlanTotal;
  int cantPlanCumplido;
  List<int> logros;
  DateTime fechaRegistro;

  EstadisticasDiaria({
    this.fecha = '',
    this.estadoAnimo = '',
    this.descripcionAnimo = '',
    this.cantPlanTotal = 0,
    this.cantPlanCumplido = 0,
    this.logros = const [],
    required DateTime? fechaRegistro,
    }
  ) : fechaRegistro = fechaRegistro ?? DateTime.now();

  //Crea un constructor vacio
  EstadisticasDiaria.empty() : fecha = '', estadoAnimo = '', descripcionAnimo = '', cantPlanTotal = 0, cantPlanCumplido = 0, logros = [], fechaRegistro = DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'fecha': fecha,
      'estadoAnimo': estadoAnimo,
      'descripcionAnimo': descripcionAnimo,
      'cantPlanTotal': cantPlanTotal,
      'cantPlanCumplido': cantPlanCumplido,
      'logros': logros,
      'fechaRegistro': Timestamp.fromDate(fechaRegistro),
    };
  }

  factory EstadisticasDiaria.fromJson(Map<String, dynamic> json) {
    return EstadisticasDiaria(
      fecha:  json['fecha'] ?? '', // Asumiendo que 'fecha' es un String en formato ISO8601
      estadoAnimo: json['estadoAnimo'] ?? '',
      descripcionAnimo: json['descripcionAnimo'] ?? '',
      cantPlanTotal: json['cantPlanTotal'] ?? 0,
      cantPlanCumplido: json['cantPlanCumplido'] ?? 0,
      logros: List<int>.from(json['logros'] ?? []),
      fechaRegistro: (json['fechaRegistro'] as Timestamp).toDate(),
    );
  }

  // Método para crear una instancia desde un snapshot de base de datos (Firebase, por ejemplo)
  factory EstadisticasDiaria.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return EstadisticasDiaria(
        fecha: data['fecha'] ?? '', // Asumiendo que 'fecha' es un String en formato ISO8601
        estadoAnimo: data['estadoAnimo'] ?? '',
        descripcionAnimo: data['descripcionAnimo'] ?? '',
        cantPlanTotal: data['cantPlanTotal'] ?? 0,
        cantPlanCumplido: data['cantPlanCumplido'] ?? 0,
        logros: List<int>.from(data['logros'] ?? []),
        fechaRegistro: (data['fechaRegistro'] as Timestamp).toDate(),
      );
    } else {
      return EstadisticasDiaria(
        fecha: '',
        estadoAnimo: '',
        descripcionAnimo: '',
        cantPlanTotal: 0,
        cantPlanCumplido: 0,
        logros: [],
        fechaRegistro: DateTime.now(),
      );
    }
  }
}

class EstadisticasSemanal {
   String estadoAnimoPromedio;
   String mensajeEstadoAnimo;
   List<int> progresoLogros;
   List<int> progresoPlanes;
  // final List<int> progresoSemanal;
  // final List<int> progresoMensual;
   List<int> logros;

  EstadisticasSemanal({
     this.estadoAnimoPromedio='',
     this.mensajeEstadoAnimo='',
     this.progresoLogros=const [],
     this.progresoPlanes=const [],
     this.logros= const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'estadoAnimoPromedio': estadoAnimoPromedio,
      'mensajeEstadoAnimo': mensajeEstadoAnimo,
      'progresoLogros': progresoLogros,
      'progresoPlanes': progresoPlanes,
      'logros': logros,
    };
  }

  factory EstadisticasSemanal.fromJson(Map<String, dynamic> json) {
    return EstadisticasSemanal(
      estadoAnimoPromedio: json['estadoAnimoPromedio'] ?? '',
      mensajeEstadoAnimo: json['mensajeEstadoAnimo'] ?? '',
      progresoLogros: json['progresoLogros'] ?? 0,
      progresoPlanes: json['progresoPlanes'] ?? 0,
      logros: List<int>.from(json['logros'] ?? []),
    );
  }

  // Método para crear una instancia desde un snapshot de base de datos (Firebase, por ejemplo)
  factory EstadisticasSemanal.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return EstadisticasSemanal(// Asumiendo que 'fecha' es un String en formato ISO8601
        estadoAnimoPromedio: data['estadoAnimoPromedio'] ?? '',
        mensajeEstadoAnimo: data['mensajeEstadoAnimo'] ?? '',
        progresoLogros: List<int>.from(data['progresoLogros'] ?? []),
        progresoPlanes: List<int>.from(data['progresoPlanes'] ?? []),
        logros: List<int>.from(data['logros'] ?? []),
      );
    } else {
      return EstadisticasSemanal(
        estadoAnimoPromedio: '',
        mensajeEstadoAnimo: '',
        progresoLogros: [],
        progresoPlanes: [],
        logros: [],
      );
    }
  }


}
