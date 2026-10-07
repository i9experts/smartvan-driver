import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/network/json_helpers.dart';
import '../../../core/network/network_providers.dart';
import 'models/driver_document_type.dart';
import 'models/driver_profile.dart';
import 'models/issue_report.dart';

/// Profile, documents, image upload and issue reports.
class ProfileRepository {
  const ProfileRepository(this._api);

  final ApiClient _api;

  /// `GET /auth/getProfile`.
  Future<DriverProfile> getProfile() => _api.get(
        '/auth/getProfile',
        (json) => DriverProfile.fromJson(asJsonMap(json)),
      );

  /// `POST /van/update-profile` (the same endpoint also stores the FCM
  /// token). [image] is a URL from [uploadImage]; left out when null.
  Future<void> updateProfile({
    required String fullname,
    required String phoneNo,
    required String alternatePhoneNo,
    required String address,
    required String nic,
    String? image,
  }) =>
      _api.post<void>(
        '/van/update-profile',
        (_) {},
        body: {
          'fullname': fullname,
          'phoneNo': phoneNo,
          'alternatePhoneNo': alternatePhoneNo,
          'address': address,
          'NIC': nic,
          'userType': 'driver',
          if (image != null) 'image': image,
        },
      );

  /// `POST /upload/image` (multipart `file`). Returns the hosted URL; throws
  /// an `ApiError(UPLOAD_FAILED)` if the server answers without one, so a
  /// caller can never carry on without the image by accident.
  Future<String> uploadImage(File file) async {
    final url = await _api.uploadImage(file);
    if (url == null || url.isEmpty) {
      throw const ApiError(
        code: 'UPLOAD_FAILED',
        message: 'Image upload failed. Please try again.',
        status: 200,
      );
    }
    return url;
  }

  /// `POST /van/uploadDocuments` with an already uploaded [imageUrl].
  Future<void> uploadDocument(DriverDocumentType type, String imageUrl) =>
      _api.post<void>(
        '/van/uploadDocuments',
        (_) {},
        body: {'title': type.title, type.frontImageField: imageUrl},
      );

  /// `POST /report/addReportByDriver`.
  Future<void> submitReport(IssueReport report) => _api.post<void>(
        '/report/addReportByDriver',
        (_) {},
        body: report.toJson(),
      );
}

final profileRepositoryProvider = Provider<ProfileRepository>(
    (ref) => ProfileRepository(ref.watch(apiClientProvider)));
