import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'HLEN key' command.
///
/// **Redis Command:**
/// ```
/// HLEN user:1
/// ```
///
/// **Redis Reply (Example):**
/// ```
/// :2
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `2`
///
/// Parameters:
/// - [key]: The key of the hash.
final class HLenCommand extends ValkeyCommand<int> with KeyCommand<int> {
  HLenCommand(this.key);
  final String key;

  @override
  List<String> get commandParts => ['HLEN', key];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for HLEN: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<int> applyPrefix(String prefix) {
    return HLenCommand('$prefix$key');
  }
}
