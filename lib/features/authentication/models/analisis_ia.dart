import 'dart:convert';

AnalisisIA welcomeFromJson(String str) => AnalisisIA.fromJson(json.decode(str));

String welcomeToJson(AnalisisIA data) => json.encode(data.toJson());

class AnalisisIA {
  String personal ;
  String imc ;
  String trabajo;
  String salud;
  String indTrabajo;
  String indSalud;

  AnalisisIA({
    this.personal = '',
    this.imc = '',
    this.trabajo = '',
    this.salud = '',
    this.indTrabajo = '',
    this.indSalud = '',
  });


  factory AnalisisIA.fromJson(Map<String, dynamic> json) => AnalisisIA(
        personal: json["personal"],
        imc: json["imc"],
        trabajo: json["trabajo"],
        salud: json["salud"],
        indTrabajo: json["ind_trabajo"],
        indSalud: json["ind_salud"],
      );

  Map<String, dynamic> toJson() => {
        "personal": personal,
        "imc": imc,
        "trabajo": trabajo,
        "salud": salud,
        "ind_trabajo": indTrabajo,
        "ind_salud": indSalud,
      };
}
