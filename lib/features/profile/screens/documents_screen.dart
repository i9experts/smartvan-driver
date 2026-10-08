import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../core/network/api_service.dart';

class DocumentsScreen extends ConsumerStatefulWidget {
  const DocumentsScreen({super.key});

  @override
  ConsumerState<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends ConsumerState<DocumentsScreen> {
  Map<String, dynamic>? _documents;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  Future<void> _loadDocuments() async {
    try {
      final response = await ApiService.get('/auth/getProfile');
      if (response.statusCode == 200) {
        final raw = response.data;
        setState(() => _documents = raw['data'] ?? raw);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load documents'),
            backgroundColor: Color(0xFFFF4B4B),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _uploadDocument(String type) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 80);
    if (picked == null) return;

    // Ambiguous generic button — no specific document field to target,
    // so rather than silently discarding the image (as before), tell the
    // driver to use one of the specific cards instead.
    if (type != 'vehicle_card' && type != 'driving_license') {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Please tap directly on "Vehicle Registration" or "Driving License" above to upload that specific document.'),
            backgroundColor: Color(0xFFFF4B4B),
          ),
        );
      }
      return;
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Uploading...'),
          duration: Duration(seconds: 30),
        ),
      );
    }

    try {
      final imageFile = File(picked.path);
      final imageUrl = await ApiService.uploadImage(imageFile);
      if (imageUrl == null) {
        throw Exception('Upload failed');
      }

      final fieldName = type == 'vehicle_card'
          ? 'vehicleCardImageFront'
          : 'licenceImageFront';

      await ApiService.post('/van/uploadDocuments', {
        'title': type,
        fieldName: imageUrl,
      });

      await _loadDocuments();

      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${type == 'vehicle_card' ? 'Vehicle Registration Certificate' : 'Driving License'} uploaded successfully!'),
            backgroundColor: const Color(0xFF27AE60),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload document: $e'),
            backgroundColor: const Color(0xFFFF4B4B),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String licenceFront =
        _documents?['licenceImageFront'] ?? '';
    final String licenceBack =
        _documents?['licenceImageBack'] ?? '';
    final String vehicleFront =
        _documents?['vehicleCardImageFront'] ?? '';
    final String vehicleBack =
        _documents?['vehicleCardImageBack'] ?? '';

    final bool hasLicence =
        licenceFront.isNotEmpty || licenceBack.isNotEmpty;
    final bool hasVehicleCard =
        vehicleFront.isNotEmpty || vehicleBack.isNotEmpty;

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
                      'Documents',
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
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!hasLicence && !hasVehicleCard)
                          _buildEmptyState(),

                        // Vehicle Registration
                        _buildDocumentCard(
                          'Vehicle Registration Certificate',
                          Icons.car_rental_outlined,
                          vehicleFront,
                          'vehicle_card',
                        ),
                        const SizedBox(height: 16),

                        // Driving License
                        _buildDocumentCard(
                          'Driving License',
                          Icons.badge_outlined,
                          licenceFront,
                          'driving_license',
                        ),
                        const SizedBox(height: 32),

                        // Upload Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                _uploadDocument('Document'),
                            icon: const Icon(Icons.upload_file, size: 20),
                            label: const Text(
                              'Upload New Document',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFB800),
                              foregroundColor: const Color(0xFF1B3B69),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(14)),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFF1B3B69).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.folder_outlined,
                size: 32, color: Color(0xFF1B3B69)),
          ),
          const SizedBox(height: 12),
          const Text(
            'No Documents',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'No documents to show',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF8A94A6),
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(
      String title, IconData icon, String imageUrl, String type) {
    final bool hasDoc = imageUrl.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B3B69).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      Icon(icon, color: const Color(0xFF1B3B69), size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                if (hasDoc)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF27AE60).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Uploaded',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF27AE60),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (hasDoc)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 160,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 160,
                  color: const Color(0xFFF0F3FF),
                  child: const Center(
                    child: Icon(Icons.broken_image_outlined,
                        color: Color(0xFF8A94A6), size: 40),
                  ),
                ),
              ),
            )
          else
            GestureDetector(
              onTap: () => _uploadDocument(type),
              child: Container(
                width: double.infinity,
                height: 100,
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F3FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF1B3B69).withOpacity(0.2),
                    style: BorderStyle.solid,
                  ),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.upload_outlined,
                        color: Color(0xFF1B3B69), size: 28),
                    SizedBox(height: 8),
                    Text(
                      'Upload',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF1B3B69),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}