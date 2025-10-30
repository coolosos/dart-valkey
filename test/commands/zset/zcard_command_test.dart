import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/zset/zcard_command.dart';
import 'package:test/test.dart';

void main() {
  group('ZCardCommand', () {
    test('should build the correct command', () {
      final command = ZCardCommand('myzset');
      expect(command.commandParts, ['ZCARD', 'myzset']);
    });

    test('should parse int response correctly', () {
      final command = ZCardCommand('myzset');
      expect(command.parse(2), 2);
    });

    test('should throw an exception for invalid response', () {
      final command = ZCardCommand('myzset');
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = ZCardCommand('myzset');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts, ['ZCARD', 'myprefix:myzset']);
    });
  });
}
