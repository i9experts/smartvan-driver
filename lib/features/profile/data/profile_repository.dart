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

  /// `POST /van/uploadDocuments` with an already uploaded [imageUrl] and,
  /// when the driver gave one, the document's [expiry] date (sent as
  /// `YYYY-MM-DD`; left out otherwise so the saved date stays).
  Future<void> uploadDocument(
    DriverDocumentType type,
    String imageUrl, {
    DateTime? expiry,
  }) =>
      _api.post<void>(
        '/van/uploadDocuments',
        (_) {},
        body: {
          'title': type.title,
          type.frontImageField: imageUrl,
          if (expiry != null) type.expiryField: _isoDate(expiry),
        },
      );

  /// `POST /van/removeDocument`: takes the document off the profile, both
  /// sides (the app only ever shows the front).
  Future<void> removeDocument(DriverDocumentType type) => _api.post<void>(
        '/van/removeDocument',
        (_) {},
        body: {'document': type.removeKey, 'side': 'both'},
      );

  /// `POST /report/addReportByDriver`.
  Future<void> submitReport(IssueReport report) => _api.post<void>(
        '/report/addReportByDriver',
        (_) {},
        body: report.toJson(),
      );
}

String _isoDate(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

final profileRepositoryProvider = Provider<ProfileRepository>(
    (ref) => ProfileRepository(ref.watch(apiClientProvider)));
