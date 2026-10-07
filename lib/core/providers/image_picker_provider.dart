import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

/// Gallery / camera access (overridable in tests).
final imagePickerProvider = Provider<ImagePicker>((ref) => ImagePicker());
