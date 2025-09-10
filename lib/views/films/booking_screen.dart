import 'package:cinemax/api/film_service.dart';
import 'package:cinemax/models/list_film_model.dart';
import 'package:cinemax/views/films/booking_detail_screen.dart';
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
    _filmsFuture = FilmService.fetchFilms();
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
          height: 300,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: films.length,
            itemBuilder: (context, index) {
              final film = films[index];
              return Container(
                width: 150,
                margin: const EdgeInsets.only(right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          film.imageUrl ?? '',
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.broken_image,
                                  color: Colors.white,
                                  size: 48,
                                ),
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      film.title ?? 'No Title',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
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
                      child: const Text(
                        "Pesan",
                        style: TextStyle(color: Colors.white),
                      ),
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
