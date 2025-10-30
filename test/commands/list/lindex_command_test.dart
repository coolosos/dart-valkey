import 'package:dart_valkey/src/commands/list/lindex_command.dart';
import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:test/test.dart';

void main() {
  group('LIndexCommand', () {
    test('should build the correct command', () {
      final command = LIndexCommand('mylist', 0);
      expect(command.commandParts, ['LINDEX', 'mylist', '0']);
    });

    test('should parse string response correctly', () {
      final command = LIndexCommand('mylist', 0);
      expect(command.parse('item1'), 'item1');
    });

    test('should parse null response correctly', () {
      final command = LIndexCommand('mylist', 0);
      expect(command.parse(null), isNull);
    });

    test('should throw an exception for invalid response', () {
      final command = LIndexCommand('mylist', 0);
      expect(() => command.parse(123), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = LIndexCommand('mylist', 0);
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts, ['LINDEX', 'myprefix:mylist', '0']);
    });
  });
}
