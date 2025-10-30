import 'package:dart_valkey/src/commands/pubsub/publish_command.dart';
import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:test/test.dart';

void main() {
  group('PublishCommand', () {
    test('should build the correct command', () {
      final command = PublishCommand('mychannel', 'mymessage');
      expect(command.commandParts, ['PUBLISH', 'mychannel', 'mymessage']);
    });

    test('should parse int response correctly', () {
      final command = PublishCommand('mychannel', 'mymessage');
      expect(command.parse(1), 1);
    });

    test('should throw an exception for invalid response', () {
      final command = PublishCommand('mychannel', 'mymessage');
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });
  });
}
