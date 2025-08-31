import '../command.dart';

/// Represents the `PUNSUBSCRIBE [pattern [pattern ...]]` command.
///
/// Unsubscribes the client from channels matching one or more glob-style patterns.
/// This command is typically used internally by [ValkeyPubSubClient].
final class PUnsubscribeCommand extends PubSubCommand<void> {
  PUnsubscribeCommand(this.patterns);
  // Changed extends
  final List<String> patterns;

  @override
  List<Object> get commandParts => ['PUNSUBSCRIBE', ...patterns];
}
