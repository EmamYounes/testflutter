import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Hello, ${user.displayName}",
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(user.photoURL ?? ""),
            ),
            const SizedBox(height: 10),
            Text(user.email ?? ""),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => logout(context),
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class HomeScreen extends StatelessWidget {
//   final User user;
//
//   const HomeScreen({required this.user});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Welcome")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("Hello, ${user.displayName}"),
//             CircleAvatar(
//               radius: 40,
//               backgroundImage: NetworkImage(user.photoURL!),
//             ),
//             Text(user.email!),
//           ],
//         ),
//       ),
//     );
//   }
// }
