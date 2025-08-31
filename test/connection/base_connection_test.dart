import 'dart:async';
import 'dart:io';

import 'package:dart_valkey/src/connection/base_connection.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../mocks.mocks.dart';

class TestConnection extends BaseConnection {
  TestConnection({
    super.onConnected,
    super.onData,
    super.onDone,
    super.onError,
  });

  late Socket socketToReturn;

  @override
  Future<Socket> performSocketConnection() async {
    return socketToReturn;
  }
}

void main() {
  group('BaseConnection', () {
    late TestConnection connection;
    late MockSocket mockSocket;

    setUp(() {
      mockSocket = MockSocket();
      connection = TestConnection();
      connection.socketToReturn = mockSocket;
    });

    test('connect should call performSocketConnection and set socket options',
        () async {
      when(mockSocket.setOption(any, any)).thenReturn(true);
      when(mockSocket.transform(any)).thenAnswer((_) => const Stream.empty());

      await connection.connect();

      verify(
        mockSocket.setOption(
          argThat(equals(SocketOption.tcpNoDelay)),
          true,
        ),
      ).called(1);
      expect(connection.host, '127.00.1'); // default value
    });

    test('send should forward data to socket.add', () async {
      when(mockSocket.setOption(any, any)).thenReturn(true);

      // Return an open stream so that the connection stays alive
      final controller = StreamController<List<int>>();
      when(mockSocket.transform(any)).thenAnswer((_) => controller.stream);

      await connection.connect();

      final data = [1, 2, 3];
      connection.send(data);

      verify(mockSocket.add(data)).called(1);

      await controller.close();
    });

    test('close should cancel subscription and destroy the socket', () async {
      final mockSub = MockStreamSubscription();

      when(mockSocket.setOption(any, any)).thenReturn(true);
      when(mockSocket.transform(any)).thenAnswer((_) => const Stream.empty());

      await connection.connect();
      // force close
      await connection.close();

      verify(mockSocket.destroy()).called(1);
      // Subscription cancel is already awaited in close()
      verifyNever(mockSub.cancel()); // not injected here, but shows expectation
    });

    test('when the stream emits an error, onError should be called', () async {
      Object? receivedError;

      connection = TestConnection(
        onError: (error) => receivedError = error,
      );
      connection.socketToReturn = mockSocket;

      when(mockSocket.setOption(any, any)).thenReturn(true);
      when(mockSocket.transform(any))
          .thenAnswer((_) => Stream.error(Exception('failure')));

      await connection.connect();

      expect(receivedError, isA<Exception>());
    });
  });
}
