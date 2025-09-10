import 'dart:convert';

import 'package:cinemax/api/tiket_service.dart';
import 'package:cinemax/models/tiket_film_saya.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart'; // Import package QR

class TiketSayaPage extends StatefulWidget {
  const TiketSayaPage({super.key});

  @override
  State<TiketSayaPage> createState() => _TiketSayaPageState();
}

class _TiketSayaPageState extends State<TiketSayaPage> {
  late Future<List<Datum>> _tiketFuture;

  @override
  void initState() {
    super.initState();
    Intl.defaultLocale = 'id_ID';
    _refreshTiketList();
  }

  void _refreshTiketList() {
    setState(() {
      _tiketFuture = TiketService.getTiketSaya();
    });
  }

  String formatTanggal(DateTime? dt) {
    if (dt == null) return "-";
    return DateFormat('EEEE, dd MMMM yyyy').format(dt);
  }

  String formatJam(DateTime? dt) {
    if (dt == null) return "-";
    return DateFormat('HH:mm').format(dt);
  }

  // Fungsi untuk menampilkan QR code
  void _showTicketQRCode(Datum tiket) {
    // Data yang akan diencode ke QR code
    final qrData = jsonEncode({
      'ticket_id': tiket.id,
      'film': tiket.schedule?.film?.title,
      'cinema': tiket.schedule?.cinema?.name,
      'date': formatTanggal(tiket.schedule?.startTime),
      'time': formatJam(tiket.schedule?.startTime),
      'quantity': tiket.quantity,
      'total_price': tiket.totalPrice,
    });

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        insetPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Tiket ${tiket.schedule?.film?.title ?? 'Film'}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "${tiket.schedule?.cinema?.name ?? 'Bioskop'} • ${formatTanggal(tiket.schedule?.startTime)}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),
              // Widget QR code
              QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 200,
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 15),
              Text(
                "ID Tiket: ${tiket.id}",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              const Text(
                "Tunjukkan QR code ini di bioskop",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text("Tutup"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(int ticketId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus tiket ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              try {
                await TiketService.deleteTiket(ticketId: ticketId);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tiket berhasil dihapus'),
                    backgroundColor: Colors.green,
                  ),
                );
                _refreshTiketList();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Gagal menghapus tiket: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showUpdateDialog(Datum tiket) {
    final quantityController = TextEditingController(
      text: tiket.quantity.toString(),
    );
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ubah Jumlah Tiket'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: 'Jumlah Tiket Baru',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Jumlah tidak boleh kosong';
              }
              if (int.tryParse(value) == null || int.parse(value) <= 0) {
                return 'Masukkan jumlah yang valid (lebih dari 0)';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                Navigator.of(ctx).pop();
                final newQuantity = int.parse(quantityController.text);
                try {
                  await TiketService.updateTiket(
                    ticketId: tiket.id!,
                    newQuantity: newQuantity,
                    scheduleId: tiket.schedule!.id!, // Mengirim schedule_id
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Jumlah tiket berhasil diperbarui'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  _refreshTiketList();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal memperbarui tiket: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tiket Saya")),
      body: FutureBuilder<List<Datum>>(
        future: _tiketFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Terjadi kesalahan: ${snapshot.error}",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: _refreshTiketList,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final tiketList = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: tiketList.length,
              itemBuilder: (context, index) {
                final tiket = tiketList[index];
                final schedule = tiket.schedule;
                final price = num.tryParse(tiket.totalPrice ?? '0') ?? 0;

                return Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.red.shade50, Colors.red.shade100],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 70.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      schedule?.film?.title ??
                                          "Judul Film Tidak Tersedia",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      schedule?.cinema?.name ??
                                          "Nama Bioskop Tidak Tersedia",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(height: 24, thickness: 1),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildDetailColumn(
                                    "Tanggal",
                                    formatTanggal(schedule?.startTime),
                                  ),
                                  _buildDetailColumn(
                                    "Jam",
                                    formatJam(schedule?.startTime),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildDetailColumn(
                                    "Jumlah",
                                    "${tiket.quantity ?? '-'} tiket",
                                  ),
                                  _buildDetailColumn(
                                    "Total",
                                    "Rp ${NumberFormat('#,###').format(price)}",
                                    isPrice: true,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Center(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    _showTicketQRCode(
                                      tiket,
                                    ); // Panggil fungsi untuk menampilkan QR
                                  },
                                  icon: const Icon(
                                    Icons.qr_code,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    "Lihat Tiket",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    backgroundColor: Colors.redAccent,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blueGrey,
                                ),
                                tooltip: 'Ubah Jumlah Tiket',
                                onPressed: () {
                                  if (tiket.id != null &&
                                      tiket.schedule?.id != null) {
                                    _showUpdateDialog(tiket);
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                tooltip: 'Hapus Tiket',
                                onPressed: () {
                                  if (tiket.id != null) {
                                    _showDeleteConfirmationDialog(tiket.id!);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text("Anda belum memesan tiket apapun."),
            );
          }
        },
      ),
    );
  }

  Widget _buildDetailColumn(
    String title,
    String value, {
    bool isPrice = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: isPrice ? Colors.red : Colors.black,
            fontWeight: isPrice ? FontWeight.bold : FontWeight.normal,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
