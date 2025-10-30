import 'package:dart_valkey/src/commands/connection/client_no_evict_command.dart';
import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:test/test.dart';

void main() {
  group('ClientNoEvictCommand', () {
    test('should build the correct command with enable true', () {
      final command = ClientNoEvictCommand(enable: true);
      expect(command.commandParts, ['CLIENT', 'NO-EVICT', 'ON']);
    });

    test('should build the correct command with enable false', () {
      final command = ClientNoEvictCommand(enable: false);
      expect(command.commandParts, ['CLIENT', 'NO-EVICT', 'OFF']);
    });

    test('should parse OK response correctly', () {
      final command = ClientNoEvictCommand(enable: true);
      expect(command.parse('OK'), 'OK');
    });

    test('should throw an exception for invalid response', () {
      final command = ClientNoEvictCommand(enable: true);
      expect(() => command.parse('ERROR'), throwsA(isA<ValkeyException>()));
    });
  });
}
