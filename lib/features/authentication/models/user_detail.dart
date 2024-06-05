import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetail {
  String idUsuario;
  String genero;
  String fechaNacimiento;
  String altura;
  String peso;
  String ocupacion;
  String modalidadTrabajo;
  String horasTrabajo;
  String tipoHorasTrabajo;
  String tipoContrato;
  String turnoTrabajo;
  List<String> opcionesSalud;

  UserDetail({
    required this.idUsuario,
    required this.genero,
    required this.fechaNacimiento,
    required this.altura,
    required this.peso,
    this.ocupacion = '',
    this.modalidadTrabajo = '',
    this.horasTrabajo = '',
    this.tipoHorasTrabajo = '',
    this.tipoContrato = '',
    this.turnoTrabajo = '',
    this.opcionesSalud = const [],
  });

  // Método para convertir un UserProfile a un mapa (útil para JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': idUsuario,
      'genero': genero,
      'fechaNacimiento': fechaNacimiento,
      'altura': altura,
      'peso': peso,
      'ocupacion': ocupacion,
      'modalidadTrabajo': modalidadTrabajo,
      'horasTrabajo': horasTrabajo,
      'tipoHorasTrabajo': tipoHorasTrabajo,
      'tipoContrato': tipoContrato,
      'turnoTrabajo': turnoTrabajo,
      'opcionesSalud': opcionesSalud,
    };
  }

  // Método para crear un UserProfile desde un mapa (útil para JSON)
  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      idUsuario: json['id'],
      genero: json['genero'],
      fechaNacimiento: json['fechaNacimiento'],
      altura: json['altura'],
      peso: json['peso'],
      ocupacion: json['ocupacion'],
      modalidadTrabajo: json['modalidadTrabajo'],
      horasTrabajo: json['horasTrabajo'],
      tipoHorasTrabajo: json['tipoHorasTrabajo'],
      tipoContrato: json['tipoContrato'],
      turnoTrabajo: json['turnoTrabajo'],
      opcionesSalud: List<String>.from(json['opcionesSalud']),
    );
  }

  factory UserDetail.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return UserDetail(
        idUsuario: document.id,
        genero: data['genero'] ?? '',
        fechaNacimiento: data['fechaNacimiento'] ?? '',
        altura: data['altura'] ?? '',
        peso: data['peso'] ?? '',
        ocupacion: data['ocupacion'] ?? '',
        modalidadTrabajo: data['modalidadTrabajo'] ?? '',
        horasTrabajo: data['horasTrabajo'] ?? '',
        tipoHorasTrabajo: data['tipoHorasTrabajo'] ??'',
        tipoContrato: data['tipoContrato'] ?? '',
        turnoTrabajo: data['turnoTrabajo'] ?? '',
        opcionesSalud: List<String>.from(data['opcionesSalud']),
      );
    }
    return throw Exception();
  }
}
