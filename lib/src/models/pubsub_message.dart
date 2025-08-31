/// Represents a message received from a Pub/Sub channel.
class PubSubMessage {
  PubSubMessage({
    required this.type,
    required this.channel,
    this.pattern,
    this.message,
    this.count,
  });

  /// The type of the Pub/Sub message.
  /// Can be 'message', 'pmessage', 'subscribe', 'unsubscribe', 'psubscribe', 'punsubscribe'.
  final String type;

  /// The channel the message was received on.
  final String channel;

  /// The pattern that matched the channel (only for 'pmessage' type).
  final String? pattern;

  /// The actual message content (only for 'message' and 'pmessage' types).
  final String? message;

  /// The number of channels currently subscribed to (for 'subscribe', 'unsubscribe', 'psubscribe', 'punsubscribe' types).
  final int? count;

  @override
  String toString() {
    if (type == 'message' || type == 'pmessage') {
      return 'PubSubMessage(type: $type, channel: $channel, pattern: $pattern, message: $message)';
    }
    return 'PubSubMessage(type: $type, channel: $channel, count: $count)';
  }
}
