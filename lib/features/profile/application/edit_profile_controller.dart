import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/profile_repository.dart';
import 'driver_profile_provider.dart';

part 'edit_profile_controller.g.dart';

/// Saves edits to the driver's profile. State is the status of the last save.
@riverpod
class EditProfileController extends _$EditProfileController {
  @override
  FutureOr<void> build() {}

  /// Uploads [newImage] first (if any) so the profile is never saved without
  /// it, then updates the profile and refreshes the shared copy.
  /// Returns true on success.
  Future<bool> save({
    required String fullname,
    required String phoneNo,
    required String alternatePhoneNo,
    required String address,
    required String nic,
    File? newImage,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(profileRepositoryProvider);
      final imageUrl =
          newImage == null ? null : await repo.uploadImage(newImage);
      await repo.updateProfile(
        fullname: fullname,
        phoneNo: phoneNo,
        alternatePhoneNo: alternatePhoneNo,
        address: address,
        nic: nic,
        image: imageUrl,
      );
      ref.invalidate(driverProfileProvider);
    });
    return !state.hasError;
  }
}
