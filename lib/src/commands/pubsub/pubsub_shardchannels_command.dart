import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'PUBSUB SHARDCHANNELS [pattern]' command.
/// Lists the currently active shard channels.
final class PubsubShardchannelsCommand extends ValkeyCommand<List<String>> {
  PubsubShardchannelsCommand([this.pattern]);
  final String? pattern;

  @override
  List<Object> get commandParts =>
      ['PUBSUB', 'SHARDCHANNELS', if (pattern != null) pattern!];

  @override
  List<String> parse(dynamic data) {
    if (data is List) {
      return data.cast<String>();
    }
    throw ValkeyException(
      'Invalid response for PUBSUB SHARDCHANNELS: expected a list of strings, got ${data.runtimeType}',
    );
  }
}
