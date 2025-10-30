import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/connection/client_reply_command.dart';
import 'package:test/test.dart';

void main() {
  group('ClientReplyCommand', () {
    test('should build the correct command for ON mode', () {
      final command = ClientReplyCommand(ClientReplyMode.on);
      expect(command.commandParts, ['CLIENT', 'REPLY', 'ON']);
    });

    test('should build the correct command for OFF mode', () {
      final command = ClientReplyCommand(ClientReplyMode.off);
      expect(command.commandParts, ['CLIENT', 'REPLY', 'OFF']);
    });

    test('should build the correct command for SKIP mode', () {
      final command = ClientReplyCommand(ClientReplyMode.skip);
      expect(command.commandParts, ['CLIENT', 'REPLY', 'SKIP']);
    });

    test('should parse OK response correctly', () {
      final command = ClientReplyCommand(ClientReplyMode.on);
      expect(command.parse('OK'), isTrue);
    });

    test('should throw an exception for invalid response', () {
      final command = ClientReplyCommand(ClientReplyMode.on);
      expect(() => command.parse('ERROR'), throwsA(isA<ValkeyException>()));
    });
  });
}
