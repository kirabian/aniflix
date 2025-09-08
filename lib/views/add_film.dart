import 'package:cinemax/models/list_film_model.dart';
import 'package:cinemax/views/add_film_page.dart';
import 'package:cinemax/views/film_service.dart';
import 'package:flutter/material.dart';

class AdminFilmPage extends StatefulWidget {
  final List<Datum> films;
  final Future<void> Function()? onRefresh;

  const AdminFilmPage({super.key, required this.films, this.onRefresh});

  @override
  State<AdminFilmPage> createState() => _AdminFilmPageState();
}

class _AdminFilmPageState extends State<AdminFilmPage> {
  static const int pageSize = 10;
  int currentPage = 1;

  List<Datum> get pagedFilms {
    final start = (currentPage - 1) * pageSize;
    final end = start + pageSize;
    return widget.films.sublist(
      start,
      end > widget.films.length ? widget.films.length : end,
    );
  }

  Future<void> _deleteFilm(int filmId) async {
    try {
      await FilmService.deleteFilm(filmId);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Film berhasil dihapus")));
      if (widget.onRefresh != null) {
        await widget.onRefresh!();
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal hapus film: $e")));
    }
  }

  Future<void> _refreshFilms() async {
    if (widget.onRefresh != null) await widget.onRefresh!();
    setState(() {
      currentPage = 1;
    });
  }

  void _goToPage(int page) {
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = (widget.films.length / pageSize).ceil();

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: pagedFilms.length,
              itemBuilder: (context, index) {
                final film = pagedFilms[index];
                return Card(
                  child: Column(
                    children: [
                      Expanded(
                        child: film.imageUrl != null
                            ? Image.network(film.imageUrl!, fit: BoxFit.cover)
                            : const SizedBox(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          film.title ?? "-",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () async {
                              // Edit film
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddFilmPage(
                                    filmToEdit: film, // kirim film untuk edit
                                  ),
                                ),
                              );
                              if (result == true) {
                                _refreshFilms();
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Konfirmasi Hapus"),
                                  content: Text(
                                    "Apakah Anda yakin ingin menghapus '${film.title}'?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text("Batal"),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text("Hapus"),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                _deleteFilm(film.id!);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (totalPages > 1)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: currentPage > 1
                        ? () => _goToPage(currentPage - 1)
                        : null,
                  ),
                  Text("Halaman $currentPage dari $totalPages"),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: currentPage < totalPages
                        ? () => _goToPage(currentPage + 1)
                        : null,
                  ),
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "addFilm",
            onPressed: () async {
              // Tambah film baru
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddFilmPage()),
              );
              if (result == true) {
                _refreshFilms();
              }
            },
            tooltip: "Tambah Film",
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: "editFilm",
            onPressed: () {
              // Shortcut Edit global (opsional)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Pilih film untuk diedit")),
              );
            },
            tooltip: "Edit Film",
            child: const Icon(Icons.edit),
          ),
        ],
      ),
    );
  }
}
