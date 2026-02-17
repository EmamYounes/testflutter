import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  /// حفظ بيانات المستخدم
  static Future<void> saveUserData({
    required String name,
    required int age,
    required double weight,
    required double height,
    required String? gender,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    await _firestore.collection('users').doc(user.uid).set({
      'name': name,
      'age': age,
      'weight': weight,
      'height': height,
      'gender': gender,
      'email': user.email,
      'uid': user.uid,
      'updatedAt': Timestamp.now(),
    }, SetOptions(merge: true));
  }

  /// تحميل بيانات المستخدم
  static Future<Map<String, dynamic>?> loadUserData() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    final doc =
    await _firestore.collection('users').doc(user.uid).get();

    return doc.data();
  }
}
