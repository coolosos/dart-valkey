import 'package:dart_valkey/src/commands/strings/strlen_command.dart';
import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:test/test.dart';

void main() {
  group('StrLenCommand', () {
    test('should build the correct command', () {
      final command = StrLenCommand('mykey');
      expect(command.commandParts, ['STRLEN', 'mykey']);
    });

    test('should parse int response correctly', () {
      final command = StrLenCommand('mykey');
      expect(command.parse(5), 5);
    });

    test('should throw an exception for invalid response', () {
      final command = StrLenCommand('mykey');
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = StrLenCommand('mykey');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts, ['STRLEN', 'myprefix:mykey']);
    });
  });
}
