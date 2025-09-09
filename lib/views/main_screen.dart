import 'package:cinemax/models/list_film_model.dart';
import 'package:cinemax/views/add_film.dart';
// import 'package:cinemax/views/admin_film_page.dart';
import 'package:cinemax/views/custom_drawer.dart';
import 'package:cinemax/views/film_service.dart';
import 'package:cinemax/views/home_screen.dart';
import 'package:cinemax/views/list_jadwal_film.dart';
import 'package:cinemax/views/profile_screen.dart';
import 'package:cinemax/views/tiket_saya_page.dart';
import 'package:cinemax/widgets/custtom_bottom.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static const id = "/main";

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<Datum> _films = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFilms();
  }

  // Fetch films dari API
  Future<void> _fetchFilms() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final films = await FilmService.fetchFilms();
      setState(() {
        _films = films;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal load films: $e")));
    }
  }

  // Drawer item tap
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
      const CinemaListPage(),
      // AdminFilmPage dengan parameter films dan refresh
      AdminFilmPage(films: _films, onRefresh: _fetchFilms),
      const JadwalFilmCreatePage(),
    ];

    return Scaffold(
      drawer: CustomDrawer(onItemTap: onDrawerItemTap),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE8B4C2), // pink pastel
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
                  "assets/images/background.png", // logo kecil
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CinemaListPage()),
          );
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
