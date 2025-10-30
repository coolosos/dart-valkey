import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/strings/get_command.dart';
import 'package:test/test.dart';

void main() {
  group('GetCommand', () {
    test('should build the correct command', () {
      final command = GetCommand('mykey');
      expect(command.commandParts, ['GET', 'mykey']);
    });

    test('should parse string response correctly', () {
      final command = GetCommand('mykey');
      expect(command.parse('myvalue'), 'myvalue');
    });

    test('should parse null response correctly', () {
      final command = GetCommand('mykey');
      expect(command.parse(null), isNull);
    });

    test('should throw an exception for invalid response', () {
      final command = GetCommand('mykey');
      expect(() => command.parse(123), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = GetCommand('mykey');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts, ['GET', 'myprefix:mykey']);
    });
  });
}
