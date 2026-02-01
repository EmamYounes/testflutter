import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

class PreviewScreen extends StatelessWidget {
  final Uint8List imageBytes;
  final String title;

  const PreviewScreen({
    super.key,
    required this.imageBytes,
    required this.title,
  });

  Future<void> saveImage() async {
    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/saved.png");
    await file.writeAsBytes(imageBytes);
  }

  Future<void> shareImage() async {
    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/share.png");
    await file.writeAsBytes(imageBytes);
    await Share.shareFiles([file.path]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        children: [
          Expanded(
            child: Image.memory(imageBytes),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: saveImage, child: const Text("Save")),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: shareImage, child: const Text("Share")),
          ),
        ],
      ),
    );
  }
}
