import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashService {
  final _loginStateController = BehaviorSubject<bool>();

  Stream<bool> get loginStateStream => _loginStateController.stream;

  SplashService() {
    _checkLoginState();
  }

  Future<void> _checkLoginState() async {
    await Future.delayed(const Duration(seconds: 3));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    _loginStateController.add(isLoggedIn);
  }

  void dispose() {
    _loginStateController.close();
  }
}
