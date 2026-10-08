import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/providers/image_picker_provider.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/router/navigation.dart';
import '../../../../core/widgets/app_snack.dart';
import '../../../../core/widgets/app_states.dart';
import '../../../../core/widgets/screen_header.dart';
import '../../../../l10n/error_text.dart';
import '../../../../l10n/l10n.dart';
import '../../application/documents_controller.dart';
import '../../application/driver_profile_provider.dart';
import '../../data/models/driver_document_type.dart';
import '../widgets/document_sheets.dart';
import '../widgets/document_widgets.dart';
import 'document_viewer_screen.dart';

class DocumentsScreen extends ConsumerWidget {
  const DocumentsScreen({super.key});

  Future<void> _onTap(BuildContext context, WidgetRef ref,
      DriverDocumentType type, String? imageUrl, DateTime? oldExpiry) async {
    final l10n = context.l10n;
    final name = type.label(l10n);
    if (imageUrl != null && imageUrl.isNotEmpty) {
      final action = await showDocumentActionsSheet(context, name);
      if (!context.mounted) return;
      switch (action) {
        case DocumentAction.view:
          await Navigator.of(context).push(MaterialPageRoute<void>(
            fullscreenDialog: true,
            builder: (_) =>
                DocumentViewerScreen(title: name, imageUrl: imageUrl),
          ));
        case DocumentAction.change:
          await _change(context, ref, type, oldExpiry);
        case DocumentAction.remove:
          await _remove(context, ref, type);
        case null:
          break;
      }
    } else {
      await _change(context, ref, type, oldExpiry);
    }
  }

  /// Picks a picture, asks for the expiry date (optional, the old one is
  /// filled in), then uploads. Backing out at any step changes nothing.
  Future<void> _change(BuildContext context, WidgetRef ref,
      DriverDocumentType type, DateTime? oldExpiry) async {
    final l10n = context.l10n;
    final name = type.label(l10n);
    final source = await showImageSourceSheet(context, name);
    if (source == null || !context.mounted) return;

    final picked = await ref
        .read(imagePickerProvider)
        .pickImage(source: source, imageQuality: 80);
    if (picked == null || !context.mounted) return;

    final now = ref.read(clockProvider)();
    final expiry = await showDatePicker(
      context: context,
      helpText: l10n.documentsExpiryHelp,
      initialDate: oldExpiry ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 30),
    );
    if (!context.mounted) return;

    final error = await ref
        .read(documentsControllerProvider.notifier)
        .upload(type, File(picked.path), expiry: expiry);
    if (!context.mounted) return;
    if (error == null) {
      AppSnack.success(context, l10n.documentsUploadedOk(name));
    } else {
      AppSnack.error(context,
          errorText(l10n, error, fallback: l10n.documentsUploadFailed));
    }
  }

  Future<void> _remove(
      BuildContext context, WidgetRef ref, DriverDocumentType type) async {
    final l10n = context.l10n;
    final name = type.label(l10n);
    if (!await confirmRemoveDocument(context, name) || !context.mounted) {
      return;
    }
    final error =
        await ref.read(documentsControllerProvider.notifier).remove(type);
    if (!context.mounted) return;
    if (error == null) {
      AppSnack.success(context, l10n.documentsRemovedOk(name));
    } else {
      AppSnack.error(context,
          errorText(l10n, error, fallback: l10n.documentsRemoveFailed));
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
    final busy = ref.watch(documentsControllerProvider);
    final now = ref.watch(clockProvider)();
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
            onBack: () => context.popOrGo(AppRoutes.profile),
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
                          expiry: profile?.expiryDateVehicleCard,
                          now: now,
                          busy: busy == DriverDocumentType.vehicleCard,
                          onTap: () => _onTap(
                              context,
                              ref,
                              DriverDocumentType.vehicleCard,
                              vehicleFront,
                              profile?.expiryDateVehicleCard),
                        ),
                        const SizedBox(height: 16),
                        DocumentCard(
                          title: l10n.documentsDrivingLicense,
                          icon: Icons.badge_outlined,
                          imageUrl: licenceFront,
                          expiry: profile?.expiryDateLicense,
                          now: now,
                          busy: busy == DriverDocumentType.drivingLicense,
                          onTap: () => _onTap(
                              context,
                              ref,
                              DriverDocumentType.drivingLicense,
                              licenceFront,
                              profile?.expiryDateLicense),
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
