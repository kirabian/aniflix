import 'dart:convert';
import 'dart:io';

import 'package:cinemax/api/endpoint/endpoint.dart';
import 'package:cinemax/models/add_film_model.dart';
import 'package:cinemax/models/list_film_model.dart';
import 'package:cinemax/models/list_jadwal_film.dart';
import 'package:cinemax/shared_preferenced/preference.dart';
import 'package:http/http.dart' as http;

class FilmService {
  // Fetch semua film
  static Future<List<Datum>> fetchFilms() async {
    final url = Uri.parse(Endpoint.films);
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
      final data = listFilmModelFromJson(response.body);
      return data.data ?? [];
    } else {
      throw Exception("Gagal load films (${response.statusCode})");
    }
  }

  // Fetch jadwal film berdasarkan filmId
  static Future<List<DatumJadwal>> fetchJadwalFilmById(int filmId) async {
    final url = Uri.parse("${Endpoint.jadwalFilms}?film_id=$filmId");
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
      final data = listJadwalFilmFromJson(response.body);
      return data.data?.data ?? [];
    } else {
      throw Exception("Gagal load jadwal film (${response.statusCode})");
    }
  }

  // Tambah film baru
  static Future<AddFIlm> addFilm({
    required String title,
    required String description,
    String? genre,
    String? director,
    String? writer,
    String? stats,
    String? youtubeUrl,
    File? imageFile,
    String? scheduleDate,
    String? scheduleTime,
  }) async {
    final url = Uri.parse(Endpoint.films);
    final token = await PreferenceHandler.getToken();

    String imageBase64 = "";
    if (imageFile != null) {
      final bytes = imageFile.readAsBytesSync();
      imageBase64 = base64Encode(bytes);
    }

    final body = {
      "title": title,
      "description": description,
      "genre": genre ?? "",
      "director": director ?? "",
      "writer": writer ?? "",
      "stats": stats ?? "",
      "youtube_url": youtubeUrl ?? "",
      "image_base64": imageBase64,
      "schedule_date": scheduleDate ?? "",
      "schedule_time": scheduleTime ?? "",
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
      return addFIlmFromJson(response.body);
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Gagal menambahkan film");
    }
  }

  // Update film
  static Future<AddFIlm> updateFilm({
    required int id,
    required String title,
    required String description,
    String? genre,
    String? director,
    String? writer,
    String? stats,
    String? youtubeUrl,
    File? imageFile,
  }) async {
    final url = Uri.parse("${Endpoint.films}/$id");
    final token = await PreferenceHandler.getToken();

    String imageBase64 = "";
    if (imageFile != null) {
      final bytes = imageFile.readAsBytesSync();
      imageBase64 = base64Encode(bytes);
    }

    final body = {
      "title": title,
      "description": description,
      "genre": genre ?? "",
      "director": director ?? "",
      "writer": writer ?? "",
      "stats": stats ?? "",
      "youtube_url": youtubeUrl ?? "",
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
      return addFIlmFromJson(response.body);
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Gagal update film");
    }
  }

  // Delete film
  static Future<void> deleteFilm(int id) async {
    final url = Uri.parse("${Endpoint.films}/$id");
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
      throw Exception(error["message"] ?? "Gagal menghapus film");
    }
  }
}
