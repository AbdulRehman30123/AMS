import 'dart:convert';

Studentmodel studentmodelFromJson(String str) =>
    Studentmodel.fromJson(json.decode(str));

String studentmodelToJson(Studentmodel data) => json.encode(data.toJson());

class Studentmodel {
  Studentmodel(
      {required this.id,
      required this.studentName,
      required this.Email,
      required this.numberofabsents,
      required this.numberofleaves,
      required this.numberofpresents,
      required this.leavestatus});

  String id;
  String studentName;
  String Email;
  int numberofabsents;
  int numberofpresents;
  int numberofleaves;
  var leavestatus;

  factory Studentmodel.fromJson(Map<String, dynamic> json) => Studentmodel(
      id: json["id"],
      studentName: json["student name"],
      Email: json['Email'],
      numberofabsents: json['number of absents'],
      numberofleaves: json['number of leaves'],
      numberofpresents: json['number of presents'],
      leavestatus: json['leave status']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "student name": studentName,
        "Email": Email,
        "number of absents": numberofabsents,
        "number of leaves": numberofleaves,
        "number of presents": numberofpresents,
        "leave status": leavestatus
      };
}
