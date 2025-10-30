import 'package:dart_valkey/src/commands/connection/client_kill_command.dart';
import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:test/test.dart';

void main() {
  group('ClientKillCommand', () {
    test('should build the correct command', () {
      final command = ClientKillCommand(12345);
      expect(command.commandParts, ['CLIENT', 'KILL', 'ID', '12345']);
    });

    test('should parse int response correctly', () {
      final command = ClientKillCommand(12345);
      expect(command.parse(1), 1);
    });

    test('should throw an exception for invalid response', () {
      final command = ClientKillCommand(12345);
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });
  });
}
