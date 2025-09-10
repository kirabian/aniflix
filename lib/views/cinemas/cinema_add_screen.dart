import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cinemax/api/cinema_service.dart';

class AddCinemaPage extends StatefulWidget {
  const AddCinemaPage({super.key});

  @override
  State<AddCinemaPage> createState() => _AddCinemaPageState();
}

class _AddCinemaPageState extends State<AddCinemaPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await CinemaService.addCinema(
        name: _nameController.text,
        imageFile: _selectedImage,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cinema berhasil ditambahkan")),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal menambahkan cinema: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Cinema")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nama Cinema"),
                validator: (v) => v!.isEmpty ? "Nama wajib diisi" : null,
              ),
              const SizedBox(height: 16),
              _selectedImage != null
                  ? Column(
                      children: [
                        Image.file(_selectedImage!, height: 150),
                        TextButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.image),
                          label: const Text("Ganti Gambar"),
                        ),
                      ],
                    )
                  : TextButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.image),
                      label: const Text("Pilih Gambar"),
                    ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: const Text("Tambah Cinema"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
