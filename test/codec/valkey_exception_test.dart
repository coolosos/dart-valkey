import 'package:dart_valkey/dart_valkey.dart';
import 'package:test/test.dart';

void main() {
  group('ValkeyException', () {
    test('should hold the message', () {
      final exception = ValkeyException('Error message');
      expect(exception.message, 'Error message');
    });

    test('toString should return correct format', () {
      final exception = ValkeyException('Another error');
      expect(exception.toString(), 'ValkeyException: Another error');
    });
  });
}
