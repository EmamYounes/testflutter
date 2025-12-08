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



// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'login_screen.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     navigateToNext();
//   }
//
//   void navigateToNext() async {
//     // ننتظر 3 ثواني
//     await Future.delayed(Duration(seconds: 5 ));
//
//     // نجيب حالة تسجيل الدخول
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
//
//     if (isLoggedIn) {
//       // لو المستخدم مسجل دخول، نروح مباشرة للـ gallery
//       Navigator.pushReplacementNamed(context, '/gallery');
//     } else {
//       // لو مش مسجل دخول، نروح للـ LoginScreen
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const LoginScreen()),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Lottie.asset('assets/lottie/splash.json'),
//       ),
//     );
//   }
// }
