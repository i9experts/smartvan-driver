import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/driver_profile.dart';
import '../data/profile_repository.dart';

part 'driver_profile_provider.g.dart';

/// The signed-in driver's profile, fetched once and shared by every screen
/// (it used to be fetched separately by five). Invalidate after anything
/// that changes it (edit, document upload) and on sign-in / sign-out.
@Riverpod(keepAlive: true)
Future<DriverProfile> driverProfile(Ref ref) =>
    ref.watch(profileRepositoryProvider).getProfile();
