import 'dart:io';
import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const String apiKey = 'AIzaSyCjJhQqritdiDMrzo5wDu0ESND7O0vXnRY';

  static Future<Uint8List> generateImageFromPrompt({
    required File image,
    required String prompt,
  }) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );


    final imageBytes = await image.readAsBytes();

    final content = [
      Content.multi([
        TextPart(prompt),
        DataPart('image/jpeg', imageBytes),
      ])
    ];

    final response = await model.generateContent(content);

    if (response.candidates == null ||
        response.candidates!.isEmpty ||
        response.candidates!.first.content.parts.isEmpty) {
      throw Exception("Gemini لم يرجّع صورة");
    }

    final part = response.candidates!.first.content.parts.first;

    if (part is DataPart) {
      return part.bytes;
    } else {
      throw Exception("الـ response مش صورة");
    }
  }
}
