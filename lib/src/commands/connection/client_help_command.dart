import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'CLIENT HELP' command.
final class ClientHelpCommand extends ValKeyedCommand<String> {
  @override
  List<String> get commandParts => ['CLIENT', 'HELP'];

  @override
  String parse(dynamic data) {
    if (data is String) {
      return data;
    }
    throw ValkeyException(
      'Invalid response for CLIENT HELP: expected a string, got ${data.runtimeType}',
    );
  }
}
