import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'MGET key [key ...]' command.
/// Returns the values of all specified keys.
///
/// **Redis Command:**
/// ```
/// MGET key1 key2
/// ```
///
/// **Redis Reply (Example):**
/// ```
/// *2
/// $5
/// value1
/// $-1
/// ```
///
/// **Dart Result (from parse method):**
/// `List<String?>` resolving to `['value1', null]`
///
/// Parameters:
/// - [keys]: A list of keys to retrieve values for.
final class MGetCommand extends ValKeyedCommand<List<String?>>
    with KeyedCommand<List<String?>> {
  MGetCommand(this.keys);
  final List<String> keys;

  @override
  List<String> get commandParts => ['MGET', ...keys];

  @override
  List<String?> parse(dynamic data) {
    if (data is List) return data.map((e) => e as String?).toList();
    throw ValkeyException(
      'Invalid response for MGET: expected a list, got ${data.runtimeType}',
    );
  }

  @override
  ValKeyedCommand<List<String?>> applyPrefix(String prefix) {
    return MGetCommand(keys.map((key) => '$prefix$key').toList());
  }
}
