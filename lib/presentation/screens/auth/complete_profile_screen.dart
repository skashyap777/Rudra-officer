import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/common/loading_indicator.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/services/storage_service.dart';

class CompleteProfileScreen extends ConsumerStatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  ConsumerState<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends ConsumerState<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _storage = StorageService();
  final _imagePicker = ImagePicker();
  
  bool _isLoading = false;
  File? _selectedImage;
  String? _existingProfilePic;

  final _kGreen = const Color(0xFF3D9A7E);
  final _kBg = const Color(0xFFF5F7FA);

  @override
  void initState() {
    super.initState();
    _loadExistingUserData();
  }

  void _loadExistingUserData() {
    _nameController.text = _storage.name ?? '';
    final storedAddress = _storage.address;
    _addressController.text = (storedAddress == 'null' || storedAddress == null) ? '' : storedAddress;
    setState(() {
      final pic = _storage.profilePic;
      _existingProfilePic = (pic == 'null' || pic == null) ? '' : pic;
    });
  }

  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _completeProfile() async {
    if (!_formKey.currentState!.validate()) return;
    
    // SnackBar if no image
    if (_selectedImage == null && (_existingProfilePic == null || _existingProfilePic!.isEmpty)) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add a profile picture')));
       return;
    }

    setState(() => _isLoading = true);

    try {
      final authRepo = await ref.read(authRepositoryProvider.future);
      await authRepo.updateProfile(
        name: _nameController.text.trim(),
        address: _addressController.text.trim(),
        imagePath: _selectedImage?.path ?? _existingProfilePic,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Color(0xFF3D9A7E), content: Text('Profile updated successfully')));
      ref.invalidate(currentUserProvider);
      context.pop();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit Profile', style: TextStyle(fontFamily: 'inter_medium', fontSize: 16, color: Colors.white)),
        backgroundColor: const Color(0xFF3D9A7E),
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(child: LoadingOverlay(
        isLoading: _isLoading,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                
                // Photo Picker
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        Container(
                          width: 120, height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[200],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: _selectedImage != null
                              ? Image.file(_selectedImage!, fit: BoxFit.cover)
                              : (_existingProfilePic != null && _existingProfilePic!.isNotEmpty)
                                  ? Image.network(_existingProfilePic!, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.person, size: 60, color: Colors.grey))
                                  : const Icon(Icons.person, size: 60, color: Colors.grey),
                        ),
                        
                        Positioned(
                          bottom: 0, right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt_outlined, size: 18, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Inputs
                _buildLabel('Enter Name', true),
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                  decoration: _inputDeco(),
                  validator: (v) => v == null || v.isEmpty ? 'Name is required' : null,
                ),
                const SizedBox(height: 20),
                
                _buildLabel('Enter Address for Communication', true),
                TextFormField(
                  controller: _addressController,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                  decoration: _inputDeco(),
                  validator: (v) => v == null || v.isEmpty ? 'Address is required' : null,
                ),
                const SizedBox(height: 20),

                _buildLabel('Division', false),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _storage.division ?? '',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
                
                const SizedBox(height: 40),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _completeProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3D9A7E),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: const Text('Save', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      )),
    );
  }

  Widget _buildLabel(String text, bool isRequired) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          text: text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
          children: isRequired ? [
            const TextSpan(text: ' *', style: TextStyle(color: Colors.red, fontSize: 14))
          ] : [],
        ),
      ),
    );
  }

  InputDecoration _inputDeco() => InputDecoration(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF3D9A7E), width: 1.5)),
  );

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
