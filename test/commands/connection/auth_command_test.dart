import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/connection/auth_command.dart';
import 'package:test/test.dart';

void main() {
  group('AuthCommand', () {
    test('should build the correct command with only password', () {
      final command = AuthCommand(password: 'mypass');
      expect(command.commandParts, ['AUTH', 'mypass']);
    });

    test('should build the correct command with username and password', () {
      final command = AuthCommand(username: 'myuser', password: 'mypass');
      expect(command.commandParts, ['AUTH', 'myuser', 'mypass']);
    });

    test('should parse OK response correctly', () {
      final command = AuthCommand(password: 'mypass');
      expect(command.parse('OK'), 'OK');
    });

    test('should throw an exception for invalid response', () {
      final command = AuthCommand(password: 'mypass');
      expect(() => command.parse('ERROR'), throwsA(isA<ValkeyException>()));
    });
  });
}
