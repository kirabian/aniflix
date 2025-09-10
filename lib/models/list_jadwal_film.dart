// To parse this JSON data, do
//
//     final listJadwalFilm = listJadwalFilmFromJson(jsonString);

import 'dart:convert';

ListJadwalFilm listJadwalFilmFromJson(String str) =>
    ListJadwalFilm.fromJson(json.decode(str));

String listJadwalFilmToJson(ListJadwalFilm data) => json.encode(data.toJson());

class ListJadwalFilm {
  String? message;
  Data? data;

  ListJadwalFilm({this.message, this.data});

  factory ListJadwalFilm.fromJson(Map<String, dynamic> json) => ListJadwalFilm(
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"message": message, "data": data?.toJson()};
}

class Data {
  int? currentPage;
  List<DatumJadwal>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links;
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  Data({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    currentPage: json["current_page"],
    data: json["data"] == null
        ? []
        : List<DatumJadwal>.from(
            json["data"].map((x) => DatumJadwal.fromJson(x)),
          ),
    firstPageUrl: json["first_page_url"],
    from: json["from"],
    lastPage: json["last_page"],
    lastPageUrl: json["last_page_url"],
    links: json["links"] == null
        ? []
        : List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
    nextPageUrl: json["next_page_url"],
    path: json["path"],
    perPage: int.tryParse(json["per_page"]?.toString() ?? "0"),
    prevPageUrl: json["prev_page_url"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,
    "links": links == null
        ? []
        : List<dynamic>.from(links!.map((x) => x.toJson())),
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };
}

class DatumJadwal {
  int? id;
  Film? film;
  Cinema? cinema;
  DateTime? startTime;
  DateTime? endTime;
  int? price;
  dynamic format;
  DateTime? createdAt;
  DateTime? updatedAt;

  DatumJadwal({
    this.id,
    this.film,
    this.cinema,
    this.startTime,
    this.endTime,
    this.price,
    this.format,
    this.createdAt,
    this.updatedAt,
  });

  factory DatumJadwal.fromJson(Map<String, dynamic> json) => DatumJadwal(
    id: json["id"],
    film: json["film"] == null ? null : Film.fromJson(json["film"]),
    cinema: json["cinema"] == null ? null : Cinema.fromJson(json["cinema"]),
    startTime: json["start_time"] == null
        ? null
        : DateTime.tryParse(json["start_time"]),
    endTime: json["end_time"] == null
        ? null
        : DateTime.tryParse(json["end_time"]),
    // ✅ FIX: Logika parsing harga diperbaiki untuk menangani string desimal
    price: json["price"] == null
        ? null
        : double.tryParse(json["price"].toString())?.toInt(),
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
    "film": film?.toJson(),
    "cinema": cinema?.toJson(),
    "start_time": startTime?.toIso8601String(),
    "end_time": endTime?.toIso8601String(),
    "price": price,
    "format": format,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Film {
  int? id;
  String? title;
  String? genre;
  String? imageUrl;
  String? imagePath;
  dynamic youtubeUrl;
  dynamic youtubeEmbedUrl;

  Film({
    this.id,
    this.title,
    this.genre,
    this.imageUrl,
    this.imagePath,
    this.youtubeUrl,
    this.youtubeEmbedUrl,
  });

  factory Film.fromJson(Map<String, dynamic> json) => Film(
    id: json["id"],
    title: json["title"],
    genre: json["genre"],
    imageUrl: json["image_url"],
    imagePath: json["image_path"],
    youtubeUrl: json["youtube_url"],
    youtubeEmbedUrl: json["youtube_embed_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "genre": genre,
    "image_url": imageUrl,
    "image_path": imagePath,
    "youtube_url": youtubeUrl,
    "youtube_embed_url": youtubeEmbedUrl,
  };
}

class Cinema {
  int? id;
  String? name;
  String? imageUrl;

  Cinema({this.id, this.name, this.imageUrl});

  factory Cinema.fromJson(Map<String, dynamic> json) =>
      Cinema(id: json["id"], name: json["name"], imageUrl: json["image_url"]);

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image_url": imageUrl,
  };
}

class Link {
  String? url;
  String? label;
  bool? active;

  Link({this.url, this.label, this.active});

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url: json["url"],
    label: json["label"]?.toString(),
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "active": active,
  };
}
