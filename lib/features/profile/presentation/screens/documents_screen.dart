import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/providers/image_picker_provider.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_snack.dart';
import '../../../../core/widgets/app_states.dart';
import '../../../../core/widgets/screen_header.dart';
import '../../../../l10n/error_text.dart';
import '../../../../l10n/l10n.dart';
import '../../application/documents_controller.dart';
import '../../application/driver_profile_provider.dart';
import '../../data/models/driver_document_type.dart';
import '../widgets/document_widgets.dart';

class DocumentsScreen extends ConsumerWidget {
  const DocumentsScreen({super.key});

  Future<void> _upload(
    BuildContext context,
    WidgetRef ref,
    DriverDocumentType? requested,
  ) async {
    // The generic "Upload New Document" button doesn't know which document it
    // is for, so ask first.
    final type = requested ?? await showDocumentTypeSheet(context);
    if (type == null || !context.mounted) return;

    final picked = await ref
        .read(imagePickerProvider)
        .pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked == null || !context.mounted) return;

    final l10n = context.l10n;
    AppSnack.info(context, l10n.documentsUploading);
    final ok = await ref
        .read(documentsControllerProvider.notifier)
        .upload(type, File(picked.path));
    if (!context.mounted) return;
    if (ok) {
      AppSnack.success(context, l10n.documentsUploadedOk(type.label(l10n)));
    } else {
      final error = ref.read(documentsControllerProvider).error!;
      AppSnack.error(
        context,
        errorText(l10n, error, fallback: l10n.documentsUploadFailed),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final profileAsync = ref.watch(driverProfileProvider);

    ref.listen(driverProfileProvider, (_, next) {
      if (next.hasError) AppSnack.error(context, l10n.documentsLoadFailed);
    });

    final profile = profileAsync.valueOrNull;
    final licenceFront = profile?.licenceImageFront ?? '';
    final vehicleFront = profile?.vehicleCardImageFront ?? '';
    final hasLicence =
        licenceFront.isNotEmpty || (profile?.licenceImageBack ?? '').isNotEmpty;
    final hasVehicleCard = vehicleFront.isNotEmpty ||
        (profile?.vehicleCardImageBack ?? '').isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F3FF),
      body: Column(
        children: [
          ScreenHeader(
            title: l10n.documentsTitle,
            onBack: () => context.go(AppRoutes.profile),
          ),
          Expanded(
            child: profileAsync.isLoading && !profileAsync.hasValue
                ? const AppLoading()
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!hasLicence && !hasVehicleCard)
                          const DocumentsEmptyState(),
                        DocumentCard(
                          title: l10n.documentsVehicleRegistration,
                          icon: Icons.car_rental_outlined,
                          imageUrl: vehicleFront,
                          onUpload: () => _upload(
                              context, ref, DriverDocumentType.vehicleCard),
                        ),
                        const SizedBox(height: 16),
                        DocumentCard(
                          title: l10n.documentsDrivingLicense,
                          icon: Icons.badge_outlined,
                          imageUrl: licenceFront,
                          onUpload: () => _upload(
                              context, ref, DriverDocumentType.drivingLicense),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: () => _upload(context, ref, null),
                            icon: const Icon(Icons.upload_file, size: 20),
                            label: Text(
                              l10n.documentsUploadNew,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFB800),
                              foregroundColor: const Color(0xFF1B2B6B),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
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
}
