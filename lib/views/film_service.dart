import 'package:cinemax/api/endpoint/endpoint.dart';
import 'package:cinemax/models/list_film_model.dart';
import 'package:cinemax/models/list_jadwal_film.dart';
import 'package:cinemax/shared_preferenced/preference.dart';
import 'package:http/http.dart' as http;

class FilmService {
  // Fetch semua film
  static Future<List<Datum>> fetchFilms() async {
    final url = Uri.parse(Endpoint.films);

    // Ambil token dari SharedPreferences
    final token = await PreferenceHandler.getToken();

    final response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    print("STATUS CODE: ${response.statusCode}");
    print("BODY: ${response.body}");

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

    print("STATUS CODE Jadwal: ${response.statusCode}");
    print("BODY Jadwal: ${response.body}");

    if (response.statusCode == 200) {
      final data = listJadwalFIlmFromJson(response.body);
      return data.data?.data ?? [];
    } else {
      throw Exception("Gagal load jadwal film (${response.statusCode})");
    }
  }
}
