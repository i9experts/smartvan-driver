import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'token_storage.dart';

/// Where the auth token lives. Everything new depends on this interface
/// (through [tokenStorageProvider]) so tests can swap in a fake.
abstract interface class TokenStore {
  Future<String?> read();
  Future<void> save(String token);
  Future<void> clear();
  Future<bool> hasToken();
}

/// Production implementation: the platform keystore via the static
/// [TokenStorage]. The statics go away once the last caller is migrated
/// (docs/ARCHITECTURE.md §3, R.5).
class SecureTokenStore implements TokenStore {
  const SecureTokenStore();

  @override
  Future<String?> read() => TokenStorage.read();

  @override
  Future<void> save(String token) => TokenStorage.save(token);

  @override
  Future<void> clear() => TokenStorage.clear();

  @override
  Future<bool> hasToken() => TokenStorage.hasToken();
}

final tokenStorageProvider =
    Provider<TokenStore>((ref) => const SecureTokenStore());
