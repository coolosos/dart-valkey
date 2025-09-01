import '../command.dart';

/// Represents the `PSUBSCRIBE pattern [pattern ...]` command.
///
/// Subscribes the client to channels matching one or more glob-style patterns.
/// This command is typically used internally by [ValkeyPubSubClient].
final class PSubscribeCommand extends PubSubCommand<void> {
  PSubscribeCommand(this.patterns);
  final List<String> patterns;

  @override
  List<String> get commandParts => ['PSUBSCRIBE', ...patterns];
}
