import 'package:test/test.dart';
import 'package:dart_valkey/src/models/pubsub_message.dart';

void main() {
  group('PubSubMessage', () {
    group('Constructor', () {
      test('should create a message for type "message"', () {
        final msg = PubSubMessage(
          type: 'message',
          channel: 'channel1',
          message: 'hello',
        );
        expect(msg.type, 'message');
        expect(msg.channel, 'channel1');
        expect(msg.message, 'hello');
        expect(msg.pattern, isNull);
        expect(msg.count, isNull);
      });

      test('should create a message for type "pmessage"', () {
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
    });
  });
}
