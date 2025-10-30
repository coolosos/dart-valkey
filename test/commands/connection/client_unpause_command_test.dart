import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/connection/client_unpause_command.dart';
import 'package:test/test.dart';

void main() {
  group('ClientUnpauseCommand', () {
    test('should build the correct command', () {
      final command = ClientUnpauseCommand();
      expect(command.commandParts, ['CLIENT', 'UNPAUSE']);
    });

    test('should parse OK response correctly', () {
      final command = ClientUnpauseCommand();
      expect(command.parse('OK'), 'OK');
    });

    test('should throw an exception for invalid response', () {
      final command = ClientUnpauseCommand();
      expect(() => command.parse('ERROR'), throwsA(isA<ValkeyException>()));
    });
  });
}
