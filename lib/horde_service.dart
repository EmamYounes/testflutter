import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:http/http.dart' as http;

class HordeService {
  static const String _base = "https://aihorde.net/api/v2";
  static const String apiKey = "0000000000"; // Free anonymous key

  static Map<String, String> get _headers => {
    "Content-Type": "application/json",
    "apikey": apiKey,
  };

  /// ================== TEXT → IMAGE ==================
  static Future<Uint8List> generate({
    required String prompt,
    int width = 512,
    int height = 512,
  }) async {
    final id = await _createJob(
      {
        "prompt": prompt,
        "models": ["stable_diffusion"],
        "params": {
          "width": width,
          "height": height,
          "steps": 25,
        }
      },
    );

    final result = await _wait(id);
    return await _extractImage(result);
  }

  /// ================== IMAGE → EDIT ==================
  static Future<Uint8List> edit({
    required File image,
    required String prompt,
  }) async {
    final bytes = await image.readAsBytes();
    final b64 = base64Encode(bytes);

    final id = await _createJob(
      {
        "prompt": prompt,
        "source_image": b64,
        "source_processing": "img2img",
        "models": ["stable_diffusion"],
        "params": {
          "steps": 30,
          "denoising_strength": 0.6,
        }
      },
    );

    final result = await _wait(id);
    return await _extractImage(result);
  }

  /// ================== INTERNAL ==================

  static Future<String> _createJob(Map payload) async {
    final res = await http.post(
      Uri.parse("$_base/generate/async"),
      headers: _headers,
      body: jsonEncode(payload),
    );

    final data = jsonDecode(res.body);
    return data["id"];
  }

  static Future<Map<String, dynamic>> _wait(String id) async {
    final url = Uri.parse("$_base/generate/status/$id");

    for (int i = 0; i < 200; i++) {
      final res = await http.get(url, headers: _headers);
      final data = jsonDecode(res.body);

      if (data["done"] == true && data["generations"]?.isNotEmpty == true) {
        return data["generations"][0];
      }

      await Future.delayed(const Duration(seconds: 2));
    }

    throw Exception("Timeout — please try again");
  }

  /// ================== IMAGE DECODER ==================
  static Future<Uint8List> _extractImage(Map gen) async {
    final img = gen["img"];

    // 1) Base64 case → decode directly
    final bool isURL = img.startsWith("http");

    if (!isURL) {
      return base64Decode(img);
    }

    // 2) URL case → download
    final url = Uri.parse(img);
    final res = await http.get(url);

    if (res.statusCode == 200) {
      return res.bodyBytes;
    }

    throw Exception("Failed to download image from URL");
  }
}
