import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'ZSCORE key member' command.
///
/// **Redis Command:**
/// ```
/// ZSCORE myzset member1
/// ```
///
/// **Redis Reply (Example):**
/// ```
/// $3
/// 1.0
/// ```
///
/// **Dart Result (from parse method):**
/// `double?` resolving to `1.0` or `null`
final class ZScoreCommand extends ValkeyCommand<double?>
    with KeyedCommand<double?> {
  ZScoreCommand(this.key, this.member);
  final String key;
  final String member;

  @override
  List<String> get commandParts => ['ZSCORE', key, member];

  @override
  double? parse(dynamic data) {
    if (data == null) return null;
    if (data is String) return double.tryParse(data);
    throw ValkeyException(
      'Invalid response for ZSCORE: expected a string or null, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<double?> applyPrefix(String prefix) {
    return ZScoreCommand('$prefix$key', member);
  }
}
