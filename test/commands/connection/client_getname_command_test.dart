import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/connection/client_getname_command.dart';
import 'package:test/test.dart';

void main() {
  group('ClientGetnameCommand', () {
    test('should build the correct command', () {
      final command = ClientGetnameCommand();
      expect(command.commandParts, ['CLIENT', 'GETNAME']);
    });

    test('should parse string response correctly', () {
      final command = ClientGetnameCommand();
      expect(command.parse('myclient'), 'myclient');
    });

    test('should parse null response correctly', () {
      final command = ClientGetnameCommand();
      expect(command.parse(null), isNull);
    });

    test('should throw an exception for invalid response', () {
      final command = ClientGetnameCommand();
      expect(() => command.parse(123), throwsA(isA<ValkeyException>()));
    });
  });
}
