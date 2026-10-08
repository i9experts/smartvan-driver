import 'package:flutter/material.dart';
import '../../../../core/formatting/date_formats.dart';
import '../../../../l10n/l10n.dart';
import '../../application/document_expiry.dart';
import '../../data/models/driver_document_type.dart';

extension DriverDocumentTypeLabel on DriverDocumentType {
  String label(AppLocalizations l10n) => switch (this) {
        DriverDocumentType.vehicleCard => l10n.documentsVehicleRegistration,
        DriverDocumentType.drivingLicense => l10n.documentsDrivingLicense,
      };
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

/// A document: title, "Uploaded" badge, expiry and the image, or an upload
/// box. The whole card is one tap target ([onTap]); while [busy] it shows a
/// spinner instead.
class DocumentCard extends StatelessWidget {
  const DocumentCard({
    super.key,
    required this.title,
    required this.icon,
    required this.imageUrl,
    required this.onTap,
    this.expiry,
    this.now,
    this.busy = false,
  });

  final String title;
  final IconData icon;
  final String? imageUrl;
  final VoidCallback onTap;
  final DateTime? expiry;

  /// Today, for colouring [expiry].
  final DateTime? now;
  final bool busy;

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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: busy ? null : onTap,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Header(
                    title: title,
                    icon: icon,
                    hasDoc: hasDoc,
                    expiry: expiry,
                    now: now,
                  ),
                  if (hasDoc)
                    Image.network(
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
                    )
                  else
                    Container(
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
                ],
              ),
              if (busy)
                Positioned.fill(
                  child: ColoredBox(
                    color: Colors.white.withValues(alpha: 0.75),
                    child: const Center(
                      child: CircularProgressIndicator(
                          color: Color(0xFF1B2B6B), strokeWidth: 3),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.icon,
    required this.hasDoc,
    required this.expiry,
    required this.now,
  });

  final String title;
  final IconData icon;
  final bool hasDoc;
  final DateTime? expiry;
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final date = expiry;
    final status =
        date == null ? null : expiryStatus(date, now ?? DateTime.now());
    final dateText = date == null ? null : formatDayMonthYear(date);
    final (expiryColor, expiryText) = switch (status) {
      ExpiryStatus.expired => (
          const Color(0xFFE53935),
          l10n.documentsExpired(dateText!)
        ),
      ExpiryStatus.soon => (
          const Color(0xFFF57C00),
          l10n.documentsExpires(dateText!)
        ),
      ExpiryStatus.ok => (
          const Color(0xFF8A94A6),
          l10n.documentsExpires(dateText!)
        ),
      null => (const Color(0xFF8A94A6), ''),
    };
    return Padding(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                    fontFamily: 'Poppins',
                  ),
                ),
                if (status != null)
                  Text(
                    expiryText,
                    style: TextStyle(
                      fontSize: 12,
                      color: expiryColor,
                      fontWeight: status == ExpiryStatus.ok
                          ? FontWeight.w400
                          : FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                if (hasDoc)
                  Text(
                    l10n.documentsTapToChange,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF8A94A6),
                      fontFamily: 'Poppins',
                    ),
                  ),
              ],
            ),
          ),
          if (hasDoc)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
    );
  }
}
