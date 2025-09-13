import '../command.dart';

/// Represents the `SELECT` command in Valkey.
///
/// Selects the database with the specified zero-based index.
final class SelectCommand extends ValKeyedCommand<bool> {
  SelectCommand(this.index);

  final int index;

  @override
  List<String> get commandParts => ['SELECT', index.toString()];

  @override
  bool parse(dynamic data) {
    return data == 'OK';

    // throw Exception('Unexpected response for SELECT: $data');
  }
}
