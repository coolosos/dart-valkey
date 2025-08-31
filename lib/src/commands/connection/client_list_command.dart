import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'CLIENT LIST' command.
final class ClientListCommand extends ValkeyCommand<String> {
  @override
  List<Object> get commandParts => ['CLIENT', 'LIST'];

  @override
  String parse(dynamic data) {
    if (data is String) {
      return data;
    }
    throw ValkeyException(
      'Invalid response for CLIENT LIST: expected a string, got ${data.runtimeType}',
    );
  }
}
