import '../command.dart';

/// Represents the 'LTRIM key start stop' command.
///
/// **Redis Command:**
/// ```
/// LTRIM mylist 0 0
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
/// - [key]: The key of the list.
/// - [start]: The starting offset.
/// - [stop]: The ending offset (inclusive).
final class LTrimCommand extends ValkeyCommand<bool> with KeyCommand<bool> {
  LTrimCommand(this.key, this.start, this.stop);
  final String key;
  final int start;
  final int stop;

  @override
  List<String> get commandParts =>
      ['LTRIM', key, start.toString(), stop.toString()];

  @override
  bool parse(dynamic data) {
    return data == 'OK';
    // throw ValkeyException(
    //     'Invalid response for LTRIM: expected "OK", got "$data"');
  }

  @override
  ValkeyCommand<bool> applyPrefix(String prefix) {
    return LTrimCommand('$prefix$key', start, stop);
  }
}
