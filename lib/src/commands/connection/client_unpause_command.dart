import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'CLIENT UNPAUSE' command.
///
/// **Valkey Command:**
/// ```
/// CLIENT UNPAUSE
/// ```
///
/// **Valkey Reply:**
/// ```
/// OK
/// ```
///
/// **Dart Result (from parse method):**
/// `String` resolving to `'OK'`
final class ClientUnpauseCommand extends ValKeyedCommand<String> {
  ClientUnpauseCommand();

  @override
  List<String> get commandParts => ['CLIENT', 'UNPAUSE'];

  @override
  String parse(dynamic data) {
    if (data is String && data == 'OK') return data;
    throw ValkeyException(
      'Invalid response for CLIENT UNPAUSE: expected OK, got ${data.runtimeType}',
    );
  }
}
