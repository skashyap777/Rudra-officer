import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:dio/dio.dart';
import '../../../../data/providers/providers.dart';

class ReportCapturedPotholeScreen extends ConsumerStatefulWidget {
  final List<File> images;
  final double latitude;
  final double longitude;
  final double accuracy;
  final List<Map<String, double>> coordinates;

  const ReportCapturedPotholeScreen({
    super.key,
    required this.images,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.coordinates,
  });

  @override
  ConsumerState<ReportCapturedPotholeScreen> createState() => _ReportCapturedPotholeScreenState();
}

class _ReportCapturedPotholeScreenState extends ConsumerState<ReportCapturedPotholeScreen> {
  final _landmarkController = TextEditingController();
  final _remarksController = TextEditingController();
  
  bool _isLoading = false;
  bool _isSuccess = false;
  String _currentAddress = "Fetching address...";
  late File _mainImage;

  @override
  void initState() {
    super.initState();
    _mainImage = widget.images.first;
    _fetchAddress();
  }

  Future<void> _fetchAddress() async {
    try {
      final dio = Dio();
      final String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${widget.latitude},${widget.longitude}&key=AIzaSyBU8zniWDcPMAUWkqIJ0iTmGbkF7jtRwzA";
      final response = await dio.get(url);
      
      if (response.statusCode == 200 && response.data != null) {
        final results = response.data['results'] as List?;
        if (results != null && results.isNotEmpty) {
          String fullAddress = results[0]['formatted_address'] as String;
          // Matches Android's logic: Remove Plus Code if it exists (before the first comma)
          if (RegExp(r'^[A-Z0-9\+]{6,},\s.*').hasMatch(fullAddress)) {
            fullAddress = fullAddress.substring(fullAddress.indexOf(",") + 1).trim();
          }
          if (mounted) setState(() => _currentAddress = fullAddress);
          return;
        }
      }
      
      if (mounted) setState(() => _currentAddress = "Unknown Location");
    } catch (_) {
      if (mounted) setState(() => _currentAddress = "Coordinate: ${widget.latitude}, ${widget.longitude}");
    }
  }

  Future<void> _submitRecord() async {
    if (_landmarkController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a landmark')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final reportRepo = await ref.read(reportRepositoryProvider.future);
      
      await reportRepo.captureNearbyPothole(
        areaDetails: _currentAddress,
        landmark: _landmarkController.text,
        remarks: _remarksController.text,
        accuracy: widget.accuracy,
        images: widget.images,
        coordinates: widget.coordinates,
      );

      if (mounted) setState(() => _isSuccess = true);
    } catch (e) {
      if (mounted) {
        String serverMessage = e.toString();
        if (e is DioException) {
          final resData = e.response?.data;
          if (resData is Map && resData.containsKey('message')) {
            serverMessage = resData['message'].toString();
          } else if (resData is Map && resData.containsKey('errors')) {
            serverMessage = resData['errors'].toString();
          } else if (e.response?.statusMessage != null) {
            serverMessage = '${e.response!.statusCode}: ${e.response!.statusMessage}';
          }
        }
        
        _showErrorDialog(serverMessage);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                const Icon(Icons.error, color: Color(0xFFD32F2F), size: 90), // Red error icon
                const SizedBox(height: 20),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          context.go('/main');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFF3D9A7E), width: 1),
                          ),
                          alignment: Alignment.center,
                          child: const Text('Go Home', style: TextStyle(color: Color(0xFF3D9A7E), fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3D9A7E),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          alignment: Alignment.center,
                          child: const Text('OK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isSuccess) return _buildSuccessView(theme);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Report Pothole', style: TextStyle(fontFamily: 'inter_medium', fontSize: 16, color: Colors.white)),
        backgroundColor: const Color(0xFF3D9A7E),
        elevation: 0,
        titleSpacing: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(child: _isLoading 
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(strokeWidth: 3),
                const SizedBox(height: 20),
                Text('Uploading Report...', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600)),
              ],
            ),
          )
        : SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main Image
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10)),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.file(_mainImage, width: double.infinity, height: 320, fit: BoxFit.cover),
                ),

                const SizedBox(height: 16),
                
                // Thumbnails
                SizedBox(
                  height: 70,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.images.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final isSelected = _mainImage == widget.images[index];
                      return GestureDetector(
                        onTap: () => setState(() => _mainImage = widget.images[index]),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 70,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected ? theme.primaryColor : Colors.white,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              if (isSelected) BoxShadow(color: theme.primaryColor.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.file(widget.images[index], fit: BoxFit.cover),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 32),
                
                // Information Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoSection('Current Location', '${widget.latitude.toStringAsFixed(6)}, ${widget.longitude.toStringAsFixed(6)}', Icons.location_on_rounded),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(height: 1, color: Color(0xFFF5F5F5)),
                      ),
                      _buildInfoSection('Detected Address', _currentAddress, Icons.map_rounded),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
                
                // Form Fields
                _buildFieldLabel('Landmark Name', isRequired: true),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: TextField(
                    controller: _landmarkController,
                    textCapitalization: TextCapitalization.sentences,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      hintText: 'e.g. Near ABC School',
                      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                
                _buildFieldLabel('Additional Remarks', isRequired: false),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: TextField(
                    controller: _remarksController,
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      hintText: 'Describe the pothole context...',
                      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),

                const SizedBox(height: 48),
                
                ElevatedButton(
                  onPressed: _submitRecord,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(60),
                    backgroundColor: theme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 0,
                    textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                  child: const Text('SUBMIT REPORT'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          )),
    );
  }

  Widget _buildInfoSection(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: Colors.blue[700], size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey[400], letterSpacing: 0.5)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label, {required bool isRequired}) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Colors.black87)),
          if (isRequired) const Text(' *', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSuccessView(ThemeData theme) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120, height: 120,
                decoration: BoxDecoration(color: theme.primaryColor.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(Icons.check_circle_rounded, color: theme.primaryColor, size: 80),
              ),
              const SizedBox(height: 40),
              const Text('Report Submitted', 
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 28, letterSpacing: -0.5)),
              const SizedBox(height: 16),
              const Text(
                'Thank you for your report. It has been successfully recorded and will be reviewed shortly.', 
                textAlign: TextAlign.center, 
                style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.5, fontWeight: FontWeight.w500)
              ),
              const SizedBox(height: 60),
              ElevatedButton(
                onPressed: () => context.goNamed('main'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(60),
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                  textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
                ),
                child: const Text('BACK TO HOME'),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
