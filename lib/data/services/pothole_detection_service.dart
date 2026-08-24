import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

/// Top-level function for compute() background isolate preprocessing
Float32List _preprocessImageIsolate(Uint8List imageBytes) {
  final rawImage = img.decodeImage(imageBytes);
  if (rawImage == null) return Float32List(0);

  // Crop to square (center)
  int size = min(rawImage.width, rawImage.height);
  int x = (rawImage.width - size) ~/ 2;
  int y = (rawImage.height - size) ~/ 2;
  final croppedImage = img.copyCrop(rawImage, x: x, y: y, width: size, height: size);

  // Resize to 640x640
  final resizedImage = img.copyResize(croppedImage, width: 640, height: 640);

  // Preprocess (normalize 0-1)
  var input = Float32List(1 * 640 * 640 * 3);
  var buffer = input.buffer.asFloat32List();
  int pixelIndex = 0;
  for (int i = 0; i < 640; i++) {
    for (int j = 0; j < 640; j++) {
      final pixel = resizedImage.getPixel(j, i);
      buffer[pixelIndex++] = pixel.r / 255.0;
      buffer[pixelIndex++] = pixel.g / 255.0;
      buffer[pixelIndex++] = pixel.b / 255.0;
    }
  }
  return input;
}

class PotholeDetectionService {
  Interpreter? _interpreter;
  bool _isModelLoaded = false;

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/models/best_float32.tflite');
      _isModelLoaded = true;
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  Future<bool> detectPothole(File imageFile) async {
    if (!_isModelLoaded) await loadModel();
    if (_interpreter == null) return false;

    try {
      // 1-4. Offload heavy image decoding & preprocessing to background isolate
      final imageBytes = await imageFile.readAsBytes();
      final input = await compute(_preprocessImageIsolate, imageBytes);
      if (input.isEmpty) return false;

      // 5. Setup output (1, 5, 8400)
      var output = List.filled(1 * 5 * 8400, 0.0).reshape([1, 5, 8400]);

      // 6. Inference
      _interpreter!.run(input.buffer.asFloat32List().reshape([1, 640, 640, 3]), output);

      // 7. Post-process (Parity with Android / YOLOv8)
      double maxConfidence = -1.0;
      int highConfCount = 0;
      
      final results = output[0] as List<List<double>>;
      final confidences = results[4]; // Row 4
      
      for (var conf in confidences) {
        if (conf > maxConfidence) maxConfidence = conf;
        if (conf > 0.5) highConfCount++;
      }

      print('Inference Success: maxConfidence=$maxConfidence, highConfCount=$highConfCount');

      return (maxConfidence > 0.5 || highConfCount > 0);
    } catch (e) {
      print('Inference Error: $e');
      return false;
    }
  }

  void dispose() {
    _interpreter?.close();
  }
}
