import 'package:dart_valkey/src/commands/strings/decrby_command.dart';
import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:test/test.dart';

void main() {
  group('DecrByCommand', () {
    test('should build the correct command', () {
      final command = DecrByCommand('mykey', 5);
      expect(command.commandParts, ['DECRBY', 'mykey', '5']);
    });

    test('should parse the response correctly', () {
      final command = DecrByCommand('mykey', 5);
      expect(command.parse(10), 10);
    });

    test('should throw an exception for invalid response', () {
      final command = DecrByCommand('mykey', 5);
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = DecrByCommand('mykey', 5);
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts, ['DECRBY', 'myprefix:mykey', '5']);
    });
  });
}
