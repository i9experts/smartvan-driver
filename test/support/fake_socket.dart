import 'package:mocktail/mocktail.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

/// A socket that records its handlers so tests can fire server events.
/// (`onConnect` & co. are extensions that call `on('connect', ...)`.)
class FakeSocket extends Mock implements io.Socket {
  FakeSocket() {
    when(() => on(any(), any())).thenAnswer((inv) {
      handlers[inv.positionalArguments[0] as String] =
          inv.positionalArguments[1] as dynamic Function(dynamic);
    });
    when(() => connect()).thenReturn(this);
    when(() => disconnect()).thenReturn(this);
    when(() => dispose()).thenReturn(null);
    when(() => emit(any(), any())).thenReturn(null);
    when(() => connected).thenAnswer((_) => isConnected);
  }

  final Map<String, dynamic Function(dynamic)> handlers = {};
  bool isConnected = false;

  /// Simulates the server connecting.
  void serverConnects() {
    isConnected = true;
    handlers['connect']?.call(null);
  }

  void serverDisconnects() {
    isConnected = false;
    handlers['disconnect']?.call(null);
  }

  void serverSends(String event, Object? data) => handlers[event]?.call(data);
}
