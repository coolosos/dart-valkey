import '../command.dart';

/// Represents the 'PERSIST key' command.
/// Removes the expiration from a key.
///
/// **Redis Command:**
/// ```
/// PERSIST mykey
/// ```
///
/// **Redis Reply (Example):**
/// ```
/// :1
/// ```
///
/// **Dart Result (from parse method):**
/// `bool` resolving to `true` (TTL removed) or `false` (key does not exist or no TTL)
final class PersistCommand extends ValkeyCommand<bool> with KeyedCommand<bool> {
  PersistCommand(this.key);
  final String key;

  @override
  List<String> get commandParts => ['PERSIST', key];

  @override
  bool parse(dynamic data) {
    return data == 1;
  }

  @override
  ValkeyCommand<bool> applyPrefix(String prefix) {
    return PersistCommand('$prefix$key');
  }
}
