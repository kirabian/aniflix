import 'package:cinemax/views/custom_drawer.dart';
import 'package:cinemax/views/home_screen.dart';
import 'package:cinemax/views/profile_screen.dart';
import 'package:cinemax/widgets/custtom_bottom.dart';
import 'package:flutter/material.dart';
// import 'package:cinemax/widgets/custom_bottom.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static const id = "/main";

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    // MoviesScreen(),
    // TicketsScreen(),
    ProfileScreen(),
  ];

  void onDrawerItemTap(int index) {
    Navigator.pop(context); // tutup drawer
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: CircleAvatar(
              backgroundColor: Colors.pink[200],
              radius: 20,
              child: ClipOval(
                child: Image.asset(
                  "assets/images/background.png", // logo AniFlix kecil
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),

      body: Center(child: _widgetOptions[_selectedIndex]),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.local_activity, size: 32), // tiket bioskop 🎟️
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
