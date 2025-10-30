import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/connection/client_getredir_command.dart';
import 'package:test/test.dart';

void main() {
  group('ClientGetredirCommand', () {
    test('should build the correct command', () {
      final command = ClientGetredirCommand();
      expect(command.commandParts, ['CLIENT', 'GETREDIR']);
    });

    test('should parse positive int response correctly', () {
      final command = ClientGetredirCommand();
      expect(command.parse(123), 123);
    });

    test('should parse 0 response correctly', () {
      final command = ClientGetredirCommand();
      expect(command.parse(0), 0);
    });

    test('should parse -1 response correctly', () {
      final command = ClientGetredirCommand();
      expect(command.parse(-1), -1);
    });

    test('should throw an exception for invalid response', () {
      final command = ClientGetredirCommand();
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });
  });
}
