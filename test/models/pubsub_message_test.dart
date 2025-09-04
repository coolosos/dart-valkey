import 'package:test/test.dart';
import 'package:dart_valkey/src/models/pubsub_message.dart';

void main() {
  group('PubSubMessage', () {
    test('Constructor"', () {
      final msg = PubSubMessage(
        type: 'pmessage',
        pattern: 'patt*',
        channel: 'channel2',
        message: 'world',
      );
      expect(msg.type, 'pmessage');
      expect(msg.pattern, 'patt*');
      expect(msg.channel, 'channel2');
      expect(msg.message, 'world');
      expect(msg.count, isNull);
    });

    test('toString', () {
      final msg = PubSubMessage(
        type: 'pmessage',
        pattern: 'patt*',
        channel: 'channel2',
        message: 'world',
      );
      expect(
        msg.toString(),
        'PubSubMessage(type: pmessage, channel: channel2, pattern: patt*, message: world)',
      );
    });
  });
}
