import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // Google Sign In Function
  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser =
      await GoogleSignIn().signIn();

      if (googleUser == null) {
        return null; // user canceled
      }

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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(user: user),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'auth_service.dart';
// import 'home_screen.dart';
//
// // class LoginScreen extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     print("Login screen is running ✅");
// //
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: Center(
// //         child: ElevatedButton(
// //           onPressed: () async {
// //             final user = await AuthService.signInWithGoogle();
// //             if (user != null) {
// //               Navigator.pushReplacement(
// //                 context,
// //                 MaterialPageRoute(
// //                   builder: (_) => HomeScreen(user: user),
// //                 ),
// //               );
// //             }
// //           },
// //           child: const Text("Sign in with Google"),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //............................................
// // class LoginScreen extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     print("Login screen is running ✅");
// //
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: Center(
// //         child: ElevatedButton(
// //           onPressed: () async {
// //             final user = await AuthService.signInWithGoogle();
// //
// //             if (user != null) {
// //               Navigator.pushReplacement(
// //                 context,
// //                 MaterialPageRoute(
// //                   builder: (_) => HomeScreen(user: user),
// //                 ),
// //               );
// //             } else {
// //               ScaffoldMessenger.of(context).showSnackBar(
// //                 SnackBar(
// //                   content: Text("Login failed, please try again"),
// //                 ),
// //               );
// //             }
// //           },
// //           child: const Text("Sign in with Google"),
// //         ),
// //       ),
// //     );
// //   }
// // }
// class LoginScreen extends StatefulWidget {
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   bool isLoading = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: isLoading
//             ? CircularProgressIndicator()
//             : ElevatedButton(
//           onPressed: () async {
//             setState(() {
//               isLoading = true;
//             });
//
//             final user = await AuthService.signInWithGoogle();
//
//             setState(() {
//               isLoading = false;
//             });
//
//             if (user != null) {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => HomeScreen(user: user),
//                 ),
//               );
//             } else {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text("Login failed, please try again"),
//                 ),
//               );
//             }
//           },
//           child: Text("Sign in with Google"),
//         ),
//       ),
//     );
//   }
// }
