import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      selectedItemColor: Colors.pink[400],
      unselectedItemColor: Colors.grey,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(
          icon: Icon(Icons.confirmation_number),
          label: "Tikets",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_movies),
          label: "Cinema",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.movie), label: "Movie"),
        BottomNavigationBarItem(
          icon: Icon(Icons.schedule),
          label: "Jadwal FIlm",
        ),
      ],
    );
  }
}
