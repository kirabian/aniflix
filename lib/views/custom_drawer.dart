import 'package:cinemax/api/register_user.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final Function(int) onItemTap;

  const CustomDrawer({super.key, required this.onItemTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFFDEDEE), // pink muda pastel
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFFE8B4C2)),
            accountName: const Text("Anime Lover"),
            accountEmail: const Text("aniflix@cinema.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Image.asset(
                  "assets/images/background.png", // logo AniFlix kecil
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.pink),
            title: const Text("Home"),
            onTap: () => onItemTap(0),
          ),
          ListTile(
            leading: const Icon(Icons.movie, color: Colors.pink),
            title: const Text("Movies"),
            onTap: () => onItemTap(1),
          ),
          ListTile(
            leading: const Icon(Icons.local_activity, color: Colors.pink),
            title: const Text("Tickets"),
            onTap: () => onItemTap(2),
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.pink),
            title: const Text("Profile"),
            onTap: () => onItemTap(3),
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.pink),
            title: const Text("add_film"),
            onTap: () => onItemTap(4),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: ElevatedButton(
              onPressed: () async {
                await AuthenticationAPI.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
              ),
              child: const Text("Keluar"),
            ),
          ),
        ],
      ),
    );
  }
}
