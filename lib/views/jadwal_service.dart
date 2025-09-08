import 'dart:convert';
import 'dart:developer';

// Sesuaikan path import ini dengan struktur proyek Anda
import 'package:cinemax/api/endpoint/endpoint.dart';
import 'package:cinemax/shared_preferenced/preference.dart';
import 'package:http/http.dart' as http;

/// `JadwalCreateService` hanya bertanggung jawab untuk membuat jadwal film baru.
class JadwalCreateService {
  /// Membuat jadwal baru.
  static Future<void> createJadwal(Map<String, dynamic> data) async {
    final token = await PreferenceHandler.getToken();
    // Ganti Endpoint.jadwalFilms jika endpoint untuk create berbeda
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

      // Status 201 berarti 'Created'
      if (response.statusCode != 201) {
        final responseData = jsonDecode(response.body);
        throw Exception(responseData['message'] ?? 'Gagal membuat jadwal');
      }
    } catch (e) {
      log('Exception saat membuat jadwal: $e');
      rethrow;
    }
  }
}
