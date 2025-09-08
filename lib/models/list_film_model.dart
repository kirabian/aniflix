// To parse this JSON data, do
//
//     final listFilmModel = listFilmModelFromJson(jsonString);

import 'dart:convert';

ListFilmModel listFilmModelFromJson(String str) =>
    ListFilmModel.fromJson(json.decode(str));

String listFilmModelToJson(ListFilmModel data) => json.encode(data.toJson());

class ListFilmModel {
  String? message;
  List<Datum>? data;

  ListFilmModel({this.message, this.data});

  factory ListFilmModel.fromJson(Map<String, dynamic> json) => ListFilmModel(
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
  String? title;
  String? description;
  String? genre;
  String? director;
  String? writer;
  String? stats;
  String? imageUrl;
  String? imagePath;
  dynamic youtubeUrl;
  List<dynamic>? cinemas;
  List<Schedule>? schedules;

  Datum({
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

  factory Datum.fromJson(Map<String, dynamic> json) {
    // 🔥 Fix parsing schedules yang bisa dynamic
    List<Schedule> parsedSchedules = [];
    if (json["schedules"] is List) {
      parsedSchedules = (json["schedules"] as List)
          .map((x) => Schedule.fromJson(x))
          .toList();
    } else if (json["schedules"] is Map) {
      parsedSchedules = [Schedule.fromJson(json["schedules"])];
    } else {
      parsedSchedules = [];
    }

    return Datum(
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
          : List<dynamic>.from(json["cinemas"]!.map((x) => x)),
      schedules: parsedSchedules,
    );
  }

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
        : List<dynamic>.from(cinemas!.map((x) => x)),
    "schedules": schedules == null
        ? []
        : List<dynamic>.from(schedules!.map((x) => x.toJson())),
  };
}

class Schedule {
  int? id;
  String? filmId;
  dynamic cinemaId;
  DateTime? startTime;
  dynamic endTime;
  dynamic price;
  dynamic format;
  DateTime? createdAt;
  DateTime? updatedAt;

  Schedule({
    this.id,
    this.filmId,
    this.cinemaId,
    this.startTime,
    this.endTime,
    this.price,
    this.format,
    this.createdAt,
    this.updatedAt,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
    id: json["id"],
    filmId: json["film_id"]?.toString(),
    cinemaId: json["cinema_id"],
    startTime: json["start_time"] == null
        ? null
        : DateTime.tryParse(json["start_time"]),
    endTime: json["end_time"],
    price: json["price"],
    format: json["format"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.tryParse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.tryParse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "film_id": filmId,
    "cinema_id": cinemaId,
    "start_time": startTime?.toIso8601String(),
    "end_time": endTime,
    "price": price,
    "format": format,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
