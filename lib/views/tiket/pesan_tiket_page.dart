import 'package:cinemax/api/tiket_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PesanTiketPage extends StatefulWidget {
  final int scheduleId;
  final String filmTitle;
  final String cinemaName;
  final String date;
  final String time;
  final String price;
  final String? startTimeFromApi;

  const PesanTiketPage({
    super.key,
    required this.scheduleId,
    required this.filmTitle,
    required this.cinemaName,
    required this.date,
    required this.time,
    required this.price,
    this.startTimeFromApi,
  });

  @override
  State<PesanTiketPage> createState() => _PesanTiketPageState();
}

class _PesanTiketPageState extends State<PesanTiketPage> {
  int quantity = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _debugPrintData();
  }

  void _debugPrintData() {
    print('=== DEBUG DATA PESAN TIKET ===');
    print('Film: ${widget.filmTitle}');
    print('Bioskop: ${widget.cinemaName}');
    print('Date: ${widget.date}');
    print('Time: ${widget.time}');
    print('Raw Price: "${widget.price}"');
    print('Schedule ID: ${widget.scheduleId}');
    print('StartTimeFromApi: ${widget.startTimeFromApi}');
    print('Parsed hargaPerTiket: $hargaPerTiket');
    print('Formatted harga: ${formatCurrency(hargaPerTiket)}');
    print('Total: ${formatCurrency(total)}');
    print('==============================');
  }

  /// Parsing harga dengan berbagai format
  int get hargaPerTiket {
    if (widget.price.isEmpty) {
      print('WARNING: Price is empty');
      return 0;
    }

    try {
      print('DEBUG - Raw price string: "${widget.price}"');

      // Coba parsing langsung sebagai angka
      if (RegExp(r'^\d+$').hasMatch(widget.price)) {
        return int.parse(widget.price);
      }

      // Handle format dengan "Rp" dan titik
      String cleaned = widget.price
          .replaceAll(RegExp(r'[^\d]'), '') // Hapus semua non-digit
          .trim();

      print('DEBUG - After cleaning: "$cleaned"');

      if (cleaned.isEmpty) {
        print('WARNING: Cleaned price is empty');
        return 0;
      }

      int parsedValue = int.tryParse(cleaned) ?? 0;
      print('DEBUG - Parsed value: $parsedValue');

      return parsedValue;
    } catch (e) {
      print('ERROR parsing price: $e');
      return 0;
    }
  }

  int get total => hargaPerTiket * quantity;

  /// Format currency Indonesia
  String formatCurrency(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  /// Format tanggal dan waktu untuk tampilan
  String formatDisplayDateTime(DateTime dateTime) {
    return DateFormat(
      'dd MMMM yyyy, HH:mm',
      'id_ID',
    ).format(dateTime.toLocal());
  }

  /// Cek apakah jadwal masih valid dengan penyesuaian zona waktu
  bool get isScheduleValid {
    try {
      final now = DateTime.now().toLocal();
      final scheduleTime = _parseScheduleTime().toLocal();
      return scheduleTime.isAfter(now);
    } catch (e) {
      print('Error parsing schedule time: $e');
      return false;
    }
  }

  /// Dapatkan waktu jadwal yang sudah diformat untuk display
  String get formattedScheduleTime {
    try {
      final scheduleTime = _parseScheduleTime().toLocal();
      return formatDisplayDateTime(scheduleTime);
    } catch (e) {
      return '${widget.date} ${widget.time}';
    }
  }

  /// Parse waktu jadwal dari API dengan penanganan zona waktu
  DateTime _parseScheduleTime() {
    // Prioritaskan menggunakan startTimeFromApi jika tersedia
    if (widget.startTimeFromApi != null) {
      return DateTime.parse(widget.startTimeFromApi!);
    }

    // Fallback: gabungkan date dan time
    try {
      // Format date dari API (YYYY-MM-DD) dan time (HH:MM)
      final datePart = DateFormat('yyyy-MM-dd').parse(widget.date);
      final timePart = DateFormat('HH:mm').parse(widget.time);

      return DateTime(
        datePart.year,
        datePart.month,
        datePart.day,
        timePart.hour,
        timePart.minute,
      );
    } catch (e) {
      print('Error parsing combined date/time: $e');
      throw Exception('Invalid date/time format');
    }
  }

  Future<void> _pesanTiket() async {
    // Validasi jadwal sebelum memesan dengan zona waktu lokal
    if (!isScheduleValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tidak dapat memesan untuk jadwal yang sudah lewat"),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    final result = await TiketService.pesanTiket(
      scheduleId: widget.scheduleId,
      quantity: quantity,
    );

    setState(() => isLoading = false);

    if (result.data != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Tiket berhasil dipesan!")));
      Navigator.pop(context, true);
    } else {
      // Tampilkan error message dari API jika ada
      final errorMessage = result.message ?? "Gagal memesan tiket";
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pesan Tiket"),
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informasi Film dan Jadwal
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Detail Pesanan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.pinkAccent,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow("Film", widget.filmTitle),
                    _buildInfoRow("Bioskop", widget.cinemaName),
                    _buildInfoRow("Tanggal Tayang", formattedScheduleTime),
                    _buildInfoRow(
                      "Zona Waktu",
                      "Waktu Indonesia (${DateFormat('zzz', 'id_ID').format(DateTime.now().toLocal())})",
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Jumlah Tiket
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Jumlah Tiket",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: quantity > 1
                              ? () => setState(() => quantity--)
                              : null,
                          icon: Icon(
                            Icons.remove_circle,
                            color: quantity > 1
                                ? Colors.pinkAccent
                                : Colors.grey,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          "$quantity",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          onPressed: () => setState(() => quantity++),
                          icon: const Icon(
                            Icons.add_circle,
                            color: Colors.pinkAccent,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Harga
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Detail Harga",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildPriceRow(
                      "Harga per tiket",
                      formatCurrency(hargaPerTiket),
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 8),
                    _buildPriceRow(
                      "Total",
                      formatCurrency(total),
                      isTotal: true,
                    ),
                  ],
                ),
              ),
            ),

            // Informasi waktu saat ini
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "Waktu saat ini: ${DateFormat('dd MMMM yyyy, HH:mm:ss', 'id_ID').format(DateTime.now().toLocal())}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const Spacer(),

            // Tombol Pesan
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: (isLoading || !isScheduleValid) ? null : _pesanTiket,
                style: ElevatedButton.styleFrom(
                  backgroundColor: !isScheduleValid
                      ? Colors.grey
                      : Colors.pinkAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : !isScheduleValid
                    ? const Text(
                        "Jadwal sudah lewat",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "Pesan Tiket",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.pinkAccent : Colors.black87,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.pinkAccent : Colors.black87,
          ),
        ),
      ],
    );
  }
}
