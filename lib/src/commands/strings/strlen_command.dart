import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'STRLEN key' command.
/// Returns the length of the string value stored at key.
///
/// **Redis Command:**
/// ```
/// STRLEN mykey
/// ```
///
/// **Redis Reply (Example):**
/// ```
/// :5
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `5`
///
/// Parameters:
/// - [key]: The key to get the length of.
final class StrLenCommand extends ValKeyedCommand<int> with KeyedCommand<int> {
  StrLenCommand(this.key);
  final String key;

  @override
  List<String> get commandParts => ['STRLEN', key];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for STRLEN: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValKeyedCommand<int> applyPrefix(String prefix) {
    return StrLenCommand('$prefix$key');
  }
}
