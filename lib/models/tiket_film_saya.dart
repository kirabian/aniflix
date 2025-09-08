// To parse this JSON data, do
//
//     final tiketFilmSaya = tiketFilmSayaFromJson(jsonString);

import 'dart:convert';

TiketFilmSaya tiketFilmSayaFromJson(String str) =>
    TiketFilmSaya.fromJson(json.decode(str));

String tiketFilmSayaToJson(TiketFilmSaya data) => json.encode(data.toJson());

class TiketFilmSaya {
  String? message;
  List<Datum>? data;

  TiketFilmSaya({this.message, this.data});

  factory TiketFilmSaya.fromJson(Map<String, dynamic> json) => TiketFilmSaya(
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
  int? quantity;
  String? totalPrice;
  Schedule? schedule;
  DateTime? createdAt;

  Datum({
    this.id,
    this.quantity,
    this.totalPrice,
    this.schedule,
    this.createdAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"] is int ? json["id"] : int.tryParse(json["id"].toString()),
    quantity: json["quantity"] is int
        ? json["quantity"]
        : int.tryParse(json["quantity"].toString()),
    totalPrice: json["total_price"]?.toString(),
    schedule: json["schedule"] == null
        ? null
        : Schedule.fromJson(json["schedule"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.tryParse(json["created_at"].toString()),
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
    id: json["id"] is int ? json["id"] : int.tryParse(json["id"].toString()),
    startTime: json["start_time"] == null
        ? null
        : DateTime.tryParse(json["start_time"].toString()),
    endTime: json["end_time"] == null
        ? null
        : DateTime.tryParse(json["end_time"].toString()),
    price: json["price"]?.toString(),
    format: json["format"]?.toString(),
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
    id: json["id"] is int ? json["id"] : int.tryParse(json["id"].toString()),
    name: json["name"]?.toString(),
    imageUrl: json["image_url"]?.toString(),
    imagePath: json["image_path"]?.toString(),
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
    id: json["id"] is int ? json["id"] : int.tryParse(json["id"].toString()),
    title: json["title"]?.toString(),
    genre: json["genre"]?.toString(),
    imageUrl: json["image_url"]?.toString(),
    imagePath: json["image_path"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "genre": genre,
    "image_url": imageUrl,
    "image_path": imagePath,
  };
}
