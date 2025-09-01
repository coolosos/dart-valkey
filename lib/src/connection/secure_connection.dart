import 'dart:io';

import 'base_connection.dart';

class SecureConnection extends BaseConnection {
  SecureConnection({
    super.host,
    super.port,
    super.connectionTimeout,
    super.onConnected,
    super.onData,
    super.onDone,
    super.onError,
    super.maxReconnectAttempts,
    this.onBadCertificate,
  });

  final bool Function(X509Certificate certificate)? onBadCertificate;

  @override
  Future<Socket> performSocketConnection() => SecureSocket.connect(
        host,
        port,
        timeout: connectionTimeout,
        onBadCertificate: onBadCertificate,
      );
}
