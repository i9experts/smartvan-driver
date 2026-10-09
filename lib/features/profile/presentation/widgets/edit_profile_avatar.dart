import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../l10n/l10n.dart';

/// Tappable avatar with a camera badge and a "Change Image" caption.
class EditProfileAvatar extends StatelessWidget {
  const EditProfileAvatar({
    super.key,
    required this.selectedImage,
    required this.currentImageUrl,
    required this.onTap,
  });

  final File? selectedImage;
  final String? currentImageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Stack(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF1B3B69), width: 2),
                ),
                child: ClipOval(
                  child: selectedImage != null
                      ? Image.file(selectedImage!, fit: BoxFit.cover)
                      : currentImageUrl != null
                          ? Image.network(currentImageUrl!, fit: BoxFit.cover)
                          : Container(
                              color: const Color(0xFF1B3B69)
                                  .withValues(alpha: 0.1),
                              child: const Icon(Icons.person,
                                  size: 40, color: Color(0xFF1B3B69)),
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
                    color: Color(0xFFFEC610),
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
        Text(
          context.l10n.editProfileChangeImage,
          style: const TextStyle(
            color: Color(0xFF1B3B69),
            fontSize: 13,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
