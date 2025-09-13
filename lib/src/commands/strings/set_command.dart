import 'dart:core';
import 'package:meta/meta.dart';
import '../command.dart';

enum SetStrategyTypes {
  onlyIfNotExists('NX'),
  onlyIfExists('XX'),
  always(''),
  ;

  const SetStrategyTypes(this.command);

  final String command;
}

enum ExpireDurationTypes {
  EX,
  PX,
}

enum ExpireTimeTypes {
  EXAT,
  PXAT,
}

sealed class ExpireOption {
  const ExpireOption();
  List<String> get commandParts;
}

class ExpireDuration extends ExpireOption {
  const ExpireDuration(this.duration, {this.type = ExpireDurationTypes.EX});
  final Duration duration;
  final ExpireDurationTypes type;

  @override
  List<String> get commandParts => [
        type.name,
        switch (type) {
          ExpireDurationTypes.EX => duration.inSeconds.toString(),
          ExpireDurationTypes.PX => duration.inMilliseconds.toString(),
        },
      ];
}

class ExpireAt extends ExpireOption {
  const ExpireAt(this.dateTime, {this.type = ExpireTimeTypes.EXAT});
  final DateTime dateTime;
  final ExpireTimeTypes type;

  @override
  List<String> get commandParts => [
        type.name,
        switch (type) {
          ExpireTimeTypes.EXAT =>
            (dateTime.millisecondsSinceEpoch / 1000).round().toString(),
          ExpireTimeTypes.PXAT => dateTime.millisecondsSinceEpoch.toString(),
        },
      ];
}

class KeepTtl extends ExpireOption {
  const KeepTtl();

  @override
  List<String> get commandParts => ['KEEPTTL'];
}

abstract base class BaseSetCommand<T> extends ValKeyedCommand<T>
    with KeyedCommand<T> {
  BaseSetCommand(
    this.key,
    this.value, {
    this.expire,
    this.strategyType = SetStrategyTypes.always,
  });
  final String key;
  final String value;
  final ExpireOption? expire;
  final SetStrategyTypes strategyType;

  @override
  List<String> get commandParts {
    final parts = <String>['SET', key, value];

    if (strategyType != SetStrategyTypes.always) {
      parts.add(strategyType.command);
    }
    if (expire case final expire?) {
      parts.addAll(expire.commandParts);
    }

    return parts;
  }
}

@immutable
final class SetCommand extends BaseSetCommand<bool> {
  SetCommand(
    super.key,
    super.value, {
    super.expire,
    super.strategyType = SetStrategyTypes.always,
  });

  @override
  List<String> get commandParts {
    final parts = <String>['SET', key, value];

    if (strategyType != SetStrategyTypes.always) {
      parts.add(strategyType.command);
    }
    if (expire case final expire?) {
      parts.addAll(expire.commandParts);
    }

    return parts;
  }

  @override
  bool parse(dynamic data) {
    return (data == 'OK');
  }

  @override
  SetCommand applyPrefix(String prefix) {
    return SetCommand(
      '$prefix$key',
      value,
      expire: expire,
      strategyType: strategyType,
    );
  }
}
