import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'CLIENT CAPA' command.
final class ClientCapaCommand extends ValKeyedCommand<List<String>> {
  @override
  List<String> get commandParts => ['CLIENT', 'CAPA'];

  @override
  List<String> parse(dynamic data) {
    if (data is List) {
      return data.cast<String>();
    }
    throw ValkeyException(
      'Invalid response for CLIENT CAPA: expected a list of strings, got ${data.runtimeType}',
    );
  }
}
