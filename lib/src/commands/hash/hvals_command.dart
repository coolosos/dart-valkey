import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'HVALS key' command.
/// Returns all values in the hash stored at key.
///
/// **Redis Command:**
/// ```
/// HVALS user:1
/// ```
///
/// **Redis Reply (Example):**
/// ```
/// *2
/// $5
/// Alice
/// $2
/// 30
/// ```
///
/// **Dart Result (from parse method):**
/// `List<String>` resolving to `['Alice', '30']`
///
/// Parameters:
/// - [key]: The key of the hash.
final class HValsCommand extends ValkeyCommand<List<String>>
    with KeyCommand<List<String>> {
  HValsCommand(this.key);
  final String key;

  @override
  List<String> get commandParts => ['HVALS', key];

  @override
  List<String> parse(dynamic data) {
    if (data is List) return data.map((e) => e as String).toList();
    throw ValkeyException(
      'Invalid response for HVALS: expected a list, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<List<String>> applyPrefix(String prefix) {
    return HValsCommand('$prefix$key');
  }
}
