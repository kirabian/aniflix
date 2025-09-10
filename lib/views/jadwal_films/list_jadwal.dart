// Sesuaikan path import ini dengan struktur proyek Anda
// import 'package:cinemax/views/jadwal_create_service.dart';
import 'package:cinemax/api/jadwal_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class JadwalFilmCreatePage extends StatefulWidget {
  const JadwalFilmCreatePage({super.key});

  @override
  State<JadwalFilmCreatePage> createState() => _JadwalFilmCreatePageState();
}

class _JadwalFilmCreatePageState extends State<JadwalFilmCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _filmIdController = TextEditingController();
  final _cinemaIdController = TextEditingController();
  final _priceController = TextEditingController();
  DateTime? _selectedDateTime;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    Intl.defaultLocale = 'id_ID';
  }

  @override
  void dispose() {
    _filmIdController.dispose();
    _cinemaIdController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
    );
    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _filmIdController.clear();
    _cinemaIdController.clear();
    _priceController.clear();
    setState(() {
      _selectedDateTime = null;
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() && !_isSaving) {
      if (_selectedDateTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Waktu tayang harus dipilih'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      setState(() => _isSaving = true);

      final data = {
        'film_id': int.parse(_filmIdController.text),
        'cinema_id': int.parse(_cinemaIdController.text),
        'price': num.parse(_priceController.text),
        'start_time': DateFormat(
          "yyyy-MM-dd HH:mm:ss",
        ).format(_selectedDateTime!),
      };

      try {
        await JadwalCreateService.createJadwal(data);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Jadwal baru berhasil disimpan!'),
            backgroundColor: Colors.green,
          ),
        );

        _clearForm(); // Bersihkan form agar bisa input lagi
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Jadwal Film Baru')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // PENTING: Di aplikasi nyata, ganti TextFormField ini dengan Dropdown/pencarian
            TextFormField(
              controller: _filmIdController,
              decoration: const InputDecoration(
                labelText: 'Film ID',
                border: OutlineInputBorder(),
                hintText: 'Contoh: 1',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) =>
                  v!.isEmpty ? 'Film ID tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cinemaIdController,
              decoration: const InputDecoration(
                labelText: 'Cinema ID',
                border: OutlineInputBorder(),
                hintText: 'Contoh: 1',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) =>
                  v!.isEmpty ? 'Cinema ID tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Harga (Rp)',
                border: OutlineInputBorder(),
                hintText: 'Contoh: 50000',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) => v!.isEmpty ? 'Harga tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _pickDateTime,
              icon: const Icon(Icons.calendar_today),
              label: Text(
                _selectedDateTime == null
                    ? 'Pilih Waktu Tayang'
                    : DateFormat(
                        'dd MMMM yyyy, HH:mm',
                      ).format(_selectedDateTime!),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isSaving ? null : _submitForm,
              icon: _isSaving
                  ? Container(
                      width: 24,
                      height: 24,
                      padding: const EdgeInsets.all(2.0),
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                  : const Icon(Icons.save),
              label: const Text('Simpan Jadwal'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
