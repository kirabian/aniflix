// import 'package:cinemax/models/list_jadwal_film.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class JadwalDetailPage extends StatelessWidget {
//   final DatumJadwal datum;

//   const JadwalDetailPage({super.key, required this.datum});

//   @override
//   Widget build(BuildContext context) {
//     final film = datum.film;
//     final startTime = datum.startTime != null
//         ? DateFormat('dd MMM yyyy – HH:mm').format(datum.startTime!)
//         : "Unknown";

//     return Scaffold(
//       appBar: AppBar(title: Text(film?.title ?? "Detail Jadwal")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Poster
//             if (film?.imageUrl != null)
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Image.network(
//                   film!.imageUrl!,
//                   height: 200,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             const SizedBox(height: 16),

//             // Title
//             Text(
//               film?.title ?? "No Title",
//               style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),

//             const SizedBox(height: 8),
//             // Genre
//             Text(
//               "Genre: ${film?.genre ?? "Unknown"}",
//               style: const TextStyle(fontSize: 16),
//             ),

//             const SizedBox(height: 8),
//             // Jadwal
//             Text(
//               "Start Time: $startTime",
//               style: const TextStyle(fontSize: 16),
//             ),

//             const SizedBox(height: 8),
//             // Cinema
//             Text(
//               "Cinema: ${datum.cinema ?? 'Unknown Cinema'}",
//               style: const TextStyle(fontSize: 16),
//             ),

//             const SizedBox(height: 16),
//             // Tombol Booking
//             ElevatedButton(
//               onPressed: () {
//                 // Navigasi ke BookingDetailPage
//                 print(
//                   "Booking ${film?.title} at $startTime, cinema: ${datum.cinema}",
//                 );
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text(
//                       "Booking ${film?.title} at $startTime, cinema: ${datum.cinema}",
//                     ),
//                   ),
//                 );
//               },
//               child: const Text("Pesan Tiket"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
