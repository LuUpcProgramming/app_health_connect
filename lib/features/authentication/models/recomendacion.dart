class Recomendacion2 {
  String idDocumento;
  String idUsuario;
  String titulo;
  String descripcion;
  String descripcion2;
  int tipoActividad;
  String fechaRegistro;
  String horaRegistro;

  Recomendacion2({
    this.idDocumento='0',
    required this.idUsuario,
    required this.titulo,
    required this.descripcion,
    required this.descripcion2,
    this.tipoActividad = 0,
    required this.fechaRegistro,
    required this.horaRegistro,
  });

  Map<String, dynamic> toJson() {
    return {
      'idDocumento': idDocumento,
      'idUsuario': idUsuario,
      'titulo': titulo,
      'descripcion': descripcion,
      'descripcion2': descripcion2,
      'tipoActividad': tipoActividad,
      'fechaRegistro': fechaRegistro,
      'horaRegistro': horaRegistro,
    };
  }

  factory Recomendacion2.fromMap(Map<String, dynamic> map) {
    return Recomendacion2(
      idDocumento: map['idDocumento'],
      idUsuario: map['idUsuario'],
      titulo: map['titulo'],
      descripcion: map['descripcion'],
      descripcion2: map['descripcion2'],
      tipoActividad: map['tipoActividad'],
      fechaRegistro: map['fechaRegistro'],
      horaRegistro: map['horaRegistro'],
    );
  }

  @override
  String toString() {
    return 'Recomendacion(idDocumento: $idDocumento, idUsuario: $idUsuario, titulo: $titulo, descripcion: $descripcion, descripcion2: $descripcion2, tipoActividad: $tipoActividad, fechaRegistro: $fechaRegistro, horaRegistro: $horaRegistro)';
  }
}

class Recomendacion {
  String idDocumento;
  String idUsuario;
  String titulo;
  List<String> descripcion;
  List<String> beneficios;
  String fechaRegistro;
  String horaRegistro;

  Recomendacion({
    this.idDocumento='0',
    this.idUsuario='0',
    required this.titulo,
    required this.descripcion,
    required this.beneficios,
    this.fechaRegistro='',
    this.horaRegistro='',
  });

  Map<String, dynamic> toJson() {
    return {
      'idDocumento': idDocumento,
      'idUsuario': idUsuario,
      'titulo': titulo,
      'descripcion': descripcion,
      'beneficios': beneficios,
      'fechaRegistro': fechaRegistro,
      'horaRegistro': horaRegistro,
    };
  }

  // Método para crear un objeto Recomendacion desde un Map (JSON)
  factory Recomendacion.fromJson(Map<String, dynamic> json) {
    return Recomendacion(
      titulo: json['titulo'],
      descripcion: List<String>.from(json['descripcion']),
      beneficios: List<String>.from(json['beneficios']),
    );
  }

  factory Recomendacion.fromMap(Map<String, dynamic> json) {
    return Recomendacion(
      idDocumento: json['idDocumento'],
      idUsuario: json['idUsuario'],
      titulo: json['titulo'],
      descripcion: List<String>.from(json['descripcion']),
      beneficios: List<String>.from(json['beneficios']),
      fechaRegistro: json['fechaRegistro'],
      horaRegistro: json['horaRegistro'],
    );
  }
}
