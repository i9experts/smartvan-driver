import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../core/network/api_service.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _altPhoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _nicController = TextEditingController();
  bool _isLoading = true;
  bool _isSaving = false;
  bool _hasError = false;
  File? _selectedImage;
  Map<String, dynamic>? _profile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _altPhoneController.dispose();
    _addressController.dispose();
    _nicController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() => _hasError = false);
    try {
      final response = await ApiService.get('/auth/getProfile');
      if (response.statusCode == 200) {
        final raw = response.data;
        final data = raw['data'] ?? raw;
        setState(() {
          _profile = data;
          _nameController.text = data['fullname'] ?? data['name'] ?? '';
          _phoneController.text = data['phoneNo'] ?? '';
          _altPhoneController.text = data['alternatePhoneNo'] ?? '';
          _addressController.text = data['address'] ?? '';
          _nicController.text = data['NIC'] ?? '';
        });
      }
    } catch (e) {
      // Left the fields blank instead of surfacing this: saving from here
      // would silently overwrite the driver's real name/phone/address/NIC
      // with empty strings, so editing has to be blocked until this loads.
      if (mounted) setState(() => _hasError = true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 70);
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);
    try {
      // Was previously only a local preview via Image.file — never
      // actually uploaded or included in the update request at all.
      String? imageUrl;
      if (_selectedImage != null) {
        imageUrl = await ApiService.uploadImage(_selectedImage!);
      }

      await ApiService.post('/van/update-profile', {
        'fullname': _nameController.text.trim(),
        'phoneNo': _phoneController.text.trim(),
        'alternatePhoneNo': _altPhoneController.text.trim(),
        'address': _addressController.text.trim(),
        'NIC': _nicController.text.trim(),
        'userType': 'driver',
        if (imageUrl != null) 'image': imageUrl,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile updated successfully!'),
            backgroundColor: const Color(0xFF27AE60),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
        );
        context.go('/profile');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to update profile'),
            backgroundColor: const Color(0xFFFF4B4B),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F3FF),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1B3B69), Color(0xFF2D4099)],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 20, 20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          color: Colors.white),
                      onPressed: () => context.go('/profile'),
                    ),
                    const Text(
                      'Edit Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFF1B3B69)))
                : _hasError
                    ? _buildErrorState()
                    : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Avatar
                        GestureDetector(
                          onTap: _pickImage,
                          child: Stack(
                            children: [
                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: const Color(0xFF1B3B69),
                                      width: 2),
                                ),
                                child: ClipOval(
                                  child: _selectedImage != null
                                      ? Image.file(_selectedImage!,
                                          fit: BoxFit.cover)
                                      : _profile?['image'] != null
                                          ? Image.network(
                                              _profile!['image'],
                                              fit: BoxFit.cover)
                                          : Container(
                                              color: const Color(0xFF1B3B69)
                                                  .withOpacity(0.1),
                                              child: const Icon(
                                                  Icons.person,
                                                  size: 40,
                                                  color:
                                                      Color(0xFF1B3B69)),
                                            ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFFB800),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.camera_alt,
                                      size: 16, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Change Image',
                          style: TextStyle(
                            color: Color(0xFF1B3B69),
                            fontSize: 13,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 24),

                        _buildField('Full Name', _nameController,
                            Icons.person_outlined),
                        const SizedBox(height: 16),
                        _buildField('Phone Number', _phoneController,
                            Icons.phone_outlined,
                            keyboardType: TextInputType.phone),
                        const SizedBox(height: 16),
                        _buildField('Alternate Phone',
                            _altPhoneController,
                            Icons.phone_callback_outlined,
                            keyboardType: TextInputType.phone),
                        const SizedBox(height: 16),
                        _buildField('Address', _addressController,
                            Icons.home_outlined,
                            maxLines: 2),
                        const SizedBox(height: 16),
                        _buildField('CNIC Number', _nicController,
                            Icons.badge_outlined,
                            keyboardType: TextInputType.text),
                        const SizedBox(height: 32),

                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _isSaving ? null : _saveProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFB800),
                              foregroundColor: const Color(0xFF1B3B69),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(14)),
                              elevation: 0,
                            ),
                            child: _isSaving
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF1B3B69),
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Update Profile',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(Icons.arrow_forward, size: 18),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFFF4B4B).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.wifi_off_rounded,
                  size: 40, color: Color(0xFFFF4B4B)),
            ),
            const SizedBox(height: 16),
            const Text(
              'Couldn\'t Load Your Profile',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Editing is disabled until your current details load, so nothing gets overwritten with blank fields. Check your connection and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF8A94A6),
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() => _isLoading = true);
                _loadProfile();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B3B69),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Retry', style: TextStyle(fontFamily: 'Poppins')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A2E),
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF1B3B69)),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFEAECF0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFEAECF0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFF1B3B69), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}