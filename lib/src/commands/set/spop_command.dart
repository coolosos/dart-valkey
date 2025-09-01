import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'SPOP key' command.
/// Removes and returns a random member from the set value stored at key.
///
/// **Redis Command:**
/// ```
/// SPOP myset
/// ```
///
/// **Redis Reply (Example):**
/// ```
/// $7
/// member1
/// ```
///
/// **Dart Result (from parse method):**
/// `String?` resolving to `'member1'` or `null`
final class SPopCommand extends ValkeyCommand<String?>
    with KeyCommand<String?> {
  SPopCommand(this.key);
  final String key;

  @override
  List<String> get commandParts => ['SPOP', key];

  @override
  String? parse(dynamic data) {
    if (data == null || data is String) return data as String?;
    throw ValkeyException(
      'Invalid response for SPOP: expected a string or null, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<String?> applyPrefix(String prefix) {
    return SPopCommand('$prefix$key');
  }
}
