import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'CLIENT CACHING' command.
///
/// **Valkey Command:**
/// ```
/// CLIENT CACHING YES | NO
/// ```
///
/// **Valkey Reply:**
/// ```
/// OK
/// ```
///
/// **Dart Result (from parse method):**
/// `String` resolving to `'OK'`
final class ClientCachingCommand extends ValKeyedCommand<String> {
  ClientCachingCommand(this.enable);

  final bool enable;

  @override
  List<String> get commandParts => ['CLIENT', 'CACHING', enable ? 'YES' : 'NO'];

  @override
  String parse(dynamic data) {
    if (data is String && data == 'OK') return data;
    throw ValkeyException(
      'Invalid response for CLIENT CACHING: expected OK, got ${data.runtimeType}',
    );
  }
}
