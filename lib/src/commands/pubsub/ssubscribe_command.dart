import '../command.dart';

/// Represents the `SSUBSCRIBE channel [channel ...]` command.
/// Subscribes the client to one or more shard channels.
final class SsubscribeCommand extends PubSubCommand<void> {
  SsubscribeCommand(this.channels);
  final List<String> channels;

  @override
  List<Object> get commandParts => ['SSUBSCRIBE', ...channels];
}
