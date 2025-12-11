import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataScreen extends StatefulWidget {
  @override
  _UserDataScreenState createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  String? gender = "";

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  /// تحميل بيانات المستخدم
  Future<void> loadUserData() async {
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    // لو مفيش مستخدم → نعمل تسجيل Anonymous تلقائي
    if (user == null) {
      user = (await auth.signInAnonymously()).user;
    }

    final uid = user!.uid;

    var doc = await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if (doc.exists) {
      var data = doc.data()!;
      nameController.text = data["name"] ?? "";
      ageController.text = data["age"]?.toString() ?? "";
      weightController.text = data["weight"]?.toString() ?? "";
      heightController.text = data["height"]?.toString() ?? "";
      gender = data["gender"];
    }

    setState(() => isLoading = false);
  }

  /// حفظ البيانات
  Future<void> saveData() async {
    if (!_formKey.currentState!.validate()) return;

    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection("users").doc(uid).set({
      "name": nameController.text.trim(),
      "age": int.parse(ageController.text.trim()),
      "weight": double.parse(weightController.text.trim()),
      "height": double.parse(heightController.text.trim()),
      "gender": gender,
    }, SetOptions(merge: true));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("تم حفظ البيانات بنجاح")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Data")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // NAME
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  hintText: "Please enter your name",
                ),
                maxLength: 20,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return "Name is required";
                  if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value))
                    return "Only letters allowed";
                  return null;
                },
              ),

              // AGE
              TextFormField(
                controller: ageController,
                decoration: InputDecoration(
                  labelText: "Age",
                  hintText: "Please enter your age",
                ),
                keyboardType: TextInputType.number,
                maxLength: 2,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return "Age required";
                  int age = int.tryParse(value) ?? 0;
                  if (age < 1 || age > 95)
                    return "Age must be 1–95";
                  return null;
                },
              ),

              // WEIGHT
              TextFormField(
                controller: weightController,
                decoration: InputDecoration(
                  labelText: "Weight (kg)",
                  hintText: "Please enter your weight",
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                maxLength: 3,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return "Weight required";
                  double w = double.tryParse(value) ?? 0;
                  if (w < 1 || w > 200)
                    return "Weight must be 1–200 kg";
                  return null;
                },
              ),

              // HEIGHT
              TextFormField(
                controller: heightController,
                decoration: InputDecoration(
                  labelText: "Height (cm)",
                  hintText: "Please enter your height",
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                maxLength: 3,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return "Height required";
                  double h = double.tryParse(value) ?? 0;
                  if (h < 30 || h > 250)
                    return "Height must be 30–250 cm";
                  return null;
                },
              ),

              SizedBox(height: 15),

              Text("Gender", style: TextStyle(fontSize: 18)),

              RadioListTile(
                title: Text("Male"),
                value: "Male",
                groupValue: gender,
                onChanged: (value) => setState(() => gender = value),
              ),
              RadioListTile(
                title: Text("Female"),
                value: "Female",
                groupValue: gender,
                onChanged: (value) => setState(() => gender = value),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: saveData,
                child: Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
