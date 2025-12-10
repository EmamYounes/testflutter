import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rxdart/rxdart.dart';
import 'splash_service.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SplashService _splashService;
  late Stream<bool> _loginStream;

  @override
  void initState() {
    super.initState();
    _splashService = SplashService();
    _loginStream = _splashService.loginStateStream;

    _loginStream.listen((isLoggedIn) {
      if (!mounted) return;

      if (isLoggedIn) {
        Navigator.pushReplacementNamed(context, '/gallery');
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _splashService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset('assets/lottie/splash.json'),
      ),
    );
  }
}

