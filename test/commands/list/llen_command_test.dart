import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/list/llen_command.dart';
import 'package:test/test.dart';

void main() {
  group('LLenCommand', () {
    test('should build the correct command', () {
      final command = LLenCommand('mylist');
      expect(command.commandParts, ['LLEN', 'mylist']);
    });

    test('should parse int response correctly', () {
      final command = LLenCommand('mylist');
      expect(command.parse(2), 2);
    });

    test('should throw an exception for invalid response', () {
      final command = LLenCommand('mylist');
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = LLenCommand('mylist');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts, ['LLEN', 'myprefix:mylist']);
    });
  });
}
