import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'CLIENT PAUSE timeout [WRITE]' command.
final class ClientPauseCommand extends ValkeyCommand<bool> {
  ClientPauseCommand(this.timeout, {this.write = false});
  final int timeout;
  final bool write;

  @override
  List<Object> get commandParts =>
      ['CLIENT', 'PAUSE', timeout.toString(), if (write) 'WRITE'];

  @override
  bool parse(dynamic data) {
    if (data is String) return data == 'OK';

    throw ValkeyException(
      'Invalid response for CLIENT PAUSE: expected OK, got ${data.runtimeType}',
    );
  }
}
