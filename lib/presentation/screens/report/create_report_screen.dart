import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

import '../../../data/services/location_service.dart';
import '../../../data/providers/providers.dart';
import '../../../core/widgets/widgets.dart';

// Provider for LocationService
final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

class CreateReportScreen extends ConsumerStatefulWidget {
  final List<File>? initialImages;
  final double? initialLat;
  final double? initialLng;
  final double? initialAccuracy;

  const CreateReportScreen({
    super.key,
    this.initialImages,
    this.initialLat,
    this.initialLng,
    this.initialAccuracy,
  });

  @override
  ConsumerState<CreateReportScreen> createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends ConsumerState<CreateReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _districtController = TextEditingController();
  final _pincodeController = TextEditingController();
  
  final List<File> _selectedImages = [];
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _initializePreCapturedData();
  }

  void _initializePreCapturedData() {
    if (widget.initialImages != null) {
      _selectedImages.addAll(widget.initialImages!);
    }
    if (widget.initialLat != null && widget.initialLng != null) {
      _currentPosition = Position(
        latitude: widget.initialLat!,
        longitude: widget.initialLng!,
        timestamp: DateTime.now(),
        accuracy: widget.initialAccuracy ?? 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      );
      // Auto-fetch reverse geocode address for the pre-captured location
      _getCurrentAddress(_currentPosition!);
    }
  }

  Future<void> _getCurrentAddress(Position pos) async {
    try {
      final address = await ref.read(locationServiceProvider).getAddressFromCoordinates(pos.latitude, pos.longitude);
      if (mounted) {
        setState(() {
          _addressController.text = address ?? '';
        });
      }
    } catch (_) {}
  }
  bool _isLoading = false;
  bool _isGettingLocation = false;
  String _selectedCategory = 'Pothole';
  String _selectedPriority = 'Medium';

  final List<String> _categories = [
    'Pothole',
    'Road Damage',
    'Drainage Issue',
    'Street Light',
    'Others',
  ];

  final List<String> _priorities = ['Low', 'Medium', 'High', 'Critical'];

  @override
  void dispose() {
    _addressController.dispose();
    _descriptionController.dispose();
    _districtController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isGettingLocation = true);
    
    try {
      final position = await ref.read(locationServiceProvider).getCurrentPosition();
      if (position == null) {
        throw Exception('Could not get current position');
      }
      final address = await ref.read(locationServiceProvider).getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );
      
      setState(() {
        _currentPosition = position;
        _addressController.text = address ?? '';
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to get location: $e')),
        );
      }
    } finally {
      setState(() => _isGettingLocation = false);
    }
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final images = await picker.pickMultiImage();
    
    if (images.isNotEmpty) {
      setState(() {
        for (var image in images) {
          if (_selectedImages.length < 5) {
            _selectedImages.add(File(image.path));
          }
        }
      });
    }
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    
    if (image != null) {
      setState(() {
        if (_selectedImages.length < 5) {
          _selectedImages.add(File(image.path));
        }
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one image')),
      );
      return;
    }
    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please get your location first')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final reportRepo = await ref.read(reportRepositoryProvider.future);
      
      await reportRepo.createReport(
        address: _addressController.text,
        description: _descriptionController.text,
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        category: _selectedCategory,
        priority: _selectedPriority,
        district: _districtController.text.isEmpty ? null : _districtController.text,
        pincode: _pincodeController.text.isEmpty ? null : _pincodeController.text,
        images: _selectedImages,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Report submitted successfully'),
            backgroundColor: const Color(0xFFF8C300),
          ),
        );
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit report: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Report'),
        centerTitle: true,
      ),
      body: SafeArea(child: _isLoading
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Submitting report...'),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Location Section
                    _buildLocationSection(),
                    const SizedBox(height: 20),
                    
                    // Images Section
                    _buildImagesSection(),
                    const SizedBox(height: 20),
                    
                    // Category & Priority
                    _buildCategoryPrioritySection(),
                    const SizedBox(height: 20),
                    
                    // Address Details
                    _buildAddressSection(),
                    const SizedBox(height: 20),
                    
                    // Description
                    _buildDescriptionSection(),
                    const SizedBox(height: 30),
                    
                    // Submit Button
                    CustomButton(
                      text: 'Submit Report',
                      icon: const Icon(Icons.send, size: 18),
                      backgroundColor: Colors.blue,
                      onPressed: _submitReport,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            )),
    );
  }

  Widget _buildLocationSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.blue[700]),
                const SizedBox(width: 8),
                const Text(
                  'Location',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _isGettingLocation ? null : _getCurrentLocation,
                  icon: _isGettingLocation
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.my_location, size: 18),
                  label: Text(_isGettingLocation ? 'Getting...' : 'Get Location'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            if (_currentPosition != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location captured successfully',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Lat: ${_currentPosition!.latitude.toStringAsFixed(6)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      'Lng: ${_currentPosition!.longitude.toStringAsFixed(6)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImagesSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.photo_camera, color: Colors.blue[700]),
                const SizedBox(width: 8),
                const Text(
                  'Photos',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_selectedImages.length}/5',
                  style: TextStyle(
                    color: _selectedImages.length >= 5 ? Colors.red : Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Add photos of the pothole/damage',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // Add Photo Buttons
                if (_selectedImages.length < 5) ...[
                  _buildAddPhotoButton(
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    onTap: _takePhoto,
                  ),
                  _buildAddPhotoButton(
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    onTap: _pickImages,
                  ),
                ],
                // Selected Images
                ..._selectedImages.asMap().entries.map((entry) {
                  return _buildImageThumbnail(entry.value, entry.key);
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddPhotoButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.blue[700], size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageThumbnail(File image, int index) {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: FileImage(image),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 2,
          right: 2,
          child: InkWell(
            onTap: () => _removeImage(index),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryPrioritySection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.category, color: Colors.blue[700]),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedCategory = value!);
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedPriority,
              decoration: const InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
              ),
              items: _priorities.map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Text(priority),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedPriority = value!);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.home, color: Colors.blue[700]),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _addressController,
              label: 'Address *',
              hint: 'Enter detailed address',
              prefixIcon: const Icon(Icons.location_on),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Address is required';
                }
                return null;
              },
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _districtController,
              label: 'District',
              hint: 'Enter district',
              prefixIcon: const Icon(Icons.map),
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _pincodeController,
              label: 'Pincode',
              hint: 'Enter pincode',
              prefixIcon: const Icon(Icons.pin_drop),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.description, color: Colors.blue[700]),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _descriptionController,
              label: 'Description',
              hint: 'Describe the issue in detail...',
              prefixIcon: const Icon(Icons.notes),
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }
}
