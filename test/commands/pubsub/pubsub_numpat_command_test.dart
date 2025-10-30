import 'package:dart_valkey/src/commands/pubsub/pubsub_numpat_command.dart';
import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:test/test.dart';

void main() {
  group('PubsubNumpatCommand', () {
    test('should build the correct command', () {
      final command = PubsubNumpatCommand();
      expect(command.commandParts, ['PUBSUB', 'NUMPAT']);
    });

    test('should parse int response correctly', () {
      final command = PubsubNumpatCommand();
      expect(command.parse(5), 5);
    });

    test('should throw an exception for invalid response', () {
      final command = PubsubNumpatCommand();
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });
  });
}
