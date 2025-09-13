import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'PUBSUB HELP' command.
/// Returns a help text.
final class PubsubHelpCommand extends ValKeyedCommand<List<String>> {
  @override
  List<String> get commandParts => ['PUBSUB', 'HELP'];

  @override
  List<String> parse(dynamic data) {
    if (data is List) {
      return data.cast<String>();
    }
    throw ValkeyException(
      'Invalid response for PUBSUB HELP: expected a list of strings, got ${data.runtimeType}',
    );
  }
}
