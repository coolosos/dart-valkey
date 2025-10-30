import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/connection/client_help_command.dart';
import 'package:test/test.dart';

void main() {
  group('ClientHelpCommand', () {
    test('should build the correct command', () {
      final command = ClientHelpCommand();
      expect(command.commandParts, ['CLIENT', 'HELP']);
    });

    test('should parse string response correctly', () {
      final command = ClientHelpCommand();
      expect(command.parse('Help text'), 'Help text');
    });

    test('should throw an exception for invalid response', () {
      final command = ClientHelpCommand();
      expect(() => command.parse(123), throwsA(isA<ValkeyException>()));
    });
  });
}
