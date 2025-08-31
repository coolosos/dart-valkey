import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'HGETALL key' command.
///
/// **Redis Command:**
/// ```
/// HGETALL user:1
/// ```
///
/// **Redis Reply (Example):**
/// ```
/// *4
/// $4
/// name
/// $5
/// Alice
/// $3
/// age
/// $2
/// 30
/// ```
///
/// **Dart Result (from parse method):**
/// `Map<String, String>` resolving to `{'name': 'Alice', 'age': '30'}`
///
/// Parameters:
/// - [key]: The key of the hash.
final class HGetAllCommand extends ValkeyCommand<Map<String, String>>
    with KeyCommand<Map<String, String>> {
  HGetAllCommand(this.key);
  final String key;

  @override
  List<Object> get commandParts => ['HGETALL', key];

  @override
  Map<String, String> parse(dynamic data) {
    if (data is List) {
      if (data.isEmpty) return {};
      final map = <String, String>{};
      for (var i = 0; i < data.length; i += 2) {
        map[data[i] as String] = data[i + 1] as String;
      }
      return map;
    }
    throw ValkeyException(
      'Invalid response for HGETALL: expected a list, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<Map<String, String>> applyPrefix(String prefix) {
    return HGetAllCommand('$prefix$key');
  }
}
