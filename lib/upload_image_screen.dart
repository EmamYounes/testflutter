import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'horde_service.dart';
import 'preview_screen.dart';

class UploadImageScreen extends StatefulWidget {
  final String title;
  final String prompt;

  const UploadImageScreen({
    super.key,
    required this.title,
    required this.prompt,
  });

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File? userImage;
  bool isLoading = false;
  final ImagePicker picker = ImagePicker();

  /// اختيار صورة من المعرض
  Future<void> pickImage() async {
    final XFile? picked =
    await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        userImage = File(picked.path);
      });
    }
  }

  /// تحقق من الإنترنت
  Future<bool> hasInternet() async {
    final connectivityResult =
    await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  /// تنفيذ التعديل باستخدام AI Horde
  Future<void> submitImage() async {
    if (userImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload image first")),
      );
      return;
    }

    if (!await hasInternet()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No Internet Connection")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      /// 🔥 استدعاء Horde img2img
      Uint8List bytes = await HordeService.edit(
        image: userImage!,
        prompt: widget.prompt,
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PreviewScreen(
            imageBytes: bytes,   // 👈 متوافق مع البريفيو
            title: widget.title, // 👈 متوافق مع البريفيو
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// عرض اسم الستايل
            Text(
              "Style: ${widget.title}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
              ),
              child: const Text(
                "Upload Image",
                style: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 20),

            if (userImage != null)
              Image.file(
                userImage!,
                height: 200,
              ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : submitImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding:
                  const EdgeInsets.symmetric(vertical: 14),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text(
                  "Generate",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
