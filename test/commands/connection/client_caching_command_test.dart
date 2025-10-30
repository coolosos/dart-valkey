import 'package:dart_valkey/src/commands/connection/client_caching_command.dart';
import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:test/test.dart';

void main() {
  group('ClientCachingCommand', () {
    test('should build the correct command with enable true', () {
      final command = ClientCachingCommand(enable: true);
      expect(command.commandParts, ['CLIENT', 'CACHING', 'YES']);
    });

    test('should build the correct command with enable false', () {
      final command = ClientCachingCommand(enable: false);
      expect(command.commandParts, ['CLIENT', 'CACHING', 'NO']);
    });

    test('should parse OK response correctly', () {
      final command = ClientCachingCommand(enable: true);
      expect(command.parse('OK'), 'OK');
    });

    test('should throw an exception for invalid response', () {
      final command = ClientCachingCommand(enable: true);
      expect(() => command.parse('ERROR'), throwsA(isA<ValkeyException>()));
    });
  });
}
