/// The two documents a driver uploads, with the backend's `title` value and
/// the profile field that holds the front image.
enum DriverDocumentType {
  vehicleCard('vehicle_card', 'vehicleCardImageFront'),
  drivingLicense('driving_license', 'licenceImageFront');

  const DriverDocumentType(this.title, this.frontImageField);

  /// Value of `title` in `POST /van/uploadDocuments`.
  final String title;

  /// Body key that carries the uploaded image URL.
  final String frontImageField;
}
