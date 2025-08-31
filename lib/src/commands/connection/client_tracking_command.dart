import '../../codec/valkey_exception.dart';
import '../command.dart';

enum ClientTrackingMode {
  on,
  off,
}

/// Represents the 'CLIENT TRACKING ON|OFF' command.
final class ClientTrackingCommand extends ValkeyCommand<bool> {
  ClientTrackingCommand(this.mode);
  final ClientTrackingMode mode;

  @override
  List<Object> get commandParts =>
      ['CLIENT', 'TRACKING', mode.name.toUpperCase()];

  @override
  bool parse(dynamic data) {
    if (data is String) return data == 'OK';

    throw ValkeyException(
      'Invalid response for CLIENT TRACKING: expected OK, got ${data.runtimeType}',
    );
  }
}
