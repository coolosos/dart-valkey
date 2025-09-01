import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'INCR key' command.
///
/// **Redis Command:**
/// ```
/// INCR mycounter
/// ```
///
/// **Redis Reply (Example):**
/// ```
/// :1
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `1`
///
/// Parameters:
/// - [key]: The key to increment.
final class IncrCommand extends ValkeyCommand<int> with KeyCommand<int> {
  IncrCommand(this.key);
  final String key;

  @override
  List<String> get commandParts => ['INCR', key];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    if (data is String) {
      if (int.tryParse(data) case final value?) {
        return value;
      }
    }
    throw ValkeyException(
      'Invalid response for INCR: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<int> applyPrefix(String prefix) {
    return IncrCommand('$prefix$key');
  }
}
