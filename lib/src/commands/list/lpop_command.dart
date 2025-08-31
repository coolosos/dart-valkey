import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'LPOP key [count]' command.
///
/// **Redis Command:**
/// ```
/// LPOP mylist
/// LPOP mylist 2
/// ```
///
/// **Redis Reply (Example):**
/// ```
/// $5
/// item1
/// ```
///
/// **Dart Result (from parse method):**
/// `String?` resolving to `'item1'` or `null` (if count is not provided)
/// `List<String>?` resolving to `['item1', 'item2']` or `null` (if count is provided)
///
/// Parameters:
/// - [key]: The key of the list.
/// - [count]: (Optional) The number of elements to pop.
final class LPopCommand extends ValkeyCommand<List<String>>
    with KeyCommand<List<String>> {
  LPopCommand(this.key, [this.count]);
  final String key;
  final int? count;

  @override
  List<Object> get commandParts => ['LPOP', key, if (count != null) count!];

  @override
  List<String> parse(dynamic data) {
    if (data == null) return List.empty();
    if (data is String) return [data];

    if (data is List) return data.map((e) => e as String).toList();

    throw ValkeyException(
      'Invalid response for LPOP: expected a string/null or list, got ${data.runtimeType}',
    );
  }

  @override
  LPopCommand applyPrefix(String prefix) {
    return LPopCommand('$prefix$key', count);
  }
}
