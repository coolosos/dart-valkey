import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'SET key value [EX seconds | PX milliseconds | EXAT timestamp | PXAT timestamp | KEEPTTL] [NX | XX]' command.
///
/// **Redis Command:**
/// ```
/// SET mykey myvalue PX 60000 NX
/// ```
///
/// **Redis Reply (Example):**
/// ```
/// +OK
/// ```
///
/// **Dart Result (from parse method):**
/// `String?` resolving to `'OK'` or `null`
///
/// Parameters:
/// - [key]: The key to set.
/// - [value]: The string value to set.
/// - [expire]: (Optional) Sets an expiration time in milliseconds (PX).
///   Use a [Duration] object. Only one expiration option ([expire], [expireAt], [keepTtl]) can be specified.
/// - [expireAt]: (Optional) Sets an expiration time as a Unix timestamp in milliseconds (PXAT).
///   Use a [DateTime] object. Only one expiration option can be specified.
/// - [keepTtl]: (Optional) Retains the time to live associated with the key.
///   Only one expiration option can be specified.
/// - [onlyIfNotExists]: (Optional) Only set the key if it does not already exist (NX).
///   Returns `null` if the key already exists and the operation was not performed.
///   Cannot be used with [onlyIfExists].
/// - [onlyIfExists]: (Optional) Only set the key if it already exists (XX).
///   Returns `null` if the key does not exist and the operation was not performed.
///   Cannot be used with [onlyIfNotExists].
final class SetCommand extends ValkeyCommand<String?> with KeyCommand<String?> {
  SetCommand(
    this.key,
    this.value, {
    this.expire,
    this.expireAt,
    this.keepTtl = false,
    this.onlyIfNotExists = false,
    this.onlyIfExists = false,
  })  : assert(
          (expire != null && expireAt == null && !keepTtl) ||
              (expire == null && expireAt != null && !keepTtl) ||
              (expire == null && expireAt == null && keepTtl) ||
              (expire == null && expireAt == null && !keepTtl),
          'Only one of expire, expireAt, or keepTtl can be specified.',
        ),
        assert(
          !(onlyIfNotExists && onlyIfExists),
          'Only one of onlyIfNotExists or onlyIfExists can be specified.',
        );
  final String key;
  final String value;

  /// Set the specified expire time in milliseconds.
  final Duration? expire;

  /// Set the specified Unix timestamp in milliseconds as expire time.
  final DateTime? expireAt;

  /// Retain the time to live associated with the key.
  final bool keepTtl;

  /// Only set the key if it does not already exist.
  final bool onlyIfNotExists;

  /// Only set the key if it already exists.
  final bool onlyIfExists;

  @override
  List<Object> get commandParts {
    final parts = <Object>['SET', key, value];

    if (expire != null) {
      parts.addAll(['PX', expire!.inMilliseconds.toString()]);
    } else if (expireAt != null) {
      parts.addAll(['PXAT', expireAt!.millisecondsSinceEpoch.toString()]);
    } else if (keepTtl) {
      parts.add('KEEPTTL');
    }

    if (onlyIfNotExists) {
      parts.add('NX');
    }
    if (onlyIfExists) {
      parts.add('XX');
    }
    return parts;
  }

  @override
  String? parse(dynamic data) {
    // When using NX or XX, the command returns a Null Bulk String if the
    // operation was not performed.
    if (data == null) return null;

    if (data == 'OK') return data;

    throw ValkeyException(
      'Invalid response for SET: expected "OK" or null, got "$data"',
    );
  }

  @override
  ValkeyCommand<String?> applyPrefix(String prefix) {
    return SetCommand(
      '$prefix$key',
      value,
      expire: expire,
      expireAt: expireAt,
      keepTtl: keepTtl,
      onlyIfNotExists: onlyIfNotExists,
      onlyIfExists: onlyIfExists,
    );
  }
}
