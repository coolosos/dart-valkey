import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'LINSERT key BEFORE|AFTER pivot value' command.
/// Inserts an element before or after another element in a list.
///
/// **Redis Command:**
/// ```
/// LINSERT mylist BEFORE item2 newitem
/// ```
///
/// **Redis Reply (Example):**
/// ```
/// :3
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `3` (new length of the list)
///
/// Parameters:
/// - [key]: The key of the list.
/// - [before]: If true, insert before the pivot; otherwise, insert after.
/// - [pivot]: The element to insert relative to.
/// - [value]: The value to insert.
final class LInsertCommand extends ValkeyCommand<int> with KeyCommand<int> {
  LInsertCommand(this.key, this.before, this.pivot, this.value);
  final String key;
  final bool before;
  final String pivot;
  final String value;

  @override
  List<Object> get commandParts => [
        'LINSERT',
        key,
        before ? 'BEFORE' : 'AFTER',
        pivot,
        value,
      ];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for LINSERT: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<int> applyPrefix(String prefix) {
    return LInsertCommand('$prefix$key', before, pivot, value);
  }
}
