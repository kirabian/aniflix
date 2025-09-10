import 'dart:convert';
import 'dart:developer';

import 'package:cinemax/api/endpoint/endpoint.dart';
import 'package:cinemax/shared_preferenced/preference.dart';
import 'package:http/http.dart' as http;

class JadwalCreateService {
  /// =========================
  /// CREATE JADWAL FILM
  /// =========================
  static Future<void> createJadwal(Map<String, dynamic> data) async {
    final token = await PreferenceHandler.getToken();
    final url = Uri.parse(Endpoint.jadwalFilms);
    final body = jsonEncode(data);

    log("=============================================");
    log("MEMBUAT JADWAL BARU");
    log("URL Target      : ${Endpoint.jadwalFilms}");
    log("Method          : POST");
    log("Token yang dipakai: Bearer $token");
    log("Body Request    : $body");
    log("=============================================");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode != 201) {
        final responseData = jsonDecode(response.body);
        throw Exception(responseData['message'] ?? 'Gagal membuat jadwal');
      }
    } catch (e) {
      log('Exception saat membuat jadwal: $e');
      rethrow;
    }
  }

  /// =========================
  /// READ LIST JADWAL FILM
  /// =========================
  static Future<List<Map<String, dynamic>>> fetchJadwal() async {
    final token = await PreferenceHandler.getToken();
    final url = Uri.parse(Endpoint.jadwalFilms);

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Gagal ambil daftar jadwal');
      }

      final data = jsonDecode(response.body);

      // Pastikan selalu list
      if (data['data'] is List) {
        return List<Map<String, dynamic>>.from(data['data']);
      } else if (data['data'] is Map) {
        return [Map<String, dynamic>.from(data['data'])];
      } else {
        return [];
      }
    } catch (e) {
      log('Exception saat fetchJadwal: $e');
      rethrow;
    }
  }
}
