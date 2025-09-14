import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'SINTERSTORE destination key [key ...]' command.
/// Stores the members of the intersection of all the given sets in destination.
///
/// **Redis Command:**
/// ```
/// SINTERSTORE newset set1 set2
/// ```
///
/// **Redis Reply (Example):**
/// ```
/// :1
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `1` (number of elements in the resulting set)
final class SInterStoreCommand extends ValkeyCommand<int>
    with KeyedCommand<int> {
  SInterStoreCommand(this.destination, this.keys);
  final String destination;
  final List<String> keys;

  @override
  List<String> get commandParts => ['SINTERSTORE', destination, ...keys];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for SINTERSTORE: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<int> applyPrefix(String prefix) {
    return SInterStoreCommand(
      '$prefix$destination',
      keys.map((key) => '$prefix$key').toList(),
    );
  }
}
