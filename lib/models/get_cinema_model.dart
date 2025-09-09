import 'dart:convert';

GetCinema getCinemaFromJson(String str) => GetCinema.fromJson(json.decode(str));
String getCinemaToJson(GetCinema data) => json.encode(data.toJson());

class GetCinema {
  String? message;
  List<Datum>? data;

  GetCinema({this.message, this.data});

  factory GetCinema.fromJson(Map<String, dynamic> json) => GetCinema(
    message: json["message"],
    data: json["data"] == null
        ? []
        : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? id;
  String? name;
  String? imagePath;
  String? imageUrl;

  Datum({this.id, this.name, this.imagePath, this.imageUrl});

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    imagePath: json["image_path"],
    imageUrl: json["image_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image_path": imagePath,
    "image_url": imageUrl,
  };
}
