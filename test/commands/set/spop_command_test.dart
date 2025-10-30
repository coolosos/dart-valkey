import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/set/spop_command.dart';
import 'package:test/test.dart';

void main() {
  group('SPopCommand', () {
    test('should build the correct command', () {
      final command = SPopCommand('myset');
      expect(command.commandParts, ['SPOP', 'myset']);
    });

    test('should parse string response correctly', () {
      final command = SPopCommand('myset');
      expect(command.parse('member1'), 'member1');
    });

    test('should parse null response correctly', () {
      final command = SPopCommand('myset');
      expect(command.parse(null), isNull);
    });

    test('should throw an exception for invalid response', () {
      final command = SPopCommand('myset');
      expect(() => command.parse(123), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = SPopCommand('myset');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts, ['SPOP', 'myprefix:myset']);
    });
  });
}
