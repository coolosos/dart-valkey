import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:meta/meta.dart';

import '../../dart_valkey.dart';

/// Base implementation of a Valkey connection, containing all the common
/// reconnection and error handling logic.
///
/// This class uses the Template Method pattern, requiring subclasses to only
/// implement how the socket is physically created (insecure vs secure).
abstract class BaseConnection implements Connection {
  BaseConnection({
    this.host = '127.00.1',
    this.port = 6379,
    this.connectionTimeout = const Duration(seconds: 10),
    this.onConnected,
    this.onData,
    this.onDone,
    this.onError,
    this.maxReconnectAttempts = 5,
  });

  final String host;
  final int port;
  final Duration connectionTimeout;
  final int maxReconnectAttempts;

  final Future<void> Function()? onConnected;
  final void Function(dynamic data)? onData;
  final void Function()? onDone;
  final void Function(Object error)? onError;

  @visibleForTesting
  RespDecoder get respDecoder => const RespDecoder();

  String? username;
  String? password;
  int? protocolVersion;

  Socket? _socket;
  StreamSubscription? _socketSubscription;

  @visibleForTesting
  Socket? get testSocket => _socket;

  int _reconnectAttempts = 0;
  Timer? _reconnectTimer;

  @override
  Future<void> connect({
    String? username,
    String? password,
    int? protocolVersion,
  }) async {
    if (_socket != null) return;
    _reconnectAttempts = 0;
    this.username = username;
    this.password = password;
    this.protocolVersion = protocolVersion;
    await _performConnection();
  }

  /// The template method that subclasses must implement to provide a connected socket.
  @protected
  Future<Socket> performSocketConnection();

  Future<void> _performConnection() async {
    try {
      final socket = await performSocketConnection();
      socket.setOption(SocketOption.tcpNoDelay, true);

      final decoder = respDecoder.bind(socket).asBroadcastStream();

      if (password case final password? when password.isNotEmpty) {
        final ValkeyCommand<dynamic> command;
        if (protocolVersion case final protocolVersion?) {
          command = HelloCommand(
            protocolVersion: protocolVersion,
            username: username,
            password: password,
          );
        } else {
          command = AuthCommand(password: password, username: username);
        }

        socket.add(command.encoded);

        final response = await decoder.first;

        if (command.parse(response) != 'OK') {
          throw ValkeyException('Authentication failed: $response');
        }
      }

      _socketSubscription = decoder.listen(
        onData,
        onError: (error) {
          onError?.call(error);
          _handleDisconnect();
        },
        onDone: () {
          onDone?.call();
          _handleDisconnect();
        },
        cancelOnError: true,
      );
      _socket = socket;
      _reconnectAttempts = 0;
      await onConnected?.call();
    } catch (e) {
      onError?.call(e);
      _handleDisconnect();
    }
  }

  void _handleDisconnect() {
    _socketSubscription?.cancel();
    _socket?.destroy();
    _socket = null;

    if (_reconnectAttempts < maxReconnectAttempts) {
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    if (_reconnectTimer != null) return;

    final milliseconds = min(30000, 500 * pow(2, _reconnectAttempts)).toInt() +
        Random().nextInt(500);

    _reconnectTimer = Timer(
        Duration(
          milliseconds: milliseconds,
        ), () {
      _reconnectAttempts++;
      _performConnection();

      _reconnectTimer = null;
    });
  }

  @override
  void send(List<int> data) {
    try {
      _socket?.add(data);
    } catch (e) {
      onError?.call(e);
      _handleDisconnect();
    }
  }

  @override
  Future<void> close() async {
    _reconnectTimer?.cancel();
    await _socketSubscription?.cancel();
    _socket?.destroy();
  }
}
