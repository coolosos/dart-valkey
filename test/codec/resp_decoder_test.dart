import 'dart:async';
import 'dart:convert';

import 'package:dart_valkey/src/codec/resp_decoder.dart';
import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:test/test.dart';

void main() {
  group('RespDecoder', () {
    const decoder = Resp3Decoder();

    Future<dynamic> testDecode(String encoded) {
      return Stream.value(utf8.encode(encoded)).transform(decoder).first;
    }

    group('Simple Types', () {
      test('should decode simple string', () {
        expect(testDecode('+OK\r\n'), completion('OK'));
      });

      test('should decode error', () async {
        final aa = await testDecode('-ERR unknown command\r\n');
        expect(
          aa,
          isA<ValkeyException>(),
        );
        expect(
          (aa as ValkeyException).message,
          'ERR unknown command',
        );
      });

      test('should decode integer', () {
        expect(testDecode(':1000\r\n'), completion(1000));
      });
    });

    group('Bulk Strings', () {
      test('should decode bulk string', () {
        expect(testDecode('\$6\r\nfoobar\r\n'), completion('foobar'));
      });

      test('should decode empty bulk string', () {
        expect(testDecode('\$0\r\n\r\n'), completion(''));
      });

      test('should decode null bulk string', () {
        expect(testDecode('\$-1\r\n'), completion(isNull));
      });
    });

    group('Arrays', () {
      test('should decode array of bulk strings', () {
        expect(
          testDecode('*2\r\n\$3\r\nfoo\r\n\$3\r\nbar\r\n'),
          completion(['foo', 'bar']),
        );
      });

      test('should decode empty array', () {
        expect(testDecode('*0\r\n'), completion([]));
      });

      test('should decode null array', () {
        expect(testDecode('*-1\r\n'), completion(isNull));
      });

      test('should decode array with null element', () {
        expect(
          testDecode('*3\r\n\$3\r\nfoo\r\n\$-1\r\n\$3\r\nbar\r\n'),
          completion(['foo', null, 'bar']),
        );
      });

      test('should decode nested arrays', () {
        expect(
          testDecode('*2\r\n*3\r\n:1\r\n:2\r\n:3\r\n*2\r\n+Foo\r\n+Bar\r\n'),
          completion([
            [1, 2, 3],
            ['Foo', 'Bar'],
          ]),
        );
      });
    });
  });
}
