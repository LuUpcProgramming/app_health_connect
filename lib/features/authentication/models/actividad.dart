import 'package:flutter/material.dart';

class Tarea {
  final String nombre;
  final String hora;
  final IconData icono;
  IconData logro;
  String descripcionLogro='';
  String mensaje = '';
  String estado = '1';
  bool completada;

  Tarea(this.nombre, this.hora, this.icono, this.logro, this.mensaje,
      this.completada);
}
