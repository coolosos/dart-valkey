import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'SCARD key' command.
///
/// **Redis Command:**
/// ```
/// SCARD myset
/// ```
///
/// **Redis Reply (Example):**
/// ```
/// :2
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `2`
final class SCardCommand extends ValKeyedCommand<int> with KeyedCommand<int> {
  SCardCommand(this.key);
  final String key;

  @override
  List<String> get commandParts => ['SCARD', key];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for SCARD: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValKeyedCommand<int> applyPrefix(String prefix) {
    return SCardCommand('$prefix$key');
  }
}
