import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'DECRBY key decrement' command.
/// Decrements the number stored at key by decrement.
///
/// **Redis Command:**
/// ```
/// DECRBY mycounter 5
/// ```
///
/// **Redis Reply (Example):**
/// ```
/// :5
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `5`
///
/// Parameters:
/// - [key]: The key to decrement.
/// - [decrement]: The amount to decrement by.
final class DecrByCommand extends ValkeyCommand<int> with KeyedCommand<int> {
  DecrByCommand(this.key, this.decrement);
  final String key;
  final int decrement;

  @override
  List<String> get commandParts => ['DECRBY', key, decrement.toString()];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for DECRBY: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<int> applyPrefix(String prefix) {
    return DecrByCommand('$prefix$key', decrement);
  }
}
