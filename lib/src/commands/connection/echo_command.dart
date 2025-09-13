import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'ECHO message' command.
final class EchoCommand extends ValKeyedCommand<String> {
  EchoCommand(this.message);
  final String message;

  @override
  List<String> get commandParts => ['ECHO', message];

  @override
  String parse(dynamic data) {
    if (data is String) {
      return data;
    }
    throw ValkeyException(
      'Invalid response for ECHO: expected a string, got ${data.runtimeType}',
    );
  }
}
