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

    group('_onConnected', () {
      late ValkeyCommandClient client;
      late MockConnection mockConnection;

      setUp(() {
        mockConnection = MockConnection();
        when(mockConnection.isConnected).thenReturn(false);
        // Prevent connect from doing anything automatically
        when(mockConnection.connect()).thenAnswer((_) async {});

        client = ValkeyCommandClient(
          host: 'localhost',
          port: 6379,
          connection: mockConnection,
        );
      });

      test('should resend queued commands', () async {
        final command = FakeCommand(fakeEncoded: [1, 2, 3], fakeResult: 'OK');

        // Mock the send call to avoid unexpected calls error
        when(mockConnection.send(any)).thenReturn(null);

        // Execute a command while the client is "disconnected"
        final future = client.execute(command);

        // Verify the initial send
        verify(mockConnection.send(command.encoded)).called(1);

        // Now, trigger the onConnected logic directly
        await client.handleOnConnectedMock();

        // Verify the SELECT command and the resend happened
        // Total calls = 1 (initial) + 1 (SELECT) + 1 (resend) = 3
        verify(mockConnection.send(any)).called(3);

        // Clean up the queue
        client.handleDataMock('OK'); // For SELECT
        client.handleDataMock('OK'); // For our command
        await future;
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
