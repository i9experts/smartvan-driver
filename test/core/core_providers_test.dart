import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:location/location.dart' as loc;
import 'package:mocktail/mocktail.dart';
import 'package:smartvan_driver/core/providers/core_providers.dart';
import 'package:smartvan_driver/core/router/app_router.dart';
import 'package:smartvan_driver/core/sync/sync_queue.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class _FakeSyncQueue extends Mock implements SyncQueue {}

class _FakeLocation extends Mock implements loc.Location {}

class _FakeSocket extends Mock implements io.Socket {}

void main() {
  test('defaults point at the existing singletons', () {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    expect(c.read(syncQueueProvider), same(SyncQueue.instance));
    expect(c.read(routerProvider), same(appRouter));
  });

  test('every seam can be replaced with a fake', () {
    final fakeSocket = _FakeSocket();
    String? requestedUrl;
    final router = GoRouter(
        routes: [GoRoute(path: '/', builder: (_, __) => const SizedBox())]);
    final c = ProviderContainer(overrides: [
      syncQueueProvider.overrideWithValue(_FakeSyncQueue()),
      locationServiceProvider.overrideWithValue(_FakeLocation()),
      socketFactoryProvider.overrideWithValue((url, options) {
        requestedUrl = url;
        return fakeSocket;
      }),
      routerProvider.overrideWithValue(router),
    ]);
    addTearDown(c.dispose);

    expect(c.read(syncQueueProvider), isA<_FakeSyncQueue>());
    expect(c.read(locationServiceProvider), isA<_FakeLocation>());
    expect(c.read(socketFactoryProvider)('http://x', {}), same(fakeSocket));
    expect(requestedUrl, 'http://x');
    expect(c.read(routerProvider), same(router));
  });
}
