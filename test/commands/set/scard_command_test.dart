import 'package:dart_valkey/src/commands/set/scard_command.dart';
import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:test/test.dart';

void main() {
  group('SCardCommand', () {
    test('should build the correct command', () {
      final command = SCardCommand('myset');
      expect(command.commandParts, ['SCARD', 'myset']);
    });

    test('should parse int response correctly', () {
      final command = SCardCommand('myset');
      expect(command.parse(2), 2);
    });

    test('should throw an exception for invalid response', () {
      final command = SCardCommand('myset');
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = SCardCommand('myset');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts, ['SCARD', 'myprefix:myset']);
    });
  });
}
