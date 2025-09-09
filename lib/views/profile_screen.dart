import 'package:cinemax/models/get_cinema_model.dart';
import 'package:cinemax/views/cinema_form_page.dart';
import 'package:cinemax/views/cinema_service.dart';
import 'package:flutter/material.dart';

class CinemaListPage extends StatefulWidget {
  const CinemaListPage({super.key});

  @override
  _CinemaListPageState createState() => _CinemaListPageState();
}

class _CinemaListPageState extends State<CinemaListPage> {
  late Future<List<Datum>> _futureCinemas;

  @override
  void initState() {
    super.initState();
    _loadCinemas();
  }

  void _loadCinemas() {
    _futureCinemas = CinemaService.getCinema();
  }

  Future<void> _navigateAndRefresh(
    BuildContext context, {
    Datum? cinema,
  }) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CinemaFormPage(cinema: cinema)),
    );

    if (result == true) {
      setState(() {
        _loadCinemas();
      });
    }
  }

  Future<void> _deleteCinema(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to delete this cinema?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await CinemaService.deleteCinema(id: id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cinema deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _loadCinemas();
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cinema Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _loadCinemas();
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _loadCinemas();
          });
        },
        child: FutureBuilder<List<Datum>>(
          future: _futureCinemas,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No cinema data available.'));
            }

            final cinemas = snapshot.data!;
            return ListView.builder(
              itemCount: cinemas.length,
              itemBuilder: (context, index) {
                final cinema = cinemas[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: cinema.imageUrl != null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(cinema.imageUrl!),
                            onBackgroundImageError: (_, __) =>
                                const Icon(Icons.error),
                          )
                        : const CircleAvatar(child: Icon(Icons.movie_creation)),
                    title: Text(cinema.name ?? 'No Name'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () =>
                              _navigateAndRefresh(context, cinema: cinema),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteCinema(cinema.id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateAndRefresh(context),
        tooltip: 'Add Cinema',
        child: const Icon(Icons.add),
      ),
    );
  }
}
