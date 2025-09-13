import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'ZRANK key member' command.
/// Returns the rank of member in the sorted set at key, with the scores ordered from low to high.
///
/// **Redis Command:**
/// ```
/// ZRANK myzset member1
/// ```
///
/// **Redis Reply (Example):**
/// ```
/// :0
/// ```
///
/// **Dart Result (from parse method):**
/// `int?` resolving to `0` or `null`
final class ZRankCommand extends ValKeyedCommand<int?> with KeyedCommand<int?> {
  ZRankCommand(this.key, this.member);
  final String key;
  final String member;

  @override
  List<String> get commandParts => ['ZRANK', key, member];

  @override
  int? parse(dynamic data) {
    if (data == null || data is int) return data as int?;
    throw ValkeyException(
      'Invalid response for ZRANK: expected an integer or null, got ${data.runtimeType}',
    );
  }

  @override
  ValKeyedCommand<int?> applyPrefix(String prefix) {
    return ZRankCommand('$prefix$key', member);
  }
}
