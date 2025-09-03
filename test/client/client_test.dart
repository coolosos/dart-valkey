import 'dart:async';
import 'package:dart_valkey/dart_valkey.dart';

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import '../mocks.mocks.dart';

base class FakeFailingCommand extends FakeCommand<String> {
  FakeFailingCommand() : super(fakeEncoded: [1], fakeResult: 'wont happen');

  @override
  String parse(dynamic data) {
    throw Exception('Parse error!');
  }
}

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
      when(mockConnection.isConnected).thenReturn(false);
      when(mockConnection.connect()).thenAnswer((_) async {
        when(mockConnection.isConnected).thenReturn(true);
      });
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

    test('connect should not reconnect if already connected', () async {
      // Connect once in setUp
      await client.connect();
      // Connect again
      await client.connect();

      verify(mockConnection.connect()).called(1);
    });

    test('onDone should complete pending commands with an error', () {
      final command = FakeCommand(fakeEncoded: [1], fakeResult: 'OK');
      final future = client.execute(command);

      client.handleDoneMock();

      expect(future, throwsA(isA<StateError>()));
    });

    test('onError should complete pending commands with an error', () {
      final command = FakeCommand(fakeEncoded: [1], fakeResult: 'OK');
      final future = client.execute(command);
      final error = Exception('Network error');

      client.handleErrorMock(error);

      expect(future, throwsA(equals(error)));
    });

    test('_onData should complete with error if command parsing fails', () {
      final command = FakeFailingCommand();
      final future = client.execute(command);

      client.handleDataMock('some data');

      expect(future, throwsA(isA<Exception>()));
    });

    group('with keyPrefix', () {
      late ValkeyCommandClient clientWithPrefix;

      setUp(() {
        clientWithPrefix = ValkeyCommandClient(
          host: 'localhost',
          port: 6379,
          connection: mockConnection,
          keyPrefix: 'test:',
        );
        when(mockConnection.isConnected).thenReturn(true);
      });

      test('should apply prefix to KeyCommands', () {
        final command = GetCommand('mykey');
        final prefixedCommand = GetCommand('test:mykey');

        when(mockConnection.send(any)).thenReturn(null);

        clientWithPrefix.execute(command);

        verify(mockConnection.send(prefixedCommand.encoded)).called(1);
      });
    });

    group('_onConnected (simpler test)', () {
      late ValkeyCommandClient client;
      late MockConnection mockConnection;

      setUp(() {
        mockConnection = MockConnection();
        // when(mockConnection.isConnected).thenReturn(true);
        // when(mockConnection.connect()).thenAnswer((_) async {});

        // when(mockConnection.send(any)).thenReturn(null);

        client = ValkeyCommandClient(
          host: 'localhost',
          port: 6379,
          connection: mockConnection,
        );

        // when(client.execute<String>(command)).thenAnswer((_) async => 'OK');
      });

      test('should call execute for SelectCommand and resend queued commands',
          () async {
        final command = FakeCommand(fakeEncoded: [1, 2, 3], fakeResult: 'OK');

        client.execute(command);

        client.handleOnConnectedMock();

        verify(mockConnection.send(argThat(isA<List<int>>()))).called(2);
      });
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
