// To parse this JSON data, do
//
//     final listJadwalFIlm = listJadwalFIlmFromJson(jsonString);

import 'dart:convert';

ListJadwalFIlm listJadwalFIlmFromJson(String str) =>
    ListJadwalFIlm.fromJson(json.decode(str));

String listJadwalFIlmToJson(ListJadwalFIlm data) => json.encode(data.toJson());

class ListJadwalFIlm {
  String? message;
  Data? data;

  ListJadwalFIlm({this.message, this.data});

  factory ListJadwalFIlm.fromJson(Map<String, dynamic> json) => ListJadwalFIlm(
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
            json["data"]!.map((x) => DatumJadwal.fromJson(x)),
          ),
    firstPageUrl: json["first_page_url"],
    from: json["from"],
    lastPage: json["last_page"],
    lastPageUrl: json["last_page_url"],
    links: json["links"] == null
        ? []
        : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
    nextPageUrl: json["next_page_url"],
    path: json["path"],
    perPage: json["per_page"],
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
  dynamic cinema;
  DateTime? startTime;
  dynamic endTime;
  dynamic price;
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
    cinema: json["cinema"],
    startTime: json["start_time"] == null
        ? null
        : DateTime.parse(json["start_time"]),
    endTime: json["end_time"],
    price: json["price"],
    format: json["format"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "film": film?.toJson(),
    "cinema": cinema,
    "start_time": startTime?.toIso8601String(),
    "end_time": endTime,
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

class Link {
  String? url;
  String? label;
  bool? active;

  Link({this.url, this.label, this.active});

  factory Link.fromJson(Map<String, dynamic> json) =>
      Link(url: json["url"], label: json["label"], active: json["active"]);

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "active": active,
  };
}
