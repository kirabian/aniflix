// import 'package:cinemax/models/get_cinema_model.dart';
// import 'package:cinemax/models/list_film_model.dart';
// import 'package:cinemax/views/add_film.dart';
// import 'package:cinemax/views/cinema_service.dart';
// import 'package:cinemax/views/film_service.dart';
// import 'package:cinemax/views/list_jadwal_film_admin.dart';
// import 'package:cinemax/views/profile_screen.dart';
// import 'package:flutter/material.dart';

// /// Halaman utama khusus Admin
// class MainScreenAdmin extends StatefulWidget {
//   const MainScreenAdmin({super.key});

//   @override
//   State<MainScreenAdmin> createState() => _MainScreenAdminState();
// }

// class _MainScreenAdminState extends State<MainScreenAdmin> {
//   int _currentIndex = 0;
//   List<Datum> _films = [];
//   List<DatumCinema> _cinemas = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchData();
//   }

//   Future<void> _fetchData() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final films = await FilmService.fetchFilms();
//       final cinemas = await CinemaService.fetchCinemas();
//       setState(() {
//         _films = films;
//         _cinemas = cinemas;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Gagal load data: $e")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // halaman sesuai bottom nav
//     final List<Widget> pages = [
//       AdminCinemaPage(cinemas: _cinemas, onRefresh: _fetchData),
//       AdminFilmPage(films: _films, onRefresh: _fetchData),
//       const AdminJadwalPage(),
//     ];

//     return Scaffold(
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : pages[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         selectedItemColor: Colors.pink[400],
//         unselectedItemColor: Colors.grey,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.local_movies),
//             label: "Cinema",
//           ),
//           BottomNavigationBarItem(icon: Icon(Icons.movie), label: "Film"),
//           BottomNavigationBarItem(icon: Icon(Icons.schedule), label: "Jadwal"),
//         ],
//       ),
//     );
//   }
// }
