import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'CLIENT SETINFO <key> <value>' command.
final class ClientSetinfoCommand extends ValkeyCommand<bool> {
  ClientSetinfoCommand(this.key, this.value);
  final String key;
  final String value;

  @override
  List<Object> get commandParts => ['CLIENT', 'SETINFO', key, value];

  @override
  bool parse(dynamic data) {
    if (data is String) return data == 'OK';

    throw ValkeyException(
      'Invalid response for CLIENT SETINFO: expected OK, got ${data.runtimeType}',
    );
  }
}
