import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'TTL key' command.
/// Gets the time to live for a key in seconds.
///
/// **Redis Command:**
/// ```
/// TTL mykey
/// ```
///
/// **Redis Reply (Example):**
/// ```
/// :60
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `60` (TTL in seconds), `-1` (no expire), or `-2` (key does not exist)
final class TtlCommand extends ValKeyedCommand<int> with KeyedCommand<int> {
  TtlCommand(this.key);
  final String key;

  @override
  List<String> get commandParts => ['TTL', key];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for TTL: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValKeyedCommand<int> applyPrefix(String prefix) {
    return TtlCommand('$prefix$key');
  }
}
