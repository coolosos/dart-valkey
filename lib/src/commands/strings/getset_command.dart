import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'GETSET key value' command.
/// Atomically sets key to value and returns the old value stored at key.
///
/// **Redis Command:**
/// ```
/// GETSET mykey newvalue
/// ```
///
/// **Redis Reply (Example):**
/// ```
/// $7
/// oldvalue
/// ```
///
/// **Dart Result (from parse method):**
/// `String?` resolving to `'oldvalue'` or `null`
///
/// Parameters:
/// - [key]: The key to set.
/// - [value]: The new value to set.
final class GetSetCommand extends ValkeyCommand<String?>
    with KeyCommand<String?> {
  GetSetCommand(this.key, this.value);
  final String key;
  final String value;

  @override
  List<Object> get commandParts => ['GETSET', key, value];

  @override
  String? parse(dynamic data) {
    if (data == null || data is String) return data as String?;
    throw ValkeyException(
      'Invalid response for GETSET: expected a string or null, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<String?> applyPrefix(String prefix) {
    return GetSetCommand('$prefix$key', value);
  }
}
