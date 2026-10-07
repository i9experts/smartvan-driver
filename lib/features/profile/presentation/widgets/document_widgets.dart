import 'package:flutter/material.dart';
import '../../../../l10n/l10n.dart';
import '../../data/models/driver_document_type.dart';

extension DriverDocumentTypeLabel on DriverDocumentType {
  String label(AppLocalizations l10n) => switch (this) {
        DriverDocumentType.vehicleCard => l10n.documentsVehicleRegistration,
        DriverDocumentType.drivingLicense => l10n.documentsDrivingLicense,
      };
}

/// Asks which document a generic "Upload New Document" is for.
Future<DriverDocumentType?> showDocumentTypeSheet(BuildContext context) {
  final l10n = context.l10n;
  return showModalBottomSheet<DriverDocumentType>(
    context: context,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.car_rental_outlined),
            title: Text(DriverDocumentType.vehicleCard.label(l10n)),
            onTap: () => Navigator.pop(ctx, DriverDocumentType.vehicleCard),
          ),
          ListTile(
            leading: const Icon(Icons.badge_outlined),
            title: Text(DriverDocumentType.drivingLicense.label(l10n)),
            onTap: () => Navigator.pop(ctx, DriverDocumentType.drivingLicense),
          ),
        ],
      ),
    ),
  );
}

class DocumentsEmptyState extends StatelessWidget {
  const DocumentsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
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
              color: const Color(0xFF1B2B6B).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.folder_outlined,
                size: 32, color: Color(0xFF1B2B6B)),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.documentsEmptyTitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.documentsEmptyBody,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF8A94A6),
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}

/// A document: title, "Uploaded" badge and the image, or an upload box.
class DocumentCard extends StatelessWidget {
  const DocumentCard({
    super.key,
    required this.title,
    required this.icon,
    required this.imageUrl,
    required this.onUpload,
  });

  final String title;
  final IconData icon;
  final String? imageUrl;
  final VoidCallback onUpload;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hasDoc = imageUrl != null && imageUrl!.isNotEmpty;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
                    color: const Color(0xFF1B2B6B).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: const Color(0xFF1B2B6B), size: 20),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF27AE60).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      l10n.documentsUploaded,
                      style: const TextStyle(
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
                imageUrl!,
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
              onTap: onUpload,
              child: Container(
                width: double.infinity,
                height: 100,
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F3FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF1B2B6B).withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.upload_outlined,
                        color: Color(0xFF1B2B6B), size: 28),
                    const SizedBox(height: 8),
                    Text(
                      l10n.documentsUpload,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF1B2B6B),
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
