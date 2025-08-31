import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'CLIENT NO-TOUCH' command.
///
/// **Valkey Command:**
/// ```
/// CLIENT NO-TOUCH ON | OFF
/// ```
///
/// **Valkey Reply:**
/// ```
/// OK
/// ```
///
/// **Dart Result (from parse method):**
/// `String` resolving to `'OK'`
final class ClientNoTouchCommand extends ValkeyCommand<String> {
  ClientNoTouchCommand(this.enable);

  final bool enable;

  @override
  List<Object> get commandParts =>
      ['CLIENT', 'NO-TOUCH', enable ? 'ON' : 'OFF'];

  @override
  String parse(dynamic data) {
    if (data is String && data == 'OK') return data;
    throw ValkeyException(
      'Invalid response for CLIENT NO-TOUCH: expected OK, got ${data.runtimeType}',
    );
  }
}
