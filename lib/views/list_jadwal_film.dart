// import 'package:cinemax/models/get_cinema_model.dart';
// import 'package:cinemax/models/list_film_model.dart';
// import 'package:cinemax/api/cinema_service.dart';
// import 'package:cinemax/api/film_service.dart';
// import 'package:cinemax/api/jadwal_service.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class CreateJadwalPage extends StatefulWidget {
//   const CreateJadwalPage({super.key});

//   @override
//   State<CreateJadwalPage> createState() => _CreateJadwalPageState();
// }

// class _CreateJadwalPageState extends State<CreateJadwalPage> {
//   Datum? selectedFilm;
//   List<DatumCinema> cinemas = [];
//   List<int> selectedCinemaIds = [];
//   DateTime? startDateTime;
//   DateTime? endDateTime;
//   final TextEditingController _priceController = TextEditingController();

//   bool _isLoading = true;
//   bool _isSubmitting = false;
//   List<Datum> films = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadFilmsAndCinemas();
//   }

//   Future<void> _loadFilmsAndCinemas() async {
//     try {
//       final filmData = await FilmService.fetchFilms();
//       final cinemaData = await CinemaService.fetchCinemas();
//       setState(() {
//         films = filmData;
//         cinemas = cinemaData;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() => _isLoading = false);
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Gagal load data: $e")));
//     }
//   }

//   Future<void> _pickDateTime({required bool isStart}) async {
//     final now = DateTime.now();
//     final date = await showDatePicker(
//       context: context,
//       firstDate: DateTime(now.year - 1),
//       lastDate: DateTime(now.year + 5),
//       initialDate: now,
//     );

//     if (date == null) return;

//     final time = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );

//     if (time == null) return;

//     final chosen = DateTime(
//       date.year,
//       date.month,
//       date.day,
//       time.hour,
//       time.minute,
//     );

//     setState(() {
//       if (isStart) {
//         startDateTime = chosen;
//       } else {
//         endDateTime = chosen;
//       }
//     });
//   }

//   Future<void> _saveJadwal() async {
//     if (selectedFilm == null ||
//         selectedCinemaIds.isEmpty ||
//         startDateTime == null ||
//         endDateTime == null ||
//         _priceController.text.isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Lengkapi semua field")));
//       return;
//     }

//     setState(() => _isSubmitting = true);

//     try {
//       final apiFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

//       for (var cinemaId in selectedCinemaIds) {
//         final data = {
//           "film_id": selectedFilm!.id,
//           "cinema_id": cinemaId,
//           "start_time": apiFormat.format(startDateTime!),
//           "end_time": apiFormat.format(endDateTime!),
//           "price": int.tryParse(_priceController.text) ?? 0,
//         };

//         await JadwalCreateService.createJadwal(data);
//       }

//       if (mounted) {
//         Navigator.pop(context, true);
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Jadwal berhasil dibuat!")),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text("Gagal membuat jadwal: $e")));
//       }
//     } finally {
//       setState(() => _isSubmitting = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Buat Jadwal Film"),
//         backgroundColor: Colors.pink[300],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16),
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     // Dropdown film
//                     DropdownButtonFormField<Datum>(
//                       value: selectedFilm,
//                       decoration: const InputDecoration(
//                         labelText: "Pilih Film",
//                         border: OutlineInputBorder(),
//                       ),
//                       items: films.map((film) {
//                         return DropdownMenuItem(
//                           value: film,
//                           child: Text(film.title ?? "Tanpa Judul"),
//                         );
//                       }).toList(),
//                       onChanged: (film) => setState(() {
//                         selectedFilm = film;
//                       }),
//                     ),
//                     const SizedBox(height: 16),

//                     // Checkbox list cinema
//                     const Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         "Pilih Bioskop:",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     ...cinemas.map((cinema) {
//                       final isSelected = selectedCinemaIds.contains(
//                         cinema.id ?? -1,
//                       );
//                       return CheckboxListTile(
//                         value: isSelected,
//                         title: Text(cinema.name ?? "-"),
//                         onChanged: (val) {
//                           setState(() {
//                             if (val == true) {
//                               selectedCinemaIds.add(cinema.id!);
//                             } else {
//                               selectedCinemaIds.remove(cinema.id);
//                             }
//                           });
//                         },
//                       );
//                     }),
//                     const SizedBox(height: 16),

//                     // Start time picker
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             startDateTime == null
//                                 ? "Belum pilih start time"
//                                 : "Start: ${DateFormat("yyyy-MM-dd HH:mm").format(startDateTime!)}",
//                           ),
//                         ),
//                         TextButton(
//                           onPressed: () => _pickDateTime(isStart: true),
//                           child: const Text("Pilih Start"),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),

//                     // End time picker
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             endDateTime == null
//                                 ? "Belum pilih end time"
//                                 : "End: ${DateFormat("yyyy-MM-dd HH:mm").format(endDateTime!)}",
//                           ),
//                         ),
//                         TextButton(
//                           onPressed: () => _pickDateTime(isStart: false),
//                           child: const Text("Pilih End"),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),

//                     // Price input
//                     TextField(
//                       controller: _priceController,
//                       keyboardType: TextInputType.number,
//                       decoration: const InputDecoration(
//                         labelText: "Harga Tiket",
//                         border: OutlineInputBorder(),
//                         prefixText: "Rp ",
//                       ),
//                     ),
//                     const SizedBox(height: 24),

//                     // Submit button
//                     ElevatedButton(
//                       onPressed: _isSubmitting ? null : _saveJadwal,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.pink[400],
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 40,
//                           vertical: 12,
//                         ),
//                       ),
//                       child: _isSubmitting
//                           ? const CircularProgressIndicator(color: Colors.white)
//                           : const Text("Simpan Jadwal"),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }
