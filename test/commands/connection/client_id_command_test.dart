import 'package:dart_valkey/src/commands/connection/client_id_command.dart';
import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:test/test.dart';

void main() {
  group('ClientIdCommand', () {
    test('should build the correct command', () {
      final command = ClientIdCommand();
      expect(command.commandParts, ['CLIENT', 'ID']);
    });

    test('should parse int response correctly', () {
      final command = ClientIdCommand();
      expect(command.parse(12345), 12345);
    });

    test('should throw an exception for invalid response', () {
      final command = ClientIdCommand();
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });
  });
}
