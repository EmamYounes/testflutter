import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testflutter/user_data_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // Google Sign In Function
  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser =
      await GoogleSignIn().signIn();

      if (googleUser == null) return null; // user canceled the login

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      return userCredential.user;

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
      return null;
    }
  }

  // Check if user data exists in Firestore
  Future<bool> doesUserDataExist(String uid) async {
    var doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();

    return doc.exists;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.login),
          label: const Text("Sign in with Google"),
          onPressed: () async {

            User? user = await signInWithGoogle(context);

            if (user != null) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', true);

              bool dataExists = await doesUserDataExist(user.uid);


              if (dataExists) {

                Navigator.pushReplacementNamed(context, '/gallery');
              } else {

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => UserDataScreen()),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
