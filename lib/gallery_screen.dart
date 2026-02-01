import 'package:flutter/material.dart';
import 'upload_image_screen.dart';

class ItemModel {
  final String title;
  final String description;

  const ItemModel({required this.title, required this.description});
}

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  final List<ItemModel> items = const [
    ItemModel(title: 'Cartoon Style', description: 'Turn photo into cartoon'),
    ItemModel(title: 'Background Blur', description: 'Blur background effect'),
    ItemModel(title: 'Fantasy', description: 'Fantasy look'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(item.title),
              subtitle: Text(item.description),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UploadImageScreen(title: item.title),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
