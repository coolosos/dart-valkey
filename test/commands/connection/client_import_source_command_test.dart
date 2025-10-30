import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/connection/client_import_source_command.dart';
import 'package:test/test.dart';

void main() {
  group('ClientImportSourceCommand', () {
    test('should build the correct command', () {
      final command = ClientImportSourceCommand();
      expect(command.commandParts, ['CLIENT', 'IMPORT-SOURCE']);
    });

    test('should parse OK response correctly', () {
      final command = ClientImportSourceCommand();
      expect(command.parse('OK'), isTrue);
    });

    test('should throw an exception for invalid response', () {
      final command = ClientImportSourceCommand();
      expect(() => command.parse('ERROR'), throwsA(isA<ValkeyException>()));
    });
  });
}
