// To parse this JSON data, do
//
//     final addFIlm = addFIlmFromJson(jsonString);

import 'dart:convert';

AddFIlm addFIlmFromJson(String str) => AddFIlm.fromJson(json.decode(str));

String addFIlmToJson(AddFIlm data) => json.encode(data.toJson());

class AddFIlm {
  String? message;
  Data? data;

  AddFIlm({this.message, this.data});

  factory AddFIlm.fromJson(Map<String, dynamic> json) => AddFIlm(
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"message": message, "data": data?.toJson()};
}

class Data {
  int? id;
  String? title;
  String? description;
  String? genre;
  String? director;
  String? writer;
  String? stats;
  String? imageUrl;
  String? imagePath;
  String? youtubeUrl;
  List<Cinema>? cinemas;
  List<dynamic>? schedules;

  Data({
    this.id,
    this.title,
    this.description,
    this.genre,
    this.director,
    this.writer,
    this.stats,
    this.imageUrl,
    this.imagePath,
    this.youtubeUrl,
    this.cinemas,
    this.schedules,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    genre: json["genre"],
    director: json["director"],
    writer: json["writer"],
    stats: json["stats"],
    imageUrl: json["image_url"],
    imagePath: json["image_path"],
    youtubeUrl: json["youtube_url"],
    cinemas: json["cinemas"] == null
        ? []
        : List<Cinema>.from(json["cinemas"]!.map((x) => Cinema.fromJson(x))),
    schedules: json["schedules"] == null
        ? []
        : List<dynamic>.from(json["schedules"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "genre": genre,
    "director": director,
    "writer": writer,
    "stats": stats,
    "image_url": imageUrl,
    "image_path": imagePath,
    "youtube_url": youtubeUrl,
    "cinemas": cinemas == null
        ? []
        : List<dynamic>.from(cinemas!.map((x) => x.toJson())),
    "schedules": schedules == null
        ? []
        : List<dynamic>.from(schedules!.map((x) => x)),
  };
}

class Cinema {
  int? id;
  String? name;
  String? imageUrl;
  String? imagePath;

  Cinema({this.id, this.name, this.imageUrl, this.imagePath});

  factory Cinema.fromJson(Map<String, dynamic> json) => Cinema(
    id: json["id"],
    name: json["name"],
    imageUrl: json["image_url"],
    imagePath: json["image_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image_url": imageUrl,
    "image_path": imagePath,
  };
}
