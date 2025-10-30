import '../../codec/valkey_exception.dart';
import '../command.dart';

enum ClientReplyMode {
  on,
  off,
  skip,
}

/// Represents the 'CLIENT REPLY ON|OFF|SKIP' command.
final class ClientReplyCommand extends ValkeyCommand<bool> {
  ClientReplyCommand(this.mode);
  final ClientReplyMode mode;

  @override
  List<String> get commandParts => ['CLIENT', 'REPLY', mode.name.toUpperCase()];

  @override
  bool parse(dynamic data) {
    if (data is String) {
      if (data == 'OK') return true;
    }
    throw ValkeyException(
      'Invalid response for CLIENT REPLY: expected OK, got ${data.runtimeType} "$data"',
    );
  }
}
