// To parse this JSON data, do
//
//     final updateTiket = updateTiketFromJson(jsonString);

import 'dart:convert';

UpdateTiket updateTiketFromJson(String str) =>
    UpdateTiket.fromJson(json.decode(str));

String updateTiketToJson(UpdateTiket data) => json.encode(data.toJson());

class UpdateTiket {
  String? message;
  Data? data;

  UpdateTiket({this.message, this.data});

  factory UpdateTiket.fromJson(Map<String, dynamic> json) => UpdateTiket(
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"message": message, "data": data?.toJson()};
}

class Data {
  int? id;
  int? userId;
  int? scheduleId;
  int? quantity;
  DateTime? createdAt;
  DateTime? updatedAt;

  Data({
    this.id,
    this.userId,
    this.scheduleId,
    this.quantity,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    userId: json["user_id"],
    scheduleId: json["schedule_id"],
    quantity: json["quantity"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "schedule_id": scheduleId,
    "quantity": quantity,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
