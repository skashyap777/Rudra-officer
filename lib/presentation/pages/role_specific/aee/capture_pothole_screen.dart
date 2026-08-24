import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/services/pothole_detection_service.dart';

class CapturedImage {
  final File file;
  final double latitude;
  final double longitude;
  final double accuracy;

  CapturedImage({
    required this.file,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
  });
}

class CapturePotholeScreen extends ConsumerStatefulWidget {
  const CapturePotholeScreen({super.key});

  @override
  ConsumerState<CapturePotholeScreen> createState() => _CapturePotholeScreenState();
}

class _CapturePotholeScreenState extends ConsumerState<CapturePotholeScreen> with TickerProviderStateMixin {
  final _detectionService = PotholeDetectionService();
  final List<CapturedImage> _capturedImages = [];
  
  File? _lastCapturedFile;
  bool _isAnalyzing = false;
  bool _detectionSuccess = false;
  bool _noPotholeDetected = false;
  
  late AnimationController _scanController;

  @override
  void initState() {
    super.initState();
    _detectionService.loadModel();
    _scanController = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
    
    // Automatically open camera after initial build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialSetup();
    });
  }

  Future<void> _initialSetup() async {
    if (mounted && _capturedImages.isEmpty) {
      // Very small delay to ensure transition doesn't glitch
      await Future.delayed(const Duration(milliseconds: 100));
      if (mounted) {
        _captureAndAnalyze(isInitial: true);
      }
    }
  }

  @override
  void dispose() {
    _detectionService.dispose();
    _scanController.dispose();
    super.dispose();
  }

  Future<void> _captureAndAnalyze({bool isInitial = false}) async {
    // Check permissions first before launching camera
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permission required.')));
          if (isInitial) context.pop();
        }
        return;
      }
    }

    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.camera, 
      imageQuality: 70,
      maxWidth: 1920,
      maxHeight: 1920,
    );
    
    if (image == null) {
      if (isInitial && mounted && _capturedImages.isEmpty) {
        context.pop();
      }
      return;
    }

    setState(() {
      _lastCapturedFile = File(image.path);
      _isAnalyzing = true;
      _detectionSuccess = false;
      _noPotholeDetected = false;
    });

    Position? position;
    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 5),
      );
    } catch (e) {
      print('Location Error: $e');
    }

    final isPothole = await _detectionService.detectPothole(_lastCapturedFile!);

    bool isWithinRange = true;
    if (_capturedImages.isNotEmpty && position != null) {
      double distance = Geolocator.distanceBetween(
        _capturedImages.first.latitude,
        _capturedImages.first.longitude,
        position.latitude,
        position.longitude,
      );
      if (distance > 30.0) isWithinRange = false;
    }

    if (mounted) {
      setState(() {
        _isAnalyzing = false;
        if (isPothole && position != null && isWithinRange) {
          _detectionSuccess = true;
          _capturedImages.add(CapturedImage(
            file: _lastCapturedFile!,
            latitude: position.latitude,
            longitude: position.longitude,
            accuracy: position.accuracy,
          ));
          HapticFeedback.vibrate();
        } else if (!isWithinRange && isPothole) {
           _noPotholeDetected = true;
           _detectionSuccess = false;
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Too far from original location.')));
        } else {
          _noPotholeDetected = true;
          _detectionSuccess = false;
          HapticFeedback.heavyImpact();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Road Inspection', style: TextStyle(fontFamily: 'inter_medium', fontSize: 16, color: Colors.white)),
        backgroundColor: const Color(0xFF3D9A7E),
        elevation: 0,
        titleSpacing: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (_capturedImages.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Badge(
                  label: Text('${_capturedImages.length}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  backgroundColor: const Color(0xFFF8C300),
                  child: Icon(Icons.photo_library_outlined, color: Colors.grey[800]),
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(child: _lastCapturedFile == null 
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
                    child: Icon(Icons.camera_alt_outlined, size: 48, color: Colors.grey[300]),
                  ),
                  const SizedBox(height: 16),
                  Text('Starting Camera...', style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600)),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Image Frame
                  Container(
                    height: 440,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.file(_lastCapturedFile!, fit: BoxFit.cover),
                        ),
                        
                        if (_isAnalyzing)
                          AnimatedBuilder(
                            animation: _scanController,
                            builder: (context, child) {
                              return Positioned(
                                top: _scanController.value * 420,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 3,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.yellow.withOpacity(0.0),
                                        Colors.yellow,
                                        Colors.yellow.withOpacity(0.0),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(color: Colors.yellow.withOpacity(0.5), blurRadius: 10, spreadRadius: 1),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          
                        // HUD overlay
                        Positioned(
                          top: 20,
                          right: 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.gps_fixed_rounded, color: Colors.white, size: 14),
                                const SizedBox(width: 6),
                                Text(
                                  'GPS ACTIVE',
                                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Status Indicator
                  if (_isAnalyzing) ...[
                    const CircularProgressIndicator(strokeWidth: 3),
                    const SizedBox(height: 16),
                    const Text('ANALYZING ROAD SURFACE...', 
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 1, color: Colors.grey)),
                  ] else if (_detectionSuccess) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_rounded, color: Colors.green[600]),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Pothole Detected Successfully',
                              style: TextStyle(fontWeight: FontWeight.w800, color: Colors.green, fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else if (_noPotholeDetected) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline_rounded, color: Colors.red[600]),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Not a Clear Pothole',
                              style: TextStyle(fontWeight: FontWeight.w800, color: Colors.red, fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Thumbnails
                  if (_capturedImages.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('CAPTURED EVIDENCE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.grey, letterSpacing: 1)),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 80,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _capturedImages.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.file(_capturedImages[index].file, width: 80, height: 80, fit: BoxFit.cover),
                              ),
                              Positioned(
                                right: 4, top: 4,
                                child: GestureDetector(
                                  onTap: () => setState(() => _capturedImages.removeAt(index)),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                                    child: const Icon(Icons.close_rounded, color: Colors.white, size: 12),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],

                  // Action Buttons
                  const SizedBox(height: 48),
                  if (!_isAnalyzing) ...[
                    if (!_detectionSuccess || _capturedImages.length < 5)
                      OutlinedButton.icon(
                        onPressed: _captureAndAnalyze,
                        icon: const Icon(Icons.add_a_photo_rounded),
                        label: Text(_noPotholeDetected ? 'RETAKE IMAGE' : 'ADD ANOTHER IMAGE'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(60),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          side: BorderSide(color: theme.primaryColor, width: 2),
                          foregroundColor: theme.primaryColor,
                          textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, letterSpacing: 0.5),
                        ),
                      ),

                    if (_capturedImages.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.pushNamed('reportCapturedPothole', extra: {
                          'preCapturedImages': _capturedImages.map((e) => e.file).toList(),
                          'preLatitude': _capturedImages.first.latitude,
                          'preLongitude': _capturedImages.first.longitude,
                          'preAccuracy': _capturedImages.first.accuracy,
                          'preCoordinates': _capturedImages.map((e) => {
                            'latitude': e.latitude,
                            'longitude': e.longitude,
                          }).toList(),
                        }),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(60),
                          backgroundColor: const Color(0xFFF8C300),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          elevation: 0,
                          textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                        ),
                        child: Text('CONTINUE (${_capturedImages.length})'),
                      ),
                    ],
                  ],
                ],
              ),
            )),
    );
  }
}
