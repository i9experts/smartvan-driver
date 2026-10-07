import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../l10n/l10n.dart';

/// "Add a photo" row: thumbnail (or camera icon), caption and Take/Retake.
class ChecklistPhotoCard extends StatelessWidget {
  const ChecklistPhotoCard({
    super.key,
    required this.photo,
    required this.hasExistingPhoto,
    required this.onTake,
  });

  final File? photo;
  final bool hasExistingPhoto;
  final VoidCallback onTake;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hasPhoto = photo != null || hasExistingPhoto;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: photo != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(photo!,
                    width: 48, height: 48, fit: BoxFit.cover))
            : const Icon(Icons.photo_camera_outlined, color: Color(0xFF1B2B6B)),
        title: Text(
            hasPhoto ? l10n.checklistPhotoAdded : l10n.checklistAddPhoto,
            style: const TextStyle(fontFamily: 'Poppins')),
        subtitle: Text(l10n.checklistPhotoHelp,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 12)),
        trailing: TextButton(
          onPressed: onTake,
          child: Text(hasPhoto ? l10n.checklistRetake : l10n.checklistTake),
        ),
      ),
    );
  }
}
