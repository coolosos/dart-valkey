import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'CLIENT NO-EVICT' command.
///
/// **Valkey Command:**
/// ```text
/// CLIENT NO-EVICT ON | OFF
/// ```
///
/// **Valkey Reply:**
/// ```text
/// OK
/// ```
///
/// **Dart Result (from parse method):**
/// `String` resolving to `'OK'`
final class ClientNoEvictCommand extends ValkeyCommand<String> {
  ClientNoEvictCommand({required this.enable});

  final bool enable;

  @override
  List<String> get commandParts =>
      ['CLIENT', 'NO-EVICT', if (enable) 'ON' else 'OFF'];

  @override
  String parse(dynamic data) {
    if (data is String && data == 'OK') return data;
    throw ValkeyException(
      'Invalid response for CLIENT NO-EVICT: expected OK, got ${data.runtimeType}',
    );
  }
}
