import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/network/app_exception.dart';
import '../../../../core/providers/image_picker_provider.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/router/navigation.dart';
import '../../../../core/widgets/app_snack.dart';
import '../../../../core/widgets/app_states.dart';
import '../../../../core/widgets/form_widgets.dart';
import '../../../../core/widgets/screen_header.dart';
import '../../../../l10n/error_text.dart';
import '../../../../l10n/l10n.dart';
import '../../application/driver_profile_provider.dart';
import '../../application/edit_profile_controller.dart';
import '../../data/models/driver_profile.dart';
import '../widgets/edit_profile_avatar.dart';
import '../widgets/edit_profile_load_error.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _altPhoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _nicController = TextEditingController();
  File? _selectedImage;
  bool _filled = false;

  @override
  void initState() {
    super.initState();
    // Fill the fields once, from the first profile that is available.
    ref.listenManual<AsyncValue<DriverProfile>>(
      driverProfileProvider,
      (_, next) => _fillFrom(next.valueOrNull),
      fireImmediately: true,
    );
  }

  void _fillFrom(DriverProfile? profile) {
    if (_filled || profile == null) return;
    _filled = true;
    _nameController.text = profile.fullname;
    _phoneController.text = profile.phoneNo ?? '';
    _altPhoneController.text = profile.alternatePhoneNo ?? '';
    _addressController.text = profile.address ?? '';
    _nicController.text = profile.nic ?? '';
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

  Future<void> _pickImage() async {
    final picked = await ref
        .read(imagePickerProvider)
        .pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (picked != null && mounted) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  Future<void> _save() async {
    final ok = await ref.read(editProfileControllerProvider.notifier).save(
          fullname: _nameController.text.trim(),
          phoneNo: _phoneController.text.trim(),
          alternatePhoneNo: _altPhoneController.text.trim(),
          address: _addressController.text.trim(),
          nic: _nicController.text.trim(),
          newImage: _selectedImage,
        );
    if (ok && mounted) {
      AppSnack.success(context, context.l10n.editProfileUpdated);
      context.popOrGo(AppRoutes.profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final profileAsync = ref.watch(driverProfileProvider);
    final saving = ref.watch(editProfileControllerProvider).isLoading;

    ref.listen(editProfileControllerProvider, (_, next) {
      final error = next.error;
      if (error == null) return;
      final uploadFailed = error is ApiError && error.code == 'UPLOAD_FAILED';
      AppSnack.error(
        context,
        uploadFailed ? errorText(l10n, error) : l10n.editProfileUpdateFailed,
      );
    });

    final Widget body;
    if (profileAsync.hasError) {
      body = EditProfileLoadError(
          onRetry: () => ref.invalidate(driverProfileProvider));
    } else if (!profileAsync.hasValue) {
      body = const AppLoading();
    } else {
      body = SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            EditProfileAvatar(
              selectedImage: _selectedImage,
              currentImageUrl: profileAsync.value!.image,
              onTap: _pickImage,
            ),
            const SizedBox(height: 24),
            LabeledField(
                label: l10n.profileFullName,
                controller: _nameController,
                icon: Icons.person_outlined),
            const SizedBox(height: 16),
            LabeledField(
                label: l10n.editProfilePhoneNumber,
                controller: _phoneController,
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            LabeledField(
                label: l10n.profileAlternatePhone,
                controller: _altPhoneController,
                icon: Icons.phone_callback_outlined,
                keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            LabeledField(
                label: l10n.profileAddress,
                controller: _addressController,
                icon: Icons.home_outlined,
                maxLines: 2),
            const SizedBox(height: 16),
            LabeledField(
                label: l10n.editProfileCnicNumber,
                controller: _nicController,
                icon: Icons.badge_outlined),
            const SizedBox(height: 32),
            PrimaryActionButton(
              label: l10n.editProfileUpdate,
              trailingIcon: Icons.arrow_forward,
              loading: saving,
              onPressed: _save,
            ),
            const SizedBox(height: 32),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF0F3FF),
      body: Column(
        children: [
          ScreenHeader(
            title: l10n.editProfileTitle,
            onBack: () => context.popOrGo(AppRoutes.profile),
          ),
          Expanded(child: body),
        ],
      ),
    );
  }
}
