class PlanDiario {
  String idUsuario; // ID del usuario al que pertenece el plan diario
  String meta;
  String tipoActividad;
  List<String> dias;
  String hora;
  String periodo;
  String mensaje;
  String recomendacion;
  int tipoLogro;

  PlanDiario({
    required this.idUsuario,
    required this.meta,
    required this.tipoActividad,
    required this.dias,
    required this.hora,
    required this.periodo,
    this.mensaje = '',
    this.recomendacion = '',
    this.tipoLogro = 0,
  });

  // Método para convertir el modelo a un mapa (útil para guardar en Firebase)
  Map<String, dynamic> toJson() {
    return {
      'idUsuario': idUsuario,
      'meta': meta,
      'tipoActividad': tipoActividad,
      'dias': dias,
      'hora': hora,
      'periodo': periodo,
      'mensaje': mensaje,
      'recomendacion': recomendacion,
      'tipoLogro': tipoLogro,

    };
  }

  // Método para crear el modelo a partir de un mapa (útil para leer de Firebase)
  factory PlanDiario.fromMap(Map<String, dynamic> map) {
    return PlanDiario(
      idUsuario: map['idUsuario'],
      meta: map['meta'],
      tipoActividad: map['tipoActividad'],
      dias: List<String>.from(map['dias']),
      hora: map['hora'],
      periodo: map['periodo'],
      mensaje: map['mensaje'],
      recomendacion: map['recomendacion'],
      tipoLogro: map['tipoLogro'],
    );
  }
}
