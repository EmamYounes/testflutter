import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/user_data/upload_bloc.dart';
import 'bloc/user_data/upload_event.dart';
import 'bloc/user_data/upload_state.dart';
import 'Preview_Screen.dart';

class UploadImageScreen extends StatelessWidget {
  final String title;
  final String prompt;

  const UploadImageScreen({
    super.key,
    required this.title,
    required this.prompt,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UploadBloc(),
      child: UploadView(title: title, prompt: prompt),
    );
  }
}

class UploadView extends StatelessWidget {
  final String title;
  final String prompt;

  const UploadView({
    super.key,
    required this.title,
    required this.prompt,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<UploadBloc, UploadState>(
          listener: (context, state) {
            if (state is UploadError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }

            if (state is ImageGeneratedState) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PreviewScreen(
                    imageBytes: state.imageBytes,
                    title: title,
                  ),
                ),
              );
            }
          },

          builder: (context, state) {
            final bloc = context.read<UploadBloc>();
            File? image;

            if (state is ImagePickedState) {
              image = state.image;
            }

            return Column(
              children: [
                const SizedBox(height: 20),

                Text(
                  "Style: $title",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    bloc.add(PickImageEvent());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  ),
                  child: const Text(
                    "Upload Image",
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                const SizedBox(height: 20),

                if (image != null)
                  Image.file(
                    image,
                    height: 200,
                  ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state is UploadLoading
                        ? null
                        : () {
                      if (image == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Please upload image")),
                        );
                        return;
                      }

                      bloc.add(
                        GenerateImageEvent(
                          image: image!,
                          prompt: prompt,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: state is UploadLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "Generate",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}