import 'package:cinemax/views/login_Screen.dart';
import 'package:cinemax/views/main_screen.dart';
import 'package:cinemax/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() async {
  // Pastikan binding terinisialisasi sebelum async code
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi format tanggal lokal Indonesia
  await initializeDateFormatting('id_ID', null);

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
        "/login": (context) => LoginScreen02(),
        Day16SplashScreen.id: (context) => Day16SplashScreen(),
        MainScreen.id: (context) => MainScreen(),
      },
    );
  }
}
