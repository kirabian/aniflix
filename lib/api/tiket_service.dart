import 'dart:convert';
import 'dart:developer'; // Untuk logging yang detail

// Sesuaikan path import ini dengan struktur proyek Anda
import 'package:cinemax/api/endpoint/endpoint.dart';
import 'package:cinemax/models/pesan_tiket_film.dart';
import 'package:cinemax/models/tiket_film_saya.dart';
import 'package:cinemax/models/update_tiket_model.dart';
// import 'package:cinemax/models/update_tiket.dart';
import 'package:cinemax/shared_preferenced/preference.dart';
import 'package:http/http.dart' as http;

/// `TiketService` bertanggung jawab untuk semua interaksi jaringan
/// terkait dengan data tiket pengguna, seperti membuat, membaca, memperbarui,
/// dan menghapus tiket.
class TiketService {
  /// Mengambil daftar semua tiket yang dimiliki oleh pengguna yang sedang login.
  static Future<List<Datum>> getTiketSaya() async {
    final token = await PreferenceHandler.getToken();
    final url = Uri.parse(Endpoint.TiketSaya);

    log("=============================================");
    log("MEMINTA DAFTAR TIKET SAYA");
    log("URL Target      : ${Endpoint.TiketSaya}");
    log("Method          : GET");
    log("Token yang dipakai: Bearer $token");
    log("=============================================");

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = tiketFilmSayaFromJson(response.body);
        return data.data ?? [];
      } else {
        log("Error ambil tiket: ${response.body}");
        throw Exception('Gagal memuat daftar tiket');
      }
    } catch (e) {
      log("Exception saat mengambil tiket: $e");
      rethrow; // Melempar kembali error untuk ditangani di UI
    }
  }

  /// Membuat pesanan tiket baru untuk jadwal film tertentu.
  static Future<PesanTiketFilm> pesanTiket({
    required int scheduleId,
    required int quantity,
  }) async {
    final token = await PreferenceHandler.getToken();
    final url = Uri.parse(Endpoint.TiketSaya);
    final body = jsonEncode({"schedule_id": scheduleId, "quantity": quantity});

    log("=============================================");
    log("MEMBUAT PESANAN TIKET BARU");
    log("URL Target      : ${Endpoint.TiketSaya}");
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

      log('Pesan Tiket Response status: ${response.statusCode}');
      log('Pesan Tiket Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return pesanTiketFilmFromJson(response.body);
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['message'] ?? 'Gagal memesan tiket';
        throw Exception(errorMessage);
      }
    } catch (e) {
      log("Exception saat pesan tiket: $e");
      rethrow;
    }
  }

  /// Memperbarui jumlah (quantity) dan jadwal dari tiket yang sudah ada.
  static Future<UpdateTiket> updateTiket({
    required int ticketId,
    required int newQuantity,
    required int scheduleId, // Diperlukan oleh server untuk validasi
  }) async {
    final token = await PreferenceHandler.getToken();
    final urlString = '${Endpoint.TiketSaya}/$ticketId';
    final body = jsonEncode({
      'quantity': newQuantity,
      'schedule_id': scheduleId, // Mengirim field yang dibutuhkan
    });
    final url = Uri.parse(urlString);

    log("=============================================");
    log("MEMPERBARUI TIKET");
    log("URL Target      : $urlString");
    log("Method          : PUT");
    log("Token yang dipakai: Bearer $token");
    log("Body Request    : $body");
    log("=============================================");

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      log('Update Tiket Response status: ${response.statusCode}');
      log('Update Tiket Response body: ${response.body}');

      if (response.statusCode == 200) {
        return updateTiketFromJson(response.body);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Gagal memperbarui tiket');
      }
    } catch (e) {
      log("Exception saat update tiket: $e");
      rethrow;
    }
  }

  /// Menghapus tiket berdasarkan ID-nya.
  static Future<void> deleteTiket({required int ticketId}) async {
    final token = await PreferenceHandler.getToken();
    final urlString = '${Endpoint.TiketSaya}/$ticketId';
    final url = Uri.parse(urlString);

    log("=============================================");
    log("MENGHAPUS TIKET");
    log("URL Target      : $urlString");
    log("Method          : DELETE");
    log("Token yang dipakai: Bearer $token");
    log("=============================================");

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      log('Delete Tiket Response status: ${response.statusCode}');
      log('Delete Tiket Response body: ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 204) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Gagal menghapus tiket');
      }
    } catch (e) {
      log("Exception saat delete tiket: $e");
      rethrow;
    }
  }
}
