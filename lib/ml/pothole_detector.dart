import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

import '../../core/constants/app_constants.dart';

/// Pothole Detection Result
class DetectionResult {
  final List<BoundingBox> boxes;
  final bool hasPothole;
  final double confidence;

  const DetectionResult({
    required this.boxes,
    required this.hasPothole,
    required this.confidence,
  });

  factory DetectionResult.empty() {
    return const DetectionResult(
      boxes: [],
      hasPothole: false,
      confidence: 0.0,
    );
  }
}

/// Bounding Box for detected objects
class BoundingBox {
  final double x;
  final double y;
  final double width;
  final double height;
  final double confidence;
  final String label;

  const BoundingBox({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.confidence,
    required this.label,
  });
}

/// Pothole Detector - TensorFlow Lite model wrapper
/// Replaces Android TensorFlow Lite implementation
class PotholeDetector {
  Interpreter? _interpreter;
  bool _isModelLoaded = false;

  static const String modelPath = AppConstants.tfliteModelPath;
  static const int inputSize = AppConstants.tfliteInputSize;
  static const double confidenceThreshold = AppConstants.tfliteConfidenceThreshold;

  /// Load the TFLite model
  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(modelPath);
      _isModelLoaded = true;
      if (kDebugMode) {
        print('TFLite model loaded successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load TFLite model: $e');
      }
      throw Exception('Failed to load model: $e');
    }
  }

  /// Detect potholes in an image
  Future<DetectionResult> detectPotholes(String imagePath) async {
    if (!_isModelLoaded) {
      await loadModel();
    }

    try {
      // Load and preprocess image
      final imageData = await File(imagePath).readAsBytes();
      final image = img.decodeImage(imageData);

      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Resize to model input size
      final resized = img.copyResize(
        image,
        width: inputSize,
        height: inputSize,
      );

      // Normalize and create input tensor [1, 640, 640, 3]
      final input = _preprocessImage(resized);

      // Create output tensor
      // Output shape depends on your model - adjust as needed
      final output = List.generate(
        1,
        (i) => List.generate(
          100, // Max detections
          (j) => List.filled(6, 0.0), // [x, y, w, h, confidence, class]
        ),
      );

      // Run inference
      _interpreter?.run(input, output);

      // Process detections
      return _processDetections(output[0]);
    } catch (e) {
      if (kDebugMode) {
        print('Detection error: $e');
      }
      return DetectionResult.empty();
    }
  }

  /// Preprocess image for model input
  List<List<List<List<double>>>> _preprocessImage(img.Image image) {
    final input = List.generate(
      1,
      (i) => List.generate(
        inputSize,
        (y) => List.generate(
          inputSize,
          (x) => List.generate(3, (c) {
            final pixel = image.getPixel(x, y);
            // Normalize to [0, 1]
            return [pixel.r, pixel.g, pixel.b][c] / 255.0;
          }),
        ),
      ),
    );
    return input;
  }

  /// Process model output
  DetectionResult _processDetections(List<List<double>> detections) {
    final List<BoundingBox> boxes = [];
    double maxConfidence = 0.0;

    for (final detection in detections) {
      final confidence = detection[4];

      // Filter by confidence threshold
      if (confidence > confidenceThreshold) {
        final x = detection[0];
        final y = detection[1];
        final w = detection[2];
        final h = detection[3];
        final classId = detection[5].toInt();

        // Update max confidence
        if (confidence > maxConfidence) {
          maxConfidence = confidence;
        }

        boxes.add(BoundingBox(
          x: x,
          y: y,
          width: w,
          height: h,
          confidence: confidence,
          label: classId == 0 ? 'pothole' : 'unknown',
        ));
      }
    }

    // Apply Non-Maximum Suppression (NMS) if needed
    final filteredBoxes = _applyNMS(boxes);

    return DetectionResult(
      boxes: filteredBoxes,
      hasPothole: filteredBoxes.isNotEmpty,
      confidence: maxConfidence,
    );
  }

  /// Apply Non-Maximum Suppression
  List<BoundingBox> _applyNMS(List<BoundingBox> boxes, {double iouThreshold = 0.5}) {
    // Sort by confidence
    boxes.sort((a, b) => b.confidence.compareTo(a.confidence));

    final List<BoundingBox> selected = [];
    final List<bool> suppressed = List.filled(boxes.length, false);

    for (int i = 0; i < boxes.length; i++) {
      if (suppressed[i]) continue;

      selected.add(boxes[i]);

      for (int j = i + 1; j < boxes.length; j++) {
        if (suppressed[j]) continue;

        final iou = _calculateIoU(boxes[i], boxes[j]);
        if (iou > iouThreshold) {
          suppressed[j] = true;
        }
      }
    }

    return selected;
  }

  /// Calculate Intersection over Union (IoU)
  double _calculateIoU(BoundingBox a, BoundingBox b) {
    final x1 = (a.x - a.width / 2).clamp(0.0, 1.0);
    final y1 = (a.y - a.height / 2).clamp(0.0, 1.0);
    final x2 = (a.x + a.width / 2).clamp(0.0, 1.0);
    final y2 = (a.y + a.height / 2).clamp(0.0, 1.0);

    final x3 = (b.x - b.width / 2).clamp(0.0, 1.0);
    final y3 = (b.y - b.height / 2).clamp(0.0, 1.0);
    final x4 = (b.x + b.width / 2).clamp(0.0, 1.0);
    final y4 = (b.y + b.height / 2).clamp(0.0, 1.0);

    final intersectionX1 = x1 > x3 ? x1 : x3;
    final intersectionY1 = y1 > y3 ? y1 : y3;
    final intersectionX2 = x2 < x4 ? x2 : x4;
    final intersectionY2 = y2 < y4 ? y2 : y4;

    final intersectionArea = (intersectionX2 - intersectionX1).clamp(0.0, 1.0) *
        (intersectionY2 - intersectionY1).clamp(0.0, 1.0);

    final areaA = a.width * a.height;
    final areaB = b.width * b.height;
    final unionArea = areaA + areaB - intersectionArea;

    return unionArea > 0 ? intersectionArea / unionArea : 0.0;
  }

  /// Release resources
  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _isModelLoaded = false;
  }
}
