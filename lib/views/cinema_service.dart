import 'dart:convert';
import 'dart:io';

import 'package:cinemax/api/endpoint/endpoint.dart';
import 'package:cinemax/models/get_cinema_model.dart';
import 'package:cinemax/shared_preferenced/preference.dart';
import 'package:http/http.dart' as http;

class CinemaService {
  /// Fetch semua cinema
  static Future<List<DatumCinema>> fetchCinemas() async {
    final url = Uri.parse(Endpoint.Cinema);
    final token = await PreferenceHandler.getToken();

    final response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = getCinemaFromJson(response.body);
      return data.data ?? [];
    } else {
      throw Exception("Gagal load cinemas (${response.statusCode})");
    }
  }

  /// Tambah cinema baru
  static Future<DatumCinema> addCinema({
    required String name,
    File? imageFile,
  }) async {
    final url = Uri.parse(Endpoint.Cinema);
    final token = await PreferenceHandler.getToken();

    String imageBase64 = "";
    if (imageFile != null) {
      final bytes = imageFile.readAsBytesSync();
      imageBase64 = base64Encode(bytes);
    }

    final body = {
      "name": name,
      "image_base64": imageBase64,
    };

    final response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = DatumCinema.fromJson(json.decode(response.body)["data"]);
      return data;
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Gagal menambahkan cinema");
    }
  }

  /// Update cinema
  static Future<DatumCinema> updateCinema({
    required int id,
    required String name,
    File? imageFile,
  }) async {
    final url = Uri.parse("${Endpoint.Cinema}/$id");
    final token = await PreferenceHandler.getToken();

    String imageBase64 = "";
    if (imageFile != null) {
      final bytes = imageFile.readAsBytesSync();
      imageBase64 = base64Encode(bytes);
    }

    final body = {
      "name": name,
      "image_base64": imageBase64,
    };

    final response = await http.put(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = DatumCinema.fromJson(json.decode(response.body)["data"]);
      return data;
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Gagal update cinema");
    }
  }

  /// Delete cinema
  static Future<void> deleteCinema(int id) async {
    final url = Uri.parse("${Endpoint.Cinema}/$id");
    final token = await PreferenceHandler.getToken();

    final response = await http.delete(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Gagal menghapus cinema");
    }
  }
}
