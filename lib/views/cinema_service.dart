import 'package:cinemax/models/get_cinema_model.dart';

class CinemaService {
  static final List<Datum> _cinemas = [];

  static Future<List<Datum>> getCinema() async {
    return _cinemas;
  }

  static Future<void> addCinema(Datum cinema) async {
    _cinemas.add(cinema);
  }

  static Future<void> updateCinema(Datum cinema) async {
    final index = _cinemas.indexWhere((c) => c.id == cinema.id);
    if (index != -1) {
      _cinemas[index] = cinema;
    }
  }

  static Future<void> deleteCinema({required int id}) async {
    _cinemas.removeWhere((c) => c.id == id);
  }
}
