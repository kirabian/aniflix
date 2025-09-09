import 'dart:io';

import 'package:cinemax/models/get_cinema_model.dart';
import 'package:cinemax/views/cinema_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:cinemax/services/cinema_service.dart';

class CinemaFormPage extends StatefulWidget {
  final Datum? cinema;

  const CinemaFormPage({super.key, this.cinema});

  @override
  State<CinemaFormPage> createState() => _CinemaFormPageState();
}

class _CinemaFormPageState extends State<CinemaFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    if (widget.cinema != null) {
      _nameController.text = widget.cinema!.name ?? '';
      if (widget.cinema!.imagePath != null) {
        _selectedImage = File(widget.cinema!.imagePath!);
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveCinema() async {
    if (_formKey.currentState!.validate()) {
      final newCinema = Datum(
        id: widget.cinema?.id ?? DateTime.now().millisecondsSinceEpoch,
        name: _nameController.text.trim(),
        imagePath: _selectedImage?.path ?? widget.cinema?.imagePath,
        imageUrl: _selectedImage?.path ?? widget.cinema?.imageUrl,
      );

      if (widget.cinema == null) {
        await CinemaService.addCinema(newCinema);
      } else {
        await CinemaService.updateCinema(newCinema);
      }

      if (mounted) Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cinema == null ? 'Add Cinema' : 'Edit Cinema'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: _selectedImage != null
                    ? Image.file(
                        _selectedImage!,
                        height: 150,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 150,
                        color: Colors.grey[300],
                        child: const Icon(Icons.camera_alt, size: 50),
                      ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Cinema Name',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _saveCinema, child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
