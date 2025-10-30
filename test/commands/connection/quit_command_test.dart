import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/connection/quit_command.dart';
import 'package:test/test.dart';

void main() {
  group('QuitCommand', () {
    test('should build the correct command', () {
      final command = QuitCommand();
      expect(command.commandParts, ['QUIT']);
    });

    test('should parse OK response correctly', () {
      final command = QuitCommand();
      expect(command.parse('OK'), 'OK');
    });

    test('should throw an exception for invalid response', () {
      final command = QuitCommand();
      expect(() => command.parse('ERROR'), throwsA(isA<ValkeyException>()));
    });
  });
}
