import '../command.dart';

/// Represents the 'PING [message]' command.
///
/// **Redis Command:**
/// ```text
/// PING
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// +PONG
/// ```
///
/// **Dart Result (from parse method):**
/// `String` resolving to `'PONG'`
///
/// Parameters:
/// - [message]: (Optional) A message to be echoed back by the server.
final class PingCommand extends ValkeyCommand<bool> {
  PingCommand([this.message]);
  final String? message;

  @override
  List<String> get commandParts => ['PING', if (message != null) message!];

  @override
  bool parse(dynamic data) {
    return (data == 'PONG');
  }
}
