import 'dart:async';
import 'package:dart_valkey/dart_valkey.dart';
import 'package:dart_valkey/src/models/pubsub_message.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import '../mocks.mocks.dart';

void main() {
  group('ValkeyCommandClient', () {
    late MockConnection mockConnection;
    late ValkeyCommandClient client;

    setUp(() {
      mockConnection = MockConnection();
      client = ValkeyCommandClient(
        host: 'localhost',
        port: 6379,
        connection: mockConnection,
      );
    });

    test('execute should enqueue command and send encoded data', () async {
      final command = FakeCommand(fakeEncoded: [1, 2, 3], fakeResult: 'OK');

      client.execute(command);

      verify(mockConnection.send([1, 2, 3])).called(1);
    });

    test('_onData should complete the first queued command', () async {
      final command = FakeCommand(fakeEncoded: [1], fakeResult: 'OK');
      final future = client.execute(command);

      client.handleDataMock('OK'); // helper to call _onData

      expect(await future, equals('OK'));
    });
  });

  group('ValkeySubscriptionClient', () {
    late ValkeySubscriptionClient subClient;

    setUp(() {
      subClient = ValkeySubscriptionClient(
        host: 'localhost',
        port: 6379,
        connection: MockConnection(),
      );
    });

    test('onData should emit message events', () async {
      final messages = <PubSubMessage>[];
      subClient.messages.listen(messages.add);

      subClient.handleDataMock(['message', 'channel1', 'hello']);

      await Future.delayed(const Duration());

      expect((messages.first).message, equals('hello'));
    });

    test('onData with unknown type should emit error', () async {
      Object? receivedError;
      subClient.messages.listen(null, onError: (e) => receivedError = e);

      subClient.handleDataMock(['wtf', '???']);
      await Future.delayed(const Duration());

      expect(receivedError, isA<ValkeyException>());
    });
  });
}
