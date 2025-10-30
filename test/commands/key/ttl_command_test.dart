import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/key/ttl_command.dart';
import 'package:test/test.dart';

void main() {
  group('TtlCommand', () {
    test('should build the correct command', () {
      final command = TtlCommand('mykey');
      expect(command.commandParts, ['TTL', 'mykey']);
    });

    test('should parse positive int response correctly', () {
      final command = TtlCommand('mykey');
      expect(command.parse(60), 60);
    });

    test('should parse -1 response correctly', () {
      final command = TtlCommand('mykey');
      expect(command.parse(-1), -1);
    });

    test('should parse -2 response correctly', () {
      final command = TtlCommand('mykey');
      expect(command.parse(-2), -2);
    });

    test('should throw an exception for invalid response', () {
      final command = TtlCommand('mykey');
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = TtlCommand('mykey');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts, ['TTL', 'myprefix:mykey']);
    });
  });
}
