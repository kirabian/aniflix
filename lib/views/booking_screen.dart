import 'package:cinemax/models/list_film_model.dart';
import 'package:cinemax/views/booking_detail_screen.dart';
import 'package:cinemax/views/film_service.dart';
import 'package:flutter/material.dart';

class BookingSection extends StatefulWidget {
  const BookingSection({super.key});

  @override
  State<BookingSection> createState() => _BookingSectionState();
}

class _BookingSectionState extends State<BookingSection> {
  late Future<List<Datum>> _filmsFuture;

  @override
  void initState() {
    super.initState();
    _filmsFuture = FilmService.fetchFilms(); // fetch list film
  }

  void _retryFetch() {
    setState(() {
      _filmsFuture = FilmService.fetchFilms();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Datum>>(
      future: _filmsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Error: ${snapshot.error}"),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _retryFetch,
                  child: const Text("Coba Lagi"),
                ),
              ],
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Belum ada film yang tersedia"));
        }

        final films = snapshot.data!;

        return SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: films.length,
            itemBuilder: (context, index) {
              final film = films[index];
              return Container(
                width: 150,
                margin: const EdgeInsets.only(right: 12),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        film.imageUrl ?? '',
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 140,
                          color: Colors.grey,
                          child: const Icon(
                            Icons.broken_image,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      film.title ?? 'No Title',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    ElevatedButton(
                      onPressed: () async {
                        // Navigasi ke BookingDetailPage, fetch jadwal film
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookingDetailPage(
                              filmId: film.id!,
                              filmTitle: film.title!,
                            ),
                          ),
                        );
                      },
                      child: const Text("Pesan"),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
