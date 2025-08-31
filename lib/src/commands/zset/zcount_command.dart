import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'ZCOUNT key min max' command.
///
/// **Redis Command:**
/// ```
/// ZCOUNT myzset 0 10
/// ```
///
/// **Redis Reply (Example):**
/// ```
/// :2
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `2`
final class ZCountCommand extends ValkeyCommand<int> with KeyCommand<int> {
  ZCountCommand(this.key, this.min, this.max);
  final String key;
  final String min;
  final String max;

  @override
  List<Object> get commandParts => ['ZCOUNT', key, min, max];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for ZCOUNT: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<int> applyPrefix(String prefix) {
    return ZCountCommand('$prefix$key', min, max);
  }
}
