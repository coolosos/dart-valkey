import 'package:dart_valkey/src/commands/key/persist_command.dart';
import 'package:test/test.dart';

void main() {
  group('PersistCommand', () {
    test('should build the correct command', () {
      final command = PersistCommand('mykey');
      expect(command.commandParts, ['PERSIST', 'mykey']);
    });

    test('should parse true response correctly', () {
      final command = PersistCommand('mykey');
      expect(command.parse(1), isTrue);
    });

    test('should parse false response correctly', () {
      final command = PersistCommand('mykey');
      expect(command.parse(0), isFalse);
    });

    test('should apply prefix to key', () {
      final command = PersistCommand('mykey');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts, ['PERSIST', 'myprefix:mykey']);
    });
  });
}
