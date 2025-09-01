import '../command.dart';

/// Represents the `SUNSUBSCRIBE [channel [channel ...]]` command.
/// Unsubscribes the client from one or more shard channels.
final class SunsubscribeCommand extends PubSubCommand<void> {
  SunsubscribeCommand([this.channels = const []]);
  final List<String> channels;

  @override
  List<String> get commandParts => ['SUNSUBSCRIBE', ...channels];
}
