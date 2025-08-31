import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'MSET key value [key value ...]' command.
/// Sets multiple key-value pairs in a single atomic operation.
///
/// **Redis Command:**
/// ```
/// MSET key1 value1 key2 value2
/// ```
///
/// **Redis Reply (Example):**
/// ```
/// +OK
/// ```
///
/// **Dart Result (from parse method):**
/// `String` resolving to `'OK'`
///
/// Parameters:
/// - [keyValuePairs]: A map of key-value pairs to set.
final class MSetCommand extends ValkeyCommand<String> with KeyCommand<String> {
  MSetCommand(this.keyValuePairs);
  final Map<String, String> keyValuePairs;

  @override
  List<Object> get commandParts {
    final parts = <Object>['MSET'];
    keyValuePairs.forEach((key, value) {
      parts.add(key);
      parts.add(value);
    });
    return parts;
  }

  @override
  String parse(dynamic data) {
    if (data == 'OK') return data;
    throw ValkeyException(
      'Invalid response for MSET: expected "OK", got "$data"',
    );
  }

  @override
  ValkeyCommand<String> applyPrefix(String prefix) {
    final prefixedPairs = <String, String>{};
    keyValuePairs.forEach((key, value) {
      prefixedPairs['$prefix$key'] = value;
    });
    return MSetCommand(prefixedPairs);
  }
}
