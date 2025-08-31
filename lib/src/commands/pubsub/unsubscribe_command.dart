import '../command.dart';

/// Represents the `UNSUBSCRIBE [channel [channel ...]]` command.
///
/// Unsubscribes the client from one or more channels.
/// This command is typically used internally by [ValkeyPubSubClient].
final class UnsubscribeCommand extends PubSubCommand<void> {
  UnsubscribeCommand(this.channels);
  // Changed extends
  final List<String> channels;

  @override
  List<Object> get commandParts => ['UNSUBSCRIBE', ...channels];
}
