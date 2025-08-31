import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'HEXISTS key field' command.
///
/// **Redis Command:**
/// ```
/// HEXISTS user:1 name
/// ```
///
/// **Redis Reply (Example):**
/// ```
/// :1
/// ```
///
/// **Dart Result (from parse method):**
/// `bool` resolving to `true`
///
/// Parameters:
/// - [key]: The key of the hash.
/// - [field]: The field to check for existence.
final class HExistsCommand extends ValkeyCommand<bool> with KeyCommand<bool> {
  HExistsCommand(this.key, this.field);
  final String key;
  final String field;

  @override
  List<Object> get commandParts => ['HEXISTS', key, field];

  @override
  bool parse(dynamic data) {
    if (data is int) return data == 1;
    throw ValkeyException(
      'Invalid response for HEXISTS: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<bool> applyPrefix(String prefix) {
    return HExistsCommand('$prefix$key', field);
  }
}
