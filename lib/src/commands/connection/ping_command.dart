import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'PING [message]' command.
///
/// **Redis Command:**
/// ```
/// PING
/// ```
///
/// **Redis Reply (Example):**
/// ```
/// +PONG
/// ```
///
/// **Dart Result (from parse method):**
/// `String` resolving to `'PONG'`
///
/// Parameters:
/// - [message]: (Optional) A message to be echoed back by the server.
final class PingCommand extends ValkeyCommand<String> {
  PingCommand([this.message]);
  final String? message;

  @override
  List<Object> get commandParts => ['PING', if (message != null) message!];

  @override
  String parse(dynamic data) {
    if (data is String) return data;
    throw ValkeyException(
      'Invalid response for PING: expected a string, got ${data.runtimeType}',
    );
  }
}
