import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'LPUSH key value [value ...]' command.
///
/// **Redis Command:**
/// ```
/// LPUSH mylist item1 item2
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
final class LPushCommand extends ValkeyCommand<int> with KeyCommand<int> {
  LPushCommand(this.key, this.values);
  final String key;
  final List<String> values;

  @override
  List<Object> get commandParts => ['LPUSH', key, ...values];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for LPUSH: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<int> applyPrefix(String prefix) {
    return LPushCommand('$prefix$key', values);
  }
}
