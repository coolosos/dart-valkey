import 'package:dart_valkey/src/commands/connection/client_setinfo_command.dart';
import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:test/test.dart';

void main() {
  group('ClientSetinfoCommand', () {
    test('should build the correct command', () {
      final command = ClientSetinfoCommand('mykey', 'myvalue');
      expect(command.commandParts, ['CLIENT', 'SETINFO', 'mykey', 'myvalue']);
    });

    test('should parse OK response correctly', () {
      final command = ClientSetinfoCommand('mykey', 'myvalue');
      expect(command.parse('OK'), isTrue);
    });

    test('should throw an exception for invalid response', () {
      final command = ClientSetinfoCommand('mykey', 'myvalue');
      expect(() => command.parse('ERROR'), throwsA(isA<ValkeyException>()));
    });
  });
}
