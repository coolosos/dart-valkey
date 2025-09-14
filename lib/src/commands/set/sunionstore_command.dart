import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'SUNIONSTORE destination key [key ...]' command.
/// Stores the members of the union of all the given sets in destination.
///
/// **Redis Command:**
/// ```
/// SUNIONSTORE newset set1 set2
/// ```
///
/// **Redis Reply (Example):**
/// ```
/// :3
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `3` (number of elements in the resulting set)
final class SUnionStoreCommand extends ValkeyCommand<int>
    with KeyedCommand<int> {
  SUnionStoreCommand(this.destination, this.keys);
  final String destination;
  final List<String> keys;

  @override
  List<String> get commandParts => ['SUNIONSTORE', destination, ...keys];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for SUNIONSTORE: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<int> applyPrefix(String prefix) {
    return SUnionStoreCommand(
      '$prefix$destination',
      keys.map((key) => '$prefix$key').toList(),
    );
  }
}
