import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'TYPE key' command.
/// Determines the type of a key.
///
/// **Redis Command:**
/// ```
/// TYPE mykey
/// ```
///
/// **Redis Reply (Example):**
/// ```
/// +string
/// ```
///
/// **Dart Result (from parse method):**
/// `String` resolving to `'string'`, `'hash'`, `'list'`, `'set'`, `'zset'`, or `'none'`
final class TypeCommand extends ValkeyCommand<String> with KeyCommand<String> {
  TypeCommand(this.key);
  final String key;

  @override
  List<String> get commandParts => ['TYPE', key];

  @override
  String parse(dynamic data) {
    if (data is String) return data;
    throw ValkeyException(
      'Invalid response for TYPE: expected a string, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<String> applyPrefix(String prefix) {
    return TypeCommand('$prefix$key');
  }
}
