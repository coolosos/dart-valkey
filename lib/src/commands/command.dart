import '../codec/resp_encoder.dart';

/// The base class for all commands in the Valkey client.
///
/// This is a sealed class, allowing for exhaustive pattern matching
/// on its direct subclasses (e.g., [ValkeyCommand] for regular commands
/// and [PubSubCommand] for Pub/Sub commands).
sealed class Command<T> {
  /// The command and its arguments, to be implemented by each subclass.
  List<String> get commandParts;

  late final List<int> encoded = RespEncoder.encode(commandParts);
}

/// The base class for all Pub/Sub specific commands.
///
/// These commands are typically used with a dedicated Pub/Sub client
/// and should not be used with the main [ValkeyClient].
abstract base class PubSubCommand<T> extends Command<T> {
  // No additional members needed here, just serves as a marker interface
  // and base class for Pub/Sub commands.
}

/// The base class for all Valkey commands.
///
/// It is abstract and generic over the return type `T`.
abstract base class ValkeyCommand<T> extends Command<T> {
  // commandParts, parse, and encoded are inherited from Command<T>
  /// The parser for the response, to be implemented by each subclass.
  T parse(dynamic data);
}

base mixin KeyedCommand<T> on ValkeyCommand<T> {
  ValkeyCommand<T> applyPrefix(String prefix);
}
