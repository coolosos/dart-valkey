import 'dart:convert';
import 'dart:typed_data';

import 'resp_constants.dart';

class RespEncoder {
  static const List<int> _crlf = [respCarriageReturn, respLineFeed]; // \r\n
  static List<int> encode(List<Object> command) {
    final builder = BytesBuilder()
      ..addByte(respArray) // * (Array)
      ..add(utf8.encode(command.length.toString()))
      ..add(_crlf);

    for (final part in command) {
      _writeBulkString(builder, part.toString());
    }
    return builder.toBytes();
  }

  /// Escribe un único string en formato RESP Bulk String.
  /// Ejemplo: $5\r\nhello\r\n
  static void _writeBulkString(BytesBuilder builder, String text) {
    final textBytes = utf8.encode(text);
    builder
      ..addByte(respBulkString) // $
      ..add(utf8.encode(textBytes.length.toString()))
      ..add(_crlf)
      ..add(textBytes)
      ..add(_crlf);
  }
}
