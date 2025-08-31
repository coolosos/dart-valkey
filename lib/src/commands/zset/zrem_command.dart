import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'ZREM key member [member ...]' command.
///
/// **Redis Command:**
/// ```
/// ZREM myzset member1
/// ```
///
/// **Redis Reply (Example):**
/// ```
/// :1
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `1` (number of members removed)
final class ZRemCommand extends ValkeyCommand<int> with KeyCommand<int> {
  ZRemCommand(this.key, this.members);
  final String key;
  final List<String> members;

  @override
  List<Object> get commandParts => ['ZREM', key, ...members];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for ZREM: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<int> applyPrefix(String prefix) {
    return ZRemCommand('$prefix$key', members);
  }
}
