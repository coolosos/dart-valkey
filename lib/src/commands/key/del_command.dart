import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'DEL key [key ...]' command.
/// Deletes one or more keys.
///
/// **Redis Command:**
/// ```
/// DEL mykey1 mykey2
/// ```
///
/// **Redis Reply (Example):**
/// ```
/// :2
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `2` (number of keys deleted)
final class DelCommand extends ValKeyedCommand<int> with KeyedCommand<int> {
  DelCommand(this.keys);
  final List<String> keys;

  @override
  List<String> get commandParts => ['DEL', ...keys];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for DEL: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValKeyedCommand<int> applyPrefix(String prefix) {
    return DelCommand(keys.map((key) => '$prefix$key').toList());
  }
}
