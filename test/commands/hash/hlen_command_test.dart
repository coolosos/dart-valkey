import 'package:dart_valkey/src/commands/hash/hlen_command.dart';
import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:test/test.dart';

void main() {
  group('HLenCommand', () {
    test('should build the correct command', () {
      final command = HLenCommand('mykey');
      expect(command.commandParts, ['HLEN', 'mykey']);
    });

    test('should parse int response correctly', () {
      final command = HLenCommand('mykey');
      expect(command.parse(2), 2);
    });

    test('should throw an exception for invalid response', () {
      final command = HLenCommand('mykey');
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = HLenCommand('mykey');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts, ['HLEN', 'myprefix:mykey']);
    });
  });
}
