import 'package:dart_valkey/src/commands/connection/client_setname_command.dart';
import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:test/test.dart';

void main() {
  group('ClientSetnameCommand', () {
    test('should build the correct command', () {
      final command = ClientSetnameCommand('myclient');
      expect(command.commandParts, ['CLIENT', 'SETNAME', 'myclient']);
    });

    test('should parse OK response correctly', () {
      final command = ClientSetnameCommand('myclient');
      expect(command.parse('OK'), 'OK');
    });

    test('should throw an exception for invalid response', () {
      final command = ClientSetnameCommand('myclient');
      expect(() => command.parse('ERROR'), throwsA(isA<ValkeyException>()));
    });
  });
}
