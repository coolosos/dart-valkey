import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/strings/decr_command.dart';
import 'package:test/test.dart';

void main() {
  group('DecrCommand', () {
    test('should build the correct command', () {
      final command = DecrCommand('mykey');
      expect(command.commandParts, ['DECR', 'mykey']);
    });

    test('should parse the response correctly', () {
      final command = DecrCommand('mykey');
      expect(command.parse(10), 10);
    });

    test('should throw an exception for invalid response', () {
      final command = DecrCommand('mykey');
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = DecrCommand('mykey');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts, ['DECR', 'myprefix:mykey']);
    });
  });
}