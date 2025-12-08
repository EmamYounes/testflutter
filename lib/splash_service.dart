import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashService {
  final BehaviorSubject<bool> _loginState = BehaviorSubject<bool>();

  Stream<bool> get loginStateStream => _loginState.stream;

  SplashService() {
    _init();
  }

  void _init() async {
    await Future.delayed(const Duration(seconds: 5));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _loginState.add(isLoggedIn);
  }

  void dispose() {
    _loginState.close();
  }
}
