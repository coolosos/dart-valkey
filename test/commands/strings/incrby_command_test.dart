import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/strings/incrby_command.dart';
import 'package:test/test.dart';

void main() {
  group('IncrByCommand', () {
    test('should build the correct command', () {
      final command = IncrByCommand('mykey', 5);
      expect(command.commandParts, ['INCRBY', 'mykey', '5']);
    });

    test('should parse the response correctly', () {
      final command = IncrByCommand('mykey', 5);
      expect(command.parse(15), 15);
    });

    test('should throw an exception for invalid response', () {
      final command = IncrByCommand('mykey', 5);
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = IncrByCommand('mykey', 5);
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts, ['INCRBY', 'myprefix:mykey', '5']);
    });
  });
}
