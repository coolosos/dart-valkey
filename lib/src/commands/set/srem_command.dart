import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'SREM key member [member ...]' command.
///
/// **Redis Command:**
/// ```
/// SREM myset member1
/// ```
///
/// **Redis Reply (Example):**
/// ```
/// :1
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `1` (number of members removed)
final class SRemCommand extends ValKeyedCommand<int> with KeyedCommand<int> {
  SRemCommand(this.key, this.members);
  final String key;
  final List<String> members;

  @override
  List<String> get commandParts => ['SREM', key, ...members];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for SREM: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValKeyedCommand<int> applyPrefix(String prefix) {
    return SRemCommand('$prefix$key', members);
  }
}
