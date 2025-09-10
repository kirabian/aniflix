import 'package:cinemax/views/date_utils.dart';
import 'package:cinemax/views/auth/login_screen.dart';
import 'package:cinemax/views/main_screen.dart';
import 'package:cinemax/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() async {
  // Pastikan binding terinisialisasi sebelum async code
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi format tanggal lokal Indonesia
  await initializeDateFormatting('id_ID');

  // Set default locale
  Intl.defaultLocale = 'id_ID';

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        datePickerTheme: DatePickerThemeData(
          backgroundColor: Colors.blue.shade100,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
      ),
      initialRoute: Day16SplashScreen.id,
      routes: {
        "/login": (context) => LoginScreenAniFlix(),
        Day16SplashScreen.id: (context) => Day16SplashScreen(),
        MainScreen.id: (context) => MainScreen(),
      },
    );
  }

  String _formatDate(String dateString) {
    try {
      final utcDate = DateTime.parse(dateString).toUtc(); // pastikan UTC
      final localDate = utcDate.toLocal(); // convert ke lokal device
      return IndonesianDateUtils.formatDateTime(localDate);
    } catch (e) {
      return dateString;
    }
  }
}
