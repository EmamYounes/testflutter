import 'package:flutter/material.dart';
import 'upload_image_screen.dart';

class ItemModel {
  final String imageUrl;
  final String title;
  final String description;

  const ItemModel({
    required this.imageUrl,
    required this.title,
    required this.description,
  });
}

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  final List<ItemModel> items = const [
    ItemModel(
      imageUrl: 'https://picsum.photos/200/300',
      title: 'First Pic',
      description: 'any pic w keda',
    ),
    ItemModel(
      imageUrl: 'https://picsum.photos/200/301',
      title: 'Second Pic',
      description: 'bla bla blaaaaa',
    ),
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
              leading: Image.network(
                item.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
              title: Text(item.title),
              subtitle: Text(item.description),


              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UploadImageScreen(
                      title: item.title,
                      imageUrl: item.imageUrl,
                    ),
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
