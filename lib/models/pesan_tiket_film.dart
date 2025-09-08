// To parse this JSON data, do
//
//     final pesanTiketFilm = pesanTiketFilmFromJson(jsonString);

import 'dart:convert';

PesanTiketFilm pesanTiketFilmFromJson(String str) =>
    PesanTiketFilm.fromJson(json.decode(str));

String pesanTiketFilmToJson(PesanTiketFilm data) => json.encode(data.toJson());

class PesanTiketFilm {
  String? message;
  Data? data;

  PesanTiketFilm({this.message, this.data});

  factory PesanTiketFilm.fromJson(Map<String, dynamic> json) => PesanTiketFilm(
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"message": message, "data": data?.toJson()};
}

class Data {
  int? id;
  int? quantity;
  String? totalPrice;
  Schedule? schedule;
  DateTime? createdAt;

  Data({
    this.id,
    this.quantity,
    this.totalPrice,
    this.schedule,
    this.createdAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    quantity: json["quantity"],
    totalPrice: json["total_price"],
    schedule: json["schedule"] == null
        ? null
        : Schedule.fromJson(json["schedule"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "quantity": quantity,
    "total_price": totalPrice,
    "schedule": schedule?.toJson(),
    "created_at": createdAt?.toIso8601String(),
  };
}

class Schedule {
  int? id;
  DateTime? startTime;
  DateTime? endTime;
  String? price;
  String? format;
  Film? film;
  Cinema? cinema;

  Schedule({
    this.id,
    this.startTime,
    this.endTime,
    this.price,
    this.format,
    this.film,
    this.cinema,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
    id: json["id"],
    startTime: json["start_time"] == null
        ? null
        : DateTime.parse(json["start_time"]),
    endTime: json["end_time"] == null ? null : DateTime.parse(json["end_time"]),
    price: json["price"],
    format: json["format"],
    film: json["film"] == null ? null : Film.fromJson(json["film"]),
    cinema: json["cinema"] == null ? null : Cinema.fromJson(json["cinema"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "start_time": startTime?.toIso8601String(),
    "end_time": endTime?.toIso8601String(),
    "price": price,
    "format": format,
    "film": film?.toJson(),
    "cinema": cinema?.toJson(),
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

class Film {
  int? id;
  String? title;
  String? genre;
  String? imageUrl;
  String? imagePath;

  Film({this.id, this.title, this.genre, this.imageUrl, this.imagePath});

  factory Film.fromJson(Map<String, dynamic> json) => Film(
    id: json["id"],
    title: json["title"],
    genre: json["genre"],
    imageUrl: json["image_url"],
    imagePath: json["image_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "genre": genre,
    "image_url": imageUrl,
    "image_path": imagePath,
  };
}
