import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'PUBSUB SHARDNUMSUB [channel-1 ... channel-N]' command.
/// Returns the number of subscribers for the specified shard channels.
final class PubsubShardnumsubCommand extends ValkeyCommand<Map<String, int>> {
  PubsubShardnumsubCommand([this.channels = const []]);
  final List<String> channels;

  @override
  List<Object> get commandParts => ['PUBSUB', 'SHARDNUMSUB', ...channels];

  @override
  Map<String, int> parse(dynamic data) {
    if (data is List) {
      final result = <String, int>{};
      for (var i = 0; i < data.length; i += 2) {
        result[data[i] as String] = data[i + 1] as int;
      }
      return result;
    }
    throw ValkeyException(
      'Invalid response for PUBSUB SHARDNUMSUB: expected a list, got ${data.runtimeType}',
    );
  }
}
