import '../../codec/valkey_exception.dart';
import '../command.dart';

enum ExpireStrategyTypes {
  onlyIfNotExists('NX'),
  onlyIfExists('XX'),
  greaterThanCurrent('GT'),
  lessThanCurrent('LT'),
  always(''),
  ;

  const ExpireStrategyTypes(this.command);

  final String command;
}

/// Represents the 'EXPIRE key seconds [NX|XX|GT|LT]' command.
///
/// **Redis Command:**
/// ```text
/// EXPIRE mykey 60 NX
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// :1
/// ```
///
/// **Dart Result (from parse method):**
/// `bool` resolving to `true` (timeout set) or `false` (key does not exist)
///
/// Parameters:
/// - [key]: The key to set the expiration for.
/// - [seconds]: The time to live in seconds.
/// - [strategyType]: Set expire strategy.
final class ExpireCommand extends ValkeyCommand<bool> with KeyedCommand<bool> {
  ExpireCommand(
    this.key,
    this.seconds, {
    this.strategyType = ExpireStrategyTypes.always,
  });
  final String key;
  final int seconds;
  final ExpireStrategyTypes strategyType;

  @override
  List<String> get commandParts {
    final parts = ['EXPIRE', key, seconds.toString()];
    if (strategyType != ExpireStrategyTypes.always) {
      parts.add(strategyType.command);
    }
    return parts;
  }

  @override
  bool parse(dynamic data) {
    if (data is int) return data == 1;
    if (data is String) return data == '1';
    throw ValkeyException(
      'Invalid response for EXPIRE: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<bool> applyPrefix(String prefix) {
    return ExpireCommand(
      '$prefix$key',
      seconds,
      strategyType: strategyType,
    );
  }
}
