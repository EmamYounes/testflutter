import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'upload_image_screen.dart';

class StyleModel {
  final String id;
  final String title;
  final String description;
  final String prompt;
  final String imageUrl;

  StyleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.prompt,
    required this.imageUrl,
  });

  factory StyleModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return StyleModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      prompt: data['prompt'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gallery',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('styles').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No styles available"));
          }

          final styles = snapshot.data!.docs
              .map((doc) => StyleModel.fromDoc(doc))
              .toList();

          return ListView.builder(
            itemCount: styles.length,
            itemBuilder: (context, index) {
              final item = styles[index];

              return Padding(
                padding: const EdgeInsets.all(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UploadImageScreen(
                          title: item.title,
                          prompt: item.prompt,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: item.imageUrl.isNotEmpty
                          ? DecorationImage(
                        image: NetworkImage(item.imageUrl),
                        fit: BoxFit.cover,
                      )
                          : null,
                      color: item.imageUrl.isEmpty
                          ? Colors.grey.shade400
                          : null,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black.withOpacity(0.4),
                      ),
                      padding: const EdgeInsets.all(16),
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.description,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
