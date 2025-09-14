import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'CLIENT ID' command.
final class ClientIdCommand extends ValkeyCommand<int> {
  @override
  List<String> get commandParts => ['CLIENT', 'ID'];

  @override
  int parse(dynamic data) {
    if (data is int) {
      return data;
    }
    throw ValkeyException(
      'Invalid response for CLIENT ID: expected an integer, got ${data.runtimeType}',
    );
  }
}
