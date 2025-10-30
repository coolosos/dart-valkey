import 'package:dart_valkey/src/commands/strings/incr_command.dart';
import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:test/test.dart';

void main() {
  group('IncrCommand', () {
    test('should build the correct command', () {
      final command = IncrCommand('mykey');
      expect(command.commandParts, ['INCR', 'mykey']);
    });

    test('should parse int response correctly', () {
      final command = IncrCommand('mykey');
      expect(command.parse(10), 10);
    });

    test('should parse string response correctly', () {
      final command = IncrCommand('mykey');
      expect(command.parse('10'), 10);
    });

    test('should throw an exception for invalid response', () {
      final command = IncrCommand('mykey');
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
      expect(() => command.parse(true), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = IncrCommand('mykey');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts, ['INCR', 'myprefix:mykey']);
    });
  });
}
