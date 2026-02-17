import 'package:flutter/material.dart';
import 'user_service.dart';

class UserDataScreen extends StatefulWidget {
  const UserDataScreen({super.key});

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
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    weightController.dispose();
    heightController.dispose();
    super.dispose();
  }

  Future<void> loadUserData() async {
    try {
      final data = await UserService.loadUserData();

      if (data != null) {
        nameController.text = (data['name'] ?? '').toString();
        ageController.text = (data['age'] ?? '').toString();
        weightController.text = (data['weight'] ?? '').toString();
        heightController.text = (data['height'] ?? '').toString();
        gender = data['gender'];
      }
    } catch (e) {
      debugPrint("Load Error: $e");
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  Future<void> saveData() async {
    if (!_formKey.currentState!.validate()) return;

    if (gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select gender")),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      await UserService.saveUserData(
        name: nameController.text.trim(),
        age: int.tryParse(ageController.text) ?? 0,
        weight: double.tryParse(weightController.text) ?? 0.0,
        height: double.tryParse(heightController.text) ?? 0.0,
        gender: gender,
      );

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/gallery');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
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
                decoration:
                const InputDecoration(labelText: 'Name'),
                validator: (v) =>
                v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: ageController,
                decoration:
                const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: weightController,
                decoration:
                const InputDecoration(labelText: 'Weight'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: heightController,
                decoration:
                const InputDecoration(labelText: 'Height'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                v == null || v.isEmpty ? 'Required' : null,
              ),

              const SizedBox(height: 16),

              RadioListTile<String>(
                title: const Text('Male'),
                value: 'Male',
                groupValue: gender,
                onChanged: (v) =>
                    setState(() => gender = v),
              ),
              RadioListTile<String>(
                title: const Text('Female'),
                value: 'Female',
                groupValue: gender,
                onChanged: (v) =>
                    setState(() => gender = v),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: isSaving ? null : saveData,
                child: isSaving
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
