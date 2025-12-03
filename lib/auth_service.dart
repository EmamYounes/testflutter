import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  Future<bool> isLoggedIn() async {
    await Future.delayed(Duration(seconds: 2)); // محاكاة API
    return false; // هغيّرها حسب الحاجة
  }
  static Future<User?> signInWithGoogle() async {
    try {
      print("Google Sign In started ✅");

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        print("User cancelled sign in ❌");
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      print("Google Sign In finished ✅");

      return userCredential.user;
    } catch (e) {
      print("Google Sign-in Error: $e");
      return null;
    }
  }
}
