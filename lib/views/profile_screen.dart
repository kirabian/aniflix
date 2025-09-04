import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDEDEE), // pink pastel background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // FOTO + NAMA + EMAIL
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.pink[200],
                      child: ClipOval(
                        child: Image.asset(
                          "assets/images/background.png", // ganti dengan foto anime user
                          fit: BoxFit.cover,
                          width: 90,
                          height: 90,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Fabian Syah",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3C3F68),
                      ),
                    ),
                    const Text(
                      "fabian@aniflix.com",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // BUTTON SETTING
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tileColor: Colors.white,
                leading: const Icon(Icons.settings, color: Colors.pink),
                title: const Text("Settings"),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: nanti bisa masuk ke halaman settings
                },
              ),

              const SizedBox(height: 30),

              // SECTION FILM YANG DITONTON
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Movies You Watched",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink[400],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // LIST MOVIES DUMMY
              Column(
                children: [
                  _buildMovieCard(
                    "Your Name",
                    "A beautiful story about love & fate.",
                    "assets/images/movies/yourname.jpg",
                  ),
                  _buildMovieCard(
                    "Spirited Away",
                    "An unforgettable magical adventure.",
                    "assets/images/movies/spiritedaway.jpg",
                  ),
                  _buildMovieCard(
                    "Attack on Titan: Final Season",
                    "Epic battles and emotional rollercoaster.",
                    "assets/images/movies/aot.jpg",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Card Movie Dummy
  Widget _buildMovieCard(String title, String review, String imagePath) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            imagePath,
            width: 50,
            height: 70,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(review, maxLines: 2, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}
