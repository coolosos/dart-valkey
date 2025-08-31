import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'HDEL key field [field ...]' command.
///
/// **Redis Command:**
/// ```
/// HDEL user:1 age
/// ```
///
/// **Redis Reply (Example):**
/// ```
/// :1
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `1` (number of fields removed)
///
/// Parameters:
/// - [key]: The key of the hash.
/// - [fields]: A list of fields to remove.
final class HDelCommand extends ValkeyCommand<int> with KeyCommand<int> {
  HDelCommand(this.key, this.fields);
  final String key;
  final List<String> fields;

  @override
  List<Object> get commandParts => ['HDEL', key, ...fields];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for HDEL: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<int> applyPrefix(String prefix) {
    return HDelCommand('$prefix$key', fields);
  }
}
