import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'INCRBY key increment' command.
/// Increments the number stored at key by increment.
///
/// **Redis Command:**
/// ```
/// INCRBY mycounter 5
/// ```
///
/// **Redis Reply (Example):**
/// ```
/// :15
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `15`
///
/// Parameters:
/// - [key]: The key to increment.
/// - [increment]: The amount to increment by.
final class IncrByCommand extends ValkeyCommand<int> with KeyCommand<int> {
  IncrByCommand(this.key, this.increment);
  final String key;
  final int increment;

  @override
  List<String> get commandParts => ['INCRBY', key, increment.toString()];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for INCRBY: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<int> applyPrefix(String prefix) {
    return IncrByCommand('$prefix$key', increment);
  }
}
