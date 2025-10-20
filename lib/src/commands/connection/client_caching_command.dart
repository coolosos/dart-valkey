import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'CLIENT CACHING' command.
///
/// **Valkey Command:**
/// ``` valkey
/// CLIENT CACHING YES | NO
/// ```
///
/// **Valkey Reply:**
/// ``` valkey
/// OK
/// ```
///
/// **Dart Result (from parse method):**
/// `String` resolving to `'OK'`
final class ClientCachingCommand extends ValkeyCommand<String> {
  ClientCachingCommand({required this.enable});

  final bool enable;

  @override
  List<String> get commandParts =>
      ['CLIENT', 'CACHING', if (enable) 'YES' else 'NO'];

  @override
  String parse(dynamic data) {
    if (data is String && data == 'OK') return data;
    throw ValkeyException(
      'Invalid response for CLIENT CACHING: expected OK, got ${data.runtimeType}',
    );
  }
}
