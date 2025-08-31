import '../command.dart';

/// Represents the `SUBSCRIBE channel [channel ...]` command.
///
/// Subscribes the client to one or more channels.
/// This command is typically used internally by [ValkeyPubSubClient].
final class SubscribeCommand extends PubSubCommand<void> {
  SubscribeCommand(this.channels);
  // Changed extends
  final List<String> channels;

  @override
  List<Object> get commandParts => ['SUBSCRIBE', ...channels];
}
