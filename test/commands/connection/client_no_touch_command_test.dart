import 'package:dart_valkey/src/commands/connection/client_no_touch_command.dart';
import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:test/test.dart';

void main() {
  group('ClientNoTouchCommand', () {
    test('should build the correct command with enable true', () {
      final command = ClientNoTouchCommand(enable: true);
      expect(command.commandParts, ['CLIENT', 'NO-TOUCH', 'ON']);
    });

    test('should build the correct command with enable false', () {
      final command = ClientNoTouchCommand(enable: false);
      expect(command.commandParts, ['CLIENT', 'NO-TOUCH', 'OFF']);
    });

    test('should parse OK response correctly', () {
      final command = ClientNoTouchCommand(enable: true);
      expect(command.parse('OK'), 'OK');
    });

    test('should throw an exception for invalid response', () {
      final command = ClientNoTouchCommand(enable: true);
      expect(() => command.parse('ERROR'), throwsA(isA<ValkeyException>()));
    });
  });
}
