import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the `PUBLISH channel message` command.
///
/// Posts a message to the given channel.
final class PublishCommand extends ValKeyedCommand<int> {
  PublishCommand(this.channel, this.message);
  // Changed extends
  final String channel;
  final String message;

  @override
  List<String> get commandParts => ['PUBLISH', channel, message];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for PUBLISH: expected an integer, got ${data.runtimeType}',
    );
  }
}
