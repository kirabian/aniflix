// import 'package:cinemax/views/edit_cinema_page.dart';
import 'package:cinemax/api/cinema_service.dart';
import 'package:cinemax/models/get_cinema_model.dart';
// import 'package:cinemax/views/add_cinema_page.dart';
import 'package:cinemax/views/cinemas/cinema_add_screen.dart';
import 'package:cinemax/views/cinemas/cinemas_edit_screen..dart';
import 'package:flutter/material.dart';

class AdminCinemaPage extends StatefulWidget {
  final List<DatumCinema> cinemas;
  final Future<void> Function()? onRefresh;

  const AdminCinemaPage({super.key, required this.cinemas, this.onRefresh});

  @override
  State<AdminCinemaPage> createState() => _AdminCinemaPageState();
}

class _AdminCinemaPageState extends State<AdminCinemaPage> {
  static const int pageSize = 10;
  int currentPage = 1;

  List<DatumCinema> get pagedCinemas {
    final start = (currentPage - 1) * pageSize;
    final end = start + pageSize;
    return widget.cinemas.sublist(
      start,
      end > widget.cinemas.length ? widget.cinemas.length : end,
    );
  }

  Future<void> _deleteCinema(int cinemaId) async {
    try {
      await CinemaService.deleteCinema(cinemaId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Cinema berhasil dihapus"),
          backgroundColor: Colors.pinkAccent,
        ),
      );
      if (widget.onRefresh != null) {
        await widget.onRefresh!();
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal hapus cinema: $e")));
    }
  }

  Future<void> _refreshCinemas() async {
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
    final totalPages = (widget.cinemas.length / pageSize).ceil();

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: pagedCinemas.length,
              itemBuilder: (context, index) {
                final cinema = pagedCinemas[index];
                return Card(
                  child: Column(
                    children: [
                      Expanded(
                        child: cinema.imageUrl != null
                            ? Image.network(cinema.imageUrl!, fit: BoxFit.cover)
                            : const SizedBox(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          cinema.name ?? "-",
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
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      EditCinemaPage(cinema: cinema),
                                ),
                              );
                              if (result == true) {
                                _refreshCinemas();
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
                                    "Apakah Anda yakin ingin menghapus '${cinema.name}'?",
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
                                _deleteCinema(cinema.id!);
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
            heroTag: "addCinema",
            backgroundColor: Colors.pink[200],
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddCinemaPage()),
              );
              if (result == true) {
                _refreshCinemas();
              }
            },
            tooltip: "Tambah Cinema",
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 12),
          // FloatingActionButton(
          //   heroTag: "editCinema",
          //   onPressed: () {
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       const SnackBar(content: Text("Pilih cinema untuk diedit")),
          //     );
          //   },
          //   tooltip: "Edit Cinema",
          //   child: const Icon(Icons.edit),
          // ),
        ],
      ),
    );
  }
}
