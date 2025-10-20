import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'CLIENT NO-TOUCH' command.
///
/// **Valkey Command:**
/// ```text
/// CLIENT NO-TOUCH ON | OFF
/// ```
///
/// **Valkey Reply:**
/// ```text
/// OK
/// ```
///
/// **Dart Result (from parse method):**
/// `String` resolving to `'OK'`
final class ClientNoTouchCommand extends ValkeyCommand<String> {
  ClientNoTouchCommand({required this.enable});

  final bool enable;

  @override
  List<String> get commandParts =>
      ['CLIENT', 'NO-TOUCH', if (enable) 'ON' else 'OFF'];

  @override
  String parse(dynamic data) {
    if (data is String && data == 'OK') return data;
    throw ValkeyException(
      'Invalid response for CLIENT NO-TOUCH: expected OK, got ${data.runtimeType}',
    );
  }
}
