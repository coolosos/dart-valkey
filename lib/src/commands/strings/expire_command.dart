import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'EXPIRE key seconds [NX|XX|GT|LT]' command.
///
/// **Redis Command:**
/// ```
/// EXPIRE mykey 60 NX
/// ```
///
/// **Redis Reply (Example):**
/// ```
/// :1
/// ```
///
/// **Dart Result (from parse method):**
/// `bool` resolving to `true` (timeout set) or `false` (key does not exist)
///
/// Parameters:
/// - [key]: The key to set the expiration for.
/// - [seconds]: The time to live in seconds.
/// - [nx]: Set expiry only when the key has no expiry.
/// - [xx]: Set expiry only when the key has an existing expiry.
/// - [gt]: Set expiry only when the new expiry is greater than current one.
/// - [lt]: Set expiry only when the new expiry is less than current one.
final class ExpireCommand extends ValkeyCommand<bool> with KeyCommand<bool> {
  ExpireCommand(
    this.key,
    this.seconds, {
    this.nx = false,
    this.xx = false,
    this.gt = false,
    this.lt = false,
  });
  final String key;
  final int seconds;
  final bool nx;
  final bool xx;
  final bool gt;
  final bool lt;

  @override
  List<String> get commandParts {
    final parts = ['EXPIRE', key, seconds.toString()];
    if (nx) {
      parts.add('NX');
    }
    if (xx) {
      parts.add('XX');
    }
    if (gt) {
      parts.add('GT');
    }
    if (lt) {
      parts.add('LT');
    }
    return parts;
  }

  @override
  bool parse(dynamic data) {
    if (data is int) return data == 1;
    throw ValkeyException(
      'Invalid response for EXPIRE: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<bool> applyPrefix(String prefix) {
    return ExpireCommand(
      '$prefix$key',
      seconds,
      nx: nx,
      xx: xx,
      gt: gt,
      lt: lt,
    );
  }
}
