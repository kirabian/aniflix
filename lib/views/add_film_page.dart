import 'dart:io';

import 'package:cinemax/models/list_film_model.dart';
import 'package:cinemax/views/film_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddFilmPage extends StatefulWidget {
  final Datum? filmToEdit; // null = add, not null = edit

  const AddFilmPage({super.key, this.filmToEdit});

  @override
  State<AddFilmPage> createState() => _AddFilmPageState();
}

class _AddFilmPageState extends State<AddFilmPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _genreController;
  late TextEditingController _directorController;
  late TextEditingController _writerController;
  late TextEditingController _statsController;
  late TextEditingController _youtubeUrlController;

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final film = widget.filmToEdit;
    _titleController = TextEditingController(text: film?.title ?? "");
    _descriptionController = TextEditingController(
      text: film?.description ?? "",
    );
    _genreController = TextEditingController(text: film?.genre ?? "");
    _directorController = TextEditingController(text: film?.director ?? "");
    _writerController = TextEditingController(text: film?.writer ?? "");
    _statsController = TextEditingController(text: film?.stats ?? "");
    _youtubeUrlController = TextEditingController(text: film?.youtubeUrl ?? "");
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      bool success = false;
      if (widget.filmToEdit == null) {
        // Add film
        await FilmService.addFilm(
          title: _titleController.text,
          description: _descriptionController.text,
          genre: _genreController.text,
          director: _directorController.text,
          writer: _writerController.text,
          stats: _statsController.text,
          youtubeUrl: _youtubeUrlController.text,
          imageFile: _selectedImage,
        );
        success = true;
      } else {
        // Update film
        await FilmService.updateFilm(
          id: widget.filmToEdit!.id!,
          title: _titleController.text,
          description: _descriptionController.text,
          genre: _genreController.text,
          director: _directorController.text,
          writer: _writerController.text,
          stats: _statsController.text,
          youtubeUrl: _youtubeUrlController.text,
          imageFile: _selectedImage, // ini penting, ganti gambar jika ada
        );
        success = true;
      }

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.filmToEdit == null
                  ? "Film berhasil ditambahkan"
                  : "Film berhasil diupdate",
            ),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal menyimpan film: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.filmToEdit != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Film" : "Tambah Film")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (v) => v!.isEmpty ? "Title required" : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                validator: (v) => v!.isEmpty ? "Description required" : null,
              ),
              TextFormField(
                controller: _genreController,
                decoration: const InputDecoration(labelText: "Genre"),
              ),
              TextFormField(
                controller: _directorController,
                decoration: const InputDecoration(labelText: "Director"),
              ),
              TextFormField(
                controller: _writerController,
                decoration: const InputDecoration(labelText: "Writer"),
              ),
              TextFormField(
                controller: _statsController,
                decoration: const InputDecoration(labelText: "Stats"),
              ),
              TextFormField(
                controller: _youtubeUrlController,
                decoration: const InputDecoration(labelText: "YouTube URL"),
              ),
              const SizedBox(height: 16),
              // Gambar preview / pick image
              _selectedImage != null
                  ? Column(
                      children: [
                        Image.file(_selectedImage!, height: 150),
                        TextButton.icon(
                          icon: const Icon(Icons.image),
                          label: const Text("Ganti Gambar"),
                          onPressed: _pickImage,
                        ),
                      ],
                    )
                  : widget.filmToEdit?.imageUrl != null
                  ? Column(
                      children: [
                        Image.network(
                          widget.filmToEdit!.imageUrl!,
                          height: 150,
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.image),
                          label: const Text("Ganti Gambar"),
                          onPressed: _pickImage,
                        ),
                      ],
                    )
                  : TextButton.icon(
                      icon: const Icon(Icons.image),
                      label: const Text("Pick Image"),
                      onPressed: _pickImage,
                    ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: Text(isEdit ? "Update Film" : "Add Film"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
