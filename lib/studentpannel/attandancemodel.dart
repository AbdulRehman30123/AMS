// To parse this JSON data, do
//
//     final attandancerecord = attandancerecordFromJson(jsonString);

import 'dart:convert';

Attandancerecord attandancerecordFromJson(String str) =>
    Attandancerecord.fromJson(json.decode(str));

String attandancerecordToJson(Attandancerecord data) =>
    json.encode(data.toJson());

class Attandancerecord {
  String id;
  String attandanceStatus;

  Attandancerecord({
    required this.id,
    required this.attandanceStatus,
  });

  factory Attandancerecord.fromJson(Map<String, dynamic> json) =>
      Attandancerecord(
        id: json["id"],
        attandanceStatus: json["attandance status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attandance status": attandanceStatus,
      };
}
