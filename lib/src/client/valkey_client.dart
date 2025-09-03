library;

import 'dart:async';
import 'dart:collection';
import 'dart:io';

import '../commands/commands.dart';
import '../connection/connection.dart';
import '../connection/insecure_connection.dart';
import '../connection/secure_connection.dart';
import '../codec/valkey_exception.dart';
import '../models/pubsub_message.dart';
import 'package:meta/meta.dart';

export '../models/pubsub_message.dart';
part 'valkey_command_client.dart';
part 'valkey_subscription_client.dart';
part 'mixins/regular_subscription_mixin.dart';
part 'mixins/pattern_subscription_mixin.dart';
part 'mixins/shard_subscription_mixin.dart';

/// Base class for Valkey and Valkey Pub/Sub clients, providing common connection management.
sealed class BaseValkeyClient {
  BaseValkeyClient({
    required this.host,
    required this.port,
    this.secure = false,
    this.connectionTimeout = const Duration(seconds: 5),
    this.onBadCertificate,
    this.username,
    this.password,
    this.protocolVersion,
    Connection? connection,
  }) {
    _connection = connection ??
        (secure
            ? SecureConnection(
                host: host,
                port: port,
                connectionTimeout: connectionTimeout,
                onConnected: _onConnected,
                onData: _onData,
                onDone: _onDone,
                onError: _onError,
                onBadCertificate: onBadCertificate,
              )
            : InsecureConnection(
                host: host,
                port: port,
                connectionTimeout: connectionTimeout,
                onConnected: _onConnected,
                onData: _onData,
                onDone: _onDone,
                onError: _onError,
              ));
  }
  final String host;
  final int port;
  final bool secure;
  final Duration connectionTimeout;
  final bool Function(X509Certificate certificate)? onBadCertificate;
  final String? username;
  final String? password;
  final int? protocolVersion;
  late final Connection _connection;

  /// Establishes the network connection to the Valkey/Redis server.
  Future<void> connect() async {
    if (!_connection.isConnected) {
      await _connection.connect(
        username: username,
        password: password,
        protocolVersion: protocolVersion,
      );
    }
  }

  /// Closes the connection to the Valkey/Redis server and releases all associated resources.
  Future<void> close() => _connection.close();

  /// Sends raw encoded data over the connection.
  void _send(List<int> data) => _connection.send(data);

  /// Abstract method to be implemented by subclasses for handling connection establishment.
  Future<void> _onConnected();

  /// Abstract method to be implemented by subclasses for handling incoming data.
  void _onData(dynamic data);

  /// Abstract method to be implemented by subclasses for handling connection closure.
  void _onDone();

  /// Abstract method to be implemented by subclasses for handling connection errors.
  void _onError(Object error);
}
