import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'PUBSUB NUMPAT' command.
/// Returns the number of subscriptions to patterns.
final class PubsubNumpatCommand extends ValkeyCommand<int> {
  @override
  List<Object> get commandParts => ['PUBSUB', 'NUMPAT'];

  @override
  int parse(dynamic data) {
    if (data is int) {
      return data;
    }
    throw ValkeyException(
      'Invalid response for PUBSUB NUMPAT: expected an integer, got ${data.runtimeType}',
    );
  }
}
