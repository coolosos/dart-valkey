import 'package:dart_valkey/src/commands/set/srandmember_command.dart';
import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:test/test.dart';

void main() {
  group('SRandMemberCommand', () {
    test('should build the correct command', () {
      final command = SRandMemberCommand('myset');
      expect(command.commandParts, ['SRANDMEMBER', 'myset']);
    });

    test('should parse string response correctly', () {
      final command = SRandMemberCommand('myset');
      expect(command.parse('member1'), 'member1');
    });

    test('should parse null response correctly', () {
      final command = SRandMemberCommand('myset');
      expect(command.parse(null), isNull);
    });

    test('should throw an exception for invalid response', () {
      final command = SRandMemberCommand('myset');
      expect(() => command.parse(123), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = SRandMemberCommand('myset');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts, ['SRANDMEMBER', 'myprefix:myset']);
    });
  });
}
