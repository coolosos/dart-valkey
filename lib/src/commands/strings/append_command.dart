import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'APPEND key value' command.
/// Appends a value to a key.
///
/// **Redis Command:**
/// ```
/// APPEND mykey " World"
/// ```
///
/// **Redis Reply (Example):**
/// ```
/// :11
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `11` (new length of the string)
///
/// Parameters:
/// - [key]: The key to append to.
/// - [value]: The string to append.
final class AppendCommand extends ValkeyCommand<int> with KeyCommand<int> {
  AppendCommand(this.key, this.value);
  final String key;
  final String value;

  @override
  List<String> get commandParts => ['APPEND', key, value];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for APPEND: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<int> applyPrefix(String prefix) {
    return AppendCommand('$prefix$key', value);
  }
}
