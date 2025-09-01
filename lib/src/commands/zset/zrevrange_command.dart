import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'ZREVRANGE key start stop [BYLEX|BYSCORE] [LIMIT offset count] [WITHSCORES]' command.
/// Returns the specified range of elements in the sorted set stored at key, with scores ordered from high to low.
///
/// **Redis Command:**
/// ```
/// ZREVRANGE myzset 0 -1 WITHSCORES
/// ```
///
/// **Redis Reply (Example):**
/// ```
/// *2
/// $7
/// member2
/// $7
/// member1
/// ```
///
/// **Dart Result (from parse method):**
/// `List<String>` or `List<Map<String, String>>` (if WITHSCORES is true)
final class ZRevRangeCommand extends ValkeyCommand<List> with KeyCommand<List> {
  ZRevRangeCommand(
    this.key,
    this.start,
    this.stop, {
    this.byLex = false,
    this.byScore = false,
    this.limitOffset,
    this.limitCount,
    this.withScores = false,
  });
  final String key;
  final String start;
  final String stop;
  final bool byLex;
  final bool byScore;
  final int? limitOffset;
  final int? limitCount;
  final bool withScores;

  @override
  List<String> get commandParts {
    final parts = ['ZREVRANGE', key, start, stop];
    if (byLex) {
      parts.add('BYLEX');
    } else if (byScore) {
      parts.add('BYSCORE');
    }
    if (limitOffset != null && limitCount != null) {
      parts.addAll(['LIMIT', limitOffset!.toString(), limitCount!.toString()]);
    }
    if (withScores) {
      parts.add('WITHSCORES');
    }
    return parts;
  }

  @override
  List parse(dynamic data) {
    if (data is List) {
      if (withScores) {
        final result = <Map<String, String>>[];
        for (var i = 0; i < data.length; i += 2) {
          result.add(
            {'member': data[i] as String, 'score': data[i + 1] as String},
          );
        }
        return result;
      } else {
        return data.map((e) => e as String).toList();
      }
    }
    throw ValkeyException(
      'Invalid response for ZREVRANGE: expected a list, got ${data.runtimeType}',
    );
  }

  @override
  ZRevRangeCommand applyPrefix(String prefix) {
    return ZRevRangeCommand(
      '$prefix$key',
      start,
      stop,
      byLex: byLex,
      byScore: byScore,
      limitOffset: limitOffset,
      limitCount: limitCount,
      withScores: withScores,
    );
  }
}
