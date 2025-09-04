import 'package:cinemax/views/booking_screen.dart';
import 'package:cinemax/views/register_Screen.dart';
import 'package:cinemax/views/search.dart';
// import 'package:cinemax/widgets/search_field.dart'; // pastikan sudah import
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

  void _refreshRecipes() => setState(() {});

  void _navigateToAddRecipeScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PostApiScreen()),
    );
    if (result == true) _refreshRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddRecipeScreen,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            if (query.isNotEmpty)
              Text(
                "Searching for: $query",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            const SizedBox(height: 16),
            BookingSection(),
          ],
        ),
      ),
    );
  }
}
