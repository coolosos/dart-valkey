import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'CLIENT NO-EVICT' command.
///
/// **Valkey Command:**
/// ```
/// CLIENT NO-EVICT ON | OFF
/// ```
///
/// **Valkey Reply:**
/// ```
/// OK
/// ```
///
/// **Dart Result (from parse method):**
/// `String` resolving to `'OK'`
final class ClientNoEvictCommand extends ValkeyCommand<String> {
  ClientNoEvictCommand(this.enable);

  final bool enable;

  @override
  List<Object> get commandParts =>
      ['CLIENT', 'NO-EVICT', enable ? 'ON' : 'OFF'];

  @override
  String parse(dynamic data) {
    if (data is String && data == 'OK') return data;
    throw ValkeyException(
      'Invalid response for CLIENT NO-EVICT: expected OK, got ${data.runtimeType}',
    );
  }
}
