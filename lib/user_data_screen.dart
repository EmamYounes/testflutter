import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataScreen extends StatefulWidget {
  @override
  State<UserDataScreen> createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();

  String? gender;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;

    var doc =
    await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (doc.exists) {
      var data = doc.data()!;
      nameController.text = data['name'] ?? '';
      ageController.text = data['age']?.toString() ?? '';
      weightController.text = data['weight']?.toString() ?? '';
      heightController.text = data['height']?.toString() ?? '';
      gender = data['gender'];
    }

    setState(() => isLoading = false);
  }

  Future<void> saveData() async {
    if (!_formKey.currentState!.validate()) return;

    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': nameController.text.trim(),
      'age': int.parse(ageController.text),
      'weight': double.parse(weightController.text),
      'height': double.parse(heightController.text),
      'gender': gender,
    }, SetOptions(merge: true));

    Navigator.pushReplacementNamed(context, '/gallery');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Data')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) =>
                v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: weightController,
                decoration: const InputDecoration(labelText: 'Weight'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: heightController,
                decoration: const InputDecoration(labelText: 'Height'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                v == null || v.isEmpty ? 'Required' : null,
              ),
              RadioListTile(
                title: const Text('Male'),
                value: 'Male',
                groupValue: gender,
                onChanged: (v) => setState(() => gender = v),
              ),
              RadioListTile(
                title: const Text('Female'),
                value: 'Female',
                groupValue: gender,
                onChanged: (v) => setState(() => gender = v),
              ),
              ElevatedButton(
                onPressed: saveData,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
