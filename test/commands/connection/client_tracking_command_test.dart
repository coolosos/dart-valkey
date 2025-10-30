import 'package:dart_valkey/src/commands/connection/client_tracking_command.dart';
import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:test/test.dart';

void main() {
  group('ClientTrackingCommand', () {
    test('should build the correct command for ON mode', () {
      final command = ClientTrackingCommand(ClientTrackingMode.on);
      expect(command.commandParts, ['CLIENT', 'TRACKING', 'ON']);
    });

    test('should build the correct command for OFF mode', () {
      final command = ClientTrackingCommand(ClientTrackingMode.off);
      expect(command.commandParts, ['CLIENT', 'TRACKING', 'OFF']);
    });

    test('should parse OK response correctly', () {
      final command = ClientTrackingCommand(ClientTrackingMode.on);
      expect(command.parse('OK'), isTrue);
    });

    test('should throw an exception for invalid response', () {
      final command = ClientTrackingCommand(ClientTrackingMode.on);
      expect(() => command.parse('ERROR'), throwsA(isA<ValkeyException>()));
    });
  });
}
