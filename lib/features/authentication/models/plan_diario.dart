import 'package:flutter/material.dart';

class PlanDiario {
  String idDocumento; // ID del documento en Firebase
  String idUsuario; // ID del usuario al que pertenece el plan diario
  String meta;
  String tipoActividad;
  List<String> listaDias;
  String diaPlan;
  String fechaPlan;
  int estadoPlan;
  String hora;
  String periodo;
  String mensaje;
  String recomendacion;
  int tipoLogro;

  IconData iconoLogro;
  IconData iconoPlan;

  String fechaRegistro;
  String horaRegistro;
  String identificadorPlan;

  PlanDiario(
      {this.idDocumento = '0',
      required this.idUsuario,
      required this.meta,
      required this.tipoActividad,
      this.listaDias = const [],
      required this.diaPlan,
      required this.fechaPlan,
      this.estadoPlan = 0,
      required this.hora,
      required this.periodo,
      this.mensaje = '',
      this.recomendacion = '',
      this.tipoLogro = 0,
      this.iconoLogro = Icons.report_off,
      this.iconoPlan = Icons.report_off,
      required this.fechaRegistro,
      required this.horaRegistro,
      this.identificadorPlan = ''});

  // Método para convertir el modelo a un mapa (útil para guardar en Firebase)
  Map<String, dynamic> toJson() {
    return {
      'idDocumento': idDocumento,
      'idUsuario': idUsuario,
      'meta': meta,
      'tipoActividad': tipoActividad,
      'diaPlan': diaPlan,
      'fechaPlan': fechaPlan,
      'estadoPlan': estadoPlan,
      'hora': hora,
      'periodo': periodo,
      'mensaje': mensaje,
      'recomendacion': recomendacion,
      'tipoLogro': tipoLogro,
      'fechaRegistro': fechaRegistro,
      'horaRegistro': horaRegistro,
      'identificadorPlan': identificadorPlan,
    };
  }

  // Método para crear el modelo a partir de un mapa (útil para leer de Firebase)
  factory PlanDiario.fromMap(Map<String, dynamic> map) {
    return PlanDiario(
      idDocumento: map['idDocumento'],
      idUsuario: map['idUsuario'],
      meta: map['meta'],
      tipoActividad: map['tipoActividad'],
      diaPlan: map['diaPlan'],
      fechaPlan: map['fechaPlan'],
      estadoPlan: map['estadoPlan'],
      //  dias: List<String>.from(map['dias']),
      //  completados: List<int>.from(map['completados']),
      hora: map['hora'],
      periodo: map['periodo'],
      mensaje: map['mensaje'],
      recomendacion: map['recomendacion'],
      tipoLogro: map['tipoLogro'],
      fechaRegistro: map['fechaRegistro'],
      horaRegistro: map['horaRegistro'],
      identificadorPlan: map['identificadorPlan'],
    );
  }

  @override
  String toString() {
    return 'PlanDiario(idDocumento: $idDocumento,idUsuario: $idUsuario, meta: $meta, tipoActividad: $tipoActividad, hora: $hora, periodo: $periodo, mensaje: $mensaje, recomendacion: $recomendacion, tipoLogro: $tipoLogro)';
  }
}
