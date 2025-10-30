import 'package:dart_valkey/src/commands/list/rpoplpush_command.dart';
import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:test/test.dart';

void main() {
  group('RPopLPushCommand', () {
    test('should build the correct command', () {
      final command = RPopLPushCommand('mysource', 'mydestination');
      expect(command.commandParts, ['RPOPLPUSH', 'mysource', 'mydestination']);
    });

    test('should parse string response correctly', () {
      final command = RPopLPushCommand('mysource', 'mydestination');
      expect(command.parse('itemX'), 'itemX');
    });

    test('should parse null response correctly', () {
      final command = RPopLPushCommand('mysource', 'mydestination');
      expect(command.parse(null), isNull);
    });

    test('should throw an exception for invalid response', () {
      final command = RPopLPushCommand('mysource', 'mydestination');
      expect(() => command.parse(123), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to keys', () {
      final command = RPopLPushCommand('mysource', 'mydestination');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts, ['RPOPLPUSH', 'myprefix:mysource', 'myprefix:mydestination']);
    });
  });
}
