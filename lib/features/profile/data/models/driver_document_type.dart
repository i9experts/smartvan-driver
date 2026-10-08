/// The two documents a driver uploads, with the backend's `title` value and
/// the profile fields that go with it.
enum DriverDocumentType {
  vehicleCard(
    'vehicle_card',
    'vehicleCardImageFront',
    'expiryDateVehicleCard',
    'vehicleCard',
  ),
  drivingLicense(
    'driving_license',
    'licenceImageFront',
    'expiryDateLicense',
    'licence',
  );

  const DriverDocumentType(
      this.title, this.frontImageField, this.expiryField, this.removeKey);

  /// Value of `title` in `POST /van/uploadDocuments`.
  final String title;

  /// Body key that carries the uploaded image URL.
  final String frontImageField;

  /// Body key that carries the expiry date (`YYYY-MM-DD`).
  final String expiryField;

  /// Value of `document` in `POST /van/removeDocument`.
  final String removeKey;
}
