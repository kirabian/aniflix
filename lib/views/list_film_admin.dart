import 'package:cinemax/models/list_film_model.dart';
import 'package:flutter/material.dart';

class AdminFilmPage extends StatefulWidget {
  final List<Datum> films;

  const AdminFilmPage({super.key, required this.films});

  @override
  State<AdminFilmPage> createState() => _AdminFilmPageState();
}

class _AdminFilmPageState extends State<AdminFilmPage> {
  late List<Datum> _films;

  @override
  void initState() {
    super.initState();
    _films = List.from(widget.films);
  }

  void _addOrEditFilm({Datum? film}) async {
    final result = await showDialog<Datum>(
      context: context,
      builder: (context) => FilmDialog(film: film),
    );

    if (result != null) {
      setState(() {
        if (film != null) {
          // update
          final index = _films.indexWhere((f) => f.id == film.id);
          if (index != -1) _films[index] = result;
        } else {
          // create
          _films.add(result);
        }
      });
    }
  }

  void _deleteFilm(Datum film) {
    setState(() {
      _films.removeWhere((f) => f.id == film.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Film"),
        backgroundColor: Colors.pinkAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _addOrEditFilm(),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _films.length,
        itemBuilder: (context, index) {
          final film = _films[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: film.imageUrl != null
                  ? Image.network(
                      film.imageUrl!,
                      width: 50,
                      height: 80,
                      fit: BoxFit.cover,
                    )
                  : Container(width: 50, height: 80, color: Colors.grey),
              title: Text(film.title ?? "No Title"),
              subtitle: Text(
                "Genre: ${film.genre ?? '-'}\nDirector: ${film.director ?? '-'}",
              ),
              isThreeLine: true,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _addOrEditFilm(film: film),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteFilm(film),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Dialog untuk Create / Update Film
class FilmDialog extends StatefulWidget {
  final Datum? film;
  const FilmDialog({super.key, this.film});

  @override
  State<FilmDialog> createState() => _FilmDialogState();
}

class _FilmDialogState extends State<FilmDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _genreController;
  late TextEditingController _directorController;
  late TextEditingController _writerController;
  late TextEditingController _statsController;
  late TextEditingController _imageUrlController;
  late TextEditingController _youtubeController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.film?.title);
    _descController = TextEditingController(text: widget.film?.description);
    _genreController = TextEditingController(text: widget.film?.genre);
    _directorController = TextEditingController(text: widget.film?.director);
    _writerController = TextEditingController(text: widget.film?.writer);
    _statsController = TextEditingController(text: widget.film?.stats);
    _imageUrlController = TextEditingController(text: widget.film?.imageUrl);
    _youtubeController = TextEditingController(
      text: widget.film?.youtubeUrl?.toString(),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _genreController.dispose();
    _directorController.dispose();
    _writerController.dispose();
    _statsController.dispose();
    _imageUrlController.dispose();
    _youtubeController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final film = Datum(
        id: widget.film?.id ?? DateTime.now().millisecondsSinceEpoch,
        title: _titleController.text,
        description: _descController.text,
        genre: _genreController.text,
        director: _directorController.text,
        writer: _writerController.text,
        stats: _statsController.text,
        imageUrl: _imageUrlController.text,
        youtubeUrl: _youtubeController.text,
      );
      Navigator.pop(context, film);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.film != null ? "Edit Film" : "Tambah Film"),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildField("Title", _titleController),
                _buildField("Description", _descController),
                _buildField("Genre", _genreController),
                _buildField("Director", _directorController),
                _buildField("Writer", _writerController),
                _buildField("Stats", _statsController),
                _buildField("Image URL", _imageUrlController),
                _buildField("YouTube URL", _youtubeController),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal"),
        ),
        ElevatedButton(onPressed: _save, child: const Text("Simpan")),
      ],
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? "Harus diisi" : null,
      ),
    );
  }
}
