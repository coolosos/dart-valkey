import 'package:dart_valkey/src/commands/connection/reset_command.dart';
import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:test/test.dart';

void main() {
  group('ResetCommand', () {
    test('should build the correct command', () {
      final command = ResetCommand();
      expect(command.commandParts, ['RESET']);
    });

    test('should parse RESET response correctly', () {
      final command = ResetCommand();
      expect(command.parse('RESET'), 'RESET');
    });

    test('should throw an exception for invalid response', () {
      final command = ResetCommand();
      expect(() => command.parse('ERROR'), throwsA(isA<ValkeyException>()));
    });
  });
}
