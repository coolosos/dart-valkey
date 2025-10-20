import '../command.dart';

/// Represents the 'EVAL' command.
///
/// **Valkey Command:**
/// ```text
/// EVAL script numKeys key [key ...] arg [arg ...]
/// ```
///
/// **Valkey Reply:**
/// ```text
/// The result of the script execution.
/// ```
final class EvalCommand extends ValkeyCommand<dynamic> {
  EvalCommand({
    required this.script,
    required this.numberOfKeys,
    this.keys = const [],
    this.args = const [],
  });

  final String script;
  final int numberOfKeys;
  final List<String> keys;
  final List<String> args;

  @override
  List<String> get commandParts {
    final parts = ['EVAL', script, numberOfKeys.toString(), ...keys, ...args];
    return parts;
  }

  @override
  dynamic parse(dynamic data) {
    // EVAL can return any RESP type. The decoder handles the parsing.
    // We just return the raw parsed data.
    return data;
  }
}
