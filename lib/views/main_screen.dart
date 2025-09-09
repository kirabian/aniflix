import 'package:cinemax/models/list_film_model.dart';
import 'package:cinemax/views/add_film.dart';
import 'package:cinemax/views/custom_drawer.dart';
import 'package:cinemax/views/film_service.dart';
import 'package:cinemax/views/home_screen.dart';
import 'package:cinemax/views/list_jadwal_film.dart';
import 'package:cinemax/views/profile_screen.dart';
import 'package:cinemax/views/tiket_saya_page.dart';
import 'package:cinemax/widgets/custtom_bottom.dart';
import 'package:flutter/material.dart';

import '../models/get_cinema_model.dart' hide Datum;
import '../views/cinema_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static const id = "/main";

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<Datum> _films = [];
  List<DatumCinema> _cinemas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final films = await FilmService.fetchFilms();
      final cinemas = await CinemaService.fetchCinemas();
      setState(() {
        _films = films;
        _cinemas = cinemas;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal load data: $e")),
      );
    }
  }

  void onDrawerItemTap(int index) {
    Navigator.pop(context);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      const HomeScreen(),
      const TiketSayaPage(),
      AdminCinemaPage(
        cinemas: _cinemas,
        onRefresh: _fetchData,
      ),
      AdminFilmPage(
        films: _films,
        onRefresh: _fetchData,
      ),
      const JadwalFilmCreatePage(),
    ];

    return Scaffold(
      drawer: CustomDrawer(onItemTap: onDrawerItemTap),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE8B4C2),
        elevation: 0,
        title: const Text(
          "AniFlix Cinema",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: CircleAvatar(
              backgroundColor: Colors.pink[200],
              radius: 20,
              child: ClipOval(
                child: Image.asset(
                  "assets/images/background.png",
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : widgetOptions[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AdminCinemaPage(
                cinemas: _cinemas,
                onRefresh: _fetchData,
              ),
            ),
          );
          if (result == true) {
            _fetchData();
          }
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.local_activity, size: 32),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
    );
  }
}
