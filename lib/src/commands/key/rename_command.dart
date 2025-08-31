import '../command.dart';

/// Represents the 'RENAME key newkey' command.
/// Renames a key.
///
/// **Redis Command:**
/// ```
/// RENAME oldkey newkey
/// ```
///
/// **Redis Reply (Example):**
/// ```
/// +OK
/// ```
///
/// **Dart Result (from parse method):**
/// `String` resolving to `'OK'`
final class RenameCommand extends ValkeyCommand<bool> with KeyCommand<bool> {
  RenameCommand(this.key, this.newKey);
  final String key;
  final String newKey;

  @override
  List<Object> get commandParts => ['RENAME', key, newKey];

  @override
  bool parse(dynamic data) {
    return data == 'OK';
  }

  @override
  ValkeyCommand<bool> applyPrefix(String prefix) {
    return RenameCommand('$prefix$key', '$prefix$newKey');
  }
}
