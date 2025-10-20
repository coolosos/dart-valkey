import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'SADD key member [member ...]' command.
///
/// **Redis Command:**
/// ```text
/// SADD myset member1 member2
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// :2
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `2` (number of members added)
final class SAddCommand extends ValkeyCommand<int> with KeyedCommand<int> {
  SAddCommand(this.key, this.members);
  final String key;
  final List<String> members;

  @override
  List<String> get commandParts => ['SADD', key, ...members];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for SADD: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<int> applyPrefix(String prefix) {
    return SAddCommand('$prefix$key', members);
  }
}
