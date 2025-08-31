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
final class DelCommand extends ValkeyCommand<int> with KeyCommand<int> {
  DelCommand(this.keys);
  final List<String> keys;

  @override
  List<Object> get commandParts => ['DEL', ...keys];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for DEL: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<int> applyPrefix(String prefix) {
    return DelCommand(keys.map((key) => '$prefix$key').toList());
  }
}
