import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'LREM key count value' command.
/// Removes the first count occurrences of elements equal to value from the list stored at key.
///
/// **Redis Command:**
/// ```
/// LREM mylist 1 item1
/// ```
///
/// **Redis Reply (Example):**
/// ```
/// :1
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `1` (number of elements removed)
final class LRemCommand extends ValKeyedCommand<int> with KeyedCommand<int> {
  LRemCommand(this.key, this.count, this.value);
  final String key;
  final int count;
  final String value;

  @override
  List<String> get commandParts => ['LREM', key, count.toString(), value];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for LREM: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValKeyedCommand<int> applyPrefix(String prefix) {
    return LRemCommand('$prefix$key', count, value);
  }
}
