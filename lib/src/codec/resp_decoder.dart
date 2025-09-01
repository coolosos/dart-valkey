import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'resp_constants.dart';
import 'valkey_exception.dart';

class RespDecoder extends StreamTransformerBase<Uint8List, dynamic> {
  const RespDecoder();

  @override
  Stream<dynamic> bind(Stream<List<int>> stream) {
    final controller = StreamController<dynamic>();
    final buffer = BytesBuilder();
    var offset = 0;

    stream.listen(
      (chunk) {
        buffer.add(chunk);
        final currentBuffer = buffer.toBytes();

        offset = _processBuffer(currentBuffer, offset, controller, buffer);

        if (offset > 0) {
          final remaining = currentBuffer.sublist(offset);
          buffer.clear();
          buffer.add(remaining);
          offset = 0;
        }
      },
      onError: controller.addError,
      onDone: controller.close,
    );

    return controller.stream;
  }

  int _processBuffer(
    List<int> currentBuffer,
    int offset,
    StreamSink<dynamic> controller,
    BytesBuilder buffer,
  ) {
    while (offset < currentBuffer.length) {
      try {
        final result = _parse(currentBuffer, offset);
        controller.add(result.value);
        offset += result.bytesConsumed;
      } on _IncompleteDataException {
        break;
      } catch (e) {
        controller.addError(e);
        buffer.clear();
        offset = 0;
        return 0; // Reset offset on error
      }
    }
    return offset;
  }

  _ParseResult _parse(List<int> buffer, int offset) {
    if (offset >= buffer.length) {
      throw _IncompleteDataException();
    }

    final type = buffer[offset];
    switch (type) {
      case respSimpleString: // + Simple String
        return _parseSimpleString(buffer, offset);
      case respError: // - Error
        return _parseError(buffer, offset);
      case respInteger: // : Integer
        return _parseInteger(buffer, offset);
      case respBulkString: // $ Bulk String
        return _parseBulkString(buffer, offset);
      case respArray: // * Array
        return _parseArray(buffer, offset);
      default:
        throw FormatException(
          'Unknown RESP type: ${String.fromCharCode(type)}',
        );
    }
  }

  int _findCRLF(List<int> buffer, int from) {
    for (var i = from; i < buffer.length - 1; i++) {
      if (buffer[i] == respCarriageReturn && buffer[i + 1] == respLineFeed) {
        return i;
      }
    }
    return -1;
  }

  _ParseResult _parseSimpleString(List<int> buffer, int offset) {
    final crlfPos = _findCRLF(buffer, offset);
    if (crlfPos == -1) {
      throw _IncompleteDataException();
    }

    final value = utf8.decode(buffer.sublist(offset + 1, crlfPos));
    return _ParseResult(value, (crlfPos - offset) + 2);
  }

  _ParseResult _parseError(List<int> buffer, int offset) {
    final crlfPos = _findCRLF(buffer, offset);
    if (crlfPos == -1) {
      throw _IncompleteDataException();
    }

    final message = utf8.decode(buffer.sublist(offset + 1, crlfPos));
    // throw ValkeyException(message);
    return _ParseResult(ValkeyException(message), (crlfPos - offset) + 2);
  }

  _ParseResult _parseInteger(List<int> buffer, int offset) {
    final crlfPos = _findCRLF(buffer, offset);
    if (crlfPos == -1) {
      throw _IncompleteDataException();
    }

    final valueStr = utf8.decode(buffer.sublist(offset + 1, crlfPos));
    return _ParseResult(int.parse(valueStr), (crlfPos - offset) + 2);
  }

  _ParseResult _parseBulkString(List<int> buffer, int offset) {
    final crlfPos = _findCRLF(buffer, offset);
    if (crlfPos == -1) {
      throw _IncompleteDataException();
    }

    final length = int.parse(utf8.decode(buffer.sublist(offset + 1, crlfPos)));
    if (length == -1) {
      return _ParseResult(null, (crlfPos - offset) + 2);
    }

    final dataStart = crlfPos + 2;
    final totalLength = dataStart + length + 2;
    if (buffer.length < totalLength) {
      throw _IncompleteDataException();
    }

    final value = utf8.decode(buffer.sublist(dataStart, dataStart + length));
    return _ParseResult(value, (totalLength - offset));
  }

  _ParseResult _parseArray(List<int> buffer, int offset) {
    final crlfPos = _findCRLF(buffer, offset);
    if (crlfPos == -1) {
      throw _IncompleteDataException();
    }

    final count = int.parse(utf8.decode(buffer.sublist(offset + 1, crlfPos)));
    if (count == -1) {
      return _ParseResult(null, (crlfPos - offset) + 2);
    }

    final items = [];
    var currentOffset = crlfPos + 2;
    for (var i = 0; i < count; i++) {
      final result = _parse(buffer, currentOffset);
      items.add(result.value);
      currentOffset += result.bytesConsumed;
    }
    return _ParseResult(items, currentOffset - offset);
  }
}

class _ParseResult {
  _ParseResult(this.value, this.bytesConsumed);
  final dynamic value;
  final int bytesConsumed;
}

class _IncompleteDataException implements Exception {}
