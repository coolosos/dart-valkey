import 'package:dart_valkey/src/commands/connection/client_pause_command.dart';
import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:test/test.dart';

void main() {
  group('ClientPauseCommand', () {
    test('should build the correct command without write', () {
      final command = ClientPauseCommand(1000);
      expect(command.commandParts, ['CLIENT', 'PAUSE', '1000']);
    });

    test('should build the correct command with write', () {
      final command = ClientPauseCommand(1000, write: true);
      expect(command.commandParts, ['CLIENT', 'PAUSE', '1000', 'WRITE']);
    });

    test('should parse OK response correctly', () {
      final command = ClientPauseCommand(1000);
      expect(command.parse('OK'), isTrue);
    });

    test('should throw an exception for invalid response', () {
      final command = ClientPauseCommand(1000);
      expect(() => command.parse('ERROR'), throwsA(isA<ValkeyException>()));
    });
  });
}
