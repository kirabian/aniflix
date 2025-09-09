import 'package:cinemax/extension/navigation.dart';
import 'package:cinemax/shared_preferenced/preference.dart';
import 'package:cinemax/views/login_Screen.dart';
import 'package:cinemax/views/main_screen.dart';
import 'package:cinemax/widgets/appimage.dart';
import 'package:flutter/material.dart';

class Day16SplashScreen extends StatefulWidget {
  const Day16SplashScreen({super.key});
  static const id = "/splash_screen";

  @override
  State<Day16SplashScreen> createState() => _Day16SplashScreenState();
}

class _Day16SplashScreenState extends State<Day16SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  void _checkLogin() async {
    bool? isLogin = await PreferenceHandler.getLogin();

    Future.delayed(const Duration(seconds: 2)).then((value) {
      if (!mounted) return;

      if (isLogin == true) {
        context.pushReplacementNamed(MainScreen.id);
      } else {
        context.push(LoginScreenAniFlix());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(AppImage.Background, fit: BoxFit.cover),
      ),
    );
  }
}
