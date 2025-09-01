import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'CLIENT INFO' command.
final class ClientInfoCommand extends ValkeyCommand<String> {
  @override
  List<String> get commandParts => ['CLIENT', 'INFO'];

  @override
  String parse(dynamic data) {
    if (data is String) {
      return data;
    }
    throw ValkeyException(
      'Invalid response for CLIENT INFO: expected a string, got ${data.runtimeType}',
    );
  }
}
