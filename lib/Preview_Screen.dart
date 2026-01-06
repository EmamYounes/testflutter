import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class PreviewScreen extends StatelessWidget {
  final File generatedImage;
  final String title;

  const PreviewScreen({
    super.key,
    required this.generatedImage,
    required this.title,
  });

  Future<void> saveImage(BuildContext context) async {
    // Placeholder: show SnackBar (يمكن تحديث لاحقاً لحفظ حقيقي)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Image saved (mock)")),
    );
  }

  Future<void> shareImage(BuildContext context) async {
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/shared_image.png');
    await tempFile.writeAsBytes(await generatedImage.readAsBytes());
    await Share.shareFiles([tempFile.path], text: title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  generatedImage,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text("Save"),
                    onPressed: () => saveImage(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.share),
                    label: const Text("Share"),
                    onPressed: () => shareImage(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text("Generate Again"),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
