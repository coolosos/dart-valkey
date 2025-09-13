import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'HSTRLEN key field' command.
/// Returns the string length of the value associated with field in the hash stored at key.
///
/// **Redis Command:**
/// ```
/// HSTRLEN user:1 name
/// ```
///
/// **Redis Reply (Example):**
/// ```
/// :5
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `5`
/// Represents the 'HSTRLEN key field' command.
/// Returns the string length of the value associated with field in the hash stored at key.
///
/// **Redis Command:**
/// ```
/// HSTRLEN user:1 name
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
/// - [key]: The key of the hash.
/// - [field]: The field to get the length of.
final class HStrLenCommand extends ValKeyedCommand<int> with KeyedCommand<int> {
  HStrLenCommand(this.key, this.field);
  final String key;
  final String field;

  @override
  List<String> get commandParts => ['HSTRLEN', key, field];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for HSTRLEN: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValKeyedCommand<int> applyPrefix(String prefix) {
    return HStrLenCommand('$prefix$key', field);
  }
}
