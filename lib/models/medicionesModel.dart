// To parse this JSON data, do
//
//     final medicionesModel = medicionesModelFromJson(jsonString);

import 'dart:convert';

List<MedicionesModel> medicionesModelFromJson(String str) => List<MedicionesModel>.from(json.decode(str).map((x) => MedicionesModel.fromJson(x)));

String medicionesModelToJson(List<MedicionesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MedicionesModel {
    MedicionesModel({
        this.id,
        this.sis,
        this.dia,
        this.pul,
        this.ari,
        this.add,
        this.idMedicion,
        this.medicionUser,
        this.publishedAt,
        this.createdAt,
        this.updatedAt,
    });

    int id;
    int sis;
    int dia;
    int pul;
    int ari;
    DateTime add;
    dynamic idMedicion;
    dynamic medicionUser;
    DateTime publishedAt;
    DateTime createdAt;
    DateTime updatedAt;

    factory MedicionesModel.fromJson(Map<String, dynamic> json) => MedicionesModel(
        id: json["id"],
        sis: json["sis"],
        dia: json["dia"],
        pul: json["pul"],
        ari: json["ari"],
        add: json["add"] == null ? null : DateTime.parse(json["add"]),
        idMedicion: json["id_medicion"],
        medicionUser: json["medicion_user"],
        publishedAt: DateTime.parse(json["published_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "sis": sis,
        "dia": dia,
        "pul": pul,
        "ari": ari,
        "add": add == null ? null : add.toIso8601String(),
        "id_medicion": idMedicion,
        "medicion_user": medicionUser,
        "published_at": publishedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
