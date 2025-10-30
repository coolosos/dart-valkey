import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/connection/echo_command.dart';
import 'package:test/test.dart';

void main() {
  group('EchoCommand', () {
    test('should build the correct command', () {
      final command = EchoCommand('Hello World');
      expect(command.commandParts, ['ECHO', 'Hello World']);
    });

    test('should parse string response correctly', () {
      final command = EchoCommand('Hello World');
      expect(command.parse('Hello World'), 'Hello World');
    });

    test('should throw an exception for invalid response', () {
      final command = EchoCommand('Hello World');
      expect(() => command.parse(123), throwsA(isA<ValkeyException>()));
    });
  });
}
