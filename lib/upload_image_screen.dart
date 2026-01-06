import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:path_provider/path_provider.dart';

import 'Preview_Screen.dart';
import 'gemini_service.dart';

class UploadImageScreen extends StatefulWidget {
  final String title;
  final String imageUrl;

  const UploadImageScreen({
    super.key,
    required this.title,
    required this.imageUrl,
  });

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File? userImage;
  bool isLoading = false;
  final ImagePicker picker = ImagePicker();
  final TextEditingController promptController = TextEditingController();

  /// Pick Image from Gallery
  Future<void> pickImage() async {
    try {
      final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() {
          userImage = File(picked.path);
        });
        print("Image selected: ${picked.path}");
      } else {
        print("No image selected");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  /// Check Internet
  Future<bool> hasInternet() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      print("Error checking internet: $e");
      return false;
    }
  }

  /// Submit Logic (Gemini)
  Future<void> submitImage() async {
    print("submitImage called");

    if (userImage == null || promptController.text.trim().isEmpty) {
      print("Missing image or prompt");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select image and enter prompt")),
      );
      return;
    }

    if (!await hasInternet()) {
      print("No internet connection");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ No Internet Connection")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });
    print("Start generating image...");

    try {
      final Uint8List generatedBytes =
      await GeminiService.generateImageFromPrompt(
        image: userImage!,
        prompt: promptController.text.trim(),
      );

      print("Image generated, bytes length: ${generatedBytes.length}");

      final tempDir = await getTemporaryDirectory();
      final File generatedImage = File('${tempDir.path}/generated.png');
      await generatedImage.writeAsBytes(generatedBytes);

      if (!mounted) return;

      print("Navigating to PreviewScreen");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PreviewScreen(
            generatedImage: generatedImage,
            title: widget.title,
          ),
        ),
      );
    } catch (e) {
      print("Error in generation: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
      print("submitImage finished");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Image")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Image from previous screen
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.imageUrl,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),

            /// Title
            Text(
              widget.title,
              style:
              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            /// Prompt
            TextField(
              controller: promptController,
              decoration: const InputDecoration(
                labelText: "Prompt",
                hintText: "Describe what you want to generate...",
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            /// Upload Button
            ElevatedButton.icon(
              onPressed: pickImage,
              icon: const Icon(Icons.upload),
              label: const Text("Upload Image"),
            ),
            const SizedBox(height: 16),

            /// User Image Preview
            if (userImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  userImage!,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const Spacer(),

            /// Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : submitImage,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Generate"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
