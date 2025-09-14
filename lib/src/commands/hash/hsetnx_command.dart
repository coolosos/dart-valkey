import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'HSETNX key field value' command.
/// Sets field in the hash stored at key to value, only if field does not yet exist.
///
/// **Redis Command:**
/// ```
/// HSETNX user:1 newfield newvalue
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
/// - [field]: The field to set.
/// - [value]: The value to set.
final class HSetNxCommand extends ValkeyCommand<bool> with KeyedCommand<bool> {
  HSetNxCommand(this.key, this.field, this.value);
  final String key;
  final String field;
  final String value;

  @override
  List<String> get commandParts => ['HSETNX', key, field, value];

  @override
  bool parse(dynamic data) {
    if (data is int) return data == 1;
    throw ValkeyException(
      'Invalid response for HSETNX: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<bool> applyPrefix(String prefix) {
    return HSetNxCommand('$prefix$key', field, value);
  }
}
