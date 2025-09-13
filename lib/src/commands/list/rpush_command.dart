import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'RPUSH key value [value ...]' command.
///
/// **Redis Command:**
/// ```
/// RPUSH mylist item1 item2
/// ```
///
/// **Redis Reply (Example):**
/// ```
/// :2
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `2`
///
/// Parameters:
/// - [key]: The key of the list.
/// - [values]: The values to push to the list.
final class RPushCommand extends ValKeyedCommand<int> with KeyedCommand<int> {
  RPushCommand(this.key, this.values);
  final String key;
  final List<String> values;

  @override
  List<String> get commandParts => ['RPUSH', key, ...values];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for RPUSH: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValKeyedCommand<int> applyPrefix(String prefix) {
    return RPushCommand('$prefix$key', values);
  }
}
