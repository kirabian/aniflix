// import 'package:cinemax/views/booking_screen.dart';
import 'package:cinemax/api/register_user.dart'; // pastikan import logout
import 'package:cinemax/views/films/booking_screen.dart';
// import 'package:cinemax/views/register_Screen.dart';
import 'package:cinemax/views/search.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const id = "/home_screen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String query = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Field
            SearchField(
              controller: _searchController,
              hintText: "Search anime movies...",
              onChanged: (value) {
                setState(() => query = value);
              },
              onClear: () {
                setState(() => query = "");
              },
            ),
            const SizedBox(height: 24),

            // Display query if not empty
            if (query.isNotEmpty)
              Text(
                "Searching for: $query",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            const SizedBox(height: 16),

            // Booking section
            BookingSection(),
            const SizedBox(height: 24),

            // Log Out Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    // Panggil API logout
                    await AuthenticationAPI.logout();
                    // Pindah ke login screen
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[200],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Keluar",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
