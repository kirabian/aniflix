import 'dart:convert';

GetCinema getCinemaFromJson(String str) => GetCinema.fromJson(json.decode(str));
String getCinemaToJson(GetCinema data) => json.encode(data.toJson());

class GetCinema {
  String? message;
  List<DatumCinema>? data;

  GetCinema({this.message, this.data});

  factory GetCinema.fromJson(Map<String, dynamic> json) => GetCinema(
    message: json["message"],
    data: json["data"] == null
        ? []
        : List<DatumCinema>.from(json["data"]!.map((x) => DatumCinema.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}
class DatumCinema {
  int? id;
  String? name;
  String? imagePath;
  String? imageUrl;

  DatumCinema({this.id, this.name, this.imagePath, this.imageUrl});

  factory DatumCinema.fromJson(Map<String, dynamic> json) => DatumCinema(
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
