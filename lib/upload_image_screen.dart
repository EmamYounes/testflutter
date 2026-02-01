import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'horde_service.dart';
import 'preview_screen.dart';
import 'dart:typed_data';


class UploadImageScreen extends StatefulWidget {
  final String title;

  const UploadImageScreen({super.key, required this.title});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File? userImage;
  final picker = ImagePicker();
  final promptController = TextEditingController();
  bool isLoading = false;

  Future<void> pickImage() async {
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() => userImage = File(picked.path));
    }
  }

  Future<void> generateOnly() async {
    if (promptController.text.trim().isEmpty) {
      showMsg("أكتبي Prompt الأول");
      return;
    }

    setState(() => isLoading = true);

    try {
      final bytes =
      await HordeService.generate(prompt: promptController.text.trim());

      goToPreview(bytes);
    } catch (e) {
      showMsg("Error: $e");
    }

    setState(() => isLoading = false);
  }

  Future<void> editImage() async {
    if (userImage == null) {
      showMsg("اختاري صورة الأول");
      return;
    }
    if (promptController.text.trim().isEmpty) {
      showMsg("أكتبي Prompt الأول");
      return;
    }

    setState(() => isLoading = true);

    try {
      final bytes = await HordeService.edit(
        image: userImage!,
        prompt: promptController.text.trim(),
      );

      goToPreview(bytes);
    } catch (e) {
      showMsg("Error: $e");
    }

    setState(() => isLoading = false);
  }

  void goToPreview(Uint8List bytes) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PreviewScreen(
          imageBytes: bytes,
          title: widget.title,
        ),
      ),
    );
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: promptController,
              decoration: const InputDecoration(
                labelText: "Prompt",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: pickImage,
              child: const Text("Upload Image for Editing"),
            ),

            if (userImage != null)
              Image.file(userImage!, height: 180),

            const Spacer(),

            if (!isLoading)
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: generateOnly,
                        child: const Text("Generate From Prompt")),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: editImage,
                        child: const Text("Edit Uploaded Image")),
                  ),
                ],
              ),

            if (isLoading)
              const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
