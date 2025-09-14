import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'SRANDMEMBER key' command.
/// Returns a random member from the set stored at key.
///
/// **Redis Command:**
/// ```
/// SRANDMEMBER myset
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
final class SRandMemberCommand extends ValkeyCommand<String?>
    with KeyedCommand<String?> {
  SRandMemberCommand(this.key);
  final String key;

  @override
  List<String> get commandParts => ['SRANDMEMBER', key];

  @override
  String? parse(dynamic data) {
    if (data == null || data is String) return data as String?;
    throw ValkeyException(
      'Invalid response for SRANDMEMBER: expected a string or null, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<String?> applyPrefix(String prefix) {
    return SRandMemberCommand('$prefix$key');
  }
}
