import 'dart:io';

import 'base_connection.dart';

class InsecureConnection extends BaseConnection {
  InsecureConnection({
    required super.respDecoder,
    super.host,
    super.port,
    super.connectionTimeout,
    super.onConnected,
    super.onData,
    super.onDone,
    super.onError,
    super.maxReconnectAttempts,
  });

  @override
  Future<Socket> performSocketConnection() =>
      Socket.connect(host, port, timeout: connectionTimeout);
}
