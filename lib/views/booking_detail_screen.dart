import 'package:cinemax/models/list_jadwal_film.dart';
import 'package:cinemax/views/film_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingDetailPage extends StatefulWidget {
  final int filmId;
  final String filmTitle;

  const BookingDetailPage({
    super.key,
    required this.filmId,
    required this.filmTitle,
  });

  @override
  State<BookingDetailPage> createState() => _BookingDetailPageState();
}

class _BookingDetailPageState extends State<BookingDetailPage>
    with TickerProviderStateMixin {
  late Future<List<DatumJadwal>> _jadwalFuture;

  String? selectedDate;
  String? selectedCinema;
  String? selectedTime;
  final List<String> dummySeats = [
    "A1",
    "A2",
    "A3",
    "A4",
    "B1",
    "B2",
    "B3",
    "B4",
    "C1",
    "C2",
    "C3",
    "C4",
  ];
  String? selectedSeat;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _jadwalFuture = FilmService.fetchJadwalFilmById(widget.filmId);
    _tabController = TabController(length: 2, vsync: this);
  }

  void _retryFetch() {
    setState(() {
      _jadwalFuture = FilmService.fetchJadwalFilmById(widget.filmId);
    });
  }

  List<String> _getUniqueDates(List<DatumJadwal> jadwals) {
    final dates = jadwals
        .map(
          (e) => e.startTime != null
              ? DateFormat('yyyy-MM-dd').format(e.startTime!)
              : '',
        )
        .toSet()
        .toList();
    dates.removeWhere((e) => e.isEmpty);
    return dates;
  }

  List<String> _getCinemasByDate(List<DatumJadwal> jadwals, String date) {
    final cinemas = jadwals
        .where(
          (e) =>
              e.startTime != null &&
              DateFormat('yyyy-MM-dd').format(e.startTime!) == date,
        )
        .map(
          (e) => (e.cinema ?? "Unknown Cinema").toString(),
        ) // paksa jadi String
        .toSet()
        .toList();
    return cinemas;
  }

  List<String> _getTimesByDateAndCinema(
    List<DatumJadwal> jadwals,
    String date,
    String cinema,
  ) {
    final times = jadwals
        .where(
          (e) =>
              e.startTime != null &&
              DateFormat('yyyy-MM-dd').format(e.startTime!) == date &&
              (e.cinema ?? "Unknown Cinema") == cinema,
        )
        .map((e) => DateFormat('HH:mm').format(e.startTime!))
        .toList();
    return times;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text(widget.filmTitle),
      ),
      body: FutureBuilder<List<DatumJadwal>>(
        future: _jadwalFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Error: ${snapshot.error}"),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _retryFetch,
                    child: const Text("Coba Lagi"),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada jadwal tersedia"));
          }

          final jadwals = snapshot.data!;
          final film = jadwals.first.film;

          final dates = _getUniqueDates(jadwals);
          final cinemas = selectedDate != null
              ? _getCinemasByDate(jadwals, selectedDate!)
              : [];
          final times = (selectedDate != null && selectedCinema != null)
              ? _getTimesByDateAndCinema(
                  jadwals,
                  selectedDate!,
                  selectedCinema!,
                )
              : [];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Trailer / Poster
                if (film?.youtubeUrl != null)
                  GestureDetector(
                    onTap: () async {
                      final url = Uri.parse(film.youtubeUrl!);
                      if (await canLaunchUrl(url))
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.network(
                          film!.imageUrl ?? '',
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        const Icon(
                          Icons.play_circle_fill,
                          size: 60,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  )
                else
                  Image.network(
                    film!.imageUrl ?? '',
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),

                const SizedBox(height: 12),

                // Poster + Info
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          film.imageUrl ?? '',
                          width: 80,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              film.title ?? "No Title",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(film.genre ?? "Unknown Genre"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Tab Deskripsi / Jadwal
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.pinkAccent,
                  unselectedLabelColor: Colors.black54,
                  indicatorColor: Colors.pinkAccent,
                  tabs: const [
                    Tab(text: "Deskripsi"),
                    Tab(text: "Jadwal"),
                  ],
                ),
                SizedBox(
                  height: 400,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Deskripsi
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(film.genre ?? 'No Description'),
                      ),

                      // Jadwal
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Pilih Tanggal:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 40,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: dates.length,
                                itemBuilder: (context, index) {
                                  final date = dates[index];
                                  final formatted = DateFormat(
                                    'dd MMM',
                                  ).format(DateTime.parse(date));
                                  final isSelected = selectedDate == date;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedDate = date;
                                        selectedCinema = null;
                                        selectedTime = null;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      margin: const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.pinkAccent
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.pinkAccent,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          formatted,
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Pilih Bioskop
                            if (selectedDate != null) ...[
                              const Text(
                                "Pilih Bioskop:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                children: cinemas.map((c) {
                                  final isSelected = selectedCinema == c;
                                  return ChoiceChip(
                                    label: Text(c),
                                    selected: isSelected,
                                    selectedColor: Colors.pinkAccent,
                                    onSelected: (_) {
                                      setState(() {
                                        selectedCinema = c;
                                        selectedTime = null;
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 12),
                            ],

                            // Pilih Jam
                            if (selectedCinema != null) ...[
                              const Text(
                                "Pilih Jam:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                children: times.map((t) {
                                  final isSelected = selectedTime == t;
                                  return ChoiceChip(
                                    label: Text(t),
                                    selected: isSelected,
                                    selectedColor: Colors.pinkAccent,
                                    onSelected: (_) {
                                      setState(() {
                                        selectedTime = t;
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                      ),
                      onPressed:
                          (selectedDate != null &&
                              selectedCinema != null &&
                              selectedTime != null)
                          ? () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Booking ${film.title}, tanggal $selectedDate, bioskop $selectedCinema, jam $selectedTime",
                                  ),
                                ),
                              );
                            }
                          : null,
                      child: const Text("Beli Tiket"),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
